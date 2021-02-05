# import json
#
# propfind = json.load(open('./propfind.json', 'r', encoding='utf8'))[1:]
#
# for p in propfind:
#     payload = p["_source"]["layers"]["http"]["http.request.line"].encode()[:-3]
#     print(payload)

# from capstone import *
# from capstone.x86 import *
#
# encoded_bytes = open('shellcode.bin', 'rb').read().replace(b'\r\n', b'')
#
# l=len(encoded_bytes)//2
# decoded_bytes = []
# for i in range(l):
#     block              = encoded_bytes[i*2:i*2+2]
#     decoded_byte_low   = block[1] & 0x0F
#     decoded_byte_high  = ((block[1] >> 4) + (block[0] & 0x0F)) & 0x0F
#     decoded_byte       = decoded_byte_low + (decoded_byte_high <<4)
#     decoded_bytes     += [decoded_byte]
#
# # printable_decoded_bytes = b''.join(c for c in decoded_bytes if c in string.printable)
#
# shellcode = bytearray(decoded_bytes)
# print(shellcode)
#
# open('shell_decoded.bin', 'wb').write(shellcode)
#
# md = Cs(CS_ARCH_X86, CS_MODE_32)
#
# for insn in md.disasm(shellcode, 0x1000):
#     print("0x%x:\t%s\t%s" % (insn.address, insn.mnemonic, insn.op_str))
#     print()

from Crypto.Util.number import bytes_to_long as b2l
import rc4


socket = b'\x02\x00\x11\x5c\xc0\xa8\x44\x15\x05'

family = socket[:2]
data = socket[2:]
port = data[:2]
addr = data[2:2+4]

print(family)
print(data, len(data))
print(b2l(port))
print(addr[0], addr[1], addr[2], addr[3])

print(f"{addr[0]}.{addr[1]}.{addr[2]}.{addr[3]}:{b2l(port)}")

encrypted = "9c5c4f52a4b1037390e4c88e97b0c95bc630dc6abdf4203886f93026afedd0881b924fe509cd5c2ef5e168f8082b48daf7599ad4bb9219ae107b6eed7b6db1854d1031d28a4e7f268b10fdf41cc17fab5a739202c0cb49d953d6df6c0381a021016e875f09fe9a699435844f01966e77eca3f3f52f6a3636ab4775b580cb47bd9f7638a54048579c36ad8e7945a320faed1f1849b88918482b5b6feef4c3d6dccc84eab10109b1314ba4055098b073ae9c14101b65bd93826c57b9757a2aeede10fb39ba96d0361fc2312cc54f33a513e1595692c51fa54e0e626edb5be87f8d01a67d012b02431f54b9bcd5ef2db3daef3dd068fedade60b117feea204a2ca1bba1b5c51292a9dbf111e38c58badc3d288666c86d0eabfa83d5246010681dc7afc7ac4513a3d972e7cc5179f567417cae7fc87e954609f6ef4b4502745210501cb76a7ceb00d759c3290237d0472e1e3af7e6ac821474eb4f6b572213f6f248d66bcbb4eda73268cbd06642d3c5f2c537df7d9f9f28c0743abeb8c0a773d0bbfa507c101edab123d6c481a5d3b62229096b21a65c38c6803dbe0823c7b11f6de6646695dc10a71342cd3bfadcda148dd05ac88135542fb5dc61d6287788c55870b52fcfea4f4d85560407f39074ce5d3c8a2b06b49fe66d79c06e3dd83e2008b7743d3699cd7f607d9cc9b3ad0c8e456dea3ddd091dda0b3a1cfccb8148ed5afacef8c623b01e2644a3d9ab0ed598b133655ded6ad3237f024ab3a2f81d7ed12f5fbe89615e2ce4b89619e549764e7ae892a370556f7d3cf9c1364469337ddf7937b8e0aae86a5dc93b180f4e283a31a87fefb819ac3663e889214d83a77e5703489be1279306e43b675fe56950003e8b01b7efa6b54b3682d4fb9fde8b27cca457ce2537445042f77ea2bf4fdf0f72d8664a3ef5c8262ac5887b97ab235b2b61d83f00370e7e14fafd7df78149c2a1851bd028bea524fd60b278274eace8793b3b7adc56d076c5010fcf43b5d45f4870bdac6576db113b5bcf9c528b001e83f1fa925b7779076ae0d4339a71ba24a5a5c8eb4c01b3d3cd2c228c0b4ccd2d5a8c9ab167707f7596e256c11dff057e77a2bae59aaef9f8b2f178d2b1dce903c2d4ff1f66cdb047f0b4d1f672fa1eb7f14de76e4210ec5d9430dd7f751c014546b6146cf7453658eceff337049c21eb9454a3fe23cbbb315c6275bded2790fe9117e2ae429b7904d15cefcd4b86934a74412dad0b351d81fd102c8efd8c681df5450ab5b409be0efafad2f74e58d83c1a1b113d992553ab78ac5449bb2a42b38066b563e290f8a58f37af97132be8fc5d4b718b4d9fc8ec07281fcb30921e6ddcb9de94b8e9cb5af7a2b0bb0fc338b727331be9bf452d863e346d12f6051227c528e4d261267e992b3f1f034d7972b983566d8e8233c209eb214a0c13adea291b58da10164320557df4b7fc2634688ba054af07d5d523b523b8fb07c6644a567fa06d867c333b23b79d9ca822b1799f00e776e9c768ae5c23ae9fc6459148836fbf0ad8c977ab2c2d8547bfe9818013d9dc1c210ff4c7790752a8068c576353b2fb7dbe6c1aae2ebdc6fd970a04edc0a30545db9b62bd34a9082553009036cfd96315a5f7f8e0d869fd7924607ba2aebdf2b4b9c2088465a96deba5d872a7b65921b9f411125d391d15756d8a2f58c2fc80025178a9fc7dde0d85a55718f8f0cc8e4c5ed76558744e8a4433a224e3565768babbf2b23298f1882ec3"

encrypted = bytearray.fromhex(encrypted)
size, encrypted = encrypted[:4][::-1], encrypted[4:]
key = b"killervulture123"

decrypted = rc4.RC4(key).crypt(encrypted)
print(decrypted)

open('shell_2.bin', 'wb').write(decrypted)

# PEWPEW = [0 for i in range(0x100)] # 0x184
# PEWPEW += encrypted
# print(PEWPEW)

# temp = 0
# for i in range(0x100):
    # temp = (PEWPEW[i] + key[i & 0xf])
    # PEWPEW[i], PEWPEW[temp] = PEWPEW[temp], PEWPEW[i]
# print(PEWPEW[:0x100])

# ecx = b2l(pp) ^ 0x524f584b
# ecx = len(encrypted)
# ebp = 0x100
# al = 0
# temp = 0
# while ecx != 0:
    # al = (al + 1) & 0xf
    # temp = (temp + PEWPEW[al]) & 0xf
    # temp1 = PEWPEW[al]
    # PEWPEW[temp], temp1 = temp1, PEWPEW[temp] # 0x1b3
    # PEWPEW[ebp] = temp1
    # temp1 = (temp1 + PEWPEW[temp]) & 0xf
    # temp1 = PEWPEW[temp1]
    # PEWPEW[ebp] ^= temp1
    # ebp += 1
    # ecx -= 1
# print(PEWPEW[0x100:])