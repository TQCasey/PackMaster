# -*- coding: utf-8 -*-

import os
import sys

if __name__ == '__main__':
    args = sys.argv
    self_file = args[0]
    current_path, _ = os.path.split(self_file)
    exe_file = ""
    if sys.platform.startswith('win'):
        exe_file = os.path.join(os.path.abspath(current_path), "astcenc-avx2")
    else:
        exe_file = os.path.join(os.path.abspath(current_path), "mac", "astcenc-avx2")
    args[0] = exe_file
    os.system(" ".join(args))