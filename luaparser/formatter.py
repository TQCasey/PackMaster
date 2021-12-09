#!/usr/bin/python
# -*- coding: utf-8 -*-

def get_id_tok(line, ind0):
    val = ""
    for i in range(ind0, len(line)):
        c = line[i]
        if c.isalpha() or c.isdigit() or c == "_":
            val += c
        else:
            break
    return "ID", val, i


def get_num_tok(line, ind0):
    val = ""
    c, last_char = "", ""
    for i in range(ind0, len(line)):
        c, last_char = line[i], c
        if c.isdigit() or c == "." or c.lower() in "abcdefx":
            val += c
        else:
            break
    return "NUM", val, i


def get_minus_tok(line, ind0):
    val = ""
    tok = "OP"
    c, last_char = "", ""
    for i in range(ind0, len(line)):
        c, last_char = line[i], c
        if last_char == "-" and c == "-":
            tok = "CMT"
        elif c.isdigit() and tok != "CMT":
            tok, val, idx = get_num_tok(line, i)
            val = "-" + val
            return tok, val, idx
        elif c != "-" and tok == "OP":
            break
        elif c == "\n":
            break
        val += c

    if tok == "CMT":
        val = "-- " + "--".join(val.split("--")[1:]).strip()
    return tok, val.strip(), i


def get_dot_tok(line, ind0):
    val = ""
    tok = "OBJOP"
    c, last_char = "", ""
    for i in range(ind0, len(line)):
        c, last_char = line[i], c
        if c == ".":
            val += c
            if last_char == ".":
                tok = "OP"
            else:
                continue
        else:
            break

    return tok, val, i


def get_op_tok(line, ind0):
    val = ""
    for i in range(ind0, len(line)):
        c = line[i]
        if c in "+-*/%^=<>#~":
            val += c
        else:
            break
    return "OP", val, i


def get_str_tok(line, ind0):
    val = ""
    quote = ""
    for i in range(ind0, len(line)):
        c = line[i]
        if c in ["'", '"']:
            if not quote:
                quote = c
                continue
            elif c == quote:
                break
        val += c
    return "STR", val, i+1


def get_tok(line, ind0=0):
    if not line.endswith(" "):
        line += " "

    tokenizers = []

    c, last_char = "", ""
    f = None
    for i in range(ind0, len(line)):
        c, last_char = line[i], c
        if c == "\n":
            tokenizers.append(("BR", "\n"))
            continue
        
        if c.isspace():
            continue

        if c.isalpha() or c == "_":
            f = get_id_tok
        elif c.isdigit():
            f = get_num_tok
        elif c == "-":
            f = get_minus_tok
        elif c == ".":
            f = get_dot_tok
        elif c in "+*/^%=<>#~":
            f = get_op_tok
        elif c in ["'", '"']:
            f = get_str_tok
        elif c in "{[(":
            tokenizers.append(("LBRK", c))
            continue
        elif c in "}])":
            tokenizers.append(("RBRK", c))
            continue
        elif c == ",":
            tokenizers.append(("SEP", c))
            continue
        elif c in ":":
            tokenizers.append(("OBJOP", c))
            continue

        if f is not None:
            tok, val, idx = f(line, i)
            tokenizers.append((tok, val))
            return tokenizers + get_tok(line, idx)

    return tokenizers


def format_code(toks):
    code = ""
    indent_level = 0
    indent_scope = []
    t, last_tok = None, None
    for i in range(len(toks)):
        t, last_tok = toks[i], t
        
        if t[0] == "BR" and last_tok and last_tok[0] != "BR":
            code = code.strip()

        if t[0] == "ID" and t[1] in ("end", "else", "elseif", "until"):
            indent_level -= 1
            indent_scope.pop()
        if t[0] == "RBRK":
            indent_level -= 1
            indent_scope.pop()

        if last_tok and last_tok[0] == "BR":
            code += " " * indent_level * 4

        if t[0] == "ID" and t[1] in ("function", "if", "for", "else", "elseif", "repeat"):
            indent_level += 1
            indent_scope.append(t)
        if t[0] == "LBRK":
            indent_level += 1
            indent_scope.append(t)

        pre_fix = ""
        post_fix = ""

        if t[0] == "OP":
            pre_fix = " " if last_tok and last_tok[0] != "LBRK" and last_tok[0] != "OP" else ""
            post_fix = " " if t[1] != "#" else ""
        elif t[0] == "STR":
            pre_fix = '"' if '"' not in t[1] else "'"
            post_fix = '"' if '"' not in t[1] else "'"
        elif t[0] == "SEP":
            post_fix = " "
        elif t[0] == "ID":
            if last_tok and last_tok[0] not in ("LBRK", "OBJOP", "BR", "OP"):
                pre_fix = " "
            if t[1] in ("and", "or", "not"):
                pre_fix = " "
                post_fix = " "
            if t[1] == "return":
                pre_fix = " "
                post_fix = " "
        elif t[0] == "LBRK" and last_tok and last_tok[0] == "ID" and last_tok[1] in ("if", "and", "or", "not"):
            pre_fix = " "
        elif t[0] == "ID" and t[1] == "return":
            post_fix = " "
        elif t[0] == "CMT" and last_tok and last_tok[0] != "BR":
            pre_fix = " " * 4
        
        if code and code[-1].isspace() and pre_fix and pre_fix[0].isspace():
            pre_fix = pre_fix.strip()
        code += pre_fix + t[1] + post_fix

    return code


def format_file(file):
    toks = []
    with open(file, "r") as f:
        for line in f:
            toks += get_tok(line)

    code = format_code(toks)
    code = "\n".join(line if not line.isspace() else "" for line in code.split("\n"))
    with open(file, "w") as f:
        f.write(code)
    return code


def format_source(file):
    toks = []
    for line in f:
        toks += get_tok(line)
    code = format_code(toks)
    code = "\n".join(line if not line.isspace() else "" for line in code.split("\n"))
    return code


if __name__ == "__main__":
    from os import listdir
    import os, sys

    if len(sys.argv) != 2:
        print("USAGE: %s <path>".format(sys.argv[0]))
        sys.exit(-1)

    path = sys.argv[1]
    for f in listdir(path):
        full_name = os.path.join(path, f)
        if os.path.isfile(full_name) and f.endswith("lua"):
            format_file(full_name)
