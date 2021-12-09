import jsonpickle
from PyQt5 import Qt, QtWidgets, QtCore
from PyQt5.QtCore import QSize
from PyQt5.QtGui import QStandardItem, QStandardItemModel
from PyQt5.QtWidgets import QDialog, QPushButton, QListWidget, QAbstractItemView, QListWidgetItem, QLabel, QLineEdit, \
    QTableWidget, QTableWidgetItem
from PyQt5.uic import loadUi

from cmm import *
from profile import gWhiteList

class WhiteListDialog(QDialog):
    def __init__(self, parent=None):
        super(WhiteListDialog, self).__init__(parent)

        try:
            loadUi(os.path.join("ui",'whitelist.ui'), self)

            self.tableWidget_whitelist = self.findChild(QTableWidget,"tableWidget_whitelist");

            header = self.tableWidget_whitelist.horizontalHeader()

            width = self.tableWidget_whitelist.width() - 40;
            self.tableWidget_whitelist.setColumnWidth(0, 250);
            self.tableWidget_whitelist.setColumnWidth(1, width  - 250);

            self.pushButton_whitelist_add = self.findChild(QPushButton, "pushButton_whitelist_add")
            self.lineEdit_dev_sn = self.findChild(QLineEdit,"lineEdit_dev_sn");
            self.lineEdit_name = self.findChild(QLineEdit,"lineEdit_name");
            self.pushButton_whitelist_del = self.findChild(QPushButton,"pushButton_whitelist_del");

            self.pushButton_whitelist_add.clicked.connect (self.onAddToList);
            self.pushButton_whitelist_del.clicked.connect (self.onDelFromList);

            self.loadLists();
        except Exception as err:
            errmsg(err);

    def onAddToList(self):

        devname = self.lineEdit_dev_sn.text ();
        name = self.lineEdit_name.text ();
        if devname == "" or name == "":
            rmsgbox("请补全名字和设备名");
            return ;

        if gWhiteList.isInList(devname):
            MsgBox().msg("%s 已经添加进来，不需要再次添加" % devname);
            return ;

        if True == gWhiteList.addToList(name,devname):
            info = {
                "devname" : devname,
                "name" : name,
            };

            i = self.tableWidget_whitelist.rowCount ();
            self.tableWidget_whitelist.insertRow(i);

            """
            name 
            """
            item = QTableWidgetItem(str(info ["name"]))
            # item.setFlags(QtCore.Qt.ItemIsEnabled)
            self.tableWidget_whitelist.setItem(i, 0, item)

            """
            devname
            """
            item = QTableWidgetItem(str(info ["devname"]))
            # item.setFlags(QtCore.Qt.ItemIsUserCheckable | QtCore.Qt.ItemIsEnabled)
            self.tableWidget_whitelist.setItem(i, 1, item)

            MsgBox().msg("添加成功!");
        else:
            MsgBox().msg("添加失败!");

        pass

    def onDelFromList(self):

        try:
            if MsgBox().ask ("确认删除当前选中行么?") != 1024:
                return ;

            # print ("delete raw item");
            selectRow = self.tableWidget_whitelist.selectedItems() [1];

            index = selectRow.row ();
            devname = selectRow.text();

            self.tableWidget_whitelist.removeRow(index)
            gWhiteList.removeFromList(devname);
            MsgBox().msg("删除成功!");

        except Exception as err:
            errmsg (err);

        pass

    def loadLists(self):

        try:
            ## raw list
            self.tableWidget_whitelist.setRowCount (gWhiteList.getCount ())
            list = gWhiteList.getList();
            index = 0;
            for i in list:
                info = list[i];
                """
                name 
                """
                item = QTableWidgetItem(str(info ["name"]))
                # item.setFlags(QtCore.Qt.ItemIsUserCheckable)
                self.tableWidget_whitelist.setItem(index, 0, item)

                """
                devname
                """
                item = QTableWidgetItem(str(info ["devname"]))
                # item.setFlags(QtCore.Qt.ItemIsUserCheckable | QtCore.Qt.ItemIsEnabled)
                self.tableWidget_whitelist.setItem(index, 1, item)

                index += 1;
            pass

        except Exception as err:
            errmsg (err);

        pass

    def onSaveAll(self):
        pass

    def closeEvent(self, e):
        gWhiteList.save();
        pass


