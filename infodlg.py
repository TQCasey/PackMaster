import jsonpickle
from PyQt5.QtWidgets import QDialog, QTextBrowser
from PyQt5.uic import loadUi

from cmm import *
from profile import PMConfig


class JsonDialog (QDialog):
    def __init__(self, parent,pmconfig_str,mode = 1):
        try:
            super(JsonDialog, self).__init__(parent)
            loadUi(os.path.join("ui",'infodlg.ui'), self)

            self.textbox = self.findChild(QTextBrowser,"text_json");
            if mode == 1:
                pmconfig = PMConfig (pmconfig_str,0);
                a = jsonpickle.dumps(pmconfig);
                self.textbox.append (a);
            else:
                self.textbox.append (pmconfig_str);

        except Exception as err:
            errmsg(err);