import re
import copy
import math
import time
import threading
import jsonpickle
from threading import Thread
from PyQt5 import sip

from lupa import _lupa
from PyQt5.QtWidgets import QApplication, QDialog, QFrame, QTableWidget, QTableWidgetItem, QAbstractItemView, QLineEdit, QPushButton, QHeaderView, QLabel, QRadioButton, QSizePolicy
from PyQt5.QtGui import QPalette, QColor, QBrush
#from PyQt5.QtCore import QStringListModel, QAbstractItemModel
from PyQt5.uic import loadUi
from PyQt5.Qt import Qt, QRect, QPoint, QSize, QFont, QFontMetrics, QPropertyAnimation, QEasingCurve, QObject
from PyQt5.QtCore import pyqtSignal

from cmm import *
from profile import PMConfig, gLuaPM

'''
玩法名和语言文件名映射表（不一致）
'''
GAME_MAP = {
    "thai_sicbo": "thai_dice",
    "bandar_ceme": "ceme"
}

'''
语言编辑器数据管理类
'''
class LangDataManager ():
    def __init__(self, mainObj, luaglobals):
        self.mainObj = mainObj;
        self.langList = {};
        self.langKeys = {};
        self.langTypes = set();

        platconfig = self.mainObj.getPlatSettings();
        hallName = self.mainObj.cbox_hall.currentText();
        channelCfg = gLuaPM.hallConfig (hallName);

        self.projectPath = os.path.join(platconfig.project_dir, channelCfg.srcname, "client");

        self.getLangConfig(self.projectPath);

    '''读取文件'''
    def doLangFile(self,filename):
        try:
            if os.path.exists(filename):
                file = open(filename, encoding='utf-8');
                content = file.read();

                file.close();
                luaTable = lua.execute(content);

                return luaTable;
        except Exception as err:
            errmsg("File read failed, " + filename);
            errmsg("Reason, " + str(err));
            pass
        return None;

    '''获取语言包'''
    def getLangConfig(self, path=""):
        if path == "":
            return;

        langinfo = gLuaPM.config ().langinfo;

        for k , v in langinfo.items():
            if isinstance(v.res, str):
                self.langTypes.add(v.res);
            else:
                for _ , val in v.res.items():
                    self.langTypes.add(val);

        for res in self.langTypes:
            # base
            base_lang = None;
            filename = os.path.join(path, "base", res, "lang", "string_localize.lua");      #path + "/base/" + res + "/lang/string_localize.lua";
            base_lang = self.doLangFile(filename);

            # base mtt
            mtt_lang = None;
            filename = os.path.join(path, "base", res, "lang", "string_localize_mtt.lua");      #path + "/base/" + res + "/lang/string_localize_mtt.lua";
            mtt_lang = self.doLangFile(filename);

            # hall
            hall_lang = None;
            filename = os.path.join(path, "hall", res, "lang", "string_localize.lua");      #path + "/hall/" + res + "/lang/string_localize.lua";
            hall_lang = self.doLangFile(filename);

            # game
            game_lang = {};
            for root, dirs, files in os.walk(path + "/game"):
                for name in dirs:
                    if not re.search(".svn", name):
                        filename = os.path.join(path, "game", name, res, "lang", "string_localize_{0}.lua".format(name));       #path + "/game/" + name + "/" + res + "/lang/string_localize_" + name + ".lua";
                        if name in GAME_MAP:
                            filename = os.path.join(path, "game", name, res, "lang", "string_localize_{0}.lua".format(GAME_MAP[name]));     #path + "/game/" + name + "/" + res + "/lang/string_localize_" + GAME_MAP[name] + ".lua";
                        game_lang[name] = self.doLangFile(filename);
                break;

            '''保存读到的数据'''
            info = {'lang': res, 'base': base_lang, 'mtt': mtt_lang, 'hall': hall_lang, 'game': game_lang};
            self.langList[res] = info;

        '''保存键集合'''
        try:
            langKeys = {};
            for lang, blist in self.langList.items():
                for tp, v in blist.items():
                    if not isinstance(v, str) and v != None:
                        if tp == "game":
                            if not 'game' in langKeys:
                                langKeys['game'] = {};

                            for game, value in v.items():
                                if value != None:
                                    if not game in langKeys['game']:
                                        langKeys['game'][game] = set();

                                    for key in value.keys():
                                        langKeys['game'][game].add(key);
                        else:
                            if not tp in langKeys:
                                langKeys[tp] = set();

                            for key in v.keys():
                                langKeys[tp].add(key);
            # 键排序
            for key , val in langKeys.items():
                if key == "game":
                    self.langKeys[key] = {};
                    for game , vals in val.items():
                        self.langKeys[key][game] = list(vals);
                        self.langKeys[key][game].sort();
                else:
                    self.langKeys[key] = list(val);
                    self.langKeys[key].sort();

        except Exception as err:
            errmsg(err);


    '''获取指定语言词条'''
    def getLangList(self, lang):
        info = {};
        if self.langList[lang]:
            for tp , v in self.langList[lang].items():
                if v == None:
                    continue;

                temp = {};
                if isinstance(v, str):
                    temp = v;
                elif tp == "game":
                    for game, vals in v.items():
                        if vals != None:
                            temp[game] = {};
                            for key, val in vals.items():
                                temp[game][key] = val;
                         #   temp[game] = temp[game].items();
                        #    temp[game] = sorted(temp[game].items(), key=lambda item: item[0]);
                else:
                    for key , val in v.items():
                        temp[key] = val;
                 #   temp = sorted(temp.items(), key=lambda item: item[0]);

                info[tp] = temp;
        return info;

    '''获取所有语言词条'''
    def getAllLangs(self):
        langList = {};
        for tp in self.langTypes:
            langList[tp] = self.getLangList(tp);

        keyCount = 0;
        for key , val in self.langKeys.items():
            if key == "game":
                for k , v in val.items():
                    keyCount += len(v);
            else:
                keyCount += len(val);

        return langList, keyCount;

    def getLangKeys(self):
        return self.langKeys;

    def getLangTypes(self):
        langTypes = set();
        for lang in self.langTypes:
            if lang == "res":
                langTypes.add("INA");
            else:
                temp = lang.split('_');
                if len(temp) >= 2:
                    langTypes.add(temp[1].upper());

        langTypes = list(langTypes);
        langTypes.sort();

        return langTypes;

    '''获取Table格式化'''
    def getTableStringByKey(self, key, module):
        langTypes = self.getLangTypes();
        stringDict = {};

        for value in langTypes:
            lang, tableStr = "res", None;
            if value != "INA":
                lang = "res_" + value.lower();

            moduleObj = None;
            langList = self.langList[lang];

            if module in langList:
                moduleObj = langList[module];
            else:
                moduleObj = langList["game"][module];

            try:
                if moduleObj != None and hasattr(moduleObj, key):
                    obj = getattr(moduleObj, key);
                    tableStr = self.Table_To_String(obj);
                pass
            except Exception as err:
                errmsg(err);

            stringDict[value] = tableStr or "";

        return stringDict;

    '''Table格式化'''
    def Table_To_String(self, tab, depth=1):

        tabStr, space = "", "";

        for i in range(depth):
            space = space + "\t";
        pass

        if depth <= 1:
            tabStr = "{\n";
        pass

        if tab != None:
            # 此处按Key排序输出
            for key, val in sorted(tab.items()):
                kType = type(key).__name__;
                vType = type(val).__name__;
                tempStr = "";

                if vType == "_LuaTable":
                    if kType == "str":
                        tempStr = "[\"{0}\"] = {{".format(key) + self.Table_To_String(val, depth + 1);
                    else:
                        tempStr = "[{0}] = {{".format(key) + self.Table_To_String(val, depth + 1);
                    pass
                elif vType == "int" or vType == "float":
                    if kType == "int":
                        tempStr = "[{0}] = {1};\n".format(key, val);
                    else:
                        tempStr = "[\"{0}\"] = {1};\n".format(key, val);
                    pass
                else:
                    value = str(val);
                    if re.search("\n", value):
                        value = value.replace("\n", "\\n");
                    elif re.search("\"", value):
                        value = value.replace("\"", "\\\"");
                    pass

                    if kType == "int":
                        tempStr = "[{0}] = \"{1}\";\n".format(key, value);
                    else:
                        tempStr = "[\"{0}\"] = \"{1}\";\n".format(key, value);
                    pass
                tabStr = tabStr + space + "\t" + tempStr;
            pass

        tabStr = tabStr + space + "};\n";
        if depth > 1:
            tabStr = "\n" + tabStr;

        return tabStr;


