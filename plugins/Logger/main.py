import os, threading
import struct
import ctypes
import time
import socket
import json
import re
import hashlib

from watchdog.observers import Observer
from watchdog.events import *
from watchdog.utils.dirsnapshot import DirectorySnapshot, DirectorySnapshotDiff


'''
Proxy Mode
'''
PROXY_MODE          = 1;
PROXY_IP            = '106.53.29.180'
PROXY_PORT          = 9999;

'''
server 
'''
PORT                = 6666;
RECVBUFSZ           = 2 * 1024 * 1024;
PACKET_HDR_SIZE     = 16;

CMD_LOG             = 128;

CMD_CREATE_FILE     = 1;
CMD_MODIFY_FILE     = 2;
CMD_DELETE_FILE     = 3;
CMD_MOVE_FILE       = 4;

CMD_CREATE_DIR      = 5;
CMD_DELETE_DIR      = 6;
CMD_MODIFY_DIR      = 7;
CMD_MOVE_DIR        = 8;

CMD_RESTART         = 9;
CMD_MEMINFO         = 10;

class ByteArray:
    def __init__(self):
        self.data   = [];
        self.pos    = 0;
        self.len    = 0;
        pass

    def setData(self,data):
        expandSz = self.pos + len(data) - self.len;
        if expandSz <= 0:
            expandSz = 0;

        if (self.pos + len(data) > self.len):     # expand buffer
            dummyData = bytearray(expandSz);
            self.data += dummyData;

        for k in range(len(data)):
            self.data [self.pos + k] = data [k];

        self.pos += len(data);
        if (self.pos > self.len):
            self.len = self.pos;

    def clear(self):
        self.data = [];
        self.pos = 0;
        self.len  = 0;

    def writeUnsignedInt(self,Num):
        intBytes = Num.to_bytes(4,byteorder='big');
        self.setData (intBytes)

    def readUnsignedInt(self):
        if (self.pos + 4 > self.len) :
            return 0;

        bs = self.data [self.pos:self.pos + 4];
        Num = int.from_bytes(bs,byteorder='big');
        self.pos += 4;

        return Num;

    def writeUnsignedShort(self,Num):
        intBytes = Num.to_bytes(2,byteorder='big');
        self.setData(intBytes)

    def readUnsignedShort(self):
        if (self.pos + 2 > self.len):
            return 0;

        bs = self.data[self.pos:self.pos + 2];
        Num = int.from_bytes(bs, byteorder='big');
        self.pos += 2;

        return Num;

    def writeUnsignedChar(self,Num):
        intBytes = Num.to_bytes(1,byteorder='big');
        self.setData (intBytes)

    def readUnsignedChar(self):
        if (self.pos + 1 > self.len):
            return 0;

        bs = self.data[self.pos:self.pos + 1];
        Num = int.from_bytes(bs, byteorder='big');
        self.pos += 1;

        return Num;

    def writeBuffer(self,data):
        self.setData (data);

    def writeString(self,msg):
        if ((type(msg).__name__ == 'str')):
            msg = msg.encode();

        self.writeUnsignedInt(len(msg));
        self.writeBuffer (msg);

    def readString(self):
        strlen = self.readUnsignedInt();
        if (self.pos + strlen > self.len):
            strlen = self.len - self.pos;

        bs = self.data [self.pos:self.pos+strlen];
        self.pos += strlen;
        return bytearray(bs).decode().strip(b'\x00'.decode());

    def setPosition(self,pos):
        if (pos < 0 or pos > self.len):
            return ;
        self.pos = pos;

    def getPosition(self):
        return self.pos;

    def getLength(self):
        return self.len;

    def getBytesAvailable(self):
        return self.len - self.pos;

    def readBytes(self,offset,len):

        ba = ByteArray ();

        if (offset >= self.len):
            offset = 0;

        if (len == 0):
            return ba;

        avb = self.getBytesAvailable();
        if (len > avb):
            len = avb;

        ba.setPosition (offset);
        ba.writeBuffer(self.data[self.pos:self.pos+len]);
        self.pos += len;

        return ba;


    def toStream(self):
        return bytearray (self.data);

    def makePacket (self,cmd=1101):
        self.writeUnsignedInt(0);                                   #bodysize (4)
        self.writeUnsignedShort(cmd);                               #cmd (2)
        self.writeUnsignedChar(0);                                  #flag
        self.writeUnsignedChar(0);                                  #rand1
        self.writeUnsignedChar(0);                                  #rand2
        self.writeUnsignedChar(0);                                  #crc8
        self.writeUnsignedChar(0);                                  #ver
        self.writeUnsignedChar(0);                                  #reserved
        self.writeUnsignedInt(0);                                   #param (4)
        return self;

    def endPacket(self):
        self.setPosition(0);
        self.writeUnsignedInt(len(self.data) - 4);
        return self;

