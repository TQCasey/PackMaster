from cmm import *


class MakeHallChCommon(object):
    def __init__(self,**kwargs):
        try:

            self.pmconfig   = kwargs.get ("pmconfig");
            self.hallName   = kwargs.get ("hallName");
            self.chName     = kwargs.get ("chName");

            platconfig      = self.getPlatSettings();
            self.lua_project_dir = os.path.join(platconfig.project_dir, self.hallName);

        except Exception as err:
            errmsg(err);

    def run(self):
        try:
            if (self.lua_project_dir [0].isnumeric()):
                rmsgbox("大厅名字不合法");
                return ;

            if self.isHallChValid():
                rmsgbox("不能创建已有大厅渠道!");
                return ;

            self.makeNewHallLuaDir ();
            self.makeNewHallChConfig ();
            self.makeNewHallGames();
            self.makeNewHallNativeDir();
            self.allDone();

        except Exception as err:
            errmsg (err);

    def isHallChValid(self):
        return True;

    def allDone(self):
        pass