'''单元数据类'''
class LangDataItem ():
    def __init__(self, data):
        self.row = 0;
        self.module = "";
        self.key = "";
        self.value = "";
        self.oldValue = "";
        self.isLoad = False;
        self.isTable = False;
        self.data = data;

    def setInfo(self, row, module, key, value, isTable):
        self.row = row;
        self.module = module;
        self.key = key;
        self.value = value;
        self.oldValue = value;
        self.isLoad = True;
        self.isTable = isTable;

    def setValue(self, value, isChange=False, isNew=False):
        self.value = value;
        if isChange:
            self.data.mergeRowString(self.row);
        if isNew:
            self.oldValue = value;

'''整体数据类'''
class LangData ():
    def __init__(self, row, col):
        self.langList = [];     # 数据列表
        self.rowList = [];      # 行字符串列表

        self.moduleList = {};   # 模块列表
        self.modelList = [];    # 模板列表

        self.row = row;
        self.col = col;

        #初始化数据
        for r in range(row):
            rowList = [];
            for c in range(col):
                rowList.append(LangDataItem(self));
            pass
            self.langList.append(rowList);
            self.rowList.append("");

        #初始化模板列表
        for c in range(col):
            self.modelList.append(None);
        pass

    def isLoad(self, row, col):
        row = int(row);
        col = int(col);

        if row < self.row and col < self.col:
            item = self.langList[row][col];
            return item.isLoad;

    '''合并行字符串'''
    def mergeRowString(self, row):
        row = int(row);
        if row < self.row:
            rowStr = "";
            for item in self.langList[row]:
                if item.value:
                    rowStr = rowStr + "|" + item.value;
            pass
            self.rowList[row] = rowStr;
        pass

    def setItem(self, row, col, param):
        row = int(row);
        col = int(col);

        if row < self.row and col < self.col:
            key     = str(param['key']);
            module  = str(param['module']);
            value   = str(param['value']);
            beMerge = param['merge'];       # 拼接每行所有字符串，保存
            isTable = param['table'];

            item = self.langList[row][col];
            item.setInfo(row, module, key, value, isTable);

            if module in self.moduleList:
                if key not in self.moduleList[module]:
                    self.moduleList[module][key] = copy.deepcopy(self.modelList);   # 深拷贝
                self.moduleList[module][key][col] = item;
            else:
                self.moduleList[module] = {};
                if key not in self.moduleList[module]:
                    self.moduleList[module][key] = copy.deepcopy(self.modelList);   # 深拷贝
                self.moduleList[module][key][col] = item;

            # 合并行字符串
            if beMerge:
                self.mergeRowString(row);

            return item;

    def getItem(self, row, col):
        row = int(row);
        col = int(col);

        if row < self.row and col < self.col:
            return self.langList[row][col];

    def setItemByKeyModule(self, key, module, idx, param):
        key     = str(key);
        module  = str(module);
        idx     = int(idx);
        value   = str(param['value']);

        if module in self.moduleList:
            if key in self.moduleList[module]:
                self.moduleList[module][key].setValue(value);
            pass
        pass

    def getItemByKeyModule(self, key, module, idx):
        key = str(key);
        module = str(module);
        idx = int(idx);

        if module in self.moduleList:
            if key in self.moduleList[module]:
                return self.moduleList[module][key][idx];
            pass
        pass

    def getRowItems(self, row):
        row = int(row);

        if row < self.row:
            return self.langList[row];
        pass

    def getRowString(self, row):
        row = int(row);
        if row < self.row:
            return self.rowList[row];

    def getModuleCount(self, module):
        module = str(module);

        if module in self.moduleList:
            return len(self.moduleList[module]);
        pass

    def getItemsByModuleIdx(self, module, idx):
        module = str(module);
        idx = int(idx);

        langInfo = [];

        if module in self.moduleList:
            if idx < self.col:
                for key, vals in self.moduleList[module].items():
                    langInfo.append(vals[idx]);
                pass

        return langInfo;