def get_host_ip():
    try:
        s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

        s.connect(('8.8.8.8',80))
        s.settimeout(30);

        ip=s.getsockname()[0]
    finally:
        s.close()

    return ip

class SocketServer:
    def __init__(self, port, mode, singal=None,mgr = None):

        self.mode = mode;
        self.mgr = mgr;

        tipstr = "";

        self.socks = [];

        if (mode == PROXY_MODE):
            tipstr = "Server is running with : %s:%d" % (PROXY_IP,PROXY_PORT)
            self.socket = socket.socket();
            self.socket.connect((PROXY_IP, PROXY_PORT));
            self.socks.append(self.socket);
        else:
            localIP = get_host_ip ();
            tipstr = "Server is running with : %s:%d" % (localIP,PORT)
            print(tipstr);

            self.server = socket.socket(socket.AF_INET,socket.SOCK_STREAM);
            self.server.setblocking (1);
            self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1);

            self.server.bind ((localIP,port));
            self.server.listen(5);

        self.m_signal = singal;
        if self.m_signal:
            self.m_signal.emit([], [tipstr])
        pass

    def onGameCommand(self,cmd,**params):
        try:

            if (cmd == "restart"):
                data = ByteArray().makePacket()
                data.writeUnsignedChar(CMD_RESTART);  # cmd
                self.sendToAll (data.endPacket().toStream());
                pass

            elif (cmd == "meminfo"):
                data = ByteArray().makePacket()
                data.writeUnsignedChar(CMD_MEMINFO);  # cmd
                self.sendToAll (data.endPacket().toStream());
                pass

        except Exception as err:
            print (err);

        pass

    def sendTo(self,socket,data):
        try:
            socket.send (data);
        except Exception as err:
            print (err);

    def getModifiedFile(self,filePath):

        rawpath = filePath;
        l = len(self.mgr.baseDir);
        path = rawpath[l:];

        path = eval(repr(path).replace(r"\\", r'/'));
        # path = eval(repr(path).replace(r"src", 'src64'));
        if path[0] == '.':
            path = path.replace('.', '', 1);

        content = '';
        with open(rawpath, 'rb') as file:
            content = file.read();
            # print (content);

        fpath, filename = os.path.split(rawpath);

        return (filename, path, content);
        pass

    def onSyncFiles(self,socket,ba):

        try:
            cnt = ba.readUnsignedInt();

            baseDir     = self.mgr.baseDir;
            fileMap     = self.mgr.fileMap;
            fileMapKeys = fileMap.keys ();

            remoteFileMap   = {};

            for k in range (cnt):
                filePath = ba.readString();
                filePathMd5 = ba.readString();

                fullPath = baseDir + filePath;
                remoteFileMap[fullPath] = filePathMd5;

            remoteFileMapKeys = remoteFileMap.keys();

            fileCount = 0;
            for localfile in fileMap:

                if (localfile.find (".DS_Store") >= 0) :
                    continue;

                # if (fileCount >= 2):
                #     continue;

                # if (localfile.find ("main.lua") < 0):
                #     continue;

                if localfile in remoteFileMapKeys:
                    '''
                    existed , check md5
                    '''
                    localHash = fileMap [localfile].upper ();
                    remoteHash = remoteFileMap [localfile].upper();

                    if (localHash != remoteHash):
                        print("Sync Modified File : localFile => %s" % (localfile));
                        fileCount = fileCount + 1;
                        file = self.getModifiedFile (localfile);

                        data = ByteArray().makePacket();
                        data.writeUnsignedChar(CMD_MODIFY_FILE);  # cmd
                        data.writeString(file[0]);  #file name
                        data.writeString(file[1]);  #filePath
                        data.writeString(file[2]);  #fileContent

                        data.writeUnsignedChar(1);  #is sync

                        self.sendTo(socket,data.endPacket().toStream());

                    pass
                else:
                    fileCount = fileCount + 1;
                    '''
                    not existed 
                    '''
                    print("Sync None-Existed File localFile => %s" % (localfile));

                    file = self.getModifiedFile(localfile);

                    data = ByteArray().makePacket()
                    data.writeUnsignedChar(CMD_CREATE_FILE);  # cmd
                    data.writeString(file[0]);
                    data.writeString(file[1]);
                    data.writeString(file[2]);

                    data.writeUnsignedChar(1);  # is sync

                    self.sendTo(socket,data.endPacket().toStream());


                    pass

        except Exception as err:
            print(err)

        pass

    def onCommand(self,ba,cmdid,socket):
        try:
            # print ("CMDID %d" % cmdid);
            if (cmdid == 1101):
                cnt = ba.readUnsignedChar();
                msgs = [];

                for k in range(cnt):
                    msg = ba.readString();
                    msgs.append(msg);

                if self.m_signal:
                    info = list(socket.getpeername());
                    self.m_signal.emit(info, msgs);
                # print (socket.getpeername(),*msgs);

            elif cmdid == 1102:
                data = ByteArray().makePacket(1102);
                socket.send(data.endPacket().toStream());
                pass

            elif cmdid == 1103:
                self.onSyncFiles (socket,ba);
                pass

        except Exception as err:
            print(err)


    def onRecvData(self,sock):
        try:
            buf = ByteArray();

            while True:
                data = sock.recv (RECVBUFSZ);
                # print ("RecvData Len : %d" % (len(data)));
                if not data:
                    info = sock.getpeername();
                    print ("(%s,%s) disconnected" %(info [0],info [1]));
                    break;

                buf.setPosition(buf.getLength());
                buf.writeBuffer (data);
                buf.setPosition(0);

                while buf.getBytesAvailable() >= PACKET_HDR_SIZE:
                    body_len = buf.readUnsignedInt();
                    cmdid = buf.readUnsignedShort();
                    flag = buf.readUnsignedChar();
                    rand1 = buf.readUnsignedChar();
                    rand2 = buf.readUnsignedChar();
                    chk = buf.readUnsignedChar();
                    ver = buf.readUnsignedChar();
                    ptyp = buf.readUnsignedChar();
                    param = buf.readUnsignedInt();

                    body_len -= (PACKET_HDR_SIZE - 4);

                    if (buf.getBytesAvailable() < body_len):
                        # print("cmdid = %d : Lack of bytes,need %d bytes,got %d bytes" % (cmdid, body_len,buf.getBytesAvailable()));
                        break;
                    else:
                        ba = buf.readBytes(0,body_len);
                        ba.setPosition(0);

                        self.onCommand (ba,cmdid,sock);

                    datalen = buf.getLength();
                    if (datalen > body_len + PACKET_HDR_SIZE):
                        # print ("more than one packet,cmdid = %d : need %d bytes,got %d bytes" % (cmdid, body_len, datalen));
                        pass

                if (buf.getBytesAvailable() <= 0):
                    buf.clear();

        except Exception as err:
            print (err);
            # sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            sock.close();
            pass

        print ("thread-socket ended ....")
        self.socks.remove(sock);
        pass

    def sendToAll(self,data):

        for i in range (len(self.socks)):
            try:
                sock = self.socks[i];
                sock.send (data);

            except Exception as err:
                print (err);
                pass
        pass

    # def sendTo(self,data):
    #     try:
    #         sock = self.socks[i];
    #         sock.send(data);
    #
    #     except Exception as err:
    #         print(err);
    #         pass

    def runWithLoop(self):
        # 代理模式
        if (self.mode == PROXY_MODE):
            self.onRecvData(self.socket)
            return ;

        sock = None;
        while True:
            try:
                sock,addr = self.server.accept();
                info = sock.getpeername();
                tipstr = "(%s,%s) connected." % (info [0],info [1])
                print (tipstr);
                if self.m_signal:
                    self.m_signal.emit([], [tipstr])
                pass
                self.socks.append(sock);
                thread = threading.Thread (target=(lambda : self.onRecvData(sock)));
                thread.start();
            except Exception as err:
                print (err);
                if sock:
                    sock.close();
                break;

        self.server.close ();
        print ("Server ended");
        pass

    def closeServer(self):
        if (self.mode == PROXY_MODE):
            self.socket.close();
        else:

            self.server.close();

            for sock in self.socks:
                if sock:
                    # sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR,1)
                    sock.close();

            # self.socks = [];
            # self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR,1)


