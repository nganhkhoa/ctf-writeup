import binascii
from capstone import *
from unicorn import *
from unicorn.x86_const import *

opcode = b"".join(
    map(
        lambda x: binascii.unhexlify(x.strip()),
        """
55
89e5
53
83e4f0
83ec10
c74424050aff0dee
66c74424098903
c644240b00
eb01
d3
c7
44
240c
0000
0000
eb46
8b44240c
0540c00408
0fb618
8b4c240c
baabaaaa2a
89c8
f7ea
89c8
c1f81f
29c2
89d0
01c0
01d0
01c0
29c1
89ca
0fb6541405
8b44240c
0540c00408
31da
8810
eb01
a18344240c
01837c240c51
7eb3
eb01
68b840c004
08ff
d0b800000000
8b
5d
""".split(
            "\n"
        ),
    )
)

data = binascii.unhexlify(
    " e1da 3c27 3825 50ad 8ddc be41 e805 3c2e 3907 3b24 beef d032 d84d 2b23 0932 ca4f 0cdf 52b0 0b32 8d06 5ffc f500 52b0 ca56 46ad 5eeb 8600 0bfa 08eb 8602 0efd 09bf 8f01 0eac 08bd 890d 5cfc 0cba 8a57 09fe 0ea4 0000 ffff ffff ffff ffff ffff ffff ".replace(
        " ", ""
    )
)

md = Cs(CS_ARCH_X86, CS_MODE_32)


def disas(opcode, addr):
    for i in md.disasm(opcode, addr):
        print("0x%x:\t%s\t%s" % (i.address, i.mnemonic, i.op_str))


continueAddr = ""
isContinue = False


def prompt(uc, address, size, user_data):
    global continueAddr
    global isContinue
    while True:
        cmd = input(">>> ")
        if cmd == "q":
            exit()
        if cmd == "":
            break
        if "p" == cmd[0]:
            _, reg = cmd.split(' ')
            if reg == "eax":
                pass
            continue
        if "c" == cmd[0]:
            _, addr = cmd.split(' ')
            continueAddr = int(addr, 16)
            isContinue = True
            break
        try:
            print(eval(cmd))
        except BaseException:
            print("exception")

# callback for tracing memory access (READ or WRITE)
def hook_mem_access(uc, access, address, size, value, user_data):
    if access == UC_MEM_WRITE:
        print(
            ">>> Memory is being WRITE at 0x%x, data size = %u, data value = 0x%x"
            % (address, size, value)
        )
    else:  # READ
        print(">>> Memory is being READ at 0x%x, data size = %u" % (address, size))


def hook_code(uc, address, size, user_data):
    global continueAddr
    global isContinue
    # print(">>> Tracing instruction at 0x%x, instruction size = 0x%x" % (address, size))
    opcode = mu.mem_read(address, size)
    for i in md.disasm(opcode, address):
        print("%x bytes 0x%x:\t%s\t%s" % (size, i.address, i.mnemonic, i.op_str))
        pass

    if address == int("0x804c04e", 16):
        print('flag: ' + mu.mem_read(134529132, 38).decode())
        # print(mu.mem_read(0x0804C040, 0x100))

    if isContinue:
        if address != continueAddr:
            return
        isContinue = False

    # prompt(uc, address, size, user_data)


mu = Uc(UC_ARCH_X86, UC_MODE_32)
mu.mem_map(0x08040000, 0xC * 1024 * 1024)

mu.mem_write(0x08049166, opcode)
mu.mem_write(0x0804C040, data)

# mu.hook_add(UC_HOOK_MEM_WRITE, hook_mem_access)
# mu.hook_add(UC_HOOK_MEM_READ, hook_mem_access)
mu.hook_add(UC_HOOK_CODE, hook_code)

mu.reg_write(UC_X86_REG_ESP, 0x08040000 + 0x200000)
# mu.reg_write(UC_X86_REG_EIP, 0x08049166)
try:
    mu.emu_start(0x08049166, len(opcode))
except:
    exit()