'''操作记录类'''
class LangOperate ():
    def __init__(self, column):
        self.m_column = column;
        self.m_modelList = [];

        self.lastIndex = None;  # 最近一次操作，撤销/重做
        self.recordList = [];   # 记录列表
        self.modifyDict = {};   # 修改信息
        self.itemList   = set();   # 修改数据集合

        for i in range(column):
            self.m_modelList.append({});

    '''设置最近一次操作'''
    def setLastIndex(self, index):
        self.lastIndex = index;

    def increaseLastIndex(self):
        self.lastIndex = self.getLastIndex() + 1;

    def decreaseLastIndex(self):
        self.lastIndex = self.getLastIndex() - 1;

    def getLastIndex(self):
        if self.lastIndex == None:
            self.lastIndex = len(self.recordList) - 1;
        return self.lastIndex;

    '''获取上一次记录'''
    def getLastRecord(self):
        if self.lastIndex < 0:
            self.lastIndex = 0;
        record = self.recordList[self.lastIndex]
        self.decreaseLastIndex();
        return record;

    '''获取下一次记录'''
    def getNextRecord(self):
        self.increaseLastIndex();
        if self.lastIndex >= len(self.recordList):
            self.lastIndex = len(self.recordList) - 1;

        return self.recordList[self.lastIndex];

    def addRecordInfo(self, info):
        lastIndex = self.getLastIndex();
        if lastIndex + 1 < len(self.recordList):
            self.recordList = self.recordList[:lastIndex+1]

        self.recordList.append(info);
        self.lastIndex = len(self.recordList) - 1;

        if len(self.recordList) > 100:
            self.recordList = self.recordList[50:];
            if self.lastIndex > 49:
                self.lastIndex = self.lastIndex - 50;
            else:
                self.lastIndex = 0;

    def addModifyInfo(self, data, langIdx, newValue):
        module = str(data.module);
        langIdx = int(langIdx);
        key = str(data.key);
        value = str(newValue);
        oldValue = str(data.oldValue);

        if module not in self.modifyDict:
            self.modifyDict[module] = copy.deepcopy(self.m_modelList);    # 深拷贝

        if value == oldValue:
            if key in self.modifyDict[module][langIdx]:
                self.modifyDict[module][langIdx].pop(key);
        else:
            self.modifyDict[module][langIdx][key] = value;
            self.itemList.add(data);
        pass

    def isChangeExisted(self, langIdx):
        for module, vals in self.modifyDict.items():
            for idx , dict in enumerate(vals):
                if idx == langIdx and len(dict) > 0:
                    return True;

        return False;

    def getButtonStates(self):
        backState, redoState = True, True;
        lastIndex = self.getLastIndex();
        recordCnt = len(self.recordList);

        if lastIndex == -1:
            backState = False;
            if recordCnt == 0:
                redoState = False
            pass
        elif lastIndex + 1 == recordCnt:
            redoState = False;

        return backState, redoState;

    def getModifyConfig(self):
        config = {};
        for module, vals in self.modifyDict.items():
            if module not in config:
                config[module] = [];

            for idx, dict in enumerate(vals):
                if len(dict) > 0:
                    config[module].append(idx);
        return config;

    def reset(self):
        for item in self.itemList:
            item.oldValue = item.value;

        self.itemList.clear();
        self.modifyDict.clear();
        pass