class FileEventHandler(FileSystemEventHandler):
    def __init__(self,server,baseDir,filePath,mgr):
        FileSystemEventHandler.__init__(self)
        self.baseDir        = baseDir;
        self.filePath       = filePath;
        self.timer          = None;
        self.server         = server;
        self.mgr            = mgr;

        '''
        init with dir SnapShot
        '''
        self.snapshot   = DirectorySnapshot(self.filePath);


    def on_any_event(self, event):
        if self.timer:
            self.timer.cancel ();

        self.timer = threading.Timer (0.02,self.checkSnapshot);
        self.timer.start();

    def getModifyFilesArguments(self,data):
        argv = [];

        try:
            for k in range(len(data)):
                rawpath = data [k];
                l = len (self.baseDir);
                path = rawpath[l:];

                path = eval(repr(path).replace(r"\\", r'/'));
                # path = eval(repr(path).replace(r"src", 'src64'));
                if path [0] == '.':
                    path = path.replace ('.','',1);

                content = '';
                with open (rawpath,'rb') as file:
                    content = file.read();
                    # print (content);

                fpath,filename =  os.path.split(rawpath);

                argv.append((filename,path,content));
                pass
        except Exception as err:
            print (err);

        # print(argv);
        return argv;

    def getDeletedFilesArguments(self,data):
        argv = [];

        try:
            for k in range(len(data)):
                rawpath = data [k];
                l = len (self.baseDir);
                path = rawpath[l:];

                path = eval(repr(path).replace(r"\\", r'/'));

                if path [0] == '.':
                    path = path.replace ('.','',1);

                fpath,filename =  os.path.split(rawpath);

                argv.append((filename,path));
                pass
        except Exception as err:
            print (err);

        # print(argv);
        return argv;

    def getDirsArguments(self,data):
        argv = [];

        try:
            for k in range(len(data)):
                rawpath = data [k];
                l = len (self.baseDir);
                path = rawpath[l:];

                path = eval(repr(path).replace(r"\\", r'/'));

                if path [0] == '.':
                    path = path.replace ('.','',1);

                fpath,filename =  os.path.split(rawpath);

                argv.append((filename,path));
                pass
        except Exception as err:
            print (err);

        # print(argv);
        return argv;

    def getRenameDirsArguments(self,data):
        argv = [];

        try:
            for k in range(len(data)):
                info = data [k];

                oldpath = info [0];
                newpath = info [1];

                oldlen = len (self.baseDir);
                oldpath = oldpath[oldlen:];

                newpath = newpath[oldlen:];

                oldpath = eval(repr(oldpath).replace(r"\\", r'/'));
                newpath = eval(repr(newpath).replace(r"\\", r'/'));

                oldname,oldext =  os.path.split(oldpath);
                newname,newext =  os.path.split(newpath);

                argv.append((oldname,oldpath,newname,newpath));
                pass
        except Exception as err:
            print (err);

        # print(argv);
        return argv;

    def getRenameFilesArguments(self,data):
        argv = [];

        try:
            for k in range(len(data)):
                rawpath = data [k] [1];
                l = len (self.baseDir);
                path = rawpath[l:];

                path = eval(repr(path).replace(r"\\", r'/'));
                # path = eval(repr(path).replace(r"src", 'src64'));
                if path [0] == '.':
                    path = path.replace ('.','',1);

                content = '';
                with open (rawpath,'rb') as file:
                    content = file.read();
                    # print (content);

                fpath,filename =  os.path.split(rawpath);

                argv.append((filename,path,content));
                pass
        except Exception as err:
            print (err);

        # print(argv);
        return argv;

        # argv = [];
        #
        # try:
        #     for k in range(len(data)):
        #         info = data [k];
        #
        #         oldpath = info [0];
        #         newpath = info [1];
        #
        #         oldlen = len (self.baseDir);
        #         oldpath = oldpath[oldlen:];
        #
        #         newpath = newpath[oldlen:];
        #
        #         oldpath = eval(repr(oldpath).replace(r"\\", r'/'));
        #         newpath = eval(repr(newpath).replace(r"\\", r'/'));
        #
        #         oldname,oldext =  os.path.split(oldpath);
        #         newname,newext =  os.path.split(newpath);
        #
        #         argv.append((oldname,oldpath,newname,newpath));
        #         pass
        # except Exception as err:
        #     print (err);
        #
        # # print(argv);
        # return argv;

    def getRenameDirsArguments(self,data):
        argv = [];

        try:
            for k in range(len(data)):
                info = data [k];

                oldpath = info [0];
                newpath = info [1];

                oldlen = len (self.baseDir);
                oldpath = oldpath[oldlen:];

                newpath = newpath[oldlen:];

                oldpath = eval(repr(oldpath).replace(r"\\", r'/'));
                newpath = eval(repr(newpath).replace(r"\\", r'/'));

                oldname,oldext =  os.path.split(oldpath);
                newname,newext =  os.path.split(newpath);

                argv.append((oldname,oldpath,newname,newpath));
                pass
        except Exception as err:
            print (err);

        # print(argv);
        return argv;

    def checkSnapshot(self):

        # print("checking ...");

        snapshot = DirectorySnapshot (self.filePath);
        diff = DirectorySnapshotDiff (self.snapshot,snapshot);
        self.snapshot = snapshot;

        '''
        stop checkTimer 
        '''
        self.timer = None;

        if len (diff.files_created) > 0:
            files = self.getModifyFilesArguments (diff.files_created);
            for key in range (len(files)):
                file = files [key];

                fileinfo = diff.files_created [key];
                self.mgr.onUpdate (CMD_CREATE_FILE,fileinfo);

                print ("File Created " , file [0],file [1]);

                data = ByteArray().makePacket()
                data.writeUnsignedChar(CMD_CREATE_FILE);  #cmd
                data.writeString(file [0]);
                data.writeString(file [1]);
                data.writeString(file [2]);

                self.notifyAllClients(data.endPacket().toStream());

        if len (diff.files_deleted) > 0:

            files = self.getDeletedFilesArguments(diff.files_deleted);
            for key in range (len(files)):
                file = files [key];

                fileinfo = diff.files_deleted[key];
                self.mgr.onUpdate(CMD_DELETE_FILE, fileinfo);

                print ("File Deleted " , file [0],file [1]);

                data = ByteArray().makePacket();
                data.writeUnsignedChar(CMD_DELETE_FILE);  #cmd
                data.writeString(file [0]);
                data.writeString(file [1]);

                self.notifyAllClients(data.endPacket().toStream());


        if len(diff.files_modified) > 0:
            files = self.getModifyFilesArguments(diff.files_modified);
            for key in range (len(files)):
                file = files [key];

                fileinfo = diff.files_modified[key];
                self.mgr.onUpdate(CMD_MODIFY_FILE, fileinfo);

                print ("File Modified " , file [0],file [1]);

                data = ByteArray().makePacket();
                data.writeUnsignedChar(CMD_MODIFY_FILE);  #cmd
                data.writeString(file [0]);
                data.writeString(file [1]);
                data.writeString(file [2]);

                self.notifyAllClients(data.endPacket().toStream());

        if len(diff.files_moved) > 0:
            files = self.getRenameFilesArguments(diff.files_moved);
            for key in range (len(files)):
                file = files [key];

                fileinfo = diff.files_moved[key][1];
                self.mgr.onUpdate(CMD_MODIFY_FILE, fileinfo);

                print ("File Modified " , file [0],file [1]);

                data = ByteArray().makePacket();
                data.writeUnsignedChar(CMD_MODIFY_FILE);  #cmd
                data.writeString(file [0]);
                data.writeString(file [1]);
                data.writeString(file [2]);

                self.notifyAllClients(data.endPacket().toStream());

        #
        # no need to do this !!!
        #
        #
        # if len(diff.dirs_modified) > 0:
        #     print("dirs_modified:", diff.dirs_modified);

        if len(diff.dirs_moved) > 0:
            files = self.getRenameDirsArguments(diff.dirs_moved);
            for key in range (len(files)):
                file = files [key];

                fileinfo = diff.dirs_moved[key];
                self.mgr.onUpdate(CMD_MOVE_DIR, fileinfo);

                print ("Dir Moved " , file [0],file [1]);

                data = ByteArray().makePacket();
                data.writeUnsignedChar(CMD_MOVE_DIR);  #cmd
                data.writeString(file [0]);
                data.writeString(file [1]);
                data.writeString(file [2]);
                data.writeString(file [3]);

                self.notifyAllClients(data.endPacket().toStream());

        if len(diff.dirs_deleted) > 0:
            files = self.getDirsArguments(diff.dirs_deleted);
            for key in range (len(files)):
                file = files [key];

                fileinfo = diff.dirs_deleted[key];
                self.mgr.onUpdate(CMD_DELETE_DIR, fileinfo);

                print ("Dir Deleted " , file [0],file [1]);

                data = ByteArray().makePacket();
                data.writeUnsignedChar(CMD_DELETE_DIR);  #cmd
                data.writeString(file [0]);
                data.writeString(file [1]);

                self.notifyAllClients(data.endPacket().toStream());

        if len(diff.dirs_created) > 0:
            files = self.getDirsArguments(diff.dirs_created);
            for key in range (len(files)):
                file = files [key];

                fileinfo = diff.dirs_created[key];
                self.mgr.onUpdate(CMD_CREATE_DIR, fileinfo);
                print ("Dir Created " , file [0],file [1]);

                data = ByteArray().makePacket();
                data.writeUnsignedChar(CMD_CREATE_DIR);  #cmd
                data.writeString(file [0]);
                data.writeString(file [1]);

                self.notifyAllClients(data.endPacket().toStream());

        pass;

    def notifyAllClients (self,data):
        try:
            self.server.sendToAll (data);
        except Exception as e:
            print ("push message to clients failed ..." , e);
        pass

