import re
import hashlib
import string
import os
from ctypes import *

from Crypto.Util.number import bytes_to_long as b2l
from wincrypto import CryptDecrypt, CryptImportKey

source = open('codeit_.au3', 'r').read().split('\n')

os_string = ""
os_string += "7374727563743b75696e7420626653697a653b75696e7420626652657365727665643b75696e742062664f6666426974733b"
os_string += "75696e7420626953697a653b696e7420626957696474683b696e742062694865696768743b7573686f7274206269506c616e"
os_string += "65733b7573686f7274206269426974436f756e743b75696e74206269436f6d7072657373696f6e3b75696e7420626953697a"
os_string += "65496d6167653b696e742062695850656c735065724d657465723b696e742062695950656c735065724d657465723b75696e"
os_string += "74206269436c72557365643b75696e74206269436c72496d706f7274616e743b656e647374727563743b4FD5$626653697a6"
os_string += "54FD5$626652657365727665644FD5$62664f6666426974734FD5$626953697a654FD5$626957696474684FD5$6269486569"
os_string += "6768744FD5$6269506c616e65734FD5$6269426974436f756e744FD5$6269436f6d7072657373696f6e4FD5$626953697a65"
os_string += "496d6167654FD5$62695850656c735065724d657465724FD5$62695950656c735065724d657465724FD5$6269436c7255736"
os_string += "5644FD5$6269436c72496d706f7274616e744FD5$7374727563743b4FD5$627974655b4FD5$5d3b4FD5$656e647374727563"
os_string += "744FD5$4FD5$2e626d704FD5$5c4FD5$2e646c6c4FD5$7374727563743b64776f72643b636861725b313032345d3b656e647"
os_string += "374727563744FD5$6b65726e656c33322e646c6c4FD5$696e744FD5$476574436f6d70757465724e616d65414FD5$7074724"
os_string += "FD5$436f6465497420506c7573214FD5$7374727563743b627974655b4FD5$5d3b656e647374727563744FD5$73747275637"
os_string += "43b627974655b35345d3b627974655b4FD5$7374727563743b7074723b7074723b64776f72643b627974655b33325d3b656e"
os_string += "647374727563744FD5$61647661706933322e646c6c4FD5$437279707441637175697265436f6e74657874414FD5$64776f7"
os_string += "2644FD5$4372797074437265617465486173684FD5$437279707448617368446174614FD5$7374727563742a4FD5$4372797"
os_string += "07447657448617368506172616d4FD5$30784FD5$30383032304FD5$30303031304FD5$36363030304FD5$30323030304FD5"
os_string += "$303030304FD5$43443442334FD5$32433635304FD5$43463231424FD5$44413138344FD5$44383931334FD5$45364639324"
os_string += "FD5$30413337414FD5$34463339364FD5$33373336434FD5$30343243344FD5$35394541304FD5$37423739454FD5$413434"
os_string += "33464FD5$46443138394FD5$38424145344FD5$39423131354FD5$46364342314FD5$45324137434FD5$31414233434FD5$3"
os_string += "4433235364FD5$31324135314FD5$39303335464FD5$31384642334FD5$42313735324FD5$38423341454FD5$43414633444"
os_string += "FD5$34383045394FD5$38424638414FD5$36333544414FD5$46393734454FD5$30303133354FD5$33354432334FD5$314534"
os_string += "42374FD5$35423243334FD5$38423830344FD5$43374145344FD5$44323636414FD5$33374233364FD5$46324335354FD5$3"
os_string += "5424633414FD5$39454136414FD5$35384243384FD5$46393036434FD5$43363635454FD5$41453243454FD5$36304632434"
os_string += "FD5$44453338464FD5$44333032364FD5$39434334434FD5$45354242304FD5$39303437324FD5$46463942444FD5$323646"
os_string += "39314FD5$31394238434FD5$34383446454FD5$36394542394FD5$33344634334FD5$46454544454FD5$44434542414FD5$3"
os_string += "7393134364FD5$30383139464FD5$42323146314FD5$30463833324FD5$42324135444FD5$34443737324FD5$44423132434"
os_string += "FD5$33424544394FD5$34374636464FD5$37303641454FD5$34343131414FD5$35324FD5$7374727563743b7074723b70747"
os_string += "23b64776f72643b627974655b383139325d3b627974655b4FD5$5d3b64776f72643b656e647374727563744FD5$437279707"
os_string += "4496d706f72744b65794FD5$4372797074446563727970744FD5$464c4152454FD5$4552414c464FD5$43727970744465737"
os_string += "4726f794b65794FD5$437279707452656c65617365436f6e746578744FD5$437279707444657374726f79486173684FD5$73"
os_string += "74727563743b7074723b7074723b64776f72643b627974655b31365d3b656e647374727563744FD5$7374727563743b64776"
os_string += "f72643b64776f72643b64776f72643b64776f72643b64776f72643b627974655b3132385d3b656e647374727563744FD5$47"
os_string += "657456657273696f6e4578414FD5$456e746572207465787420746f20656e636f64654FD5$43616e2068617a20636f64653f"
os_string += "4FD5$4FD5$48656c704FD5$41626f757420436f6465497420506c7573214FD5$7374727563743b64776f72643b64776f7264"
os_string += "3b627974655b333931385d3b656e647374727563744FD5$696e743a636465636c4FD5$6a75737447656e6572617465515253"
os_string += "796d626f6c4FD5$7374724FD5$6a757374436f6e76657274515253796d626f6c546f4269746d6170506978656c734FD5$546"
os_string += "869732070726f6772616d2067656e65726174657320515220636f646573207573696e6720515220436f64652047656e65726"
os_string += "1746f72202868747470733a2f2f7777772e6e6179756b692e696f2f706167652f71722d636f64652d67656e657261746f722"
os_string += "d6c6962726172792920646576656c6f706564206279204e6179756b692e204FD5$515220436f64652047656e657261746f72"
os_string += "20697320617661696c61626c65206f6e20476974487562202868747470733a2f2f6769746875622e636f6d2f6e6179756b69"
os_string += "2f51522d436f64652d67656e657261746f722920616e64206f70656e2d736f757263656420756e6465722074686520666f6c"
os_string += "6c6f77696e67207065726d697373697665204d4954204c6963656e7365202868747470733a2f2f6769746875622e636f6d2f"
os_string += "6e6179756b692f51522d436f64652d67656e657261746f72236c6963656e7365293a4FD5$436f7079726967687420c2a9203"
os_string += "23032302050726f6a656374204e6179756b692e20284d4954204c6963656e7365294FD5$68747470733a2f2f7777772e6e61"
os_string += "79756b692e696f2f706167652f71722d636f64652d67656e657261746f722d6c6962726172794FD5$5065726d697373696f6"
os_string += "e20697320686572656279206772616e7465642c2066726565206f66206368617267652c20746f20616e7920706572736f6e2"
os_string += "06f627461696e696e67206120636f7079206f66207468697320736f66747761726520616e64206173736f636961746564206"
os_string += "46f63756d656e746174696f6e2066696c6573202874686520536f667477617265292c20746f206465616c20696e207468652"
os_string += "0536f66747761726520776974686f7574207265737472696374696f6e2c20696e636c7564696e6720776974686f7574206c6"
os_string += "96d69746174696f6e207468652072696768747320746f207573652c20636f70792c206d6f646966792c206d657267652c207"
os_string += "075626c6973682c20646973747269627574652c207375626c6963656e73652c20616e642f6f722073656c6c20636f7069657"
os_string += "3206f662074686520536f6674776172652c20616e6420746f207065726d697420706572736f6e7320746f2077686f6d20746"
os_string += "86520536f667477617265206973206675726e697368656420746f20646f20736f2c207375626a65637420746f20746865206"
os_string += "66f6c6c6f77696e6720636f6e646974696f6e733a4FD5$312e205468652061626f766520636f70797269676874206e6f7469"
os_string += "636520616e642074686973207065726d697373696f6e206e6f74696365207368616c6c20626520696e636c7564656420696e"
os_string += "20616c6c20636f70696573206f72207375627374616e7469616c20706f7274696f6e73206f662074686520536f6674776172"
os_string += "652e4FD5$322e2054686520536f6674776172652069732070726f76696465642061732069732c20776974686f75742077617"
os_string += "272616e7479206f6620616e79206b696e642c2065787072657373206f7220696d706c6965642c20696e636c7564696e67206"
os_string += "27574206e6f74206c696d6974656420746f207468652077617272616e74696573206f66206d65726368616e746162696c697"
os_string += "4792c206669746e65737320666f72206120706172746963756c617220707572706f736520616e64206e6f6e696e6672696e6"
os_string += "7656d656e742e20496e206e6f206576656e74207368616c6c2074686520617574686f7273206f7220636f707972696768742"
os_string += "0686f6c64657273206265206c6961626c6520666f7220616e7920636c61696d2c2064616d61676573206f72206f746865722"
os_string += "06c696162696c6974792c207768657468657220696e20616e20616374696f6e206f6620636f6e74726163742c20746f72742"
os_string += "06f72206f74686572776973652c2061726973696e672066726f6d2c206f7574206f66206f7220696e20636f6e6e656374696"
os_string += "f6e20776974682074686520536f667477617265206f722074686520757365206f72206f74686572206465616c696e6773206"
os_string += "96e2074686520536f6674776172652e4FD5$7374727563743b7573686f72743b656e647374727563744FD5$7374727563743"
os_string += "b627974653b627974653b627974653b656e647374727563744FD5$43726561746546696c654FD5$75696e744FD5$53657446"
os_string += "696c65506f696e7465724FD5$6c6f6e674FD5$577269746546696c654FD5$7374727563743b64776f72643b656e647374727"
os_string += "563744FD5$5265616446696c654FD5$436c6f736548616e646c654FD5$44656c65746546696c65414FD5$47657446696c655"
os_string += "3697a65"
os_string = os_string.split('4FD5$')