'''语言窗口类'''
class LangManDialog (QDialog):
    def __init__(self, parent,luaglobals):
        try:
            super(LangManDialog, self).__init__(parent)
            loadUi(os.path.join("ui",'langman.ui'), self)

            self.changeEnable = False;
            self.lastText = "";

            self.langList = [];

            self.langManager = LangDataManager(parent, None);

            '''Widget'''
            self.tableView_lang = self.findChild(QTableWidget, "lang_list");
            self.edit_input = self.findChild(QLineEdit, "lineEdit_search");
            self.btn_search = self.findChild(QPushButton, "btn_search");
            self.btn_back = self.findChild(QPushButton, "btn_back");
            self.btn_redo = self.findChild(QPushButton, "btn_redo");
            self.lb_module = self.findChild(QLabel, "moduleLabel");
            self.case_select = self.findChild(QRadioButton, "case_select");

            '''Bind event'''
            self.tableView_lang.itemClicked.connect(self.onTableViewClicked);
            self.tableView_lang.itemDoubleClicked.connect(self.onTableViewDoubleClicked);
            self.edit_input.textChanged.connect(self.onTextChanged)
            self.btn_search.clicked.connect(self.onClickSerach);
            self.btn_back.clicked.connect(self.onClickBack);
            self.btn_redo.clicked.connect(self.onClickRedo);

            self.edit_input.setToolTip("Ctrl+F");
            self.btn_search.setToolTip("Ctrl+S");
            self.btn_back.setToolTip("Ctrl+Z");
            self.btn_redo.setToolTip("Ctrl+Y");

            self.btn_back.setEnabled(False);
            self.btn_redo.setEnabled(False);

            pa = QPalette();
            pa.setColor(QPalette.WindowText, QColor(51, 153, 255))
            self.lb_module.setPalette(pa);
            self.lb_module.setText("");

            self.initTableView_lang();
            self.tableView_lang.itemChanged.connect(self.onItemChanged);

            '''初始化提示框'''
            self.langTipBox = LangTipBox(self);
        #    self.langTipBox.show();

        #    self.add_list_item(0, ['Banker_help_string', '123456']);

        except Exception as err:
            errmsg(err);

    '''初始化TableView'''
    def initTableView_lang(self):

        langTypes = self.langManager.getLangTypes();
        langList, row = self.langManager.getAllLangs();

        langTypes.insert(0, "Key")
        column = len(langTypes);
        self.langTypes = langTypes;

        self.langData = LangData(row, column);
        self.langOperate = LangOperate(column);

        self.tableView_lang.setRowCount(row);
        self.tableView_lang.setColumnCount(column);
        self.tableView_lang.setHorizontalHeaderLabels(langTypes);
        self.tableView_lang.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch);  # 所有列自动拉伸，充满界面
        self.tableView_lang.setSelectionMode(QAbstractItemView.SingleSelection);  # 设置只能选中一行
        self.tableView_lang.setSelectionBehavior(QAbstractItemView.SelectRows);  # 设置只有行选中
        self.tableView_lang.setShowGrid(False);

        '''加载词条'''
        try:
            index = 0;
            for lang in langTypes:
                lang = lang.lower();
                if lang == "key":
                    self.add_column_items(index, "KEY")
                    index += 1;
                elif lang == "ina":
                    self.add_column_items(index, langList['res'])
                    index += 1;
                else:
                    self.add_column_items(index, langList['res_' + lang])
                    index += 1;

            print("");
        except Exception as err:
            errmsg(err);


    def keyPressEvent(self, event):
        if QApplication.keyboardModifiers() == Qt.ControlModifier:
            eventKey = event.key();

            if eventKey == Qt.Key_Z:        # Ctrl + Z
                self.onClickBack();
            elif eventKey == Qt.Key_Y:      # Ctrl + Y
                self.onClickRedo();
            elif eventKey == Qt.Key_S:      # Ctrl + S
                self.tableView_lang.setFocus();
                self.saveAllFiles();
            elif eventKey == Qt.Key_F:      # Ctrl + F
                self.edit_input.setFocus();
                self.edit_input.selectAll();
        pass


    '''设置修改后表头颜色'''
    def showHeaderColor(self, idx, changed):
        item = self.tableView_lang.horizontalHeaderItem(idx);
        if item != None:
            if changed:
                item.setForeground(QBrush(QColor(255, 0, 0)));
            else:
                item.setForeground(QBrush(QColor(0, 0, 0)));
        pass

    def refreshButtons(self):
        backState, redoState = self.langOperate.getButtonStates();
        self.btn_back.setEnabled(backState);
        self.btn_redo.setEnabled(redoState);


    def onClickSerach(self):
        self.saveAllFiles();

    def onClickBack(self):
        info = self.langOperate.getLastRecord();
        item = self.tableView_lang.item(info['row'], info['col']);

        if item != None:
            item.setText(info['old']);
            if item.m_data and item.column() > 0:
                item.m_data.setValue(item.text(), True);
                self.langOperate.addModifyInfo(item.m_data, item.column(), item.text());

            state = self.langOperate.isChangeExisted(item.column());
            self.showHeaderColor(item.column(), state);
            self.refreshButtons();

            self.tableView_lang.scrollToItem(item);
            self.tableView_lang.selectRow(item.row());
            self.tableView_lang.setFocus();
        pass

    def onClickRedo(self):
        info = self.langOperate.getNextRecord();
        item = self.tableView_lang.item(info['row'], info['col']);

        if item != None:
            item.setText(info['new']);
            if item.m_data and item.column() > 0:
                item.m_data.setValue(item.text(), True);
                self.langOperate.addModifyInfo(item.m_data, item.column(), item.text());

            state = self.langOperate.isChangeExisted(item.column());
            self.showHeaderColor(item.column(), state);
            self.refreshButtons();

            self.tableView_lang.scrollToItem(item);
            self.tableView_lang.selectRow(item.row());
            self.tableView_lang.setFocus();
        pass


    '''搜索框回调'''
    def onTextChanged(self):
        self.lb_module.setText("");
        self.tableView_lang.clear();

        text = self.edit_input.text();
        caseSelect = self.case_select.isChecked();
        isNone = (text == "");

        if not caseSelect:
            text = text.lower();

        rows = self.tableView_lang.rowCount();
        cols = self.tableView_lang.columnCount();

        try:
            count = 0;
            for row in range(rows):
                isMatch = False;
                content = self.langData.getRowString(row);

                if not caseSelect and content:
                    content = content.lower();
                pass

                if content and re.search(text, content):
                    isMatch = True;
                pass

                if isMatch:
                    itemData = self.langData.getItem(row, 0);
                    if itemData:
                        length = self.langData.getModuleCount(itemData.module);
                        items = self.langData.getRowItems(row);

                        for col, data in enumerate(items):
                            self.createViewItem(count, col, data.key, data.value, data.module, length);
                        pass
                        count += 1;
                pass

            self.tableView_lang.setHorizontalHeaderLabels(self.langTypes);
            self.tableView_lang.scrollToTop();
            pass
        except Exception as err:
            errmsg(err);


    '''TableView Item Changed'''
    def onItemChanged(self, item):
        if not self.changeEnable or not hasattr(item, 'm_data'):
            return;

        curText = item.text();
        itemData = item.m_data;

        module = item.m_module;
        langIdx = item.column();

        if langIdx <= 0:
            item.setText(itemData.key);
            return;

        if itemData and curText != self.lastText:
            itemData.setValue(curText, True);
            self.langOperate.addRecordInfo({'new': item.text(), 'old': self.lastText, 'row': item.row(), 'col': item.column()});
            self.langOperate.addModifyInfo(itemData, item.column(), item.text());

            state = self.langOperate.isChangeExisted(langIdx);
            self.showHeaderColor(langIdx, state);
            self.refreshButtons();
        pass


    #    print(item.text());

        # 修改事件开关
        self.changeEnable = False;
        pass

    def onTableViewDoubleClicked(self, item):
        # 修改事件开关
        self.changeEnable = True;
        self.lastText = item.text();
        pass

    def onTableViewClicked(self, item):
        self.changeEnable = False;

        if item == None or not hasattr(item, 'm_count'):
            return;

        count = item.m_count;
        module = item.m_module;
        itemData = item.m_data;

        if isinstance(module, str):
            if count > 0:
                self.lb_module.setText("模块:  {0} - {1}".format(module.capitalize(), count));
            else:
                self.lb_module.setText("模块:  {0}".format(module.capitalize()));
        else:
            if count > 0:
                self.lb_module.setText("模块:  {0} - {1}".format("Unknown", count));
            else:
                self.lb_module.setText("模块:  {0}".format("Unknown"));
        pass

        # 第N行，第N列
        row = item.row();
        col = item.column();

        key = self.tableView_lang.item(row, 0).text();

        isTable, subItems = False, [];
        columnCount = self.tableView_lang.columnCount();

        for i in range(columnCount):
            subItem = self.tableView_lang.item(row, i);
            subItems.append(subItem);
            if subItem != None:
                if subItem.text() == "TABLE":
                    isTable = True;

        # 获取Table值
        try:
            if isTable:
                valueDict = self.langManager.getTableStringByKey(key, module);
                for subItem in subItems:
                    cIdx = subItem.column();
                    if subItem and cIdx > 0:
                        lang = self.langTypes[cIdx];
                        if lang in valueDict:
                            subItem.setText(valueDict[lang]);

                            data = self.langData.getItemByKeyModule(key, module, cIdx);
                            if data != None:
                                data.setValue(valueDict[lang], True, True);
            pass
        except Exception as err:
            errmsg(err);

        pass


    '''创建单元格'''
    def createViewItem(self, row, col, key, value, module, count):
        if isinstance(value, str):
            newItem = QTableWidgetItem(value);
        elif type(value).__name__ == "_LuaTable":
            newItem = QTableWidgetItem("TABLE");
        else:
            newItem = QTableWidgetItem("NoString");

        newItem.m_module = module;
        newItem.m_count = count;

        #保存数据
        if not self.langData.isLoad(row, col):
            beMerge = (self.langData.col == col + 1);
            isTable = (newItem.text() == "TABLE");
            newItem.m_data = self.langData.setItem(row, col, {'module': module, 'key': key, 'value': newItem.text(), 'merge': beMerge, 'table': isTable});
        else:
            newItem.m_data = self.langData.getItemByKeyModule(key, module, col);

        self.tableView_lang.setItem(row, col, newItem);
        pass

    '''添加一列数据(纵向)'''
    def add_column_items(self, column, data):
        if data == None:
            return;

        isKey = (data == "KEY");
        langKeys = self.getSortKeys();

        index, info, gameInfo = 0, [], [];

        for val in langKeys:
            module = val['type'];
            values = val['value'];
            if not isKey:
                info = [];
                if module in data:
                    info = data[module];
                pass
            if module == "game":
                for vals in values:
                    module = vals['type'];
                    keys = vals['value'];
                    count = len(keys);
                    if not isKey:
                        gameInfo = [];
                        if module in info:
                            gameInfo = info[module];
                        pass
                    for key in keys:
                        if isKey:
                            self.createViewItem(index, column, key, key, module, count);
                            index += 1;
                        else:
                            if key in gameInfo:
                                self.createViewItem(index, column, key, gameInfo[key], module, count);
                                index += 1;
                            else:
                                self.createViewItem(index, column, key, "", module, count);
                                index += 1;
            else:
                count = len(values);
                for key in values:
                    if isKey:
                        self.createViewItem(index, column, key, key, module, count);
                        index += 1;
                    else:
                        if key in info:
                            self.createViewItem(index, column, key, info[key], module, count);
                            index += 1;
                        else:
                            self.createViewItem(index, column, key, "", module, count);
                            index += 1;
                        pass
                    pass
                pass
            pass
        pass

    '''获取排序键名'''
    def getSortKeys(self):
        if hasattr(self, 'keyList'):
            return self.keyList;
        else:
            self.keyList = [];

        '''键名分类排序'''
        langKeys = self.langManager.getLangKeys();
        oneList = list(langKeys.keys());

        if not hasattr(langKeys,'game'):
            return self.keyList;

        twoList = list(langKeys['game']);

        oneList.sort();
        twoList.sort();

        for tp in oneList:
            tempList = {'type': tp, 'value': langKeys[tp]}
            if tp == "game":
                tempList = {'type': tp, 'value': []};
                for game in twoList:
                    tempList['value'].append({'type': game, 'value': langKeys[tp][game]})

            self.keyList.append(tempList);
            pass
        return self.keyList;


    '''保存所有文件'''
    def saveAllFiles(self):
        isChanged = False;
        config = self.langOperate.getModifyConfig();

        for module, vals in config.items():
            for langIdx in vals:
                self.saveToFile(module, langIdx);
                self.showHeaderColor(langIdx, False);
                isChanged = True;

        if isChanged:
            self.langOperate.reset();
            self.refreshButtons();

    '''保存数据'''
    def saveToFile(self, module, idx):

        langInfo = self.langData.getItemsByModuleIdx(module, idx);
        if langInfo == None:
            return;

        lastKey = "";
        filestr = "local string_localize = {\n";

        for item in langInfo:
            if item == None:
                continue;

            tempstr = "";
            if lastKey != item.key[0:3]:
                filestr += "\n";
                lastKey = item.key[0:3];

            if item.value == "TABLE":
                tempstr = "\t{0} = ".format(item.key);
                values = self.langManager.getTableStringByKey(item.key, module);

                lang = self.langTypes[idx];
                if lang in values:
                    tempstr += values[lang];
            else:
                value = str(item.value);
                tempstr = "\t{0} = \"".format(item.key);

                if item.isTable:
                    tempstr = "\t{0} = ".format(item.key);
                    tempstr += value + "\n";
                else:
                    if re.search("\n", value):
                        value = value.replace("\n", "\\n");
                    elif re.search("\"", value):
                        value = value.replace("\"", "\\\"");
                    pass
                    tempstr += value + "\";\n";
                pass

            filestr += tempstr;
        filestr += "};\n\nreturn string_localize;";

        path = None;

        res = self.langTypes[idx].lower();
        if res != "ina":
            res = "res_" + res;
        else:
            res = "res";

        if module == "base":
            path = os.path.join(self.langManager.projectPath, "base", res, "lang", "string_localize.lua");      #self.langManager.projectPath + "/base/" + res + "/lang/string_localize.lua";
        elif module == "mtt":
            path = os.path.join(self.langManager.projectPath, "base", res, "lang", "string_localize_mtt.lua");      #self.langManager.projectPath + "/base/" + res + "/lang/string_localize_mtt.lua";
        elif module ==  "hall":
            path = os.path.join(self.langManager.projectPath, "hall", res, "lang", "string_localize.lua");      #self.langManager.projectPath + "/hall/" + res + "/lang/string_localize.lua";
        else:
            path = os.path.join(self.langManager.projectPath, "game", module, res, "lang", "string_localize_{0}.lua".format(module));  # self.langManager.projectPath + "/game/{0}/".format(module) + res + "/lang/string_localize_{0}.lua".format(module);
            if module in GAME_MAP:
                path = os.path.join(self.langManager.projectPath, "game", module, res, "lang", "string_localize_{0}.lua".format(GAME_MAP[module]));
        pass

        source = self.langManager.doLangFile(path);
    #    path = "C:\\Users\\Administrator\\Desktop\\string_localize.lua";

        if source == None:
            self.langTipBox.showMsg("源文件读取失败：" + path);
            return;
        pass

        if os.path.exists(path):
            file = open(path, encoding='utf-8', mode='w+');

            file.write(filestr);
            file.close();

            self.langTipBox.showMsg("文件保存成功：" + path);
        pass