class DirMonitor(object):
    def __init__(self, baseDir, subDirs, singal=None, mode=None):
        self.baseDir    = baseDir;
        self.subDirs    = subDirs;
        self.observer   = Observer();
        self.server     = None;
        self.m_singal   = singal;
        self.mode       = mode;

        self.fileMap    = {};

        print ("Fetching all dir files ...");
        for key in range (len(self.subDirs)):
            subPath = self.subDirs [key];
            filePath = os.path.join(self.baseDir, subPath);
            self.genFileMap(filePath);

        print("Fetching all dir files Done");
        pass

    def onGameCommand(self,cmd,**params):
        # print("restartGame ...");
        self.server.onGameCommand (cmd,**params);
        pass

    def md5file(self,filePath):
        file_md5 = None;
        with open (filePath,"rb") as file:
            content = file.read();
            file_md5 = hashlib.md5(content).hexdigest();

        return file_md5;
        pass

    def genFileMap(self,filePath):
        files = os.listdir(filePath);
        for file in files:
            fullPath = os.path.join(filePath,file);
            if os.path.isdir(fullPath):
                self.genFileMap (fullPath);
            else:
                # setattr(self.fileMap)
                self.fileMap [fullPath] = self.md5file (fullPath);
        pass

    '''
    
    CMD_CREATE_FILE     = 1;
    CMD_MODIFY_FILE     = 2;
    CMD_DELETE_FILE     = 3;
    CMD_MOVE_FILE       = 4;
    
    CMD_CREATE_DIR      = 5;
    CMD_DELETE_DIR      = 6;
    CMD_MODIFY_DIR      = 7;
    CMD_MOVE_DIR        = 8;

    '''
    def onUpdate(self,mode,filePath):

        if (mode == CMD_CREATE_FILE):
            self.fileMap [filePath] = self.md5file(filePath);
            pass;
        elif mode == CMD_MODIFY_FILE:
            self.fileMap[filePath] = self.md5file(filePath);
            pass;
        elif mode == CMD_DELETE_FILE:
            self.fileMap[filePath] = None;
            pass;
        elif mode == CMD_MOVE_FILE:

            fromPath                = filePath [0];
            toPath                  = filePath [1];

            self.fileMap[fromPath]  = None;
            self.fileMap[toPath]    = self.md5file(toPath);

            pass

        elif mode == CMD_CREATE_DIR:
            pass;
        elif mode == CMD_DELETE_DIR:
            pass
        elif mode == CMD_MODIFY_DIR:
            pass;
        elif mode == CMD_MOVE_DIR:
            pass
        else:
            pass;

        pass

    def start(self):
        if (self.mode == PROXY_MODE):
            server = SocketServer (PROXY_PORT, PROXY_MODE, self.m_singal,self);
        else:
            server = SocketServer (PORT, self.mode, self.m_singal,self);

        for key in range (len(self.subDirs)):
            subPath = self.subDirs [key];
            filePath = os.path.join(self.baseDir, subPath);

            event_handler = FileEventHandler(server,self.baseDir,filePath,self);
            self.observer.schedule(event_handler, filePath, True);

        self.server = server;
        self.observer.start();
        server.runWithLoop();

    def getServer(self):
        return self.server;

    def stop(self):
        if self.server:
            self.server.closeServer();
        self.observer.stop()


