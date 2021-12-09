
"""
iOS
"""
from cmm import *
from gameprofile import GameProfileDialogBase
from xml.dom.minidom import parse

from profile import gLuaPM


class GameProfileDialogIOS(GameProfileDialogBase):
    def __init__(self, parent,luaglobals):
        super(GameProfileDialogIOS, self).__init__(parent,None)

    def getPlatSettings(self):
        return self.pmconfig.getPlatSettings("ios");

    def updateIcon (self):
        pass;

    def isHallChValid(self,hallName,chName):
        try:
            return True;
        except Exception as err:
            errmsg(err);

    def updateNativeParam(self):
        try:
            hallName = self.comboBox_hall.currentText();
            chName = self.comboBox_ch.currentText();

            if hallName == "" or chName == "":
                return;

            print("hallName %s , chName %s" % (hallName, chName))

        except Exception as err:
            errmsg(err);

        pass
