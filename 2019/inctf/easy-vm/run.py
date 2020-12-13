from z3 import *


class Program:

  def __init__(self):
    raw_bytes = open('crackme.i', 'rb').read()[8:]
    self.code = [ int.from_bytes(raw_bytes[i:i+8], byteorder='little') for i in range(0, len(raw_bytes), 8) ]
    self.register = [0 for i in range(10)]

    self.instruction = 0
    self.data_10 = 0
    self.data_6 = 0
    self.data_4 = 0
    self.data_7 = 0
    self.data_8 = 0
    self.data_3 = 0
    self.data_5 = 0
    self.data_11 = 0
    self.data_12 = 0
    self.code_data = [0 for i in range(10000)]

    self.s = Solver()
    self.flag_count = 0
    self.vars = []

  def decode(self, ins):
    self.instruction = ins;
    self.data_10 = ~(~ins | 0xF000FFFFFFFFFFFF) >> 52;
    self.data_6 = (ins & (ins ^ 0xFFF0FFFFFFFFFFFF)) >> 48;
    self.data_4 = (ins & (ins ^ 0xFFFF0FFFFFFFFFFF)) >> 44;
    self.data_7 = (ins & (ins ^ 0xFFFFF0FFFFFFFFFF)) >> 40;
    self.data_8 = ~(~ins | 0xFFFFFF0FFFFFFFFF) >> 36;
    self.data_3 = ~(~ins | 0xFFFFFFF000FFFFFF) >> 24;
    self.data_5 = ~(~ins | 0xFF000000);
    self.data_11 = (~(~ins | 0xFFFFFFF000FFFFFF) >> 24) // 5;

    if self.data_5 >= 0x10:
      self.data_5 = int(hex(self.data_5)[-2:], 16)

    return (~(~ins | 0xFFFFFFF000FFFFFF) >> 24) // 5;


  def switch_code1(self):
    data_3 = self.data_3
    if data_3 == 10:
      return self.add()
    if data_3 == 11:
      print("end routine")
      return 1
    if data_3 == 12:
      return self.jump()
    if data_3 == 13:
      print("has_current_eip")
      return 1
    if data_3 == 14:
      return self.foo7()
    return 0


  def switch_code2(self):
    data_3 = self.data_3
    data_4 = self.data_4
    register = self.register
    if data_3 == 0:
      return self.load()
    if data_3 == 1:
      return self.save()
    if data_3 == 2:
      print("register[{}] = get_char()".format(data_4))
      register[data_4] = Int('flag_{:>3}'.format(self.flag_count))
      self.s.add(register[data_4] >= 0)
      self.s.add(register[data_4] <= 255)
      self.flag_count += 1
      return 1
    if data_3 == 3:
      print("print register[{}] {}".format(data_4, chr(register[data_4])))
      return 1
    if data_3 == 4:
      return self.mov()
    return 0


  def switch_code3(self):
    data_3 = self.data_3
    if data_3 == 5:
      return self.cmp()
    if data_3 == 6:
      return self.foo1()
    if data_3 == 7:
      return self.mul()
    if data_3 == 8:
      return self.shift_left()
    if data_3 == 9:
      return self.shift_right()
    return 0

  def load(self):
    data_6 = self.data_6
    data_5 = self.data_5
    data_4 = self.data_4
    data_7 = self.data_7
    register = self.register
    code_data = self.code_data

    if data_6 == 1:
      print("code_data[{}] = register[{}]".format(data_5, data_4))
      code_data[data_5] = register[data_4]
      return 1

    if data_6 == 2:
      print("code_data[register[{}]] = register[{}]".format(data_7, data_4))
      code_data[register[data_7]] = register[data_4]
      return 1

    return 0


  def save(self):
    data_6 = self.data_6
    data_5 = self.data_5
    data_4 = self.data_4
    data_7 = self.data_7
    register = self.register
    code_data = self.code_data

    if data_6 == 1:
      print("register[{}] = code_data[{}]".format(data_4, data_5))
      register[data_4] = code_data[data_5]
      return 1

    if data_6 == 2:
      print("register[{}] = code_data[register[{}]]".format(data_4, data_7))
      register[data_4] = code_data[register[data_7]]
      return 1

    return 0

  def mov(self):
    data_6 = self.data_6
    data_5 = self.data_5
    data_4 = self.data_4
    data_7 = self.data_7
    register = self.register

    if data_6 == 1:
      print("register[{}] = register[{}]".format(data_4, data_7))
      register[data_4] = register[data_7]
      return 1

    if data_6 == 0:
      print("register[{}] = {} = {}".format(
        data_4, data_5, data_5.to_bytes(1, byteorder='little')
      ))
      register[data_4] = data_5
      return 1

    return 0

  def add(self):
    data_4 = self.data_4
    data_5 = self.data_5
    data_7 = self.data_7
    register = self.register
    print("register[{}] = {} + register[{}]".format(data_4, data_5, data_7))
    register[data_4] = register[data_7] + data_5
    return 1

  def jump(self):
    data_10 = self.data_10
    data_6 = self.data_6
    data_5 = self.data_5
    if data_6 == 0:
        print("jump offset {}".format(data_5))
    else:
        print("jump {}".format(data_10))
    return 1

  def mul(self):
    data_4 = self.data_4
    data_7 = self.data_7
    data_8 = self.data_8

    print("register[{}] = register[{}] * register[{}]".format(data_4, data_8, data_7))
    return 1

  def foo1(self):
    print("foo1")

    data_4 = self.data_4
    data_7 = self.data_7
    data_8 = self.data_8
    register = self.register

    register[data_4] = ~register[data_8] & register[data_7]  | ~register[data_7] & register[data_8]
    return 1

  def shift_left(self):
    data_4 = self.data_4
    data_5 = self.data_5
    print("register[{}] <<= {}".format(data_4, data_5))
    return 1

  def shift_right(self):
    data_4 = self.data_4
    data_5 = self.data_5
    print("register[{}] <<= {}".format(data_4, data_5))
    return 1

  def cmp(self):
    data_4 = self.data_4
    data_7 = self.data_7
    data_6 = self.data_6
    register = self.register
    if data_6 == 0:
      print("register[{}] != register[{}]".format(data_7, data_4))
      print(register[data_4] == register[data_7])
      self.s.add(register[data_4] == register[data_7])
      return 1
    if data_6 == 1:
      print("register[{}] > register[{}]".format(data_7, data_4))
      print(register[data_4] <= register[data_7])
      self.s.add(register[data_4] <= register[data_7])
      return 1
    if data_6 == 2:
      print("register[{}] < register[{}]".format(data_7, data_4))
      print(register[data_4] >= register[data_7])
      self.s.add(register[data_4] >= register[data_7])
      return 1
    return 0


  def foo7(self):
    print("foo7")
    return 1

  def run(self):
    for i in range(len(self.code)):
      ins = self.code[i]
      self.decode(ins)
      print("{}\t {} [{}][{}][{}]\t".format(i, hex(ins), self.data_11, self.data_3, self.data_6), end='')
      data_11 = self.data_11
      if data_11 == 0:
        self.switch_code2()
      elif data_11 == 1:
        self.switch_code3()
      elif data_11 == 2:
        self.switch_code1()
      else:
        print("invalid code?")
    self.s.check()
    m = self.s.model()
    for k, v in sorted([(k, m[k]) for k in m], key=lambda x: str(x[0])):
        print(chr(v.as_long()), end='')
    print()


program = Program()
program.run()
