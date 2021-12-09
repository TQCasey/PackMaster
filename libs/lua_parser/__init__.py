# -*- coding: UTF-8 -*-

from luaparser import ast
from luaparser import astnodes
import os
from cmm import *

def check_file_nested_level(lua_file_path):
	try:
		print("正在解析 %s ..." % lua_file_path)
		with open(lua_file_path, "r", encoding="utf-8") as f:
			src = f.read()
			tree = ast.parse(src)
			visitor = ast.ASTRecursiveVisitor()
			visitor.visit(tree)
			print("最深嵌套：{}".format(visitor.get_max_level()))
			if visitor.get_max_level() > 5:
				info = {}
				info["File"] = lua_file_path.replace("\\", "/")
				# info["Max"] = str(visitor.get_max_level())
				# info["Nested"] = visitor.get_all_nested()
				print("嵌套展开：{}".format(visitor.get_all_nested()))
			else:
				print("嵌套5层，不展开.")
	except Exception as e:
		errmsg(e)
