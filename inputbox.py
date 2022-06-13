import jsonpickle
from PyQt5.QtWidgets import QDialog, QTextBrowser, QTextEdit, QLineEdit, QCheckBox, QPushButton, QLabel
from PyQt5.uic import loadUi

from cmm import *


class InputBox (QDialog):

    def __init__(self, parent,title):
        try:
            super(InputBox, self).__init__(parent)
            loadUi(os.path.join("ui",'inputbox.ui'), self)

            self.msg = "";
            self.ret = -1;

            self.textEdit_input = self.findChild(QTextEdit,"textEdit_input");
            self.pushButton_ok = self.findChild(QPushButton,"pushButton_ok");

            self.label_title = self.findChild(QLabel,"label_title")

            self.label_title.setText (title)

            self.pushButton_ok.clicked.connect (self.onOKClicked);

            # self.username = None;
            # self.passwd = None;
            #
            # self.lineEdit_acct = self.findChild(QLineEdit,"lineEdit_acct");
            # self.lineEdit_passwd = self.findChild(QLineEdit,"lineEdit_passwd");
            # self.checkBox_save_passwd = self.findChild(QCheckBox,"checkBox_save_passwd");
            # self.pushButton_ok = self.findChild(QPushButton,"pushButton_ok");
            #
            # self.pushButton_ok.clicked.connect (self.onOKClicked);

        except Exception as err:
            errmsg(err);

    def onOKClicked(self):
        self.msg = self.textEdit_input.toPlainText ();
        self.ret = 1;
        self.accept();

    def getInput(self):
        info = {};
        info ["msg"] = self.msg;
        info ["ret"] = self.ret;
        return info;


def inputdlg(parent,title):
    dlg = InputBox (parent,title);
    dlg.exec_();
    return dlg.getInput();
