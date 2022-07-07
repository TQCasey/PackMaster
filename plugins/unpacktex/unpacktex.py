import plistlib
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
    to_list = lambda x: x.replace('{', '').replace('}', '').split(',')
    info = {}
    for k, v in plist_dict['frames'].items():
        box = to_list(v["frame"])
        x = int(box[0])
        y = int(box[1])
        rotated = v["rotated"]
        width = int(box[3] if rotated else box[2])
        height = int(box[2] if rotated else box[3])
        # width = int(box[2])
        # height = int(box[3])

        sourceSize = to_list(v["sourceSize"])
        box = (x,
               y,
               x + width,
               y + height)
        sourceSize = (int(sourceSize[0]), int(sourceSize[1]))
        result_box = (
            (sourceSize[0] - width) / 2,
            (sourceSize[1] - height) / 2,
            (sourceSize[0] + width) / 2,
            (sourceSize[1] + height) / 2,
        )
        data = {
            "box": box,
            "size": sourceSize,
            "result_box": result_box,
            "rotated": v["rotated"]
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
        if hasattr(v,"result_box"):
            result_box = v["result_box"]
        else:
            result_box = (0, 0, image_size[0], image_size[1])
        print (rect_on_big);
        print (result_box);
        print ("============")
        result_image.paste(rect_on_big, result_box, mask=0)
        if hasattr(v,"rotated") and v["rotated"] == True:
            result_image = result_image.rotate(90)
        save_image_file(result_image, file_path, k)


def gen_png_from_plist(plist_filename, png_filename):
    file_path = plist_filename.replace('.plist', '')
    big_image = Image.open(png_filename)
    root = ElementTree.fromstring(open(plist_filename, 'r').read())
    plist_dict = tree_to_dict(root[0])

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


if __name__ == '__main__':
    filename = sys.argv[1]
    plist_filename = filename + '.plist'
    png_filename = filename + '.png'
    if (os.path.exists(plist_filename) and os.path.exists(png_filename)):
        gen_png_from_plist(plist_filename, png_filename)
    else:
        print
        "make sure you have boith plist and png files in the same directory"

# 生成图片
def UnpackPngSheet(file_name, export_path):
    # 检查文件是否存在
    plist = file_name + '.plist'
    if not os.path.exists(plist):
        print('plist文件【%s】不存在！请检查' % plist)
        return

    png = file_name + '.png'
    if not os.path.exists(png):
        print('png文件【%s】不存在！请检查' % plist)
        return

    gen_png_from_plist(plist, png)

    # # 检查导出目录
    # if not os.path.exists(export_path):
    #     try:
    #         os.mkdir(export_path)
    #     except Exception as e:
    #         print(e)
    #         return
    #
    # # 使用plistlib库加载 plist 文件
    # lp = plistlib.load(open(plist, 'rb'))
    # # 加载 png 图片文件
    # img = Image.open(file_name + '.png')
    #
    # # 读取所有小图数据
    # frames = lp['frames']
    # for key in frames:
    #     item = get_frame(frames[key])
    #     export_image(img, os.path.join(export_path, key), item)


# Press the green button in the gutter to run the script.
# if __name__ == '__main__':
#     if len(sys.argv) == 3:
#         filename = sys.argv[1]
#         exportPath = sys.argv[2]
#         gen_image(filename, exportPath)