'''提示弹窗类'''
class LangTipBox(QObject):
    animate_signal = pyqtSignal([str]);     #信号槽

    def __init__(self, parent):
        super(LangTipBox, self).__init__(parent);

        self.parent = parent;
        self.tipList = [];
        self.waitList = [];
        self.boxList = [];

        self.delayTime = 6;     #显示时间
        self.maxCount = 3;      #最多显示数目
        self.size = parent.size();

        self.animate_signal.connect(self.threadCallback);
        pass

    def showMsg(self, msg):
        if msg == None or msg == "":
            return;

        try:
            if len(self.tipList) >= self.maxCount:
                self.waitList.append(msg);
            else:
                self.addMessage(msg);
            pass
        except Exception as err:
            self.animate_signal.emit(err);
            pass


    def addMessage(self, msg):
        msg = str(msg);

        tipBox = self.getTipBox();
        tipBox.setText(msg);
        tipBox.show();

        size = tipBox.getBoxSize();
        geometry = tipBox.getGeometry();
        tipBox.setPos(self.size.width() - size.width() - 5, self.getBoxPosY()+10);
        tipBox.setUsed(True);

        posy = self.getBoxEndPosY(len(self.tipList));
        self.moveTipBox(tipBox, QPoint(self.size.width() - size.width() - 5, posy));
        self.tipList.append(tipBox);

        # 线程计时
        timeOff = len(self.tipList) - 1;
        thread = threading.Thread(target=self.delay_do, args=(tipBox,self.delayTime+3*timeOff,))
        thread.start();


    def getBoxPosY(self):
        posy = 5;
        count = len(self.tipList);

        if count > 0:
            box = self.tipList[count-1];
            geometry = box.getGeometry();
            posy += geometry.y() + geometry.height();
        pass

        return posy;

    def getBoxEndPosY(self, idx):
        posy = 5;
        for i , box in enumerate(self.tipList):
            if i < idx:
                size = box.getBoxSize();
                posy += size.height() + 5;
            pass

        return posy;

    def getTipBox(self):
        if len(self.boxList) < self.maxCount:
            self.boxList.append(CustomBox(self.parent));

        for box in self.boxList:
            if not box.isUsed():
                return box;
            pass
        pass

    def moveTipBox(self, box, point):
        if box == None or point == None:
            return;

        geometry = box.getGeometry();
        animation = QPropertyAnimation(self.parent);
        animation.setTargetObject(box.getTipBox())
        animation.setPropertyName(b'pos')
        animation.setStartValue(QPoint(geometry.x(), geometry.y()));
        animation.setEndValue(point);
        animation.setDuration(500);
        animation.setEasingCurve(QEasingCurve.OutSine);
        animation.start();

        box.setAnimation(animation);

    def threadCallback(self, signal=""):
        if signal != "":
            errmsg(signal);
        else:
            for i, box in enumerate(self.tipList):
                geometry = box.getGeometry();
                posy = self.getBoxEndPosY(i);
                self.moveTipBox(box, QPoint(geometry.x(), posy));
            pass
        pass

    '''倒计时'''
    def delay_do(self, box, delay):
        for i in range(delay, -1, -1):
            if i == 0:
                index = self.tipList.index(box);
                if index != None:
                    self.tipList.pop(index);
                    box.setUsed(False);
                    box.hide();

                    # 显示下一条
                    if len(self.waitList) > 0:
                        msg = self.waitList.pop(0);
                        self.showMsg(msg);

                    size = box.getBoxSize();
                    self.animate_signal.emit("");


                    break;

            time.sleep(1.0);
        pass



