"""
android
"""
import os
import re

from PyQt5.QtGui import QPixmap
from xml.dom.minidom import parse
from gameprofile import GameProfileDialogBase
from cmm import *
from profile import gPMConfig, gLuaPM


class GameProfileDialogAndroid(GameProfileDialogBase):
    def __init__(self, parent,luaglobals):
        super(GameProfileDialogAndroid, self).__init__(parent,None)

    def getPlatSettings(self):
        return gPMConfig.getPlatSettings("android");

    def isHallChValid(self,hallName,chName):
        try:

            if hallName == "":
                return False;

            arr = hallName.split ("-");
            if chName == "":
                ch_path = os.path.join("channel_files", arr[1],"android");
                return os.path.exists(ch_path);
            else:
                ch_path = os.path.join("channel_files", arr[1],"android",chName);
                return os.path.exists(ch_path);

        except Exception as err:
            errmsg(err);

    def getLuaConfigPath(self,hallName):
        arr = hallName.split("-");
        return os.path.join("channel_files",arr [1],"android","config.lua")

    def updateIcon (self):
        try:
            hallName = self.comboBox_hall.currentText();
            chName = self.comboBox_ch.currentText();
            arr     = hallName.split ("-");

            if hallName == "" or chName == "":
                return;

            icon_path = os.path.join("channel_files",arr [1],"android",chName,"res","drawable-xhdpi","icon.png");
            if os.path.exists(icon_path):
                self.picview_ico.setPixmap(QPixmap(icon_path));
                self.picview_ico.setScaledContents(True);
            else:
                self.picview_ico.setPixmap(QPixmap(os.path.join(".", "ui", "icon.png")));

        except Exception as err:
            # errmsg(err);
            self.picview_ico.setPixmap(QPixmap(os.path.join(".", "ui", "icon.png")));
        pass


    def updateNativeParam (self):
        try:
            hallName = self.comboBox_hall.currentText();
            chName = self.comboBox_ch.currentText();
            arr = hallName.split("-");

            if hallName == "" or chName == "":
                return;

            AndroidManifest_file = os.path.join("channel_files",  arr[1],"android", chName, "AndroidManifest.xml");
            if os.path.exists(AndroidManifest_file):
                domtree = parse(AndroidManifest_file);
                root = domtree.documentElement;
                sdkinfo = root.getElementsByTagName ("uses-sdk");

                if len(sdkinfo) > 0:
                    self.lineEdit_min_api.setText(sdkinfo[0].getAttribute("android:minSdkVersion"));
                    self.lineEdit_target_api.setText(sdkinfo[0].getAttribute("android:targetSdkVersion"));

                self.trackInput (self.lineEdit_min_api);
                self.trackInput (self.lineEdit_target_api);

                appnode = root.getElementsByTagName ("application");
                if len(appnode) > 0:
                    allprovider_nodes = appnode [0].getElementsByTagName ("provider");
                    for node in allprovider_nodes:
                        name = node.getAttribute("android:name");
                        if name == "com.facebook.FacebookContentProvider":
                            self.lineEdit_fb_provider_id.setText (node.getAttribute("android:authorities"));
                            self.trackInput(self.lineEdit_fb_provider_id);
                            break;

            string_file = os.path.join("channel_files", arr[1],"android",  chName,"res","values","strings.xml");
            # print(string_file);

            if os.path.exists(string_file):
                # print ("yes yes yes .......")
                domtree = parse(string_file);
                root = domtree.documentElement;

                allnodes = root.getElementsByTagName("string");
                for node in allnodes:
                    name = node.getAttribute("name");
                    value = node.childNodes[0].nodeValue;

                    if name == "facebook_app_id":
                        self.lineEdit_fb_app_id.setText (value);
                        self.trackInput(self.lineEdit_fb_app_id);
                    elif name == "facebook_ads_id":
                        self.lineEdit_fb_ad_id.setText (value);
                        self.trackInput(self.lineEdit_fb_ad_id);
                    elif name == "base64EncodedPublicKey":
                        self.textEdit_google_key.setText (value)
                        self.trackInput(self.textEdit_google_key);
                    elif name == "SENDER_ID":
                        self.lineEdit_sender_id.setText (value);
                        self.trackInput(self.lineEdit_sender_id);
                    elif name == "app_name":
                        self.lineEdit_display_name.setText (value)
                        self.trackInput(self.lineEdit_display_name);
                    elif name == "appsflyer_dev_key":
                        self.lineEdit_appsflyer_id.setText (value);
                        self.trackInput(self.lineEdit_appsflyer_id);

        except Exception as err:
            errmsg(err);
        pass

    def saveNativeParam(self):
        gName = self.getHallName();     # 当前游戏
        chName = self.prevChName;       # 当前渠道

        # AndroidManifest.xml
        filepath = os.path.join("channel_files", gName, "android", chName, "AndroidManifest.xml");
        if os.path.exists(filepath):
            domtree = parse(filepath);
            root = domtree.documentElement;
            sdkinfo = root.getElementsByTagName("uses-sdk");

            # sdk version
            if len(sdkinfo) > 0:
                sdkinfo[0].setAttribute("android:minSdkVersion", self.lineEdit_min_api.displayText());
                sdkinfo[0].setAttribute("android:targetSdkVersion", self.lineEdit_target_api.displayText());

            # fb provider
            appnode = root.getElementsByTagName("application");
            if len(appnode) > 0:
                allprovider_nodes = appnode[0].getElementsByTagName("provider");
                for node in allprovider_nodes:
                    name = node.getAttribute("android:name");
                    if name == "com.facebook.FacebookContentProvider":
                        node.setAttribute("android:authorities", self.lineEdit_fb_provider_id.displayText());
                        break;
            # save xml
            try:
                with open(filepath, mode='w+', encoding='utf-8') as file:
                    # 4.writexml()第一个参数是目标文件对象，第二个参数是根节点的缩进格式，第三个参数是其他子节点的缩进格式，
                    # 第四个参数制定了换行格式，第五个参数制定了xml内容的编码。
                    domtree.writexml(file, indent='', addindent='', newl='', encoding='utf-8');
                    file.close();
            except Exception as err:
                print(err);

            # package name
            try:
                prev_text = self.inputs[self.lineEdit_package_name];
                now_text = self.lineEdit_package_name.displayText();
                if prev_text != now_text:
                    file = open(filepath, encoding='utf-8');
                    content = file.read();
                    file.close();

                    content = re.sub(prev_text, now_text, content);
                    file = open(filepath, mode='w+', encoding='utf-8');
                    file.write(content);
                    file.close();
            except Exception as err:
                print(err);


        # strings.xml
        filepath = os.path.join("channel_files", gName, "android", chName, "res", "values", "strings.xml");
        if os.path.exists(filepath):
            domtree = parse(filepath);
            root = domtree.documentElement;

            allnodes = root.getElementsByTagName("string");
            for node in allnodes:
                name = node.getAttribute("name");

                if name == "facebook_app_id":
                    node.childNodes[0].nodeValue = self.lineEdit_fb_app_id.displayText();
                elif name == "facebook_ads_id":
                    node.childNodes[0].nodeValue = self.lineEdit_fb_ad_id.displayText();
                elif name == "base64EncodedPublicKey":
                    node.childNodes[0].nodeValue = self.textEdit_google_key.toPlainText();
                elif name == "SENDER_ID":
                    node.childNodes[0].nodeValue = self.lineEdit_sender_id.displayText();
                elif name == "app_name":
                    node.childNodes[0].nodeValue = self.lineEdit_display_name.displayText();
                elif name == "appsflyer_dev_key":
                    node.childNodes[0].nodeValue = self.lineEdit_appsflyer_id.displayText();
                elif name == "ACTION_ON_REGISTERED":
                    value = node.childNodes[0].nodeValue;
                    prev_text = self.inputs[self.lineEdit_package_name];
                    now_text = self.lineEdit_package_name.displayText();
                    node.childNodes[0].nodeValue = re.sub(prev_text, now_text, value);

            # save xml
            try:
                with open(filepath, mode='w+', encoding='utf-8') as file:
                    # 4.writexml()第一个参数是目标文件对象，第二个参数是根节点的缩进格式，第三个参数是其他子节点的缩进格式，
                    # 第四个参数制定了换行格式，第五个参数制定了xml内容的编码。
                    domtree.writexml(file, indent='', addindent='', newl='', encoding='utf-8');
                    file.close();
            except Exception as err:
                print(err);