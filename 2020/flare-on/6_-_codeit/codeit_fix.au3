#Region
  #AutoIt3Wrapper_UseUpx=y
#EndRegion
Global Const $str_nocasesense = 0
Global Const $str_casesense = 1
Global Const $str_nocasesensebasic = 2
Global Const $str_stripleading = 1
Global Const $str_striptrailing = 2
Global Const $str_stripspaces = 4
Global Const $str_stripall = 8
Global Const $str_chrsplit = 0
Global Const $str_entiresplit = 1
Global Const $str_nocount = 2
Global Const $str_regexpmatch = 0
Global Const $str_regexparraymatch = 1
Global Const $str_regexparrayfullmatch = 2
Global Const $str_regexparrayglobalmatch = 3
Global Const $str_regexparrayglobalfullmatch = 4
Global Const $str_endisstart = 0
Global Const $str_endnotstart = 1
Global Const $sb_ansi = 1
Global Const $sb_utf16le = 2
Global Const $sb_utf16be = 3
Global Const $sb_utf8 = 4
Global Const $se_utf16 = 0
Global Const $se_ansi = 1
Global Const $se_utf8 = 2
Global Const $str_utf16 = 0
Global Const $str_ucs2 = 1

Func _hextostring($shex)
  If NOT (StringLeft($shex, 2) == "0x") Then $shex = "0x" & $shex
  Return BinaryToString($shex, $sb_utf8)
EndFunc

Func _stringbetween($sstring, $sstart, $send, $imode = $str_endisstart, $bcase = False)
  $sstart = $sstart ? "\Q" & $sstart & "\E" : "\A"
  If $imode <> $str_endnotstart Then $imode = $str_endisstart
  If $imode = $str_endisstart Then
    $send = $send ? "(?=\Q" & $send & "\E)" : "\z"
  Else
    $send = $send ? "\Q" & $send & "\E" : "\z"
  EndIf
  If $bcase = Default Then
    $bcase = False
  EndIf
  Local $areturn = StringRegExp($sstring, "(?s" & (NOT $bcase ? "i" : "") & ")" & $sstart & "(.*?)" & $send, $str_regexparrayglobalmatch)
  If @error Then Return SetError(1, 0, 0)
  Return $areturn
EndFunc

Func _stringexplode($sstring, $sdelimiter, $ilimit = 0)
  If $ilimit = Default Then $ilimit = 0
  If $ilimit > 0 Then
    Local Const $null = Chr(0)
    $sstring = StringReplace($sstring, $sdelimiter, $null, $ilimit)
    $sdelimiter = $null
  ElseIf $ilimit < 0 Then
    Local $iindex = StringInStr($sstring, $sdelimiter, $str_nocasesensebasic, $ilimit)
    If $iindex Then
      $sstring = StringLeft($sstring, $iindex - 1)
    EndIf
  EndIf
  Return StringSplit($sstring, $sdelimiter, BitOR($str_entiresplit, $str_nocount))
EndFunc

Func _stringinsert($sstring, $sinsertion, $iposition)
  Local $ilength = StringLen($sstring)
  $iposition = Int($iposition)
  If $iposition < 0 Then $iposition = $ilength + $iposition
  If $ilength < $iposition OR $iposition < 0 Then Return SetError(1, 0, $sstring)
  Return StringLeft($sstring, $iposition) & $sinsertion & StringRight($sstring, $ilength - $iposition)
EndFunc

Func _stringproper($sstring)
  Local $bcapnext = True, $schr = "", $sreturn = ""
  For $i = 1 To StringLen($sstring)
    $schr = StringMid($sstring, $i, 1)
    Select
      Case $bcapnext = True
        If StringRegExp($schr, "[a-zA-Zﾃ-ﾃｿﾅ｡ﾅ毒ｾﾅｸ]") Then
          $schr = StringUpper($schr)
          $bcapnext = False
        EndIf
      Case NOT StringRegExp($schr, "[a-zA-Zﾃ-ﾃｿﾅ｡ﾅ毒ｾﾅｸ]")
        $bcapnext = True
      Case Else
        $schr = StringLower($schr)
    EndSelect
    $sreturn &= $schr
  Next
  Return $sreturn
EndFunc

Func _stringrepeat($sstring, $irepeatcount)
  $irepeatcount = Int($irepeatcount)
  If $irepeatcount = 0 Then Return ""
  If StringLen($sstring) < 1 OR $irepeatcount < 0 Then Return SetError(1, 0, "")
  Local $sresult = ""
  While $irepeatcount > 1
    If BitAND($irepeatcount, 1) Then $sresult &= $sstring
    $sstring &= $sstring
    $irepeatcount = BitShift($irepeatcount, 1)
  WEnd
  Return $sstring & $sresult
EndFunc

Func _stringtitlecase($sstring)
  Local $bcapnext = True, $schr = "", $sreturn = ""
  For $i = 1 To StringLen($sstring)
    $schr = StringMid($sstring, $i, 1)
    Select
      Case $bcapnext = True
        If StringRegExp($schr, "[a-zA-Z\xC0-\xFF0-9]") Then
          $schr = StringUpper($schr)
          $bcapnext = False
        EndIf
      Case NOT StringRegExp($schr, "[a-zA-Z\xC0-\xFF'0-9]")
        $bcapnext = True
      Case Else
        $schr = StringLower($schr)
    EndSelect
    $sreturn &= $schr
  Next
  Return $sreturn
EndFunc

Func _stringtohex($sstring)
  Return Hex(StringToBinary($sstring, $sb_utf8))
EndFunc

