from __future__ import absolute_import, print_function, division

from subprocess import Popen, PIPE


def run(command, shell=False, capture=False):
    if capture:
        p = Popen(command, shell=shell, stdin=PIPE, stdout=PIPE)
        out, _ = p.communicate()
        return out
    else:
        Popen(command, shell=shell).wait()


def exists(name):
    return run(['command', '-v', name], capture=True).strip() != ''
