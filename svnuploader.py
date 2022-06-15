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
        self.urlPrefix = "";
        self.verifyFile = "";
        self.verifyContent = "";
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

                        info["file"] = file;
                        info["mode"] = mode;
                        mname = map[mode];
                        info["status"] = mname;
                    else:
                        file = arr[0];
                        info["file"] = file;
                        info["mode"] = "?";
                        info["status"] = "unversion";

                    # print (arr);
                    # print ("Add To changeListMap %s => %s" % (changeListName, info ["file"]))
                    self.changeListMap[changeListName].append (info);
                    continue;
                else:

                    i = msg.rfind(" ");
                    k = msg.find (" ");
                    mode = msg[:k].strip(" ");
                    msg = msg [i:].strip(' ');
                    file = msg.replace("\\","/")

                # if not self.isInDelay(file):
                    info = {};
                    info ["file"] = file;
                    info ["mode"] = mode;

                    mname = map [mode];
                    info["status"] = mname;

                    # print("Add To changeList => %s" % (info["file"]))
                    self.changesList.append (info);
                # else:
                #     print ("Skip delayFile %s" % file);

        return self.changesList;
        pass

    def removeAllChangeLists(self):
        print ("删除所有修改列表")
        for key in self.changeListMap:
            list = self.changeListMap [key];
            print ("删除 Changelist %s..." % key)
            for i in range(len(list)):
                item = list [i];
                file = item ["file"];

                cmdstr = "svn cl --remove %s" % file;
                Commander().do (cmdstr,self.svnroot,noPrint=True);

        self.changeListMap = {};
        print("删除所有修改列表完成");

    def setResListChangeList(self,name):
        print("设置修改列表 %s..." % name)
        for i in range(len(self.changesList)):
            info = self.changesList [i];
            file = info ["file"];
            status = info ["status"];

            if self.isInDelay(file):
                continue;

            if status == "unversion":
                # print ("%s is unversion file ,add to svn version..." % file);
                print("添加修改列表 添加 %s" % file)
                cmdstr = '''svn add %s''' % (file);
                Commander().do(cmdstr, cwd=self.svnroot, noPrint=True);

            elif status == "missing":
                print("添加修改列表 删除 %s" % file)
                cmdstr = '''svn delete %s''' % (file);
                Commander().do(cmdstr, cwd=self.svnroot, noPrint=True);
                pass
            else:
                print("添加修改列表 修改 %s => %s" % (name,file))

            cmdstr = '''svn cl %s %s''' % (name,file);

            # print (cmdstr);
            self.doSvnCmd (cmdstr,cwd=self.svnroot,noPrint=True);
        print("设置修改列表 %s 完成." % name)
        pass

    def dumpChangelist(self):

        for i in range(len(self.changesList)):
            info = self.changesList [i];
            file = info ["file"];
            status = info ["status"];
            print("%8s %s" % (status, file))

        pass

    def doSvnCmd (self, cmd, cwd=None, env=None, encoding=None, noPrint=False):
        return Commander ().do (cmd,cwd,env,encoding,noPrint);
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

    def setDelayListChangeList(self,name):

        if len(self.changeListMap.keys()) > 0:
            print ("Warnnig . has changeListMap . need Remove it first");
            self.removeAllChangeLists();
            self.fetchChanges ();

        print("设置修改列表 %s..." % name)
        for i in range(len(self.delayConfigs)):
            file = self.delayConfigs [i];
            # file = info ["file"];
            # status = info ["status"];
            if not self.isInChangeList (file):
               continue;

            cmdstr = '''svn cl %s %s''' % (name,file);

            # print (cmdstr);
            self.doSvnCmd (cmdstr,cwd=self.svnroot,noPrint=True);

        print("设置修改列表 %s 完成." % name)

        pass

    def uploadChangeList(self,name,msg):

        print ("正在上传修改列表 %s..." % name);

        cmdstr = '''svn commit --changelist %s -m "%s"''' % (name,msg);
        # print (cmdstr);
        self.doSvnCmd (cmdstr,cwd=self.svnroot);
        print("上传修改列表 %s 完成" % name);

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