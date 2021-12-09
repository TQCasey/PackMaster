from antlr4 import InputStream, CommonTokenStream
from luaparser.parser.LuaLexer import LuaLexer
from luaparser.astnodes import *
from luaparser import printers
from luaparser.builder import Builder
from luaparser.utils.visitor import *
from luaparser.formatter import format_file
from antlr4.error.ErrorListener import ErrorListener
import os
import json
import tempfile
from typing import Generator


def parse(source: str) -> Chunk:
    """ Parse Lua source to a Chunk.
    """
    return Builder(source).process()


def get_token_stream(source: str) -> CommonTokenStream:
    """ Get the antlr token stream.
    """
    lexer = LuaLexer(InputStream(source))
    stream = CommonTokenStream(lexer)
    return stream


def walk(root: Node) -> Generator[None, Node, None]:
    # base case:
    if root is None:
        return

    tree_visitor = WalkVisitor()
    tree_visitor.visit(root)
    for n in tree_visitor.nodes:
        yield n


def to_pretty_str(root: Node, indent=2) -> str:
    return printers.PythonStyleVisitor(indent).visit(root)


def to_lua_source(root: Node, indent=4) -> str:
    return printers.LuaOutputVisitor(indent_size=indent).visit(root)


def to_xml_str(tree):
    tree_visitor = printers.HTMLStyleVisitor()
    return tree_visitor.get_xml_string(tree)


class JSONEncoder(json.JSONEncoder):
    def default(self, o):
        try:
            to_json = getattr(o, "to_json")
            if callable(to_json):
                return to_json()

        except AttributeError:
            return {k: v for k, v in o.__dict__.items() if not k.startswith('_')}


def to_pretty_json(root: Node) -> str:
    return json.dumps(root, cls=JSONEncoder, indent=4)


class ASTVisitor:
    def visit(self, root):
        # base case:
        if root is None:
            return
        node_stack = [root]

        while len(node_stack) > 0:
            node = node_stack.pop()
            # push childs to the stack:
            if isinstance(node, Node):
                # call visit method
                name = 'visit_' + node.__class__.__name__
                tree_visitor = getattr(self, name, None)
                if tree_visitor:
                    tree_visitor(node)

                # add childs
                children = [attr for attr in node.__dict__.keys() if not attr.startswith("_")]
                for child in children:
                    node_stack.append(node.__dict__[child])
            elif isinstance(node, list):
                # append node list in reversal order
                for n in reversed(node):
                    node_stack.append(n)


class ASTRecursiveVisitor:
    def __init__(self):
        self.cur_level = 0
        self.max_level = -1
        self.enterance = set()
        self.exitrance = set()
        self.max_level_body = None
        self.nested_level = 5
        self.nested_body = []

    def enter_block(self, node):
        self.cur_level += 1
        if self.max_level < self.cur_level:
            self.max_level = self.cur_level
            if node.body:
                self.max_level_body = node.body
                if self.cur_level > self.nested_level:
                    self.nested_body.append((self.cur_level, node.body))

    def exit_block(self):
        self.cur_level -= 1
        self.max_level = max(self.max_level, self.cur_level)

    def get_max_level(self):
        return max(self.max_level - 1, 0)

    def get_max_nested(self):
        if self.max_level_body:
            return to_lua_source(self.max_level_body)
        return "null"

    def get_all_nested(self):
        nested = []
        if len(self.nested_body) > 0:
            for nest in self.nested_body:
                level, body = nest
                src = to_lua_source(body)
                src = src.split("\n")[0].split(",")[0:2]
                if src[0].find("for") > -1 and len(src) > 1:
                    src = src[0] + "," + src[1]
                else:
                    src = src[0]
                # nested.append("\n\t层级: {}\n\t位置: {}\n\n".format(level-1, src))
                nested.append({
                    "level": level-1,
                    "where": src
                })
            return nested
        return None

    def visit(self, node):
        if isinstance(node, Node):
            # call enter node method
            # if no visitor method found for this arg type,
            # search in parent arg type:
            parent_type = node.__class__
            while parent_type != object:
                name = 'enter_' + parent_type.__name__
                tree_visitor = getattr(self, name, None)
                if tree_visitor:
                    tree_visitor(node)
                    break
                else:
                    if node.display_name == 'Block' and node.node_id not in self.enterance:
                        self.enter_block(node)
                        self.enterance.add(node.node_id)
                        # print('enter ' + node.node_id, self.cur_level, self.max_level)
                    parent_type = parent_type.__bases__[0]

            # visit all object public attributes:
            children = [attr for attr in node.__dict__.keys() if not attr.startswith("_")]
            for child in children:
                self.visit(node.__dict__[child])

            # call exit node method
            # if no visitor method found for this arg type,
            # search in parent arg type:
            parent_type = node.__class__
            while parent_type != object:
                name = 'exit_' + parent_type.__name__
                if node.display_name == 'Block' and node.node_id not in self.exitrance:
                    self.exit_block()
                    self.exitrance.add(node.node_id)
                    # print('exit ' + node.node_id, self.cur_level, self.max_level)
                tree_visitor = getattr(self, name, None)
                if tree_visitor:
                    tree_visitor(node)
                    break
                else:
                    parent_type = parent_type.__bases__[0]
        elif isinstance(node, list):
            for n in node:
                self.visit(n)