'''启动 Logger'''
class Logger():
    def __init__(self, signal, platconfig=None):
        self.m_signal = signal;
        self.m_platconfig = platconfig;
        self.m_param = None;
        self.m_game = "";
        self.initConfig();

    def initConfig(self):
        try:
            path = os.path.join(os.getcwd(), 'plugins', 'Logger', 'config', self.m_game + 'Config.json')
            if not os.path.exists(path):
                path = os.path.join(os.getcwd(), 'plugins', 'Logger', 'config.json')
            
            with open(path, 'r') as file:
                jsonstr = file.read();
                self.m_param = json.loads(jsonstr);

                baseDir = self.m_param['base_dir'];
                if self.m_platconfig and not os.path.exists(baseDir):
                    self.m_param['base_dir'] = os.path.join(self.m_platconfig.project_dir, "client")
                pass
        except Exception as err:
            print(err);

    def onGameCommand(self,cmd,**params):
        if hasattr(self, 'monitor') and self.monitor:
            self.monitor.onGameCommand(cmd,**params);
        pass

    def setgame(self, game=''):
        self.m_game = game;
        self.initConfig();

    def start(self, mode=None):
        if not self.m_param:
            return;
        baseDir = self.m_param['base_dir'];
        subDirs = self.m_param['sub_dirs'];

        self.monitor = DirMonitor(baseDir, subDirs, self.m_signal, mode)
        self.monitor.start();

    def stop(self):
        if hasattr(self, 'monitor') and self.monitor:
            self.monitor.stop();
            print ("WatchDog ended...");
