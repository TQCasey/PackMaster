import sys

import psutil as psutil
from PyQt5 import QtCore
from PyQt5.QtWidgets import QApplication

from android.ui import MainWindowAndroid
from cmm import *
from ios.ui import MainWindowIOS
# import qdarkstyle

if hasattr(QtCore.Qt, 'AA_EnableHighDpiScaling'):
    QtCore.QCoreApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling, True);

if hasattr(QtCore.Qt, 'AA_UseHighDpiPixmaps'):
    QtCore.QCoreApplication.setAttribute(QtCore.Qt.AA_UseHighDpiPixmaps, True)

app = QApplication(sys.argv);
# app.setStyleSheet(qdarkstyle.load_stylesheet())

def mainLoop():
    app.setApplicationName("PackMan3")
    app.setApplicationDisplayName("PackMan3")
    app.setApplicationVersion("3")
    sys.exit(app.exec())

"""
to check if there is already a PackMan
"""
pre_pid = None;
try:
    with open ("pid.txt","r") as file:
        pre_pid = int (file.read());
except Exception as err:
    pass

pids = psutil.pids ();
if pre_pid in pids:
    MsgBox().warn ("已经开启了一个实例 PackMan ,如果需要强制启动新的PackMan，请删除 pid.txt 文件");
    sys.exit(0);
else:
    print ("start a new PackMan");

"""
save the current pid 
"""
try:
    with open ("pid.txt","w") as file:
        file.write(str (os.getpid()));
except Exception as err:
    pass

app_window = None;
if isWin():
    app_window = MainWindowAndroid ();
elif isMacOS():
    app_window = MainWindowIOS ();
else:
    MsgBox().msg("None-supported platform!!");
    sys.exit ();


if app_window != None:
    app_window.show()
    mainLoop ();