#### GLOBAL VAR RENAME #####
global_vars = {}
decl_re = re.compile(r'(\$\w+)\s+=\s+Number\("\s+(\d+)\s+"\)')
global_decls = filter(lambda x: 'Global' in x, source)
for decl in global_decls:
    decl = decl[len('Global '):].split(', ') # clear Global
    if len(decl) == 1:
        continue
    for m in filter(lambda x: x is not None, map(decl_re.match, decl)):
        var, value = m.groups()
        global_vars[var] = value

def replace_global(line):
    for ori, value in global_vars.items():
        line = line.replace(ori, value)
    return line

#### FUNCTION RENAME #####
def replace_function_name(line):
    functions = {
        "areoxaohpta": "CreatePicture",
        "arewuoknzvh": "RandomName",
        "aregfmwbsqd": "InstallResourceFile",
        "areuznaqfmn": "GetComputerNameA",
        "aregtfdcyni": "EncodeString",
        "areyzotafnf": "Decrypt",
        "areaqwbmtiz": "MD5",
        "arepfnkwypw": "Windows8",
        "areialbhuyt": "Main",
        "arepqqkaeto": "WritePictureHeader",
        "arelassehha": "WritePicture",
        "arerujpvsfp": "CreateFileRead",
        "aremyfdtfqp": "CreateFileWrite",
        "aremfkxlayv": "WriteFile",
        "aremlfozynu": "ReadFile",
        "arevtgkxjhu": "CloseHandle",
        "arebbytwcoj": "DeleteFileA",
        "arenwrbskll": "GetFileSize",
        "areihnvapwn": "InitStrings",
        "arehdidxrgk": "HexDecode"
    }
    for ori, new in functions.items():
        line = line.replace(ori, new)
    return line

