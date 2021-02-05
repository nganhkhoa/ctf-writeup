elf = open('./bot.elf', 'rb').read()
yoyo = elf[0x238:0x238 + 0x9]

# xor = lambda b, a: [a[i] ^ b[i % len(b)] for i in range(len(a))]


def xor(r13, eax):
    for i in range(len(eax)):
        r13[i % 0x10] ^= eax[i]


status = 0
flag = [status for i in range(0x10)]

# /proc/modules
# flag = xor(flag, b"cpufreq_")

# /proc/mounts, the third column is file-system type
# it expect the first chracter to be f,
# which is fat32
flag = xor(flag, b"")

# /proc/version_signature
flag = xor(flag, b"Microsoft")

# auxiliary vector, AT_SYSINFO_EHDR
flag = xor(flag, yoyo.decode())

# lxstat of file with mode 0x8000 and get st_uid, st_gid
flag = xor(flag, b"")

flag += b"@flare-on.com"

print(flag)
