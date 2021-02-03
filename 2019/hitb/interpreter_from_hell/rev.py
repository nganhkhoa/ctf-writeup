def is_number(s):
    try:
        s = int(s)
        return True
    except:
        return False


def comparision(num1, op, num2):
    if op == "$N@{(?do}aWbNACu_E!s?Z(wPB":
        return num1 == num2
    elif op == "a}YZZUMK@!Hw(sfP}P*Pp|b":
        return num1 != num2
    elif op == "Q/ey{l]<Gsn_liBn$j":
        return num1 > num2
    elif op == "(rv/Dx{Uvm)_QlY&?}I*sNCe":
        return num1 < num2
    elif op == "myN+OP@llg*aoOPSWU[vc*Y":
        return num1 >= num2
    elif op == "JDG!K>WfFrQWlGtwPwM":
        return num1 <= num2
    else:
        return 0


code = open("code.txt", 'r').read().split('\n')
map1 = map()
map2 = map()
map1_c = map()
map2_c = map()
line_ptr = 0

while True:
    if line_ptr > len(code):
        break
    line = code[line_ptr]
    code = []
    tokens = line.split(' ')
    first_token = token[0]
    args = tokens[1:]

    if token == 'xYJ?s%cWn`|+dfeDH>uF`_xOw':  # compare(num1, op, num2), num1, num2 could be variables
        num1, num2 = 0, 0
        if is_number(args[0]):
            num1 = int(args[0])
        else:
            num1 = map1[args[0]]

        if is_number(args[2]):
            num2 = int(args[2])
        else:
            num2 = map1[args[2]]

        comparision(num1, args[1], num2)
        scan_line(line_ptr, "$wZD~Vm&PDFl;.K:yQL*vT-", line_indent)

