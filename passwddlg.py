import jsonpickle
from PyQt5.QtWidgets import QDialog, QTextBrowser, QLineEdit, QCheckBox, QPushButton
from PyQt5.uic import loadUi

from cmm import *
from profile import PMConfig, gPMConfig


class PasswdDlg (QDialog):

    def __init__(self, parent):
        try:
            super(PasswdDlg, self).__init__(parent)
            loadUi(os.path.join("ui",'passwd.ui'), self)

            self.username = None;
            self.passwd = None;

            self.lineEdit_acct = self.findChild(QLineEdit,"lineEdit_acct");
            self.lineEdit_passwd = self.findChild(QLineEdit,"lineEdit_passwd");
            self.checkBox_save_passwd = self.findChild(QCheckBox,"checkBox_save_passwd");
            self.pushButton_ok = self.findChild(QPushButton,"pushButton_ok");

            self.pushButton_ok.clicked.connect (self.onOKClicked);

        except Exception as err:
            errmsg(err);

    def onOKClicked(self):
        self.username = self.lineEdit_acct.displayText ().strip ();
        self.passwd = self.lineEdit_passwd.displayText ().strip ();
        gPMConfig.setAccInfo(self.username,self.passwd);
        self.accept();

    def getAccInfo(self):
        return [self.username,self.passwd];


def getAccountInfo(parent):
    dlg = PasswdDlg (parent);
    dlg.exec_();
    return dlg.getAccInfo();
