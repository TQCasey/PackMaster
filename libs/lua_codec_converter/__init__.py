import os
import chardet
import codecs
from pathlib import Path

try:
	from cmm import *
except Exception:
	warnmsg = print
	errmsg = print

IGNORE_CODECS = ('ISO-8859-1', 'utf-8', 'ascii')

def try_convert_lua_codec(lua_filepath):
	text = Path(lua_filepath).read_bytes()
	dinfo = chardet.detect(text)
	code, confidence = dinfo['encoding'], dinfo['confidence']
	ok = code in IGNORE_CODECS and confidence >= 0.8
	func = print if ok else warnmsg
	func("{0}的文件编码是{1},可信度:{2}".format(lua_filepath, code, confidence))

	if not ok:
		try:
			temp_filepath = lua_filepath + "_temp"
			with codecs.open(temp_filepath, 'w', "utf-8") as f:
				print('尝试将{}的文件编码从{}转换成utf-8'.format(lua_filepath, code))
				f.write(text.decode(code))
				f.close()
				os.remove(lua_filepath)
				os.rename(temp_filepath, lua_filepath)
				print("转换成功")
		except Exception as e:
			errmsg("转换失败")
		finally:
			if os.path.exists(temp_filepath):
				os.remove(temp_filepath)
