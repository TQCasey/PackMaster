from PyQt5 import Qt
from PyQt5.QtCore import QSize
from PyQt5.QtGui import QStandardItem, QStandardItemModel
from PyQt5.QtWidgets import QDialog, QPushButton, QListWidget, QAbstractItemView, QListWidgetItem, QLabel
from PyQt5.uic import loadUi

from cmm import *
from profile import gFilterList


class DragDropListView(QListWidget):

    def __init__(self, parent,tagName):
        super(DragDropListView, self).__init__(parent)
        self.tagName = tagName;
        self.parent = parent;

        try:
            self.setDragDropMode(QAbstractItemView.DragDrop)
            self.setSelectionMode(QAbstractItemView.ExtendedSelection)
            self.setAlternatingRowColors(True);
            self.setAcceptDrops(True);
            self.setDropIndicatorShown(True);

        except Exception as err:
            errmsg (err);

    def dragEnterEvent(self, event):
        try:
            text = event.mimeData().text ();
            if text.endswith ("png"):
                event.accept ();
            else:
                event.ignore ();
        except Exception as err:
            errmsg (err);

    def dragMoveEvent(self, event):
        try:
            text = event.mimeData().text ();
            if text.endswith ("png"):
                event.accept ();
            else:
                event.ignore ();
        except Exception as err:
            errmsg (err);

    def dropEvent(self, event):
        try:
            path = event.mimeData().text ();
            if path.endswith ("png"):
                event.accept ();

                ## extral actions when the right png file dropped
                dir,filename = os.path.split(path);
                # filen, fileext = os.path.splitext(filename);

                if self.tagName == "raw" and not gFilterList.isInRawList(filename):
                    QListWidgetItem(filename,self);
                    gFilterList.addToRawList(filename);
                elif self.tagName == "rgba8888" and not gFilterList.isInRGBA888List(filename):
                    QListWidgetItem(filename,self);
                    gFilterList.addToRGBA888List(filename);

                self.parent.updateCountText ();
                MsgBox().msg("添加成功!");

            else:
                event.ignore ();
        except Exception as err:
            errmsg (err);


class FilterListDialogBase(QDialog):
    def __init__(self, parent=None):
        super(FilterListDialogBase, self).__init__(parent)

        try:
            loadUi(os.path.join("ui",'filterlist.ui'), self)

            self.listview_rgba8888 = DragDropListView(self,"rgba8888");
            self.listview_rgba8888.setGeometry (510,50,340,690);
            self.label_rgba8888 = self.findChild(QLabel,"label_rgba8888_cnt");
            self.btn_del_rgba8888 = self.findChild(QPushButton, "btn_del_rgba8888")
            self.label_rgba8888.setStyleSheet ("color:red;");

            self.listview_raw = DragDropListView(self,"raw");
            self.listview_raw.setGeometry(10,50,340,690);
            self.label_raw = self.findChild(QLabel, "label_raw_cnt");
            self.btn_del_raw = self.findChild(QPushButton,"btn_del_raw")
            self.label_raw.setStyleSheet("color:red;");
            self.btn_save_all   = self.findChild(QPushButton,"btn_save_all");

            self.btn_del_raw.clicked.connect (self.onDelRawListItem);
            self.btn_del_rgba8888.clicked.connect (self.onDelRGBA888ListItem);

            self.btn_save_all.clicked.connect (self.onSaveAll);

            self.loadLists();
        except Exception as err:
            errmsg(err);

    def loadLists(self):

        try:
            ### raw list
            list = gFilterList.getRawList();
            listview = self.listview_raw;
            listview.setSortingEnabled(True);

            for name in list:
                if name != "":
                    item = QListWidgetItem (name,listview);
                    item.setSizeHint(QSize(0, 25));

            ### rgba888 list
            list = gFilterList.getRGBA888List();
            listview = self.listview_rgba8888;
            listview.setSortingEnabled(True);

            for name in list:
                if name != "":
                    item = QListWidgetItem (name,listview);
                    item.setSizeHint(QSize(0, 25));

            self.updateCountText ();

        except Exception as err:
            errmsg (err);

        pass

    def onDelRawListItem(self):
        try:
            # print ("delete raw item");
            items = self.listview_raw.selectedItems();
            for item in items:
                self.listview_raw.takeItem (self.listview_raw.row (item));

                gFilterList.removeRaw(item.text());
                # print ("remove rawitem " + item.text ());

            # print (items);
            self.updateCountText ();

        except Exception as err:
            errmsg (err);

    def onDelRGBA888ListItem(self):
        try:
            # print ("delete rgba8888 item");
            items = self.listview_rgba8888.selectedItems();
            for item in items:
                self.listview_rgba8888.takeItem (self.listview_rgba8888.row (item));
                gFilterList.removeRGBA8888(item.text());
                # print ("remove rgba8888 " + item.text ());

            self.updateCountText ();

        except Exception as err:
            errmsg (err);

    def updateCountText(self):
        try:
            cnt = gFilterList.getRawCount();
            self.label_raw.setText ('''不压缩图片数量（骨骼动画） : %d''' % cnt);

            cnt = gFilterList.getRGBA8888Count();
            self.label_rgba8888.setText ('''高质量图片数量 : %d''' % cnt);

        except Exception as err:
            errmsg(err);

    def onSaveAll(self):
        # print ("save all");
        gFilterList.save();

    def closeEvent(self, e):
        gFilterList.save();
        pass


