import jsonpickle
from PyQt5.QtWidgets import QDialog, QTextBrowser, QTableWidget, QAbstractItemView, QTableView, QTableWidgetItem, \
    QHeaderView, QTextEdit, QLabel
from PyQt5.uic import loadUi

from cmm import *
from profile import PMConfig
from PyQt5 import Qt, QtCore, QtWidgets

class LogListDialog (QDialog):
    def __init__(self, parent,list,url_link):
        try:
            super(LogListDialog, self).__init__(parent)
            loadUi(os.path.join("ui",'loglistdlg.ui'), self)
            self.list = list;
            self.dbclick_version = 0;

            self.tableWidget_modlist = self.findChild(QTableWidget,"tableWidget_modlist")
            self.tableWidget_modlist.setColumnCount(4)
            # self.tableWidget_modlist.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
            self.tableWidget_modlist.setRowCount(len(list))
            # self.tableWidget_modlist.resizeColumnsToContents()
            self.tableWidget_modlist.setSelectionMode(QAbstractItemView.SingleSelection);
            self.tableWidget_modlist.setEditTriggers(QTableView.NoEditTriggers);
            self.tableWidget_modlist.setSelectionBehavior(QAbstractItemView.SelectRows);
            self.tableWidget_modlist.setHorizontalHeaderLabels(['版本',"作者",'日期',"信息"])

            width = self.tableWidget_modlist.width;
            # self.tableWidget_modlist.setColumnWidth(0, 100);

            header = self.tableWidget_modlist.horizontalHeader()
            header.setSectionResizeMode(0, QtWidgets.QHeaderView.ResizeToContents)
            header.setSectionResizeMode(1, QtWidgets.QHeaderView.ResizeToContents)
            header.setSectionResizeMode(2, QtWidgets.QHeaderView.ResizeToContents);
            header.setSectionResizeMode(3, QtWidgets.QHeaderView.ResizeToContents);

            self.tableWidget_filelist = self.findChild(QTableWidget,"tableWidget_filelist")
            self.tableWidget_filelist.setColumnCount(2)
            self.tableWidget_filelist.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
            # self.tableWidget_modlist.resizeColumnsToContents()
            self.tableWidget_filelist.setSelectionMode(QAbstractItemView.SingleSelection);
            self.tableWidget_filelist.setEditTriggers(QTableView.NoEditTriggers);
            self.tableWidget_filelist.setSelectionBehavior(QAbstractItemView.SelectRows);
            self.tableWidget_filelist.setHorizontalHeaderLabels(['路径',"操作"])

            self.textEdit_msg = self.findChild(QTextEdit,"textEdit_msg");

            self.tableWidget_modlist.cellClicked.connect (self.onLogItemClicked);
            self.tableWidget_modlist.itemDoubleClicked.connect (self.onLogItemDBClicked);
            self.onLoadLogList ();
            self.onLoadModFileList (list[0].changelist);

            self.url_label = self.findChild(QLabel,"url_label");
            self.url_label.setText (url_link)

        except Exception as err:
            errmsg(err);

    def onLogItemDBClicked(self):
        try:
            list = self.tableWidget_modlist.selectedItems();
            for i in range(len (list)):
                # print (list [i]);
                item = list [i];
                index = self.tableWidget_modlist.indexFromItem (item).row() ;
                info = self.list [index];
                # rmsgbox(info.revision);
                self.dbclick_version = info.revision;
                self.accept();
                break;
            pass
        except Exception as err:
            errmsg(err);

    def onLogItemClicked(self):
        # print ("clicked");
        try:
            list = self.tableWidget_modlist.selectedItems();
            for i in range(len (list)):
                # print (list [i]);
                item = list [i];
                index = self.tableWidget_modlist.indexFromItem (item).row() ;
                info = self.list [index];
                filelist = info.changelist;
                msg = info.msg;
                # print (filelist);
                self.textEdit_msg.setText (msg);
                self.onLoadModFileList (filelist);

                break;
            pass
        except Exception as err:
            errmsg(err);

    def onLoadLogList(self):
        try:
            list = self.list;
            for i in range(len(list)):
                info = list[i];
                """
                version 
                """
                item = QTableWidgetItem(str(info[2]))
                self.tableWidget_modlist.setItem(i, 0, item)

                """
                author
                """
                item = QTableWidgetItem(str(info[3]))
                self.tableWidget_modlist.setItem(i, 1, item)

                """
                date
                """
                date = info[0];
                # print (date);
                item = QTableWidgetItem(str(date))
                self.tableWidget_modlist.setItem(i, 2, item)

                """
                info
                """
                item = QTableWidgetItem(str(info[1]))
                self.tableWidget_modlist.setItem(i, 3, item)
        except Exception as err:
            errmsg(err);
        pass

    def onLoadModFileList(self,list):
        try:
            self.tableWidget_filelist.clearContents ();
            self.tableWidget_filelist.setRowCount(len(list))
            for i in range(len(list)):
                info = list[i];

                item = QTableWidgetItem(str(info[1]))
                self.tableWidget_filelist.setItem(i, 0, item)

                item = QTableWidgetItem(str(info[0]))
                self.tableWidget_filelist.setItem(i, 1, item)

        except Exception as err:
            errmsg(err);

        pass

    def getRevision(self):
        return self.dbclick_version;

def getRevision (parent,list,url_link):
    dialog = LogListDialog(parent,list,url_link)
    result = dialog.exec_ ();
    rev = dialog.getRevision();
    return rev;