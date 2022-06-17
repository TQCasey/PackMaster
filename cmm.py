"""
global signal slot
"""
import json
import os
import platform
import shutil
import subprocess
import sys
import traceback
from os import path

from PyQt5.QtCore import QObject, pyqtSignal
from PyQt5.QtWidgets import QMessageBox
from lupa._lupa import LuaRuntime

class GSignal(QObject):
    msg_trigger = pyqtSignal(str);
    error_msg_trigger = pyqtSignal(str);
    start_trigger = pyqtSignal();
    done_trigger = pyqtSignal(int);
    clear_trigger = pyqtSignal();
    msgbox_trigger = pyqtSignal (str);
    input_trigger = pyqtSignal (dict);
    auth_trigger = pyqtSignal ();

    ask_box_trigger = pyqtSignal (str);
    msg_ret_trigger = pyqtSignal (int);
    input_ret_trigger = pyqtSignal (dict);

    alert_changelist_trigger = pyqtSignal(dict);
    alert_ret_changelist_trigger = pyqtSignal (int);

    reload_gamesconfig_trigger = pyqtSignal ();


gsignal = GSignal();
console_print = print;

"""
overwrite print 
"""
def print(msg):
    if gsignal.msg_trigger != None and msg != None:
        gsignal.msg_trigger.emit(str(msg));

def getAcctInfo():
    if gsignal.auth_trigger != None:
        gsignal.auth_trigger.emit();

def rmsgbox(msg):
    if gsignal.msgbox_trigger and msg:
        gsignal.msgbox_trigger.emit (str(msg));

def rinputbox(dict):
    if gsignal.input_trigger and dict:
        gsignal.input_trigger.emit (dict);

def raskbox(msg):
    if gsignal.ask_box_trigger and msg:
        gsignal.ask_box_trigger.emit (str(msg));

def rchangelistbox(dict):
    if gsignal.alert_changelist_trigger and dict:
        gsignal.alert_changelist_trigger.emit (dict);

def reload_games_configs():
    if gsignal.reload_gamesconfig_trigger:
        gsignal.reload_gamesconfig_trigger.emit ();

# def errmsg(text):
#     try:
#         msg = '''<p style="color:rgb(255,0,0);">%s</p>''' % text;
#         print (msg)
#         if gsignal.error_msg_trigger and msg:
#             gsignal.error_msg_trigger.emit (str(msg));
#     except Exception as err:
#         print ('''<p style="color:rgb(255,0,0);">%s</p>''' % str (err));

def errmsg(text):
    stack = traceback.format_exc ();
    try:
        stackIndex = stack.find('NoneType');

        '''no stack'''
        if stackIndex == 0:
            msg = '''<p style="color:rgb(255,0,0);">%s</p>''' % (text);
            print (msg)
            if gsignal.error_msg_trigger and msg:
                gsignal.error_msg_trigger.emit (str(msg));
        else:
            stack = stack.replace("\n", "<br/>")
            msg = '''<p style="color:rgb(255,0,0);">%s  =>  %s</p>''' % (text, stack);
            print (msg)
            if gsignal.error_msg_trigger and msg:
                gsignal.error_msg_trigger.emit (str(msg));
    except Exception as err:
        print ('''<p style="color:rgb(255,0,0);">%s</p>''' % str (err));

def warnmsg(text):
    print('''<p style="color:rgb(0x00,255,0);">%s</p>''' % text)

def clear():
    if gsignal.clear_trigger != None:
        gsignal.clear_trigger.emit();

def start_pack():
    if gsignal.start_trigger != None:
        gsignal.start_trigger.emit();

def done_pack(retcode):
    if gsignal.done_trigger != None:
        gsignal.done_trigger.emit(retcode);

def PackManVersion():
    return 3;

def getCacheDir():
    path = "./cache";
    if not os.path.exists(path):
        os.makedirs(path);
    return path;

def JsonEncodeWithOrder(dict):
    return json.dumps(dict,sort_keys=True)

lua = LuaRuntime();

