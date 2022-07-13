import plistlib
if __name__ != '__main__':
    from cmm import *

import os, sys
import errno
from xml.etree import ElementTree
from PIL import Image


def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise


def tree_to_dict(tree):
    d = {}
    for index, item in enumerate(tree):
        if item.tag == 'key':
            if tree[index + 1].tag == 'string':
                d[item.text] = tree[index + 1].text
            elif tree[index + 1].tag == 'true':
                d[item.text] = True
            elif tree[index + 1].tag == 'false':
                d[item.text] = False
            elif tree[index + 1].tag == 'integer':
                d[item.text] = int(tree[index + 1].text);
            elif tree[index + 1].tag == 'real':
                d[item.text] = float(tree[index + 1].text);
            elif tree[index + 1].tag == 'dict':
                d[item.text] = tree_to_dict(tree[index + 1])
    return d


def do_unpack_format_0(plist_dict):
    info = {}
    for k, v in plist_dict['frames'].items():
        x = int(v["x"])
        y = int(v["y"])
        width = int(v["width"])
        height = int(v["height"])
        box = (x, y, x + width, y + height)

        data = {}
        data["box"] = box
        data["size"] = (width, height)
        info[k] = data

    return info


def do_unpack_format_2(plist_dict):
    info = {}
    for k, v in plist_dict['frames'].items():

        item = {};
        item['frame'] = v['frame'].replace('}', '').replace('{', '').split(',')
        item['sourceSize'] = v['sourceSize'].replace('}', '').replace('{', '').split(',')
        item['sourceColorRect'] = v['sourceColorRect'].replace('}', '').replace('{', '').split(',')
        item['rotated'] = v['rotated']

        # 去透明后的子图矩形
        x, y, w, h = tuple(map(int, item ['frame']))

        # 子图原始大小
        size = tuple(map(int, item['sourceSize']))
        # 子图在原始图片中的偏移
        ox, oy, _, _ = tuple(map(int, item ['sourceColorRect']))

        # 获取子图左上角，右下角
        if item ['rotated']:
            box = (x, y, x + h, y + w)
        else:
            box = (x, y, x + w, y + h)

        result_box = (
            ox,oy
        )
        data = {
            "box": box,
            "size": size,
            "result_box": result_box,
            "rotated": item ["rotated"]
        }
        info[k] = data
    return info


def save_image_file(result_image, file_path, image_name):
    if not os.path.isdir(file_path):
        os.mkdir(file_path)
    outfile = os.path.join(file_path, image_name)
    outdir = os.path.dirname(outfile)
    mkdir_p(outdir)
    result_image.save(outfile)


def do_crop_images(big_image, file_path, images_info_dict):
    for k, v in images_info_dict.items():
        rect_on_big = big_image.crop(v["box"])
        image_size = v["size"]
        result_image = Image.new('RGBA', image_size, (0, 0, 0, 0))
        if "result_box" in v:
            result_box = v["result_box"]
            if "rotated" in v and v["rotated"] == True:
                rect_on_big = rect_on_big.transpose(Image.ROTATE_90)
            result_image.paste(rect_on_big, result_box, mask=0)
        else:
            result_box = (0, 0, image_size[0], image_size[1])
            result_image.paste(rect_on_big, result_box, mask=0)
            if "rotated" in v and v["rotated"] == True:
                result_image = result_image.rotate(90)

        if k.find (".jpg") >= 0:
            result_image = result_image.convert('RGB')

        save_image_file(result_image, file_path, k)

def gen_png_from_plist(plist_filename, png_filename):
    file_path = plist_filename.replace('.plist', '')
    big_image = Image.open(png_filename)
    root = ElementTree.fromstring(open(plist_filename, 'r',encoding='utf8').read())
    plist_dict = tree_to_dict(root[0])

    if "metadata" not in plist_dict:
        return False;

    if "format" not in plist_dict["metadata"]:
        return False;

    plist_format = plist_dict["metadata"]["format"]

    images_info_dict = {}
    if (plist_format == 0):
        images_info_dict = do_unpack_format_0(plist_dict)
    elif (plist_format == 1):
        images_info_dict = do_unpack_format_2(plist_dict)
    elif (plist_format == 2):
        images_info_dict = do_unpack_format_2(plist_dict)
    elif (plist_format == 3):
        print("plist format not supported 3")
        # images_info_dict = do_unpack_format_3(plist_dict)
    else:
        print("plist format not supported")

    if (len(images_info_dict) > 0):
        do_crop_images(big_image, file_path, images_info_dict)

def is_supported_plist(plist_filename, png_filename):
    root = ElementTree.fromstring(open(plist_filename, 'r',encoding='utf8').read())
    plist_dict = tree_to_dict(root[0])

    if "metadata" not in plist_dict:
        return False;

    if "format" not in plist_dict["metadata"]:
        return False;

    plist_format = plist_dict["metadata"]["format"]

    isSupported = False;
    if (plist_format == 0):
        print ("formate 0 %s" % plist_filename)
        isSupported = True;
    elif (plist_format == 1):
        print("formate 1 %s" % plist_filename)
        isSupported = True;
    elif (plist_format == 2):
        isSupported = True;
    elif (plist_format == 3):
        isSupported = False;
    else:
        isSupported = False;

    return isSupported;


if __name__ == '__main__':
    # filename = 'D:\\HYGame\\client\\base\\res\\style\\dark\\AdMob\\JBguanggao0'
    filename = 'D:\\CynkingGame\\client\\base\\res\\style\\cat\\Bankrupt\\DailyDeal'
    plist_filename = filename + '.plist'
    png_filename = filename + '.png'
    if (os.path.exists(plist_filename) and os.path.exists(png_filename)):
        gen_png_from_plist(plist_filename, png_filename)
    else:
        print
        "make sure you have boith plist and png files in the same directory"

def UnpackPngSheet(file_name):
    plist = file_name + '.plist'
    if not os.path.exists(plist):
        print('plist %s 不存在' % plist)
        return

    png = file_name + '.png'
    if not os.path.exists(png):
        print('png %s 不存在' % png)
        return

    gen_png_from_plist(plist, png)

def IsSupportedList(file_name):
    plist = file_name + '.plist'
    if not os.path.exists(plist):
        return False

    png = file_name + '.png'
    if not os.path.exists(png):
        return False;

    return is_supported_plist(plist, png)