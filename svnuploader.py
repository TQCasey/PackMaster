import json
import os
import re
import time

from jsonpickle import json

import requests
from cmm import *

class SvnUploader:
    def __init__(self):
        self.svnroot = "";
        self.delayConfigs = [];
        self.changesList = [];
        self.changeListMap = {};
        self.devChangeList = [];
        self.urlPrefix = "";
        self.verifyFile = "";
        self.verifyContent = "";
        self.delayConfigFile = "";
        self.make_time = time.strftime("%Y%m%d%H%M%S", time.localtime());
        pass

    def setDelayConfigFile(self,path):
        with open(path,"r") as file:
            self.delayConfigs = json.loads(file.read());
        pass

    def setRepRoot(self,rootPath):
        self.svnroot = rootPath;
        pass

    def upload(self):
        pass

    def status(self):
        cmdstr = '''svn status''';
        self.doSvnCmd (cmdstr,cwd=self.svnroot)
        pass

    def isInDelay(self,file):
        for i in range(len(self.delayConfigs)):
            info = self.delayConfigs [i];
            if info == file:
                return True;

        return False;

    def isInChangeList(self,afile):
        for i in range(len(self.changesList)):
            info = self.changesList [i];
            file = info ["file"];
            status = info ["status"];

            if file == afile:
                return True;

        return False;

    def fetchChanges(self):

        self.changesList = [];

        cmdstr = '''svn status''';
        msgs = self.doSvnCmd (cmdstr,cwd=self.svnroot,noPrint=True);

        map = {
            ">" : "add",
            "?" : "unversion",
            "!" : "missing",
            "A" : "add",
            "D" : "delete",
            "M" : "modify",
            'N' : "",
        }

        changeListName = "";

        reg = re.compile(r'\'(.*)\'');

        for key in range(len(msgs)):
            msg = msgs [key];

            res = reg.findall(msg);
            if (len(res)) > 0:
                changeListName = res [0];
                print ("ChangeList %s" % res [0]);
            else:
                if changeListName != "":
                    if not (changeListName in self.changeListMap):
                        self.changeListMap [changeListName] = [];

                    info = {};
                    arr = msg.split();
                    if len(arr) >= 2:
                        file = arr [1];
                        mode = arr [0];

                        if len(mode) >= 2:
                            file_status     = mode [0];
                            prop_status     = mode [1];
                        else:
                            file_status     = mode [0];
                            prop_status     = "N";

                        info["file"]        = file;
                        info["mode"]        = file_status;
                        info["status"]      = map [file_status];
                        info["propstatus"]  = map [prop_status];

                    else:
                        file                = arr[0];
                        info["file"]        = file;
                        info["mode"]        = "?";
                        info["status"]      = "unversion";
                        info["propstatus"]  = "";

                    self.changeListMap[changeListName].append (info);
                    continue;
                else:

                    i = msg.rfind(" ");
                    k = msg.find (" ");
                    mode = msg[:k].strip(" ");
                    msg = msg [i:].strip(' ');
                    file = msg.replace("\\","/")

                    info = {};
                    info ["file"] = file;
                    info ["mode"] = mode;

                    if len(mode) >= 2:
                        file_status = mode[0];
                        prop_status = mode[1];
                    else:
                        file_status = mode[0];
                        prop_status = "N";

                    info["file"] = file;
                    info["mode"] = file_status;
                    info["status"] = map[file_status];
                    info["propstatus"] = map[prop_status];

                    self.changesList.append (info);

        return self.changesList;
        pass

    def removeAllChangeLists(self):
        print ("删除所有修改列表")
        for key in self.changeListMap:
            list = self.changeListMap [key];
            print ("删除 Changelist %s..." % key)

            target_file = os.path.join(self.svnroot, key);
            if os.path.exists(target_file):
                os.remove(target_file);
                pass

            for i in range(len(list)):
                item = list [i];
                file = item ["file"];

                cmdstr = "svn cl --remove %s" % file;
                self.doSvnCmd (cmdstr,self.svnroot,noPrint=True);

        self.changeListMap = {};
        print("删除所有修改列表完成");

    def setChangeList (self,name,callback):
        print("设置修改列表 %s..." % name)

        if len(self.changeListMap.keys()) > 0:
            print ("检测到还有changelist，需要重新筛选修改列表...");
            self.removeAllChangeLists();
            self.fetchChanges ();

        name_add = name + "_add.tqp";
        name_del = name + "_del.tqp";
        name_mod = name + "_mod.tqp"

        with open(os.path.join(self.svnroot,name_add),mode="w+") as afile:
            with open(os.path.join(self.svnroot,name_del),mode="w+") as dfile:
                with open(os.path.join(self.svnroot,name_mod),mode="w+") as cfile:
                    for i in range(len(self.changesList)):
                        info = self.changesList [i];
                        filepath = info ["file"];
                        status = info ["status"];

                        if filepath.find (".tqp") >= 0:
                            continue;

                        if callback and True == callback(filepath):
                            continue;

                        if status == "unversion":
                            print("添加增加列表 %9s 添加 %s" % (name,filepath))
                            afile.write(filepath + "\n");

                        elif status == "missing":
                            print("添加修改列表 %9s 删除 %s" % (name,filepath))
                            dfile.write(filepath + "\n");
                            # continue;

                        cfile.write (filepath + "\n");

        print("设置修改列表 %s 完成." % name)
        pass

    def dumpChangelist(self):

        for i in range(len(self.changesList)):
            info = self.changesList [i];
            file = info ["file"];
            status = info ["status"];
            print("%12s %s" % (status, file))

        pass

    def doSvnCmd (self, cmd, cwd=None, env=None, encoding=None, noPrint=False):
        msgs = Commander ().do (cmd,cwd,env,encoding,noPrint);

        hasErr = False;
        hasOutDated = False;

        if noPrint == True:
            for k in range(len(msgs)):
                msg = msgs [k];
                if msg.find ("svn: E") >= 0 or msg.find("svn: warning") >= 0:
                    hasErr = True;

                if msg.find("is out of date") >= 0:
                    hasOutDated = True;

            if hasErr:
                for k in range(len(msgs)):
                    msg = msgs[k];
                    print (msg);

        if hasOutDated:
            print ("需要更新...")
            self.update();

        return msgs;

        pass

    def update(self):
        print ("正在更新目录 %s " % self.svnroot);
        cmdstr = '''svn update'''
        self.doSvnCmd (cmdstr,cwd=self.svnroot,noPrint=True);
        print("更新完成 ");

    def dumpDelayConfigs(self):
        for i in range(len(self.delayConfigs)):
            file = self.delayConfigs [i];
            # file = info ["file"];
            # status = info ["status"];
            print("=> %s" % (file))


    def _checkResouce(self,filepath):
        return self.isInDelay(filepath);

    def setResListChangeList(self,name):
        self.setChangeList(name,self._checkResouce);
        pass

    def _checkVersion(self,filepath):
        return not self.isInDelay(filepath);

    def setDelayListChangeList(self,name):
        self.setChangeList(name,self._checkVersion);
        pass

    def deletFile(self,name):
        target_file = os.path.join(self.svnroot,name);
        if os.path.exists(target_file):
            os.remove(target_file);
            pass

    def uploadChangeList(self,name,msg):

        name_add = name + "_add.tqp";
        name_del = name + "_del.tqp";
        name_mod = name + "_mod.tqp"

        name_del_fullpath = os.path.join(self.svnroot,name_del);
        with open(name_del_fullpath,"r") as file:
            lines = file.readlines();

        if len(lines) > 0:
            print ("正在添加删除列表 %s..." % name);
            cmdstr = '''svn delete --force --keep-local --targets %s ''' % (name_del);
            self.doSvnCmd (cmdstr,cwd=self.svnroot,noPrint=True);
            print("添加删除列表 %s 完成" % name);

        name_add_fullpath = os.path.join(self.svnroot,name_add);
        with open(name_add_fullpath,"r") as file:
            lines = file.readlines();

        if len(lines) > 0:
            print ("正在添加修改列表 %s..." % name);
            cmdstr = '''svn add --targets %s ''' % (name_add);
            self.doSvnCmd (cmdstr,cwd=self.svnroot,noPrint=True);
            print("添加修改列表 %s 完成" % name);

        print ("正在上传修改列表 %s..." % name);
        cmdstr = '''svn commit --targets %s -m "%s"''' % (name_mod,msg);
        self.doSvnCmd (cmdstr,cwd=self.svnroot,noPrint=False);
        print("上传修改列表 %s 完成" % name);

        self.deletFile (name_add);
        self.deletFile (name_del);
        self.deletFile (name_mod);

        pass

    def setNetworkUrl(self,url):
        self.urlPrefix = url;

    def verifyNetwork(self):
        print ("验证文件中...");

        url = self.verifyFile;
        expectMsg = self.verifyContent;

        url = "%s/%s" % (self.urlPrefix,url);

        print ("访问链接 " + url);

        resp = requests.request("get",url);

        if resp.status_code == 200:
            if resp.text == expectMsg:
                print("验证通过");
                return True;

        print("验证失败 code %d,text = %s" % (resp.status_code,resp.text));
        return False;

        pass

    def makeCDNVerifyFile (self):

        '''
        生成验证文件
        '''
        print("删除旧CDN验证文件...")
        dirs = os.listdir(self.svnroot);
        for dir in dirs:
            if dir.find("netverify_") >= 0:
                os.remove(os.path.join(self.svnroot, dir));
            pass

        print("生成CDN验证文件...")
        filename = "netverify_%s" % self.make_time;
        verify_file = os.path.join(self.svnroot, filename);
        with open(verify_file, "w+") as f:
            f.write(self.make_time);

        self.verifyFile = filename;
        self.verifyContent = self.make_time;

        return True;

    def fetchDevChange(self):

        count = 0;
        none_count = 0;

        self.devChangeList = [];

        for key in range(len(self.changesList)):
            value = self.changesList [key];
            filepath = value ['file'];

            if self.isInDelay(filepath):
                none_count = none_count + 1;
                continue;

            if "filemd5.json" in filepath:
                none_count = none_count + 1;
                continue;

            if "src64" in filepath:
                none_count = none_count + 1;
                continue;

            count = count + 1;
            # print (value);

            self.devChangeList.append(value);

        return self.devChangeList;
        pass
