from __future__ import absolute_import, print_function, division

from . import exists, run

import os


class Stack(list):
    def pop(self, index=0):
        return list.pop(self, index)

    def peek(self):
        return self[0]


class Parser(object):
    indent = '    '

    def __init__(self, lines):
        self.parse_lines(lines)
        self.construct_commands()

    def construct_commands(self):
        self.commands = {}
        for command in Command.__subclasses__():
            self.commands[command.name] = command()

    def parse_lines(self, lines):
        # Filter comments.
        lines = map(lambda x: x.split('#')[0], lines)

        # Filter empty lines.
        lines = filter(lambda x: not x.strip() == '', lines)

        # Detect commands and arguments.
        self.code = []
        lines = Stack(lines)
        while lines:
            self.code.append(self._eat_command(lines))

    def _eat_command(self, lines):
        name = lines.pop().strip()
        arguments = []
        while lines and lines.peek().startswith(self.indent):
            arguments.append(self._eat_argument(lines))
        return {'name': name, 'arguments': arguments}

    def _eat_argument(self, lines):
        argument_parts = [lines.pop().strip()]
        # Extract the multi-line part.
        while lines and lines.peek().startswith(2 * self.indent):
            argument_parts.append(lines.pop().strip())
        return '\n'.join(argument_parts)

    def run(self):
        for step in self.code:
            if step['name'] in self.commands:
                self.commands[step['name']](*step['arguments'])
            else:
                raise RuntimeError('Cannot find command "{}".'
                                   ''.format(step['name']))


class Command(object):
    pass


class CommandExists(Command):
    name = 'command'

    def __call__(self, name, install_command):
        if not exists(name):
            run(install_command, shell=True)


class FileExists(Command):
    name = 'file'

    def __call__(self, name, install_command):
        if not os.path.exists(os.path.expanduser(name)):
            run(install_command, shell=True)
