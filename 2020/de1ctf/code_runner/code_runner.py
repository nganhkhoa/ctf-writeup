from capstone import *
from z3 import *
from elftools.elf.elffile import ELFFile

def get_insn_list(bytecode, first_addr):
    insn_list = {}
    md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS64 + CS_MODE_LITTLE_ENDIAN)
    for insn in md.disasm(bytecode, first_addr):
        insn_list[insn.address] = (hex(insn.address), insn.mnemonic, insn.op_str, insn.size)
    return insn_list

def dump_func(insn_list, func_addr):
    (addr, i, op, size) = insn_list[func_addr]
    if i != "jr":
        return [(addr, i, op)] + dump_func(insn_list, func_addr + size)
    return [(addr, i, op)]

def iter_func(insn_list, func_addr, hook_code):
    (addr, i, op, size) = insn_list[func_addr]
    hook_code(addr, i, op)
    if i != "jr":
        dump_func(insn_list, func_addr + size)

f = ELFFile(open('code_runner', 'rb'))
symbols = f.get_section_by_name('.dynsym')
[main] = symbols.get_symbol_by_name('main')
text = f.get_section_by_name('.text')

first_addr = text['sh_addr']
start_addr = main.entry.st_value
check_start = 0x00401994
bytecode = text.data()

insn_list = get_insn_list(bytecode, first_addr)

class Node:
    def __init__(self, insn, next_func = None):
        self.insn = insn
        self.addr = insn[0][0]
        self.next_func = next_func
        (_, i, op) = insn[-1]
        if i == "b":
            self.branch = "branch"
            self.to = int(op, 16)
        elif i == "beq":
            self.branch = "equal"
            self.to = int(op.split(', ')[-1], 16)
        elif i == "bne":
            self.branch = "non_equal"
            self.to = int(op.split(', ')[-1], 16)
        else:
            self.branch = "return"
            self.to = None
        self.mustbe = None

    def __repr__(self):
        next_func = f"call {hex(self.next_func)}" if self.next_func is not None else ""
        return f"{self.addr}, {self.branch}, {self.to}, {self.mustbe}, {next_func}" # , {self.insn}"

    def condition(self, z, param):
        class PIndex:
            def __init__(self, v = 0):
                self.v = v
            def __add__(self, s):
                return PIndex(self.v + s)
            def __sub__(self, s):
                return PIndex(self.v - s)
            def __repr__(self):
                return f"param[{self.v}]"

        if self.mustbe is None:
            return

        reg = {}
        reg["$zero"] = 0
        reg["$sp"] = 0
        for (_, i, op) in self.insn:
            # print(i, op)
            if i in ["sw", "nop", "jal", "negu", "b"]:
                pass
            elif i == "move":
                [out, x] = op.split(', ')
                reg[out] = reg[x]
            elif i == "lw":
                [out, x] = op.split(', ')
                if x == "0x20($fp)":
                    reg[out] = PIndex()
            elif i == "lbu":
                [out, x] = op.replace(')', '').replace('(', '').split(', ')
                reg[out] = param[reg[x].v]
            elif i == "addiu":
                [a, b, c] = op.split(', ')
                reg[a] = reg[b] + int(c, 16)
            elif i == "addu":
                [a, b, c] = op.split(', ')
                reg[a] = reg[b] + reg[c]
            elif i == "subu":
                [a, b, c] = op.split(', ')
                reg[a] = reg[b] - reg[c]
            elif i == "xor":
                [a, b, c] = op.split(', ')
                reg[a] = reg[b] ^ reg[c]
            elif i == "andi":
                [a, b, c] = op.split(', ')
                # if int(c, 16) != 255:
                reg[a] = reg[b] & int(c, 16)
                # else:
                #     reg[a] = reg[b]
            elif i == "sll":
                [a, b, c] = op.split(', ')
                reg[a] = reg[b] << int(c, 16)
            elif i == "mult":
                [a, b] = op.split(', ')
                reg["hi"] = reg[a] * reg[b]
                reg["lo"] = reg[a] * reg[b]
            elif i == "mflo":
                reg[op] = reg["hi"]
            elif i == "bgez":
                [a, _] = op.split(', ')
                reg[a] = If(reg[a] > 0, reg[a], -reg[a])
            elif i == "slt":
                [a, b, c] = op.split(', ')
                reg[a] = If(reg[b] <= reg[c], 1, 0)
            elif i == "bnez":
                [a, _] = op.split(', ')
                if self.mustbe == True:
                    z.add(reg[a] == 0)
                elif self.mustbe == False:
                    z.add(reg[a] != 0)
                print(z)
            elif i == "bne" or i == "beq":
                [a, b, c] = op.split(', ')
                if self.mustbe == True:
                    z.add(reg[a] == reg[b])
                elif self.mustbe == False:
                    z.add(reg[a] != reg[b])
                print(z)
            else:
                input("unknown instruction")
                # exit()
            # print(reg)
        # input()
        print()

