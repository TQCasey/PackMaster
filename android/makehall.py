from cmm import *
from makehall import MakeHallChCommon
from profile import gLuaPM


class MakeHallChAndroid(MakeHallChCommon):

    def makeNewHallLuaDir(self):
        try:
            print ("makeNewHallLuaDir ...");
            hallName = self.hallName;
            chName = self.chName;

            gdata = gLuaPM.hallConfig ("android-" + hallName);
            if gdata:
                print ("make new channel %s..." % self.chName);

            else:
                print ("make new hall");

        except Exception as err:
            errmsg (err);
        pass;

    def isHallChValid(self):
        hallName = self.hallName;
        chName = self.chName;

        if gLuaPM.hallConfig("android-" + hallName) and gLuaPM.chConifg("android-" + hallName,chName):
            return True;
        else:
            return False;

    def getPlatSettings(self):
        return self.pmconfig.getPlatSettings("android");

    def makeNewHallChConfig(self):
        try:
            pass
        except Exception as err:
            errmsg (err);

    def makeNewHallGames(self):
        try:
            pass
        except Exception as err:
            errmsg (err);

    def makeNewHallNativeDir(self):
        try:
            pass
        except Exception as err:
            errmsg (err);