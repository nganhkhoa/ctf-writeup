from z3 import *
import random


arr = []
for i in range(38):
    arr.append(BitVec('var{}'.format(i), 32))


s = Solver()

for i in range(38):
    s.add(arr[i] < 256)
    s.add(arr[i] >= 0x30)

s.add(
    (0 ^ (arr[0] << (0)) ^ (arr[1] << (1)) ^ (arr[2] << (2)) ^ (arr[3] << (3)) ^ (arr[4] << (4)) ^ (arr[5] << (5)) ^ (arr[6] << (6)) ^ (arr[7] << (7)) ^ (arr[8] << (8)) ^ (arr[9] << (9)) ^ (arr[10] << (10)) ^ (arr[11] << (11)) ^ (arr[12] << (12)) ^ (arr[13] << (13)) ^ (arr[14] << (14)) ^ (arr[15] << (15)) ^ (arr[16] << (16)) ^ (arr[17] << (17)) ^ (arr[18] << (18)) ^ (arr[19] << (19)) ^ (arr[20] << (20)) ^ (arr[21] << (21)) ^ (arr[22] << (22)) ^ (arr[23] << (23)) ^ (arr[24] << (24)) ^ (arr[25] << (25)) ^ (arr[26] << (26)) ^ (arr[27] << (27)) ^ (arr[28] << (28)) ^ (arr[29] << (29)) ^ (arr[30] << (30)) ^ (arr[31] << (31)) ^ (arr[32] << (0)) ^ (arr[33] << (1)) ^ (arr[34] << (2)) ^ (arr[35] << (3)) ^ (arr[36] << (4)) ^ (arr[37] << (5))) == 0x966a35fa
)
s.add(
    arr[2] == (0x61 ^ 0x15),
    arr[1] == (0x6c ^ 0x05),
    arr[3] == (0x67 ^ 0x05),
    arr[37] == (0x28 ^ 0x55),
    arr[0] == (0x66 ^ 0x0e),
    arr[4] == (0x3a ^ 0x41)
)

vector_y = [0x91, 0x42, 0xdb, 0x3f, 0xfa, 0x17, 0x80, 0xff, 0x8d, 0x75, 0x88, 0x25, 0xaf, 0x96, 0x64, 0x63]
vector1 = arr[5:21]

rand = list(map(int, open('rand', 'r').read().split(' ')[:-1]))

for i in range(125):
    for j in range(16):
        vector2 = rand[i * 16 + j]  # random vector
        vector1[j] = vector1[j] ^ (vector2 & 0xff)
    for j in range(1, 16):
        vector1[j] = vector1[j] ^ vector1[j - 1]

for i in range(16):
    s.add(vector_y[i] == vector1[i])

s.add(arr[34] ^ arr[31] ^ arr[24] ^ arr[27] == 88)
s.add(arr[25] ^ arr[26] ^ arr[32] == 101)
s.add(arr[36] ^ arr[25] ^ arr[29] ^ arr[21] == 84)
s.add(arr[28] ^ arr[24] ^ arr[23] ^ arr[27] == 7)
s.add(arr[29] ^ arr[31] ^ arr[35] ^ arr[36] == 1)
s.add(arr[36] ^ arr[31] ^ arr[32] ^ arr[33] == 10)
s.add(arr[26] == arr[14])
s.add(arr[30] ^ arr[32] ^ arr[26] == 50)
s.add(arr[36] ^ arr[33] ^ arr[22] == 62)
s.add(arr[30] ^ arr[23] ^ arr[27] ^ arr[34] == 81)
s.add(arr[24] ^ arr[33] ^ arr[23] == 54)
s.add(arr[32] ^ arr[30] ^ arr[34] ^ arr[21] == 83)
s.add(arr[28] ^ arr[26] ^ arr[21] ^ arr[22] == 10)
s.add(arr[35] ^ arr[26] ^ arr[29] ^ arr[34] == 86)
s.add(arr[36] ^ arr[27] ^ arr[33] == 62)

s.check()
ans = s.model()

result = ''
for i in range(38):
    # print(hex(ans[arr[i]].as_long()))
    result += chr(ans[arr[i]].as_long())
print(result)