class WalkVisitor:
    def __init__(self):
        self._nodes = []

    @property
    def nodes(self):
        return self._nodes

    @visitor(str)
    def visit(self, node):
        pass

    @visitor(float)
    def visit(self, node):
        pass

    @visitor(int)
    def visit(self, node):
        pass

    @visitor(list)
    def visit(self, node):
        for n in node:
            self.visit(n)

    @visitor(type(None))
    def visit(self, node):
        pass

    @visitor(Chunk)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.body)

    @visitor(Block)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.body)

    @visitor(Assign)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.targets)
        self.visit(node.values)

    @visitor(While)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.test)
        self.visit(node.body)

    @visitor(Do)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.body)

    @visitor(If)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.test)
        self.visit(node.body)
        self.visit(node.orelse)

    @visitor(ElseIf)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.test)
        self.visit(node.body)
        self.visit(node.orelse)

    @visitor(Label)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(Goto)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(Break)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(Return)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.values)

    @visitor(Fornum)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.target)
        self.visit(node.start)
        self.visit(node.stop)
        self.visit(node.step)
        self.visit(node.body)

    @visitor(Forin)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.targets)
        self.visit(node.iter)
        self.visit(node.body)

    @visitor(Call)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.func)
        self.visit(node.args)

    @visitor(Invoke)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.source)
        self.visit(node.func)
        self.visit(node.args)

    @visitor(Function)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.name)
        self.visit(node.args)
        self.visit(node.body)

    @visitor(LocalFunction)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.name)
        self.visit(node.args)
        self.visit(node.body)

    @visitor(Method)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.source)
        self.visit(node.name)
        self.visit(node.args)
        self.visit(node.body)

    @visitor(Nil)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(TrueExpr)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(FalseExpr)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(Number)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(String)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(Table)
    def visit(self, node: Table):
        self._nodes.append(node)
        for field in node.fields:
            self.visit(field)

    @visitor(Field)
    def visit(self, node: Field):
        self._nodes.append(node)
        self.visit(node.key)
        self.visit(node.value)

    @visitor(Dots)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(AnonymousFunction)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.args)
        self.visit(node.body)

    @visitor(BinaryOp)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.left)
        self.visit(node.right)

    @visitor(UnaryOp)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.operand)

    @visitor(Name)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(Index)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.value)
        self.visit(node.idx)

    @visitor(Varargs)
    def visit(self, node):
        self._nodes.append(node)

    @visitor(Repeat)
    def visit(self, node):
        self._nodes.append(node)
        self.visit(node.body)
        self.visit(node.test)

    @visitor(SemiColon)
    def visit(self, node):
        self._nodes.append(node)


class SyntaxException(Exception):
    pass


class ParserErrorListener(ErrorListener):
    def syntaxError(self, recognizer, offending_symbol, line, column, msg, e):
        raise SyntaxException(str(line) + ":" + str(column) + ': ' + str(msg))

    def reportAmbiguity(self, recognizer, dfa, start_index, stop_index, exact, ambig_alts, configs):
        pass

    def reportAttemptingFullContext(self, recognizer, dfa, start_index, stop_index, conflicting_alts, configs):
        pass

    def reportContextSensitivity(self, recognizer, dfa, start_index, stop_index, prediction, configs):
        pass
