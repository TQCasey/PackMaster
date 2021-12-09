
from PyQt5.QtWidgets import QPushButton
from PyQt5.QtGui import QIcon
from PyQt5.QtCore import QSize


'''自定义PushButton'''
class PushButton(QPushButton):

    # 静态变量
    NO_BORDER = 1;

    def __init__(self, parent):
        super(PushButton, self).__init__(parent)
        self.m_parent = parent or None;

        self.ico_normal = None;
        self.ico_press = None;
        self.ico_hover = None;


    '''设置按钮样式'''
    def setButtonStyle(self, style=None):
        if style == PushButton.NO_BORDER:
            self.setStyleSheet("QPushButton{background-color:rgba(255, 255, 255, 0); border:none}");

    '''设置按钮图标'''
    def setButtonImage(self, *args, **kwargs):
        args    = args or [];
        kwargs  = kwargs or {};

        if len(args) > 0:
            self.ico_normal = QIcon(args[1]);
            self.setIcon(self.ico_normal);
        elif "normal" in kwargs:
            self.ico_normal = QIcon(kwargs["normal"]);
            self.setIcon(self.ico_normal);
        pass

        if "press" in kwargs:
            self.ico_press = QIcon(kwargs["press"]);

        if "hover" in kwargs:
            self.ico_hover = QIcon(kwargs["hover"]);


    '''鼠标进入事件'''
    def enterEvent(self, event):
        if self.ico_hover:
            self.setIcon(self.ico_hover);


    '''鼠标离开事件'''
    def leaveEvent(self, event):
        if self.ico_normal:
            self.setIcon(self.ico_normal);


    '''按钮点击事件'''
    def mousePressEvent(self, event):
        if self.ico_press:
            self.setIcon(self.ico_press);


    '''按钮松开事件'''
    def mouseReleaseEvent(self, event):
        if self.ico_hover:
            self.setIcon(self.ico_hover);