def hex_decode(s):
    ss = bytes.fromhex(s).decode('utf-8')
    return ss

#### OS_STRING RENAME #####
def replace_os_string(line):
    os_re = re.compile(r'\$os\[(\d+)\]')
    for m in os_re.finditer(line):
        idx = int(m.groups()[0])
        line = line.replace(f'HexDecode($os[{idx}])', f'"{hex_decode(os_string[idx - 1])}"')
    return line

def replace_tab(line):
    return line.replace('\t', '  ')

replace_phase_1 = map(replace_global, source)
replace_phase_2 = map(replace_function_name, replace_phase_1)
replace_phase_3 = map(replace_os_string, replace_phase_2)
replace_phase_4 = map(replace_tab, replace_phase_3)

replace_phase_last = '\n'.join(replace_phase_4)

open('codeit_fix.au3', 'w', encoding='utf8').write(replace_phase_last)


def one_key_get(sprite, b):
    zc = 0
    nc = ord(b)
    for j in range(6, -1, -1):
        nc += (sprite[zc] & 1) << j
        zc += 1
    return (nc >> 1) + ((nc & 1) << 7)

sprite = open('./sprite.bmp', 'rb').read()
sprite = sprite[54:]

key_component = ""
for i in range(len(sprite) // 7):
    for b in string.ascii_lowercase + string.digits:
        k = one_key_get(sprite[i*7:i*7+7], b)
        if ord(b) == k:
            key_component += b
            break
    else:
        break

print(key_component.encode())
key_component = hashlib.sha256(key_component.encode()).hexdigest()

cipher_text = "CD4B3" + "2C650" + "CF21B" + "DA184" + "D8913" + "E6F92" + "0A37A" + "4F396" + "3736C" + "042C4" + "59EA0" + "7B79E" + "A443F" + "FD189" + "8BAE4" + "9B115" + "F6CB1" + "E2A7C" + "1AB3C" + "4C256" + "12A51" + "9035F" + "18FB3" + "B1752" + "8B3AE" + "CAF3D" + "480E9" + "8BF8A" + "635DA" + "F974E" + "00135" + "35D23" + "1E4B7" + "5B2C3" + "8B804" + "C7AE4" + "D266A" + "37B36" + "F2C55" + "5BF3A" + "9EA6A" + "58BC8" + "F906C" + "C665E" + "AE2CE" + "60F2C" + "DE38F" + "D3026" + "9CC4C" + "E5BB0" + "90472" + "FF9BD" + "26F91" + "19B8C" + "484FE" + "69EB9" + "34F43" + "FEEDE" + "DCEBA" + "79146" + "0819F" + "B21F1" + "0F832" + "B2A5D" + "4D772" + "DB12C" + "3BED9" + "47F6F" + "706AE" + "4411A" + "52"
key = "08020" + "00010" + "66000" + "02000" + "0000" + key_component

cipher_text = bytearray.fromhex(cipher_text)
key = bytearray.fromhex(key)

# PROV_RSA_AES
# Go to wincrypto/algorithm.py change
# IV='\0' * 16 to IV=b'\0' * 16
decrypted = CryptDecrypt(CryptImportKey(key), cipher_text)
# print(decrypted)

part_1 = decrypted[5:5+4]
part_2 = decrypted[9:9+4]
part_3 = decrypted[13:13 + len(decrypted) - 18]


# SETUP Picture and DLL #

# typedef unsigned long DWORD
class QRData(Structure):
    _pack_ = 1
    _fields_ = [('height', c_ulong),
                ('width', c_ulong),
                ('data', c_char * len(part_3))
                ]


qrdata = QRData.from_buffer_copy(part_1 + part_2 + part_3)

class PictureHeader(Structure):
    _fields_ = [('bfSize', c_uint),
                ('bfReserved', c_uint),
                ('bfOffBits', c_uint),
                ('biSize', c_uint),
                ('biWidth', c_int),
                ('biHeight', c_int),
                ('biPlanes', c_ushort),
                ('biBitCount', c_ushort),
                ('biCompression', c_uint),
                ('biSizeImage', c_uint),
                ('biXPelsPerMeter', c_int),
                ('biYPelsPerMeter', c_int),
                ('biClrUsed', c_uint),
                ('biClrImportant', c_uint),
                ]


class PictureData(Structure):
    _fields_ = [(f'data_{i}', c_char * 3 * (qrdata.width * qrdata.height)) for i in range(qrdata.height * qrdata.width)]


class Picture(Structure):
    _fields_ = [('header', PictureHeader),
                ('data', PictureData)
                ]


qr = CDLL(os.getcwd() + "/qr_encoder.dll")
qr2pixel = getattr(qr, "justConvertQRSymbolToBitmapPixels")
qr2pixel.argtypes = [POINTER(QRData), POINTER(PictureData)]
qr2pixel.rettypes = c_int


# From QRData -> Picture

def SetupPicture(a, b, c):
    pic = Picture()
    pic.header.bfSize = 3 * a + (a % 4) * abs(b)
    pic.header.bfReserved = 0
    pic.header.bfOffBits = 54
    pic.header.biSize = 40
    pic.header.biWidth = a
    pic.header.biHeight = b
    pic.header.biPlanes = 1
    pic.header.biBitCount = 24
    pic.header.biCompression = 0
    pic.header.biXPelsPerMeter = 0
    pic.header.biYPelsPerMeter = 0
    pic.header.biClrUsed = 0
    pic.header.biClrImportant = 0
    return pic


pic = SetupPicture(
    qrdata.height * qrdata.width,
    qrdata.height * qrdata.width,
    1024)


qr2pixel(pointer(qrdata), pointer(pic.data))
open('pic.bin', 'wb').write(pic.data)
bitmap_color = open('pic.bin', 'rb').read()

f = open('pic.bmp', 'wb')
f.write(b'BM')
f.write(pic.header)

bitmap_color = [bitmap_color[i * (3 * pic.header.biWidth):(i + 1) * (3 * pic.header.biWidth)] for i in range(pic.header.biHeight)]
print(len(bitmap_color), 3 * pic.header.biHeight * pic.header.biWidth)
c = pic.header.biHeight - 1
for i in range(abs(pic.header.biHeight)):
    line = bitmap_color[c-i]
    f.write(line)
    f.write(b'\00' * (pic.header.biWidth % 4))
f.close()