#OnAutoItStartRegister "AREIHNVAPWN"
Global $os
Global 0 = Number(" 0 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 1 = Number(" 1 ")
Global 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 6 = Number(" 6 "), 3 = Number(" 3 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 6 = Number(" 6 "), 4 = Number(" 4 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 3 = Number(" 3 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 0 = Number(" 0 ")
Global 0 = Number(" 0 "), 1 = Number(" 1 "), 2 = Number(" 2 "), 1 = Number(" 1 "), 2 = Number(" 2 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 3 = Number(" 3 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 7 = Number(" 7 "), 0 = Number(" 0 "), 7 = Number(" 7 "), 0 = Number(" 0 ")
Global 2 = Number(" 2 "), 4 = Number(" 4 "), 3 = Number(" 3 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 4 = Number(" 4 "), 2 = Number(" 2 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 6 = Number(" 6 "), 3 = Number(" 3 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 5 = Number(" 5 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 0 = Number(" 0 ")
Global 3 = Number(" 3 "), 2 = Number(" 2 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 3 = Number(" 3 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 ")
Global 5 = Number(" 5 "), 6 = Number(" 6 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 4 = Number(" 4 "), 3 = Number(" 3 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 4 = Number(" 4 "), 1 = Number(" 1 "), 3 = Number(" 3 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 6 = Number(" 6 "), 4 = Number(" 4 "), 2 = Number(" 2 "), 4 = Number(" 4 ")
Global 2 = Number(" 2 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 2 = Number(" 2 "), 4 = Number(" 4 "), 3 = Number(" 3 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 4 = Number(" 4 "), 3 = Number(" 3 "), 4 = Number(" 4 "), 5 = Number(" 5 "), 6 = Number(" 6 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 1 = Number(" 1 ")
Global 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 6 = Number(" 6 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 2 = Number(" 2 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 7 = Number(" 7 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 3 = Number(" 3 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 ")
Global 0 = Number(" 0 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 6 = Number(" 6 "), 3 = Number(" 3 "), 0 = Number(" 0 "), 7 = Number(" 7 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 2 = Number(" 2 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 "), 1 = Number(" 1 ")
Global 3 = Number(" 3 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 4 = Number(" 4 "), 0 = Number(" 0 "), 5 = Number(" 5 "), 0 = Number(" 0 "), 6 = Number(" 6 "), 0 = Number(" 0 "), 7 = Number(" 7 "), 0 = Number(" 0 "), 8 = Number(" 8 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 9 = Number(" 9 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 "), 0 = Number(" 0 ")
Global 36 = Number(" 36 "), 39 = Number(" 39 "), 28 = Number(" 28 "), 25 = Number(" 25 "), 26 = Number(" 26 "), 156 = Number(" 156 "), 28 = Number(" 28 "), 25 = Number(" 25 "), 26 = Number(" 26 "), 157 = Number(" 157 "), 138 = Number(" 138 "), 154 = Number(" 154 "), 25 = Number(" 25 "), 36 = Number(" 36 "), 158 = Number(" 158 "), 28 = Number(" 28 "), 39 = Number(" 39 "), 2 = Number(" 2 "), 0 = Number(" 0 "), 1 = Number(" 1 "), 0 = Number(" 0 "), 2 = Number(" 2 "), 3 = Number(" 3 "), 4 = Number(" 4 "), 0 = Number(" 0 ")
Global 150 = Number(" 150 "), 128 = Number(" 128 "), 28 = Number(" 28 "), 25 = Number(" 25 "), 150 = Number(" 150 "), 151 = Number(" 151 "), 28 = Number(" 28 "), 152 = Number(" 152 "), 28 = Number(" 28 "), 150 = Number(" 150 "), 150 = Number(" 150 "), 25 = Number(" 25 "), 28 = Number(" 28 "), 153 = Number(" 153 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 150 = Number(" 150 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 154 = Number(" 154 "), 25 = Number(" 25 "), 26 = Number(" 26 "), 155 = Number(" 155 "), 28 = Number(" 28 "), 39 = Number(" 39 ")
Global 19778 = Number(" 19778 "), 148 = Number(" 148 "), 25 = Number(" 25 "), 28 = Number(" 28 "), 149 = Number(" 149 "), 138 = Number(" 138 "), 22 = Number(" 22 "), 150 = Number(" 150 "), 2147483648 = Number(" 2147483648 "), 150 = Number(" 150 "), 28 = Number(" 28 "), 150 = Number(" 150 "), 150 = Number(" 150 "), 128 = Number(" 128 "), 28 = Number(" 28 "), 25 = Number(" 25 "), 28 = Number(" 28 "), 149 = Number(" 149 "), 138 = Number(" 138 "), 22 = Number(" 22 "), 150 = Number(" 150 "), 1073741824 = Number(" 1073741824 "), 150 = Number(" 150 "), 28 = Number(" 28 "), 150 = Number(" 150 ")
Global 26 = Number(" 26 "), 135 = Number(" 135 "), 136 = Number(" 136 "), 137 = Number(" 137 "), 39 = Number(" 39 "), 138 = Number(" 138 "), 1024 = Number(" 1024 "), 136 = Number(" 136 "), 139 = Number(" 139 "), 39 = Number(" 39 "), 39 = Number(" 39 "), 25 = Number(" 25 "), 30 = Number(" 30 "), 21 = Number(" 21 "), 11 = Number(" 11 "), 140 = Number(" 140 "), 141 = Number(" 141 "), 142 = Number(" 142 "), 143 = Number(" 143 "), 144 = Number(" 144 "), 145 = Number(" 145 "), 146 = Number(" 146 "), 4096 = Number(" 4096 "), 134 = Number(" 134 "), 147 = Number(" 147 ")
Global 26 = Number(" 26 "), 126 = Number(" 126 "), 28 = Number(" 28 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 125 = Number(" 125 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 128 = Number(" 128 "), 25 = Number(" 25 "), 26 = Number(" 26 "), 129 = Number(" 129 "), 39 = Number(" 39 "), 130 = Number(" 130 "), 300 = Number(" 300 "), 131 = Number(" 131 "), 30 = Number(" 30 "), 300 = Number(" 300 "), 132 = Number(" 132 "), 55 = Number(" 55 "), 300 = Number(" 300 "), 300 = Number(" 300 "), 133 = Number(" 133 "), 134 = Number(" 134 "), 13 = Number(" 13 ")
Global 34 = Number(" 34 "), 26 = Number(" 26 "), 37 = Number(" 37 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 32771 = Number(" 32771 "), 36 = Number(" 36 "), 36 = Number(" 36 "), 28 = Number(" 28 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 38 = Number(" 38 "), 28 = Number(" 28 "), 39 = Number(" 39 "), 36 = Number(" 36 "), 36 = Number(" 36 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 40 = Number(" 40 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 34 = Number(" 34 ")
Global 26 = Number(" 26 "), 125 = Number(" 125 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 126 = Number(" 126 "), 28 = Number(" 28 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 125 = Number(" 125 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 127 = Number(" 127 "), 16 = Number(" 16 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 35 = Number(" 35 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 24 = Number(" 24 "), 36 = Number(" 36 "), 4026531840 = Number(" 4026531840 ")
Global 28 = Number(" 28 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 36 = Number(" 36 "), 36 = Number(" 36 "), 28 = Number(" 28 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 121 = Number(" 121 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 36 = Number(" 36 "), 36 = Number(" 36 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 122 = Number(" 122 "), 123 = Number(" 123 "), 10 = Number(" 10 "), 14 = Number(" 14 "), 18 = Number(" 18 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 124 = Number(" 124 "), 28 = Number(" 28 "), 34 = Number(" 34 ")
Global 108 = Number(" 108 "), 109 = Number(" 109 "), 110 = Number(" 110 "), 111 = Number(" 111 "), 112 = Number(" 112 "), 113 = Number(" 113 "), 114 = Number(" 114 "), 115 = Number(" 115 "), 116 = Number(" 116 "), 117 = Number(" 117 "), 118 = Number(" 118 "), 119 = Number(" 119 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 35 = Number(" 35 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 24 = Number(" 24 "), 36 = Number(" 36 "), 4026531840 = Number(" 4026531840 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 120 = Number(" 120 ")
Global 83 = Number(" 83 "), 84 = Number(" 84 "), 85 = Number(" 85 "), 86 = Number(" 86 "), 87 = Number(" 87 "), 88 = Number(" 88 "), 89 = Number(" 89 "), 90 = Number(" 90 "), 91 = Number(" 91 "), 92 = Number(" 92 "), 93 = Number(" 93 "), 94 = Number(" 94 "), 95 = Number(" 95 "), 96 = Number(" 96 "), 97 = Number(" 97 "), 98 = Number(" 98 "), 99 = Number(" 99 "), 100 = Number(" 100 "), 101 = Number(" 101 "), 102 = Number(" 102 "), 103 = Number(" 103 "), 104 = Number(" 104 "), 105 = Number(" 105 "), 106 = Number(" 106 "), 107 = Number(" 107 ")
Global 58 = Number(" 58 "), 59 = Number(" 59 "), 60 = Number(" 60 "), 61 = Number(" 61 "), 62 = Number(" 62 "), 63 = Number(" 63 "), 64 = Number(" 64 "), 65 = Number(" 65 "), 66 = Number(" 66 "), 67 = Number(" 67 "), 68 = Number(" 68 "), 69 = Number(" 69 "), 70 = Number(" 70 "), 71 = Number(" 71 "), 72 = Number(" 72 "), 73 = Number(" 73 "), 74 = Number(" 74 "), 75 = Number(" 75 "), 76 = Number(" 76 "), 77 = Number(" 77 "), 78 = Number(" 78 "), 79 = Number(" 79 "), 80 = Number(" 80 "), 81 = Number(" 81 "), 82 = Number(" 82 ")
Global 26 = Number(" 26 "), 40 = Number(" 40 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 41 = Number(" 41 "), 42 = Number(" 42 "), 43 = Number(" 43 "), 44 = Number(" 44 "), 45 = Number(" 45 "), 46 = Number(" 46 "), 41 = Number(" 41 "), 47 = Number(" 47 "), 48 = Number(" 48 "), 49 = Number(" 49 "), 50 = Number(" 50 "), 51 = Number(" 51 "), 52 = Number(" 52 "), 53 = Number(" 53 "), 54 = Number(" 54 "), 55 = Number(" 55 "), 56 = Number(" 56 "), 57 = Number(" 57 ")
Global 35 = Number(" 35 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 24 = Number(" 24 "), 36 = Number(" 36 "), 4026531840 = Number(" 4026531840 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 37 = Number(" 37 "), 28 = Number(" 28 "), 36 = Number(" 36 "), 32780 = Number(" 32780 "), 36 = Number(" 36 "), 36 = Number(" 36 "), 28 = Number(" 28 "), 34 = Number(" 34 "), 26 = Number(" 26 "), 38 = Number(" 38 "), 28 = Number(" 28 "), 39 = Number(" 39 "), 36 = Number(" 36 "), 36 = Number(" 36 "), 34 = Number(" 34 ")
Global 22 = Number(" 22 "), 24 = Number(" 24 "), 1024 = Number(" 1024 "), 25 = Number(" 25 "), 26 = Number(" 26 "), 27 = Number(" 27 "), 28 = Number(" 28 "), 28 = Number(" 28 "), 29 = Number(" 29 "), 300 = Number(" 300 "), 375 = Number(" 375 "), 14 = Number(" 14 "), 54 = Number(" 54 "), 30 = Number(" 30 "), 31 = Number(" 31 "), 32 = Number(" 32 "), 54 = Number(" 54 "), 31 = Number(" 31 "), 20 = Number(" 20 "), 30 = Number(" 30 "), 31 = Number(" 31 "), 33 = Number(" 33 "), 32 = Number(" 32 "), 34 = Number(" 34 "), 26 = Number(" 26 ")
Global 54 = Number(" 54 "), 40 = Number(" 40 "), 24 = Number(" 24 "), 10 = Number(" 10 "), 11 = Number(" 11 "), 12 = Number(" 12 "), 13 = Number(" 13 "), 14 = Number(" 14 "), 15 = Number(" 15 "), 16 = Number(" 16 "), 17 = Number(" 17 "), 18 = Number(" 18 "), 19 = Number(" 19 "), 20 = Number(" 20 "), 97 = Number(" 97 "), 122 = Number(" 122 "), 15 = Number(" 15 "), 20 = Number(" 20 "), 10 = Number(" 10 "), 15 = Number(" 15 "), 21 = Number(" 21 "), 22 = Number(" 22 "), 25 = Number(" 25 "), 30 = Number(" 30 "), 23 = Number(" 23 ")

Func Setup_Picture($flmojocqtz, $fljzkjrgzs, $flsgxlqjno)
  Local $flfzxxyxzg[2]
  $flfzxxyxzg[0] = DllStructCreate("struct;uint bfSize;uint bfReserved;uint bfOffBits;uint biSize;int biWidth;int biHeight;ushort biPlanes;ushort biBitCount;uint biCompression;uint biSizeImage;int biXPelsPerMeter;int biYPelsPerMeter;uint biClrUsed;uint biClrImportant;endstruct;")
  DllStructSetData($flfzxxyxzg[0], "bfSize", (3 * $flmojocqtz + Mod($flmojocqtz, 4) * Abs($fljzkjrgzs)))
  DllStructSetData($flfzxxyxzg[0], "bfReserved", 0)
  DllStructSetData($flfzxxyxzg[0], "bfOffBits", 54)
  DllStructSetData($flfzxxyxzg[0], "biSize", 40)
  DllStructSetData($flfzxxyxzg[0], "biWidth", $flmojocqtz)
  DllStructSetData($flfzxxyxzg[0], "biHeight", $fljzkjrgzs)
  DllStructSetData($flfzxxyxzg[0], "biPlanes", 1)
  DllStructSetData($flfzxxyxzg[0], "biBitCount", 24)
  DllStructSetData($flfzxxyxzg[0], "biCompression", 0)
  DllStructSetData($flfzxxyxzg[0], "biSizeImage", 0)
  DllStructSetData($flfzxxyxzg[0], "biXPelsPerMeter", 0)
  DllStructSetData($flfzxxyxzg[0], "biYPelsPerMeter", 0)
  DllStructSetData($flfzxxyxzg[0], "biClrUsed", 0)
  DllStructSetData($flfzxxyxzg[0], "biClrImportant", 0)
  $flfzxxyxzg[1] = DllStructCreate("struct;" & _stringrepeat("byte[" & DllStructGetData($flfzxxyxzg[0], "biWidth") * 3 & "];", DllStructGetData($flfzxxyxzg[0], "biHeight")) & "endstruct")
  Return $flfzxxyxzg
EndFunc

Func RandomName($flyoojibbo, $fltyapmigo)
  Local $fldknagjpd = ""
  For $flezmzowno = 0 To Random($flyoojibbo, $fltyapmigo, 1)
    $fldknagjpd &= Chr(Random(97, 122, 1))
  Next
  Return $fldknagjpd
EndFunc

Func InstallResourceFile($flslbknofv)
  Local $flxgrwiiel = RandomName(15, 20)
  Switch $flslbknofv
    Case 10 To 15
      $flxgrwiiel &= ".bmp"
      FileInstall(".\sprite.bmp", @ScriptDir & "\" & $flxgrwiiel)
    Case 25 To 30
      $flxgrwiiel &= ".dll"
      FileInstall(".\qr_encoder.dll", @ScriptDir & "\" & $flxgrwiiel)
  EndSwitch
  Return $flxgrwiiel
EndFunc

Func GetComputerNameA()
  Local $flfnvbvvfi = -1
  Local $flfnvbvvfiraw = DllStructCreate("struct;dword;char[1024];endstruct")
  DllStructSetData($flfnvbvvfiraw, 1, 1024)
  Local $flmyeulrox = DllCall("kernel32.dll", "int", "GetComputerNameA", "ptr", DllStructGetPtr($flfnvbvvfiraw, 2), "ptr", DllStructGetPtr($flfnvbvvfiraw, 1))
  If $flmyeulrox[0] <> 0 Then
    $flfnvbvvfi = BinaryMid(DllStructGetData($flfnvbvvfiraw, 2), 1, DllStructGetData($flfnvbvvfiraw, 1))
  EndIf
  Return $flfnvbvvfi
EndFunc

GUICreate("CodeIt Plus!", 300, 375, -1, -1)

Func EncodeString(ByRef $flkqaovzec)
  Local $flqvizhezm = InstallResourceFile(14)
  Local $flfwezdbyc = CreateFileRead($flqvizhezm)
  If $flfwezdbyc <> -1 Then
    Local $flvburiuyd = get_file_size($flfwezdbyc)
    If $flvburiuyd <> -1 AND DllStructGetSize($flkqaovzec) < $flvburiuyd - 54 Then
      Local $flnfufvect = DllStructCreate("struct;byte[" & $flvburiuyd & "];endstruct")
      Local $flskuanqbg = ReadFile($flfwezdbyc, $flnfufvect)
      If $flskuanqbg <> -1 Then
        Local $flxmdchrqd = DllStructCreate("struct;byte[54];byte[" & $flvburiuyd - 54 & "];endstruct", DllStructGetPtr($flnfufvect))
        Local $flqgwnzjzc = 1
        Local $floctxpgqh = ""
        For $fltergxskh = 1 To DllStructGetSize($flkqaovzec)
          Local $flydtvgpnc = Number(DllStructGetData($flkqaovzec, 1, $fltergxskh))
          For $fltajbykxx = 6 To 0 Step -1
            $flydtvgpnc += BitShift(BitAND(Number(DllStructGetData($flxmdchrqd, 2, $flqgwnzjzc)), 1), -1 * $fltajbykxx)
            $flqgwnzjzc += 1
          Next
          $floctxpgqh &= Chr(BitShift($flydtvgpnc, 1) + BitShift(BitAND($flydtvgpnc, 1), -7))
        Next
        DllStructSetData($flkqaovzec, 1, $floctxpgqh)
      EndIf
    EndIf
    CloseHandle($flfwezdbyc)
  EndIf
  DeleteFileA($flqvizhezm)
EndFunc

Func Decrypt(ByRef $flodiutpuy)
  Local $flisilayln = GetComputerNameA()
  If $flisilayln <> -1 Then
    $flisilayln = Binary(StringLower(BinaryToString($flisilayln)))
    Local $flisilaylnraw = DllStructCreate("struct;byte[" & BinaryLen($flisilayln) & "];endstruct")
    DllStructSetData($flisilaylnraw, 1, $flisilayln)
    EncodeString($flisilaylnraw)
    Local $flnttmjfea = DllStructCreate("struct;ptr;ptr;dword;byte[32];endstruct")
    DllStructSetData($flnttmjfea, 3, 32)
    Local $fluzytjacb = DllCall("advapi32.dll", "int", "CryptAcquireContextA", "ptr", DllStructGetPtr($flnttmjfea, 1), "ptr", 0, "ptr", 0, "dword", 24, "dword", 4026531840)
    If $fluzytjacb[0] <> 0 Then
      $fluzytjacb = DllCall("advapi32.dll", "int", "CryptCreateHash", "ptr", DllStructGetData($flnttmjfea, 1), "dword", 32780, "dword", 0, "dword", 0, "ptr", DllStructGetPtr($flnttmjfea, 2))
      If $fluzytjacb[0] <> 0 Then
        $fluzytjacb = DllCall("advapi32.dll", "int", "CryptHashData", "ptr", DllStructGetData($flnttmjfea, 2), "struct*", $flisilaylnraw, "dword", DllStructGetSize($flisilaylnraw), "dword", 0)
        If $fluzytjacb[0] <> 0 Then
          $fluzytjacb = DllCall("advapi32.dll", "int", "CryptGetHashParam", "ptr", DllStructGetData($flnttmjfea, 2), "dword", 2, "ptr", DllStructGetPtr($flnttmjfea, 4), "ptr", DllStructGetPtr($flnttmjfea, 3), "dword", 0)
          If $fluzytjacb[0] <> 0 Then
            Local $flmtvyzrsy = Binary("0x" & "08020" & "00010" & "66000" & "02000" & "0000") & DllStructGetData($flnttmjfea, 4)
            Local $flkpzlqkch = Binary("0x" & "CD4B3" & "2C650" & "CF21B" & "DA184" & "D8913" & "E6F92" & "0A37A" & "4F396" & "3736C" & "042C4" & "59EA0" & "7B79E" & "A443F" & "FD189" & "8BAE4" & "9B115" & "F6CB1" & "E2A7C" & "1AB3C" & "4C256" & "12A51" & "9035F" & "18FB3" & "B1752" & "8B3AE" & "CAF3D" & "480E9" & "8BF8A" & "635DA" & "F974E" & "00135" & "35D23" & "1E4B7" & "5B2C3" & "8B804" & "C7AE4" & "D266A" & "37B36" & "F2C55" & "5BF3A" & "9EA6A" & "58BC8" & "F906C" & "C665E" & "AE2CE" & "60F2C" & "DE38F" & "D3026" & "9CC4C" & "E5BB0" & "90472" & "FF9BD" & "26F91" & "19B8C" & "484FE" & "69EB9" & "34F43" & "FEEDE" & "DCEBA" & "79146" & "0819F" & "B21F1" & "0F832" & "B2A5D" & "4D772" & "DB12C" & "3BED9" & "47F6F" & "706AE" & "4411A" & "52")
            Local $fluelrpeax = DllStructCreate("struct;ptr;ptr;dword;byte[8192];byte[" & BinaryLen($flmtvyzrsy) & "];dword;endstruct")
            DllStructSetData($fluelrpeax, 3, BinaryLen($flkpzlqkch))
            DllStructSetData($fluelrpeax, 4, $flkpzlqkch)
            DllStructSetData($fluelrpeax, 5, $flmtvyzrsy)
            DllStructSetData($fluelrpeax, 6, BinaryLen($flmtvyzrsy))
            Local $fluzytjacb = DllCall("advapi32.dll", "int", "CryptAcquireContextA", "ptr", DllStructGetPtr($fluelrpeax, 1), "ptr", 0, "ptr", 0, "dword", 24, "dword", 4026531840)
            If $fluzytjacb[0] <> 0 Then
              $fluzytjacb = DllCall("advapi32.dll", "int", "CryptImportKey", "ptr", DllStructGetData($fluelrpeax, 1), "ptr", DllStructGetPtr($fluelrpeax, 5), "dword", DllStructGetData($fluelrpeax, 6), "dword", 0, "dword", 0, "ptr", DllStructGetPtr($fluelrpeax, 2))
              If $fluzytjacb[0] <> 0 Then
                $fluzytjacb = DllCall("advapi32.dll", "int", "CryptDecrypt", "ptr", DllStructGetData($fluelrpeax, 2), "dword", 0, "dword", 1, "dword", 0, "ptr", DllStructGetPtr($fluelrpeax, 4), "ptr", DllStructGetPtr($fluelrpeax, 3))
                If $fluzytjacb[0] <> 0 Then
                  Local $flsekbkmru = BinaryMid(DllStructGetData($fluelrpeax, 4), 1, DllStructGetData($fluelrpeax, 3))
                  $flfzfsuaoz = Binary("FLARE")
                  $fltvwqdotg = Binary("ERALF")
                  $flgggftges = BinaryMid($flsekbkmru, 1, BinaryLen($flfzfsuaoz))
                  $flnmiatrft = BinaryMid($flsekbkmru, BinaryLen($flsekbkmru) - BinaryLen($fltvwqdotg) + 1, BinaryLen($fltvwqdotg))
                  If $flfzfsuaoz = $flgggftges AND $fltvwqdotg = $flnmiatrft Then
                    DllStructSetData($flodiutpuy, 1, BinaryMid($flsekbkmru, 6, 4))
                    DllStructSetData($flodiutpuy, 2, BinaryMid($flsekbkmru, 10, 4))
                    DllStructSetData($flodiutpuy, 3, BinaryMid($flsekbkmru, 14, BinaryLen($flsekbkmru) - 18))
                  EndIf
                EndIf
                DllCall("advapi32.dll", "int", "CryptDestroyKey", "ptr", DllStructGetData($fluelrpeax, 2))
              EndIf
              DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", DllStructGetData($fluelrpeax, 1), "dword", 0)
            EndIf
          EndIf
        EndIf
        DllCall("advapi32.dll", "int", "CryptDestroyHash", "ptr", DllStructGetData($flnttmjfea, 2))
      EndIf
      DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", DllStructGetData($flnttmjfea, 1), "dword", 0)
    EndIf
  EndIf
EndFunc

Func MD5(ByRef $flkhfbuyon)
  Local $fluupfrkdz = -1
  Local $flqbsfzezk = DllStructCreate("struct;ptr;ptr;dword;byte[16];endstruct")
  DllStructSetData($flqbsfzezk, 3, 16)
  Local $fltrtsuryd = DllCall("advapi32.dll", "int", "CryptAcquireContextA", "ptr", DllStructGetPtr($flqbsfzezk, 1), "ptr", 0, "ptr", 0, "dword", 24, "dword", 4026531840)
  If $fltrtsuryd[0] <> 0 Then
    $fltrtsuryd = DllCall("advapi32.dll", "int", "CryptCreateHash", "ptr", DllStructGetData($flqbsfzezk, 1), "dword", 32771, "dword", 0, "dword", 0, "ptr", DllStructGetPtr($flqbsfzezk, 2))
    If $fltrtsuryd[0] <> 0 Then
      $fltrtsuryd = DllCall("advapi32.dll", "int", "CryptHashData", "ptr", DllStructGetData($flqbsfzezk, 2), "struct*", $flkhfbuyon, "dword", DllStructGetSize($flkhfbuyon), "dword", 0)
      If $fltrtsuryd[0] <> 0 Then
        $fltrtsuryd = DllCall("advapi32.dll", "int", "CryptGetHashParam", "ptr", DllStructGetData($flqbsfzezk, 2), "dword", 2, "ptr", DllStructGetPtr($flqbsfzezk, 4), "ptr", DllStructGetPtr($flqbsfzezk, 3), "dword", 0)
        If $fltrtsuryd[0] <> 0 Then
          $fluupfrkdz = DllStructGetData($flqbsfzezk, 4)
        EndIf
      EndIf
      DllCall("advapi32.dll", "int", "CryptDestroyHash", "ptr", DllStructGetData($flqbsfzezk, 2))
    EndIf
    DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", DllStructGetData($flqbsfzezk, 1), "dword", 0)
  EndIf
  Return $fluupfrkdz
EndFunc

Func Windows8()
  Local $flgqbtjbmi = -1
  Local $fltpvjccvq = DllStructCreate("struct;dword;dword;dword;dword;dword;byte[128];endstruct")
  DllStructSetData($fltpvjccvq, 1, DllStructGetSize($fltpvjccvq))
  Local $flaghdvgyv = DllCall("kernel32.dll", "int", "GetVersionExA", "struct*", $fltpvjccvq)
  If $flaghdvgyv[0] <> 0 Then
    If DllStructGetData($fltpvjccvq, 2) = 6 Then
      If DllStructGetData($fltpvjccvq, 3) = 1 Then
        $flgqbtjbmi = 0
      EndIf
    EndIf
  EndIf
  Return $flgqbtjbmi
EndFunc

Func Main()
  Local $flokwzamxw = GUICtrlCreateInput("Enter text to encode", -1, 5, 300)
  Local $flkhwwzgne = GUICtrlCreateButton("Can haz code?", -1, 30, 300)
  Local $fluhtsijxf = GUICtrlCreatePic("", -1, 55, 300, 300)
  Local $flxeuaihlc = GUICtrlCreateMenu("Help")
  Local $flxeuaihlcitem = GUICtrlCreateMenuItem("About CodeIt Plus!", $flxeuaihlc)
  Local $flpnltlqhh = InstallResourceFile(13)
  GUICtrlSetImage($fluhtsijxf, $flpnltlqhh)
  DeleteFileA($flpnltlqhh)
  GUISetState(@SW_SHOW)
  While 1
    Switch GUIGetMsg()
      Case $flkhwwzgne
        Local $flnwbvjljj = GUICtrlRead($flokwzamxw)
        If $flnwbvjljj Then
          Local $flwxdpsimz = InstallResourceFile(26)
          Local $flnpapeken = DllStructCreate("struct;dword;dword;byte[3918];endstruct")
          Local $fljfojrihf = DllCall($flwxdpsimz, "int:cdecl", "justGenerateQRSymbol", "struct*", $flnpapeken, "str", $flnwbvjljj)
          If $fljfojrihf[0] <> 0 Then
            Decrypt($flnpapeken)
            Local $flbvokdxkg = Setup_Picture((DllStructGetData($flnpapeken, 1) * DllStructGetData($flnpapeken, 2)), (DllStructGetData($flnpapeken, 1) * DllStructGetData($flnpapeken, 2)), 1024)
            $fljfojrihf = DllCall($flwxdpsimz, "int:cdecl", "justConvertQRSymbolToBitmapPixels", "struct*", $flnpapeken, "struct*", $flbvokdxkg[1])
            If $fljfojrihf[0] <> 0 Then
              $flpnltlqhh = RandomName(25, 30) & ".bmp"
              Picture_2($flbvokdxkg, $flpnltlqhh)
            EndIf
          EndIf
          DeleteFileA($flwxdpsimz)
        Else
          $flpnltlqhh = InstallResourceFile(11)
        EndIf
        GUICtrlSetImage($fluhtsijxf, $flpnltlqhh)
        DeleteFileA($flpnltlqhh)
      Case $flxeuaihlcitem
        Local $flomtrkawp = "This program generates QR codes using QR Code Generator (https://www.nayuki.io/page/qr-code-generator-library) developed by Nayuki. "
        $flomtrkawp &= "QR Code Generator is available on GitHub (https://github.com/nayuki/QR-Code-generator) and open-sourced under the following permissive MIT License (https://github.com/nayuki/QR-Code-generator#license):"
        $flomtrkawp &= @CRLF
        $flomtrkawp &= @CRLF
        $flomtrkawp &= "Copyright © 2020 Project Nayuki. (MIT License)"
        $flomtrkawp &= @CRLF
        $flomtrkawp &= "https://www.nayuki.io/page/qr-code-generator-library"
        $flomtrkawp &= @CRLF
        $flomtrkawp &= @CRLF
        $flomtrkawp &= "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:"
        $flomtrkawp &= @CRLF
        $flomtrkawp &= @CRLF
        $flomtrkawp &= "1. The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."
        $flomtrkawp &= @CRLF
        $flomtrkawp &= "2. The Software is provided as is, without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software."
        MsgBox(4096, "About CodeIt Plus!", $flomtrkawp)
      Case -3
        ExitLoop
    EndSwitch
  WEnd
EndFunc

Func Picture_1($flmwacufre, $fljxaivjld)
  Local $fljiyeluhx = -1
  Local $flmwacufreheadermagic = DllStructCreate("struct;ushort;endstruct")
  DllStructSetData($flmwacufreheadermagic, 1, 19778)
  Local $flivpiogmf = CreateFileWrite($fljxaivjld, False)
  If $flivpiogmf <> -1 Then
    Local $flchlkbend = TruncateWriteFile($flivpiogmf, DllStructGetPtr($flmwacufreheadermagic), DllStructGetSize($flmwacufreheadermagic))
    If $flchlkbend <> -1 Then
      $flchlkbend = TruncateWriteFile($flivpiogmf, DllStructGetPtr($flmwacufre[0]), DllStructGetSize($flmwacufre[0]))
      If $flchlkbend <> -1 Then
        $fljiyeluhx = 0
      EndIf
    EndIf
    CloseHandle($flivpiogmf)
  EndIf
  Return $fljiyeluhx
EndFunc

Main()

Func Picture_2($flbaqvujsl, $flkelsuuiy)
  Local $flefoubdxt = -1
  Local $flamtlcncx = Picture_1($flbaqvujsl, $flkelsuuiy)
  If $flamtlcncx <> -1 Then
    Local $flvikmhxwu = CreateFileWrite($flkelsuuiy, True)
    If $flvikmhxwu <> -1 Then
      Local $flwldjlwrq = Abs(DllStructGetData($flbaqvujsl[0], "biHeight"))
      Local $flumnoetuu = DllStructGetData($flbaqvujsl[0], "biHeight") > 0 ? $flwldjlwrq - 1 : 0
      Local $flqphcjgtp = DllStructCreate("struct;byte;byte;byte;endstruct")
      For $fllrcvawmx = 0 To $flwldjlwrq - 1
        $flamtlcncx = TruncateWriteFile($flvikmhxwu, DllStructGetPtr($flbaqvujsl[1], Abs($flumnoetuu - $fllrcvawmx) + 1), DllStructGetData($flbaqvujsl[0], "biWidth") * 3)
        If $flamtlcncx = -1 Then ExitLoop
        $flamtlcncx = TruncateWriteFile($flvikmhxwu, DllStructGetPtr($flqphcjgtp), Mod(DllStructGetData($flbaqvujsl[0], "biWidth"), 4))
        If $flamtlcncx = -1 Then ExitLoop
      Next
      If $flamtlcncx <> -1 Then
        $flefoubdxt = 0
      EndIf
      CloseHandle($flvikmhxwu)
    EndIf
  EndIf
  Return $flefoubdxt
EndFunc

Func CreateFileRead($flrriteuxd)
  Local $flrichemye = DllCall("kernel32.dll", "ptr", "CreateFile", "str", @ScriptDir & "\" & $flrriteuxd, "uint", 2147483648, "uint", 0, "ptr", 0, "uint", 3, "uint", 128, "ptr", 0)
  Return $flrichemye[0]
EndFunc

Func CreateFileWrite($flzxepiook, $flzcodzoep = True)
  Local $flogmfcakq = DllCall("kernel32.dll", "ptr", "CreateFile", "str", @ScriptDir & "\" & $flzxepiook, "uint", 1073741824, "uint", 0, "ptr", 0, "uint", $flzcodzoep ? 3 : 2, "uint", 128, "ptr", 0)
  Return $flogmfcakq[0]
EndFunc

GUIDelete()

Func TruncateWriteFile($fllsczdyhr, $flbfzgxbcy, $flutgabjfj)
  If $fllsczdyhr <> -1 Then
    Local $flvfnkosuf = DllCall("kernel32.dll", "uint", "SetFilePointer", "ptr", $fllsczdyhr, "long", 0, "ptr", 0, "uint", 2)
    If $flvfnkosuf[0] <> -1 Then
      Local $flwzfbbkto = DllStructCreate("uint")
      $flvfnkosuf = DllCall("kernel32.dll", "ptr", "WriteFile", "ptr", $fllsczdyhr, "ptr", $flbfzgxbcy, "uint", $flutgabjfj, "ptr", DllStructGetPtr($flwzfbbkto), "ptr", 0)
      If $flvfnkosuf[0] <> 0 AND DllStructGetData($flwzfbbkto, 1) = $flutgabjfj Then
        Return 0
      EndIf
    EndIf
  EndIf
  Return -1
EndFunc

Func ReadFile($flfdnkxwze, ByRef $flgfdykdor)
  Local $flqcvtzthz = DllStructCreate("struct;dword;endstruct")
  Local $flqnsbzfsf = DllCall("kernel32.dll", "int", "ReadFile", "ptr", $flfdnkxwze, "struct*", $flgfdykdor, "dword", DllStructGetSize($flgfdykdor), "struct*", $flqcvtzthz, "ptr", 0)
  Return $flqnsbzfsf[0]
EndFunc

Func CloseHandle($fldiapcptm)
  Local $flhvhgvtxm = DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $fldiapcptm)
  Return $flhvhgvtxm[0]
EndFunc

Func DeleteFileA($flxljyoycl)
  Local $flaubrmoip = DllCall("kernel32.dll", "int", "DeleteFileA", "str", $flxljyoycl)
  Return $flaubrmoip[0]
EndFunc

Func get_file_size($flpxhqhcav)
  Local $flzmcdhzwh = -1
  Local $flztpegdeg = DllStructCreate("struct;dword;endstruct")
  Local $flekmcmpdl = DllCall("kernel32.dll", "dword", "GetFileSize", "ptr", $flpxhqhcav, "struct*", $flztpegdeg)
  If $flekmcmpdl <> -1 Then
    $flzmcdhzwh = $flekmcmpdl[0] + Number(DllStructGetData($flztpegdeg, 1))
  EndIf
  Return $flzmcdhzwh
EndFunc

Func init_os_string()
  Local $dlit = "7374727563743b75696e7420626653697a653b75696e7420626652657365727665643b75696e742062664f6666426974733b"
  $dlit &= "75696e7420626953697a653b696e7420626957696474683b696e742062694865696768743b7573686f7274206269506c616e"
  $dlit &= "65733b7573686f7274206269426974436f756e743b75696e74206269436f6d7072657373696f6e3b75696e7420626953697a"
  $dlit &= "65496d6167653b696e742062695850656c735065724d657465723b696e742062695950656c735065724d657465723b75696e"
  $dlit &= "74206269436c72557365643b75696e74206269436c72496d706f7274616e743b656e647374727563743b4FD5$626653697a6"
  $dlit &= "54FD5$626652657365727665644FD5$62664f6666426974734FD5$626953697a654FD5$626957696474684FD5$6269486569"
  $dlit &= "6768744FD5$6269506c616e65734FD5$6269426974436f756e744FD5$6269436f6d7072657373696f6e4FD5$626953697a65"
  $dlit &= "496d6167654FD5$62695850656c735065724d657465724FD5$62695950656c735065724d657465724FD5$6269436c7255736"
  $dlit &= "5644FD5$6269436c72496d706f7274616e744FD5$7374727563743b4FD5$627974655b4FD5$5d3b4FD5$656e647374727563"
  $dlit &= "744FD5$4FD5$2e626d704FD5$5c4FD5$2e646c6c4FD5$7374727563743b64776f72643b636861725b313032345d3b656e647"
  $dlit &= "374727563744FD5$6b65726e656c33322e646c6c4FD5$696e744FD5$476574436f6d70757465724e616d65414FD5$7074724"
  $dlit &= "FD5$436f6465497420506c7573214FD5$7374727563743b627974655b4FD5$5d3b656e647374727563744FD5$73747275637"
  $dlit &= "43b627974655b35345d3b627974655b4FD5$7374727563743b7074723b7074723b64776f72643b627974655b33325d3b656e"
  $dlit &= "647374727563744FD5$61647661706933322e646c6c4FD5$437279707441637175697265436f6e74657874414FD5$64776f7"
  $dlit &= "2644FD5$4372797074437265617465486173684FD5$437279707448617368446174614FD5$7374727563742a4FD5$4372797"
  $dlit &= "07447657448617368506172616d4FD5$30784FD5$30383032304FD5$30303031304FD5$36363030304FD5$30323030304FD5"
  $dlit &= "$303030304FD5$43443442334FD5$32433635304FD5$43463231424FD5$44413138344FD5$44383931334FD5$45364639324"
  $dlit &= "FD5$30413337414FD5$34463339364FD5$33373336434FD5$30343243344FD5$35394541304FD5$37423739454FD5$413434"
  $dlit &= "33464FD5$46443138394FD5$38424145344FD5$39423131354FD5$46364342314FD5$45324137434FD5$31414233434FD5$3"
  $dlit &= "4433235364FD5$31324135314FD5$39303335464FD5$31384642334FD5$42313735324FD5$38423341454FD5$43414633444"
  $dlit &= "FD5$34383045394FD5$38424638414FD5$36333544414FD5$46393734454FD5$30303133354FD5$33354432334FD5$314534"
  $dlit &= "42374FD5$35423243334FD5$38423830344FD5$43374145344FD5$44323636414FD5$33374233364FD5$46324335354FD5$3"
  $dlit &= "5424633414FD5$39454136414FD5$35384243384FD5$46393036434FD5$43363635454FD5$41453243454FD5$36304632434"
  $dlit &= "FD5$44453338464FD5$44333032364FD5$39434334434FD5$45354242304FD5$39303437324FD5$46463942444FD5$323646"
  $dlit &= "39314FD5$31394238434FD5$34383446454FD5$36394542394FD5$33344634334FD5$46454544454FD5$44434542414FD5$3"
  $dlit &= "7393134364FD5$30383139464FD5$42323146314FD5$30463833324FD5$42324135444FD5$34443737324FD5$44423132434"
  $dlit &= "FD5$33424544394FD5$34374636464FD5$37303641454FD5$34343131414FD5$35324FD5$7374727563743b7074723b70747"
  $dlit &= "23b64776f72643b627974655b383139325d3b627974655b4FD5$5d3b64776f72643b656e647374727563744FD5$437279707"
  $dlit &= "4496d706f72744b65794FD5$4372797074446563727970744FD5$464c4152454FD5$4552414c464FD5$43727970744465737"
  $dlit &= "4726f794b65794FD5$437279707452656c65617365436f6e746578744FD5$437279707444657374726f79486173684FD5$73"
  $dlit &= "74727563743b7074723b7074723b64776f72643b627974655b31365d3b656e647374727563744FD5$7374727563743b64776"
  $dlit &= "f72643b64776f72643b64776f72643b64776f72643b64776f72643b627974655b3132385d3b656e647374727563744FD5$47"
  $dlit &= "657456657273696f6e4578414FD5$456e746572207465787420746f20656e636f64654FD5$43616e2068617a20636f64653f"
  $dlit &= "4FD5$4FD5$48656c704FD5$41626f757420436f6465497420506c7573214FD5$7374727563743b64776f72643b64776f7264"
  $dlit &= "3b627974655b333931385d3b656e647374727563744FD5$696e743a636465636c4FD5$6a75737447656e6572617465515253"
  $dlit &= "796d626f6c4FD5$7374724FD5$6a757374436f6e76657274515253796d626f6c546f4269746d6170506978656c734FD5$546"
  $dlit &= "869732070726f6772616d2067656e65726174657320515220636f646573207573696e6720515220436f64652047656e65726"
  $dlit &= "1746f72202868747470733a2f2f7777772e6e6179756b692e696f2f706167652f71722d636f64652d67656e657261746f722"
  $dlit &= "d6c6962726172792920646576656c6f706564206279204e6179756b692e204FD5$515220436f64652047656e657261746f72"
  $dlit &= "20697320617661696c61626c65206f6e20476974487562202868747470733a2f2f6769746875622e636f6d2f6e6179756b69"
  $dlit &= "2f51522d436f64652d67656e657261746f722920616e64206f70656e2d736f757263656420756e6465722074686520666f6c"
  $dlit &= "6c6f77696e67207065726d697373697665204d4954204c6963656e7365202868747470733a2f2f6769746875622e636f6d2f"
  $dlit &= "6e6179756b692f51522d436f64652d67656e657261746f72236c6963656e7365293a4FD5$436f7079726967687420c2a9203"
  $dlit &= "23032302050726f6a656374204e6179756b692e20284d4954204c6963656e7365294FD5$68747470733a2f2f7777772e6e61"
  $dlit &= "79756b692e696f2f706167652f71722d636f64652d67656e657261746f722d6c6962726172794FD5$5065726d697373696f6"
  $dlit &= "e20697320686572656279206772616e7465642c2066726565206f66206368617267652c20746f20616e7920706572736f6e2"
  $dlit &= "06f627461696e696e67206120636f7079206f66207468697320736f66747761726520616e64206173736f636961746564206"
  $dlit &= "46f63756d656e746174696f6e2066696c6573202874686520536f667477617265292c20746f206465616c20696e207468652"
  $dlit &= "0536f66747761726520776974686f7574207265737472696374696f6e2c20696e636c7564696e6720776974686f7574206c6"
  $dlit &= "96d69746174696f6e207468652072696768747320746f207573652c20636f70792c206d6f646966792c206d657267652c207"
  $dlit &= "075626c6973682c20646973747269627574652c207375626c6963656e73652c20616e642f6f722073656c6c20636f7069657"
  $dlit &= "3206f662074686520536f6674776172652c20616e6420746f207065726d697420706572736f6e7320746f2077686f6d20746"
  $dlit &= "86520536f667477617265206973206675726e697368656420746f20646f20736f2c207375626a65637420746f20746865206"
  $dlit &= "66f6c6c6f77696e6720636f6e646974696f6e733a4FD5$312e205468652061626f766520636f70797269676874206e6f7469"
  $dlit &= "636520616e642074686973207065726d697373696f6e206e6f74696365207368616c6c20626520696e636c7564656420696e"
  $dlit &= "20616c6c20636f70696573206f72207375627374616e7469616c20706f7274696f6e73206f662074686520536f6674776172"
  $dlit &= "652e4FD5$322e2054686520536f6674776172652069732070726f76696465642061732069732c20776974686f75742077617"
  $dlit &= "272616e7479206f6620616e79206b696e642c2065787072657373206f7220696d706c6965642c20696e636c7564696e67206"
  $dlit &= "27574206e6f74206c696d6974656420746f207468652077617272616e74696573206f66206d65726368616e746162696c697"
  $dlit &= "4792c206669746e65737320666f72206120706172746963756c617220707572706f736520616e64206e6f6e696e6672696e6"
  $dlit &= "7656d656e742e20496e206e6f206576656e74207368616c6c2074686520617574686f7273206f7220636f707972696768742"
  $dlit &= "0686f6c64657273206265206c6961626c6520666f7220616e7920636c61696d2c2064616d61676573206f72206f746865722"
  $dlit &= "06c696162696c6974792c207768657468657220696e20616e20616374696f6e206f6620636f6e74726163742c20746f72742"
  $dlit &= "06f72206f74686572776973652c2061726973696e672066726f6d2c206f7574206f66206f7220696e20636f6e6e656374696"
  $dlit &= "f6e20776974682074686520536f667477617265206f722074686520757365206f72206f74686572206465616c696e6773206"
  $dlit &= "96e2074686520536f6674776172652e4FD5$7374727563743b7573686f72743b656e647374727563744FD5$7374727563743"
  $dlit &= "b627974653b627974653b627974653b656e647374727563744FD5$43726561746546696c654FD5$75696e744FD5$53657446"
  $dlit &= "696c65506f696e7465724FD5$6c6f6e674FD5$577269746546696c654FD5$7374727563743b64776f72643b656e647374727"
  $dlit &= "563744FD5$5265616446696c654FD5$436c6f736548616e646c654FD5$44656c65746546696c65414FD5$47657446696c655"
  $dlit &= "3697a65"
  Global $os = StringSplit($dlit, "4FD5$", 1)
EndFunc

Func hex_decode($flqlnxgxbp)
  Local $flqlnxgxbp_
  For $flrctqryub = 1 To StringLen($flqlnxgxbp) Step 2
    $flqlnxgxbp_ &= Chr(Dec(StringMid($flqlnxgxbp, $flrctqryub, 2)))
  Next
  Return $flqlnxgxbp_
EndFunc
