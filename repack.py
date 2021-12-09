

import json
import os
import plistlib
import subprocess
from os import path

from PIL import Image
from cmm import *

"""
Commander Class
"""
class Commander:

    def __init__(self):
        pass

    '''显示日志'''
    def do(self, cmd,cwd = None,env = None,encoding = None):
        try:
            process = subprocess.Popen(cmd,
                                       shell=True,
                                       bufsize=0,
                                       stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT,
                                       universal_newlines=True,
                                       cwd=cwd,
                                       encoding=encoding,
                                       env=env);
            while True:
                output = process.stdout.readline()
                if output != None:
                    output = output.strip();
                    if output != "":
                        print(output);
                if output == "" and process.poll() != None:
                    break;
        except Exception as err:
            print(err);

    '''不显示日志'''
    def run(self, cmd,cwd = None,env = None,encoding = None):
        try:
            process = subprocess.Popen(cmd,
                                       shell=True,
                                       bufsize=0,
                                       stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT,
                                       universal_newlines=True,
                                       cwd=cwd,
                                       encoding=encoding,
                                       env=env);

        except Exception as err:
            print(err);

class RepackImage:

    def __init__(self):
        pass

    def export_image(self,img, pathname, item,outdir):

        # 去透明后的子图矩形
        frameSz = item['frame'];

        x = frameSz['x'];
        y = frameSz['y'];
        w = frameSz['w'];
        h = frameSz['h'];

        # 子图原始大小
        rawSize = item['sourceSize'];
        size = (rawSize['w'], rawSize['h'])

        # 子图在原始图片中的偏移
        rawSizeOff = item['spriteSourceSize'];

        ox = rawSizeOff['x'];
        oy = rawSizeOff['y'];

        # 获取子图左上角，右下角
        if item['rotated']:
            box = (x, y, x + h, y + w)
        else:
            box = (x, y, x + w, y + h)

        # 使用原始大小创建图像，全透明
        image = Image.new('RGBA', size, (0, 0, 0, 0))
        # 从图集中裁剪出子图
        sprite = img.crop(box)

        # rotated纹理旋转90度
        if item['rotated']:
            sprite = sprite.transpose(Image.ROTATE_90)

        # 粘贴子图，设置偏移
        image.paste(sprite, (ox, oy))

        # 保存到文件
        pathdir = os.path.join(outdir, "subs");
        if not os.path.exists(pathdir):
            os.mkdir(pathdir);

        pathname = os.path.join(pathdir,pathname);

        print('保存文件 ===> %s' % pathname)
        image.save(pathname, 'png');

        return pathname;

    def get_frame(self,frame):
        result = {}
        if frame['frame']:
            result['frame'] = frame['frame'];
            result['sourceSize'] = frame['sourceSize'];
            result['spriteSourceSize'] = frame['spriteSourceSize'];
            result['rotated'] = frame['rotated']
        return result

    def packImages(self,bigImage,filename,path):

        plistfile =  path + ".plist" ##os.path.join(path,filename + ".plist");
        pngfile = path + ".png" ##os.path.join (path,filename + ".png");
        packdir = os.path.join(path,"subs");

        print("\nrepack pngres (dir : %s) (plist : %s) (png : %s) ..." % (packdir,plistfile,pngfile));

        cmdstr = ('TexturePacker '
                  '--texture-format png '
                  '--format cocos2d '
                  '--data %s '
                  '--sheet %s '
                  '--opt RGBA4444 '
                  '--max-width 4096 '
                  '--max-height 4096 '
                  '--trim-mode Trim '
                  '--size-constraints NPOT '
                  '--algorithm MaxRects '
                  '--maxrects-heuristics Best '
                  '--pack-mode Best '
                  '--scale 0.88 '
                  '--basic-sort-by Best '
                  '--dither-fs-alpha '
                  # ' --png-opt-level 4 '
                  '--padding 0 %s' % (plistfile,pngfile,packdir))

        Commander().do(cmdstr);

        print ("Write Done");

        pass

    def repack(self,inputdir,filename,outdir):

        inputfilename = os.path.join(inputdir,filename);
        pngfile = inputfilename + ".png";
        jsonfile = inputfilename + ".json";

        if (not os.path.exists(pngfile) or (not os.path.exists(jsonfile))):
            return ;

        with open(jsonfile, "r") as file:

            content = file.read();
            jsonArr = json.loads(content);

            if ('frames' not in jsonArr):
                return ;


            frames = jsonArr['frames'] or {};

            bigImage = Image.open(pngfile);


            outfiledir = os.path.join(outdir,filename);
            if not os.path.exists(outfiledir):
                os.mkdir(outfiledir);

            for key in frames:
                frameInfo = self.get_frame(frames[key]);
                self.export_image(bigImage, key, frameInfo,outfiledir);

            # outputPath = os.path.join(outdir,filename) + ".png";
            self.packImages(bigImage,filename,outfiledir);


## find all textpackers

def repackWithDir(srcDir):

    print ("Searching spriteFrames file ...");

    # srcDir = "D:\pyproj\sheetunpacker\input\h5c.cqgame.games";
    repackImage = RepackImage ();

    if not os.path.exists("output"):
        os.mkdir("output")

    all = os.walk(srcDir);
    for path, dir, filelist in all:
        for filename in filelist:
            fullPath = os.path.join(path,filename);

            print ("Repack " + fullPath);

            filen1, fileext1 = os.path.split(fullPath);
            filen2, fileext2 = os.path.splitext(fileext1);
            repackImage.repack(filen1, filen2, "output");

    print("Repack done ...");