class CustomBox():
    def __init__(self, parent):
        tipBox = QFrame(parent);
        tipBox.setStyleSheet("QWidget{border-radius:6px;background-color:rgb(255,255,222);border:1px solid rgb(0,0,0)}");
        tipBox.setFrameShape(QFrame.Box);

        label = QLabel(tipBox);
        label.adjustSize();
        label.setFrameShape(QFrame.NoFrame);
        label.setStyleSheet("QWidget{border:0px}");
        label.setAlignment(Qt.AlignTop);
        label.setWordWrap(True);
        label.setFont(QFont("微软雅黑", 10))

        self.animation = None;
        self.isused = False;
        self.label = label;
        self.tipbox = tipBox;

    def show(self):
        self.tipbox.show();
        self.label.show();

    def hide(self):
        self.tipbox.hide();
        self.label.hide();

    def setText(self, msg):
        self.label.setText(msg);

        maxWidth, gap = 320, 8;
        size = self.getMessageSize(msg);

        if size.width() + 2 * gap < maxWidth:
            self.label.setGeometry(QRect(gap, gap, size.width(), size.height()));
            self.tipbox.resize(size.width() + 2 * gap, size.height() + 2 * gap);
        else:
            width = maxWidth - 2 * gap;
            height = size.height() * math.ceil(size.width() / width);
            self.label.setGeometry(QRect(gap, gap, maxWidth - 2 * gap, height));
            self.tipbox.resize(maxWidth, height + 2 * gap);
        pass

    def setPos(self, x, y):
        size = self.getBoxSize();
        self.tipbox.setGeometry(x, y, size.width(), size.height());

    def setUsed(self, state):
        self.isused = state;

    def isUsed(self):
        return self.isused;

    def getMessageSize(self, msg):
        fm = QFontMetrics(QFont("微软雅黑", 10));
        width = fm.horizontalAdvance(msg);
        height = fm.height();
        return QSize(width,height);

    def getBoxSize(self):
        return self.tipbox.size();

    def getGeometry(self):
        return self.tipbox.geometry();

    def getTipBox(self):
        return self.tipbox;

    def setAnimation(self, ani):
        self.animation = ani;

    def stopAnimation(self):
        if self.animation:
            self.animation.stop();