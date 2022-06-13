from PyQt5 import Qt
from PyQt5.QtCore import QSize
from PyQt5.QtGui import QStandardItem, QStandardItemModel
from PyQt5.QtWidgets import QDialog, QPushButton, QListWidget, QAbstractItemView, QListWidgetItem, QLabel, QTableWidget, \
    QTableWidgetItem
from PyQt5.uic import loadUi
from PyQt5 import Qt, QtCore, QtWidgets

from cmm import *
from profile import gFilterList

class ChangeListDlg(QDialog):
    def __init__(self, parent=None,dict=None):
        super(ChangeListDlg, self).__init__(parent)

        self.dict = dict;
        self.ret = 1;

        changedlist  = dict ['changelist'];
        gamesChangedArr = dict["gamesChangedArr"];
        hasBaseAndHallChanged = dict["hasBaseAndHallChanged"];

        try:
            loadUi(os.path.join("ui",'changelist.ui'), self)

            self.pushButton_remain_hallnum = self.findChild(QPushButton,"pushButton_remain_hallnum");
            self.pushButton_add_hallnum = self.findChild(QPushButton,"pushButton_add_hallnum");
            self.tableWidget_changelist = self.findChild(QTableWidget,"tableWidget_changelist")
            self.label_tips = self.findChild(QLabel,"label_tips");

            self.tableWidget_changelist.setEditTriggers(QtWidgets.QAbstractItemView.NoEditTriggers)

            if hasBaseAndHallChanged == False:
                self.pushButton_add_hallnum.setVisible(False);
                self.label_tips.setVisible (False);
                self.pushButton_remain_hallnum.setText ("OK")


            header = self.tableWidget_changelist.horizontalHeader()
            header.setSectionResizeMode(1, QtWidgets.QHeaderView.ResizeToContents)
            header.setSectionResizeMode(0, QtWidgets.QHeaderView.Stretch)

            self.tableWidget_changelist.setRowCount(len(changedlist) - 0)

            map = {
                "?" : ("增加",Qt.QColor (0x00,0xff,0)),
                "A" : ("增加",Qt.QColor (0x00,0xff,0)),
                "!" : ("删除",Qt.QColor (0xff,0,0)),
                "D" : ("删除",Qt.QColor (0xff,0,0)),
                "M" : ("修改",Qt.QColor (0,0,0xff)),
                ">" : ("修改",Qt.QColor (0,0,0xff)),
                "Summary" : ("冲突",Qt.QColor (0xff,0,0)),
                "Text" : ("Text",Qt.QColor (0xff,0,0))
            }
            for index in range(len(changedlist)):

                changeinfo = changedlist [index];

                '''mode'''
                mkey    = changeinfo [1];
                if  mkey in map:
                    '''filepath'''
                    change_filepath = changeinfo [0];

                    tlistitem = QTableWidgetItem (change_filepath);
                    self.tableWidget_changelist.setItem (index,0,tlistitem);
                    # tlistitem.setAlignment(Qt.Qt.AlignCenter)

                    modstr  = map [mkey] [0];
                    color   = map [mkey] [1];

                    modeitem = QTableWidgetItem (modstr);
                    self.tableWidget_changelist.setItem (index,1,modeitem);
                    modeitem.setBackground (color)
                else:
                    errmsg("NO Key %s" % mkey);

            self.pushButton_remain_hallnum.clicked.connect (self.onRemainHallNum);
            self.pushButton_add_hallnum.clicked.connect (self.onAddHallNum);

        except Exception as err:
            errmsg(err);

    def onRemainHallNum(self):
        self.ret = 1;
        self.accept();
        pass

    def onAddHallNum(self):
        if MsgBox().ask("确认提升大厅框架号么??，请仔细确认") == 1024:
            self.ret = 2;
            self.accept();
        pass

    def getReturnValue(self):
        return self.ret;
        pass

def AlertChangeList (parent,dict):
    dialog = ChangeListDlg(parent,dict)
    result = dialog.exec_ ();
    rev = dialog.getReturnValue();
    return rev;