def split_to_nodes(func):
    nodes = []
    insn = []
    next_func = None
    for (addr, i, op) in func:
        insn += [(addr, i, op)]
        if i == "jal":
            next_func = int(op, 16)
        if i == "b" or i == "beq" or i == "bne" or i == "jr":
            nodes += [Node(insn, next_func)]
            next_func = None
            insn = []
    return nodes

def inspect_badjump(nodes):
    badjump = []
    for n in nodes:
        if n.to is None:
            continue
        (_, i, op, _) = insn_list[n.to]
        if i == "move" and op == "$v0, $zero":
            if n.to not in badjump: badjump += [n.to]
            if n.branch == "equal":
                n.mustbe = False
            elif n.branch == "non_equal":
                n.mustbe = True
    return badjump

def do_next(insn_list, start = check_start):
    print(hex(start))
    nodes = split_to_nodes(dump_func(insn_list, start))
    inspect_badjump(nodes)
    next_func = None
    z = Solver()
    param = [BitVec(f"param_{i}", 8) for i in range(4)]
    for n in nodes:
        # print(n)
        if n.next_func:
            next_func = n.next_func
            if hex(start) == "0x4013c8":
                n.mustbe = False
                n.condition(z, param)
        else:
            n.condition(z, param)
    z.check()
    m = z.model()
    r = sorted([(d, m[d]) for d in m], key = lambda x: str(x[0]))
    flag = list(map(lambda x: int(str(x[1])), r))
    print(flag)
    print()
    if next_func:
        return flag + do_next(insn_list, next_func)
    return flag

first_check = do_next(insn_list)
print(first_check)
first_check = bytes(first_check)
print(first_check)
exit()
from pwn import *

def pass_pow(target):
    # from itertools import combinations_with_replacement
    from string import printable
    import hashlib
    print(f"pow target: {target}")
    # for p in combinations_with_replacement(''.join([chr(i) for i in range(256)]), 3):
    # p = ''.join(list(p)).encode()
    for i in range(256):
        for j in range(256):
            for k in range(256):
                p = bytes([i, j, k])
                h = hashlib.sha256(p).hexdigest()
                # if p[0] == b'a':
                # input(f"{p}, {h}, {target}, {h == target}")
                if h == target:
                    print(f"pow solved: {p}")
                    return p
    print('pow not found!')
    exit()


# first_check = do_next(insn_list)
# first_check = bytes(first_check)

# open('code_runner.input', 'wb').write(first_check)
# print(f"faster: {first_check}")

r = remote("106.53.114.216", 9999)

r.recvline()
r.recvuntil('hashlib.sha256(s).hexdigest() == "')
target = r.recvuntil('"')[:-1]
r.recvline()
r.recvline()

r.sendline(pass_pow(target.decode()))

r.recvuntil("===============")
# binary
r.recvuntil("===============")

print(r.recvuntil("Faster > \n").decode())
first_check = open('./code_runner.input', 'rb').read()
first_check += b' ' * (0x100 - len(first_check))
r.send(first_check)

print(r.recvline())
print(r.recvline())
print(r.recvline())
print(r.recvline())
print(r.recvline())
print(r.recvline())
print(r.recvline())
# r.interactive()
