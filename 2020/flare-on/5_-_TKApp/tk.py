import hashlib
from base64 import b64decode

from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad

xor = lambda x, key: [x[i] ^ key[i % len(key)] for i in range(len(x))]

Step = list(map(ord, "magic"))
Desc = list(map(ord, "water"))
Note = list(map(ord, "keep steaks for dinner"))
Password = xor([62, 38, 63, 63, 54, 39, 59, 50, 39], [83])

first_check = [
    50, 148, 76, 233, 110, 199, 228,
    72, 114, 227, 78, 138, 93, 189,
    189, 147, 159, 70, 66, 223, 123,
    137, 44, 73, 101, 235, 129, 16,
    181, 139, 104, 56
]

first_check_hex = ''.join(map(lambda x: hex(x)[2:], first_check))
first_check_value = hashlib.sha256(bytearray(Password + Note + Step + Desc)).hexdigest()

assert(first_check_value == first_check_hex)

key_component = bytearray([
    Desc[2], Password[6], Password[4], Note[4], Note[0], Note[17],
    Note[18], Note[16], Note[11], Note[13], Note[12], Note[15],
    Step[4], Password[6], Desc[1], Password[2], Password[2],
    Password[4], Note[18], Step[2], Password[4], Note[5], Note[4],
    Desc[0], Desc[3], Note[15], Note[8], Desc[4], Desc[3], Note[4],
    Step[2], Note[13], Note[18], Note[18], Note[8], Note[4], Password[0],
    Password[7], Note[0], Password[4], Note[11], Password[6], Password[4],
    Desc[4], Desc[3]
])

key = hashlib.sha256(key_component).digest()
iv = b'NoSaltOfTheEarth'
ciphertext = open('./Runtime.dll', 'rb').read()

# RijndaelManaged is AES
cipher = AES.new(key, AES.MODE_CBC, iv=iv)
plaintext = b64decode(unpad(cipher.decrypt(ciphertext), 16))

open('tk.png', 'wb').write(plaintext)