def isWin():
    return platform.system() == "Windows";


def isMacOS():
    return platform.system() == "Darwin"


with open("./encodingMap.json","r") as file:
    if isMacOS():
        content = file.read().replace("\\\\","/").replace("\\","/")
    else:
        content = file.read();

    encodingMap = json.loads(content);

# print (encodingMap);

def convertToCRLF(content):
    newcontent = [];
    for k in range(len(content)):
        ch = content[k];
        if k == 0:
            prevch = None;
        else:
            prevch = content[k - 1];

        if k >= len(content) - 1:
            postch = None;
        else:
            postch = content[k + 1];

        if ch == 10 or ch == '\n':
            if prevch == 13 or prevch == '\r':
                newcontent.append(ch);  ## windows
            else:
                newcontent.append(13);  ## unix
                newcontent.append(10)
        elif ch == 13 or ch == '\r':
            if postch != 10 and postch != '\n' and postch != 13 and postch != '\r':  ## mac
                newcontent.append(13)
                newcontent.append(10)
            else:
                newcontent.append(ch);  ## windows
        else:
            newcontent.append(ch);  ## windows / other char

    return newcontent;


def convertToLF(content):  # --> Unix \n
    newcontent = [];
    for k in range(len(content)):
        ch = content[k];
        if k == 0:
            prevch = None;
        else:
            prevch = content[k - 1];

        if k >= len(content) - 1:
            postch = None;
        else:
            postch = content[k + 1];

        if ch == 10 or ch == '\n':
            if prevch == 13 or prevch == '\r':
                continue;
            else:
                newcontent.append(10);
        elif ch == 13 or ch == '\r':
            newcontent.append(10);
        else:
            newcontent.append(ch);

    return newcontent;


def convertToCR(content):
    newcontent = [];
    for k in range(len(content)):
        ch = content[k];
        if k == 0:
            prevch = None;
        else:
            prevch = content[k - 1];

        if k >= len(content) - 1:
            postch = None;
        else:
            postch = content[k + 1];

        if ch == 10 or ch == '\n':
            if prevch == 13 or prevch == '\r':
                continue;
            else:
                newcontent.append(13);
        elif ch == 13 or ch == '\r':
            newcontent.append(13);
        else:
            newcontent.append(ch);

    return newcontent;


def copyfileWithEncoding(src, dest, encoding="Windows"):
    try:
        with open(src, "rb") as fsrc:
            content = fsrc.read();
            if b'\x00' in content:  ## binary
                with open(dest, 'wb') as fdst:
                    fdst.write(content);
            else:  ## text
                if encoding == "Mac":
                    newcontent = convertToCR(content);
                elif encoding == 'Unix':
                    newcontent = convertToLF(content);
                else:
                    newcontent = convertToCRLF(content);

                with open(dest, 'wb') as fdst:
                    ret = fdst.write(bytearray(newcontent))

    except Exception as err:
        print(err);
        pass
    pass

def recursive_overwrite(src, dest, ignore=None,src_root = ""):
    if os.path.isdir(src):

        if not os.listdir(src):
            return;

        if not os.path.isdir(dest):
            os.makedirs(dest)
        files = os.listdir(src)
        if ignore is not None:
            ignored = ignore(src, files)
        else:
            ignored = set()
        for f in files:
            if f not in ignored:
                recursive_overwrite(os.path.join(src, f),os.path.join(dest, f),ignore,src_root)
    else:
        if len(src_root) > 0:
            src_len = len(src_root) + 1;
            real_src = src[src_len:];
            if real_src in encodingMap:
                encoding = encodingMap [real_src];
                copyfileWithEncoding (src,dest,encoding);
            else:
                copyfileWithEncoding(src, dest);
        else:
            copyfileWithEncoding (src,dest);

def replaceFileContent(filename,oldcontent,newcontent):
    try:

        content = "";

        with open(filename, "r", encoding="utf-8") as file:
            content = file.read();
            content = content.replace(oldcontent, newcontent);

        with open(filename, "w", encoding="utf-8") as file:
            file.write(content);

    except Exception as err:
        errmsg(err);

