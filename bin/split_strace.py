import sys
import re
from enum import Enum

log_files = {}

BREAK_SUFFIX = '<unfinished ...>'

class State(Enum):
    DEFAULT = 0
    CALL = 1
    STRING = 2
    STRUCT = 3
    ESCAPED_CHARACTER_IN_STRING = 4
    POST_CALL = 5

class Formatter:
    line: str
    mod_offset: int
    call_start: int
    call_end: int
    commas: list[int]

    def __init__(self, line: str):
        self.line = line
        self.mod_offset = 0
        self.call_start = -1
        self.call_end = -1
        self.commas = []

        self.parse()

    def insert(self, idx, snippet):
        idx += self.mod_offset
        self.line = self.line[:idx] + snippet + self.line[idx:]
        self.mod_offset += len(snippet)

    def replace(self, idx, snippet):
        idx += self.mod_offset
        self.line = self.line[:idx] + snippet + self.line[idx+len(snippet):]

    def at(self, idx):
        try:
            return self.line[idx+self.mod_offset]
        except IndexError as ex:
            print('what the fuck')
            print(self.line)
            print(idx)
            print(self.mod_offset)
            raise ex

    def parse(self):
        state = [State.DEFAULT]

        for idx in range(len(self.line)):
            c = self.line[idx]

            match (c, state[-1]):
                case (_, State.ESCAPED_CHARACTER_IN_STRING):
                    state.pop()
                case (_, State.POST_CALL):
                    break

                case ('(', State.DEFAULT):
                    state.append(State.CALL)
                    self.call_start = idx
                case (')', State.CALL):
                    state.append(State.POST_CALL)
                    self.call_end = idx

                case ('"', State.STRING):
                    state.pop()
                case ('"', _):
                    state.append(State.STRING)

                case ('{', State.CALL|State.STRUCT):
                    state.append(State.STRUCT)
                case ('}', State.STRUCT):
                    state.pop()

                case ('\\', State.STRING):
                    state.append(State.ESCAPED_CHARACTER_IN_STRING)

                case (',', State.CALL):
                    self.commas.append(idx)

    def reformat(self) -> str:
        assert self.call_start != -1
        assert self.call_end != -1

        self.insert(self.call_start+1, '\n\t')

        for idx in self.commas:
            self.insert(idx+1, '\n')

            # sometimes we don't get a space after the comma;
            # insert a tab anyway when there's no space
            if self.at(idx+2) == ' ':
                self.replace(idx+2, '\t')
            else:
                self.insert(idx+2, '\t')

        self.insert(self.call_end, '\n')

        return self.line

# line = 'mmap(0x559e8dd1d000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x559e8dd1d000\n'
# print(Formatter(line).reformat())
# exit(0)

input_file = sys.argv[1]

print('input', input_file)

with open(input_file) as file:
    for line in file:
        parts = line.split(' ')
        pid = parts[0]
        
        if pid not in log_files:
            log_files[pid] = []
        output = log_files[pid]

        line = ' '.join(parts[1:])

        if len(output) != 0 and output[-1].strip().endswith(BREAK_SUFFIX):
            previous_line = output.pop().replace(BREAK_SUFFIX, '').rstrip()
            line = previous_line + re.sub(r'<... [a-z_]+ resumed>', '', line)

        line = re.sub(r' +=', ' =', line)

        if len(line) > 80 and not line.rstrip().endswith(BREAK_SUFFIX):
            line = Formatter(line).reformat()

        output.append(line)

for pid in log_files:
    with open(input_file + '.' + pid, 'w') as file:
        file.writelines(log_files[pid])