""" 
MsgBox Class
"""


class MsgBox:

    def __init__(self):
        pass

    def ask(self,msgtext, title="", detail="", ico=QMessageBox.Information):
        return self.makeBox(msgtext, title, detail, ico, QMessageBox.Ok | QMessageBox.Cancel);

    def msg(self,msgtext, title="", detail="", ico=QMessageBox.Information):
        return self.makeBox(msgtext, title, detail, ico, QMessageBox.Ok);

    def yesno(self,msgtext, title="", detail="", ico=QMessageBox.Information):
        return self.makeBox(msgtext, title, detail, ico, QMessageBox.Yes | QMessageBox.No | QMessageBox.Cancel);

    def warn(self,msgtext,title="",detail="",ico=QMessageBox.Information):
        return self.makeBox(msgtext, title, detail, ico, QMessageBox.Ok);

    def makeBox(self,msgtext, title="", detail="", ico=QMessageBox.Information, style=QMessageBox.Yes):
        try:
            msg = QMessageBox()
            msg.setIcon(QMessageBox.Information)
            msg.setText(msgtext)
            msg.setWindowTitle(title)
            msg.setDetailedText(detail)
            msg.setStandardButtons(style)
            # msg.setStandardButtons(QMessageBox.Yes | QMessageBox.No | QMessageBox.Cancel)
            retval = msg.exec_()
            return retval;
        except Exception as err:
            errmsg(err);

"""
Commander Class
"""


class Commander:

    def __init__(self):

        from profile import gPMConfig

        if isWin():
            platconfig =  gPMConfig.getPlatSettings("android");
        else:
            platconfig = gPMConfig.getPlatSettings("ios");

        new_env = os.environ.copy()

        new_env['NDK_ROOT'] = platconfig.ndk_dir;
        new_env['ANDROID_SDK_ROOT'] = platconfig.sdk_dir;
        new_env['ANT_ROOT'] = platconfig.ant_dir;

        newPath = platconfig.quick_dir;
        cocosRoot = os.path.dirname(newPath);
        new_env['COCOS_X_ROOT'] = cocosRoot;
        new_env['COCOS_CONSOLE_ROOT'] = path.join(platconfig.quick_dir, "tools", "cocos2d-console", "bin");
        new_env['COCOS_TEMPLATES_ROOT'] = path.join(platconfig.quick_dir, "templates");
        new_env['QUICK_V3_ROOT'] = platconfig.quick_dir;

        if (platconfig.proxy_str != ""):
            new_env['HTTP_PROXY'] = "http://" + platconfig.proxy_str;
            # new_env['HTTPS_PROXY'] = "http://" + platconfig.proxy_str;
        '''
        top the path 
        '''
        new_env['PATH'] = new_env['COCOS_CONSOLE_ROOT'] + ";" + new_env['COCOS_TEMPLATES_ROOT'] + new_env['PATH'] + ";"

        self.new_env = new_env;

        self.precmd = "";

        if isMacOS():
            self.precmd = self.precmd + ('''PATH=$PATH:%s''' % new_env['COCOS_CONSOLE_ROOT']);

        pass

    '''显示日志'''
    def do(self, cmd,cwd = None,env = None,encoding = None,noPrint = False):
        try:
            msgs = [];
            if (env != None):
                env = {**env, **self.new_env};
            else:
                env = self.new_env;

            cmd = self.precmd + ";" + cmd;

            process = subprocess.Popen(cmd,
                                       shell=True,
                                       bufsize=0,
                                       stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT,
                                       universal_newlines=True,
                                       cwd=cwd,
                                       encoding=encoding,
                                       env=env);
            while True:
                output = process.stdout.readline()
                if output != None:
                    output = output.strip();
                    if output != "":
                        if noPrint == False:
                            print(output);
                        msgs.append(output);
                if output == "" and process.poll() != None:
                    break;

            return msgs;
        except Exception as err:
            errmsg(err);
