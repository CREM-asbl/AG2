#tag Module
Protected Module Globals
	#tag Method, Flags = &h0
		Function amplitude(b as basicpoint, a as basicpoint, c as basicpoint) As double
		  //Amplitude de l'angle bac, toujours orienté dans le sens trigonométrique, comprise entre 0 et 2Pi
		  
		  dim alpha1 As double
		  dim bp as BasicPoint
		  
		  bp = c-a
		  bp= bp.normer
		  alpha1 = bp.anglepolaire
		  bp = b-a
		  bp= bp.normer
		  alpha1 = alpha1 - bp.anglepolaire
		  return gnormalize(alpha1)
		  
		  
		  // Orientation de [ab vers [ac
		  // Toujours entre 0 et 2 PI
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function black() As couleur
		  return new couleur(noir)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BleuPale() As couleur
		  return new couleur(cyan)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function blue() As couleur
		  return new couleur(bleu)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Getangle(p as BasicPoint, q as BasicPoint) As double
		  q = q-p
		  
		  return q.anglepolaire
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function gGetSpecialKey() As integer
		  Dim m as memoryBlock
		  Dim i As Integer
		  dim k as Integer
		  
		  if Keyboard.AsyncShiftKey then
		    k = k+1
		  end if
		  if Keyboard.AsyncOptionKey then 'alt-
		    k = k+2
		  end if
		  if Keyboard.AsyncControlKey then 'ctrl-
		    k = k+4
		  end if
		  return k
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function gNormalize(Angle as double) As double
		  dim t as double
		  t=Angle
		  while t>=2*PI
		    t=t-2*PI
		  wend
		  while t<0
		    t=t+2*PI
		  wend
		  return t
		  
		  //Le résultat est toujours entre 0 et 2pi
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Green() As couleur
		  return new couleur(vert)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function grey() As couleur
		  return new couleur(gris)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Hash(password as String) As String
		  dim  h, g as integer
		  dim i as integer
		  
		  for i=1 to LenB(password)
		    h=h*16+Asc(Mid(password,i))
		  next
		  if h=0 then
		    h=1
		  end if
		  return Str(h)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function magenta() As couleur
		  return new couleur(mag)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function negcolor() As couleur
		  return poscolor.comp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function poscolor() As couleur
		  return new couleur(pos)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function red() As couleur
		  return new couleur(rouge)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TMBI(n as integer, Byref w as double, Byref h as double, byref p as double)
		  select case n
		    
		  case 32
		    w = 0.25
		  case 33
		    w = 0.389
		    h = 0.669
		    p = 0.011
		  case 34
		    w = 0.555
		    h = 0.696
		  case 35
		    w = 0.5
		    h = 0.696
		  case 36
		    w = 0.5
		    h = 0.731
		    p = 0.099
		  case 37
		    w = 0.833
		    h = 0.696
		    p = 0.011
		  case 38
		    w = 0.778
		    h = 0.669
		    p = 0.017
		  case 39
		    w = 0.333
		    h = 0.696
		  case 40
		    w = 0.333
		    h = 0.696
		    p = 0.176
		  case 41
		    w = 0.333
		    h = 0.696
		    p = 0.176
		  case 42
		    w = 0.5
		    h = 0.696
		  case 43
		    w = 0.57
		    h = 0.503
		  case 44
		    w = 0.25
		    h = 0.134
		    p = 0.184
		  case 45
		    w = 0.333
		    h = 0.275
		  case 46
		    w = 0.25
		    h = 0.134
		    p = 0.011
		  case 47
		    w = 0.278
		    h = 0.696
		    p = 0.017
		  case 48
		    w = 0.5
		    h = 0.669
		    p = 0.011
		  case 49
		    w = 0.5
		    h = 0.669
		  case 50
		    w = 0.5
		    h = 0.669
		  case 51
		    w = 0.5
		    h = 0.669
		    p = 0.011
		  case 52
		    w = 0.5
		    h = 0.669
		  case 53
		    w = 0.5
		    h = 0.669
		    p = 0.011
		  case 54
		    w = 0.5
		    h = 0.669
		    p = 0.017
		  case 55
		    w = 0.5
		    h = 0.669
		  case 56
		    w = 0.5
		    h = 0.669
		    p = 0.011
		  case 57
		    w = 0.5
		    h = 0.669
		    p = 0.011
		  case 58
		    w = 0.333
		    h = 0.455
		    p = 0.011
		  case 59
		    w = 0.333
		    h = 0.455
		    p = 0.184
		  case 60
		    w = 0.57
		    h = 0.503
		    p = 0.011
		  case 61
		    w = 0.57
		    h = 0.407
		  case 62
		    w = 0.57
		    h = 0.503
		    p = 0.011
		  case 63
		    w = 0.5
		    h = 0.669
		    p = 0.011
		  case 64
		    w = 0.832
		    h = 0.696
		    p = 0.017
		  case 65
		    w = 0.667
		    h = 0.669
		  case 66
		    w = 0.667
		    h = 0.669
		  case 67
		    w = 0.667
		    h = 0.696
		    p = 0.017
		  case 68
		    w = 0.722
		    h = 0.669
		  case 69
		    w = 0.667
		    h = 0.669
		  case 70
		    w = 0.667
		    h = 0.669
		  case 71
		    w = 0.722
		    h = 0.696
		    p = 0.017
		  case 72
		    w = 0.778
		    h = 0.669
		  case 73
		    w = 0.389
		    h = 0.669
		  case 74
		    w = 0.5
		    h = 0.669
		    p = 0.099
		  case 75
		    w = 0.667
		    h = 0.669
		  case 76
		    w = 0.611
		    h = 0.669
		  case 77
		    w = 0.889
		    h = 0.669
		    p = 0.011
		  case 78
		    w = 0.722
		    h = 0.669
		    p = 0.017
		  case 79
		    w = 0.722
		    h = 0.696
		    p = 0.017
		  case 80
		    w = 0.611
		    h = 0.669
		  case 81
		    w = 0.722
		    h = 0.696
		    p = 0.208
		  case 82
		    w = 0.667
		    h = 0.669
		  case 83
		    w = 0.556
		    h = 0.696
		    p = 0.017
		  case 84
		    w = 0.611
		    h = 0.669
		  case 85
		    w = 0.722
		    h = 0.669
		    p = 0.017
		  case 86
		    w = 0.667
		    h = 0.669
		    p = 0.017
		  case 87
		    w = 0.889
		    h = 0.669
		    p = 0.017
		  case 88
		    w = 0.667
		    h = 0.669
		  case 89
		    w = 0.611
		    h = 0.669
		  case 90
		    w = 0.611
		    h = 0.669
		  case 91
		    w = 0.333
		    h = 0.669
		    p = 0.157
		  case 92
		    w = 0.278
		    h = 0.696
		    p = 0.017
		  case 93
		    w = 0.333
		    h = 0.669
		    p = 0.157
		  case 94
		    w = 0.57
		    h = 0.669
		  case 95
		    w = 0.5
		    p = 0.122
		  case 96
		    w = 0.333
		    h = 0.696
		  case 97
		    w = 0.5
		    h = 0.455
		    p = 0.011
		  case 98
		    w = 0.5
		    h = 0.696
		    p = 0.011
		  case 99
		    w = 0.444
		    h = 0.455
		    p = 0.011
		  case 100
		    w = 0.5
		    h = 0.696
		    p = 0.011
		  case 101
		    w = 0.444
		    h = 0.455
		    p = 0.011
		  case 102
		    w = 0.333
		    h = 0.696
		    p = 0.202
		  case 103
		    w = 0.5
		    h = 0.455
		    p = 0.202
		  case 104
		    w = 0.556
		    h = 0.696
		    p = 0.011
		  case 105
		    w = 0.278
		    h = 0.669
		    p = 0.011
		  case 106
		    w = 0.278
		    h = 0.669
		    p = 0.207
		  case 107
		    w = 0.5
		    h = 0.696
		    p = 0.011
		  case 108
		    w = 0.278
		    h = 0.696
		    p = 0.011
		  case 109
		    w = 0.778
		    h = 0.455
		    p = 0.011
		  case 110
		    w = 0.556
		    h = 0.455
		    p = 0.011
		  case 111
		    w = 0.5
		    h = 0.455
		    p = 0.011
		  case 112
		    w = 0.5
		    h = 0.455
		    p = 0.202
		  case 113
		    w = 0.5
		    h = 0.455
		    p = 0.202
		  case 114
		    w = 0.389
		    h = 0.455
		  case 115
		    w = 0.389
		    h = 0.455
		    p = 0.011
		  case 116
		    w = 0.278
		    h = 0.608
		    p = 0.011
		  case 117
		    w = 0.556
		    h = 0.455
		    p = 0.011
		  case 118
		    w = 0.444
		    h = 0.455
		    p = 0.011
		  case 119
		    w = 0.667
		    h = 0.455
		    p = 0.011
		  case 120
		    w = 0.5
		    h = 0.455
		    p = 0.011
		  case 121
		    w = 0.444
		    h = 0.455
		    p = 0.202
		  case 122
		    w = 0.389
		    h = 0.455
		    p = 0.078
		  case 123
		    w = 0.348
		    h = 0.696
		    p = 0.184
		  case 124
		    w = 0.22
		    h = 0.696
		    p = 0.017
		  case 125
		    w = 0.348
		    h = 0.696
		    p = 0.184
		  case 126
		    w = 0.57
		    h = 0.333
		  case  130
		    w = 0.332996
		    h =  0.134498
		    p =  0.182996
		  case 131
		    w =  0.5
		    h =  0.687995
		    p =  0.151996
		  case 132
		    w =  0.5
		    h =  0.134498
		    p =  0.182996
		  case 133
		    w =  1.0
		    h =  0.134498
		    p =  0.018494
		  case 134
		    w =  0.5
		    h =  0.687995
		    p =  0.151996
		  case 135
		    w =  0.5
		    h =  0.687995
		    p =  0.130994
		  case 136
		    w =  0.332996
		    h =  0.687995
		  case 137
		    w =  1.0
		    h =  0.687995
		    p =  0.018494
		  case 138
		    w =  0.555994
		    h =  0.8794985
		    p =  0.018494
		  case 139
		    w =  0.332996
		    h =  0.406995
		    p =  -0.024994
		  case 140
		    w =  0.9439945
		    h =  0.687995
		    p =  0.018494
		  case 147
		    w =  0.5
		    h =  0.687995
		    p =  -0.368994
		  case 148
		    w =  0.5
		    h =  0.687995
		    p =  -0.368994
		  case 149
		    w =  0.35
		    h =  0.507495
		    p =  -0.17199
		  case 150
		    w =  0.5
		    h =  0.282995
		    p =  -0.17199
		  case 151
		    w =  1.0
		    h =  0.282995
		    p =  -0.17199
		  case 152
		    w =  0.332996
		    h =  0.638995
		  case 153
		    w =  1.0
		    h =  0.687995
		    p =  -0.261499
		  case 154
		    w =  0.38899
		    h =  0.687995
		    p =  0.018494
		  case 155
		    w =  0.332996
		    h =  0.406995
		    p =  -0.024994
		  case 156
		    w =  0.721997
		    h =  0.4555
		    p =  0.018494
		  case 159
		    w =  0.610999
		    h =  0.8794985
		  case 161
		    w =  0.38899
		    h =  0.507495
		    p =  0.208997
		  case 162
		    w =  0.5
		    h =  0.584991
		    p =  0.130994
		  case 163
		    w =  0.5
		    h =  0.687995
		    p =  0.018494
		  case 164
		    w =  0.5
		    h =  0.584991
		    p =  -0.024994
		  case 165
		    w =  0.5
		    h =  0.687995
		  case 166
		    w =  0.2199955
		    h =  0.687995
		    p =  0.018494
		  case 167
		    w =  0.5
		    h =  0.687995
		    p =  0.130994
		  case 168
		    w =  0.332996
		    h =  0.638995
		  case 169
		    w =  0.746997
		    h =  0.687995
		    p =  0.018494
		  case 170
		    w =  0.265991
		    h =  0.687995
		    p =  -0.398499
		  case 171
		    w =  0.5
		    h =  0.406995
		    p =  -0.024994
		  case 172
		    w =  0.605994
		    h =  0.406995
		    p =  -0.107495
		  case 173
		    w =  0.332996
		    h =  0.282995
		  case 174
		    w =  0.746997
		    h =  0.687995
		    p =  0.018494
		  case 175
		    w =  0.332996
		    h =  0.638995
		  case 176
		    w =  0.4
		    h =  0.687995
		    p =  -0.398499
		  case 177
		    w =  0.569995
		    h =  0.507495
		  case 178
		    w =  0.3
		    h =  0.687995
		    p =  -0.261499
		  case 179
		    w =  0.3
		    h =  0.687995
		    p =  -0.261499
		  case 180
		    w =  0.332996
		    h =  0.687995
		  case 181
		    w =  0.575989
		    h =  0.4555
		    p =  0.208997
		  case 182
		    w =  0.5
		    h =  0.687995
		    p =  0.182996
		  case 183
		    w =  0.25
		    h =  0.406995
		    p =  -0.261499
		  case 184
		    w =  0.332996
		    h =  0.024493
		    p =  0.208997
		  case 185
		    w =  0.3
		    h =  0.687995
		    p =  -0.261499
		  case 186
		    w =  0.3
		    h =  0.687995
		    p =  -0.398499
		  case 187
		    w =  0.5
		    h =  0.406995
		    p =  -0.024994
		  case 188
		    w =  0.75
		    h =  0.687995
		    p =  0.018494
		  case 189
		    w =  0.75
		    h =  0.687995
		    p =  0.018494
		  case 190
		    w =  0.75
		    h =  0.687995
		    p =  0.018494
		  case 191
		    w =  0.5
		    h =  0.507495
		    p =  0.208997
		  case 192
		    w =  0.666992
		    h =  0.912494
		  case 193
		    w =  0.666992
		    h =  0.912494
		  case 194
		    w =  0.666992
		    h =  0.8794985
		  case 195
		    w =  0.666992
		    h =  0.8794985
		  case 196
		    w =  0.666992
		    h =  0.8794985
		  case 197
		    w =  0.666992
		    h =  0.912494
		  case 198
		    w =  0.9439945
		    h =  0.687995
		  case 199
		    w =  0.666992
		    h =  0.687995
		    p =  0.208997
		  case 200
		    w =  0.666992
		    h =  0.912494
		  case 201
		    w =  0.666992
		    h =  0.912494
		  case 202
		    w =  0.666992
		    h =  0.8794985
		  case 203
		    w =  0.666992
		    h =  0.8794985
		  case 204
		    w =  0.38899
		    h =  0.912494
		  case 205
		    w =  0.38899
		    h =  0.912494
		  case 206
		    w =  0.38899
		    h =  0.8794985
		  case 207
		    w =  0.38899
		    h =  0.8794985
		  case 208
		    w =  0.721997
		    h =  0.687995
		  case 209
		    w =  0.721997
		    h =  0.8794985
		    p =  0.018494
		  case 210
		    w =  0.721997
		    h =  0.912494
		    p =  0.018494
		  case 211
		    w =  0.721997
		    h =  0.912494
		    p =  0.018494
		  case 212
		    w =  0.721997
		    h =  0.8794985
		    p =  0.018494
		  case 213
		    w =  0.721997
		    h =  0.8794985
		    p =  0.018494
		  case 214
		    w =  0.721997
		    h =  0.8794985
		    p =  0.018494
		  case 215
		    w =  0.569995
		    h =  0.507495
		    p =  -0.024994
		  case 216
		    w =  0.721997
		    h =  0.746491
		    p =  0.130994
		  case 217
		    w =  0.721997
		    h =  0.912494
		    p =  0.018494
		  case 218
		    w =  0.721997
		    h =  0.912494
		    p =  0.018494
		  case 219
		    w =  0.721997
		    h =  0.8794985
		    p =  0.018494
		  case 220
		    w =  0.721997
		    h =  0.8794985
		    p =  0.018494
		  case 221
		    w =  0.610999
		    h =  0.912494
		  case 222
		    w =  0.610999
		    h =  0.687995
		  case 223
		    w =  0.5
		    h =  0.687995
		    p =  0.208997
		  case 224
		    w =  0.5
		    h =  0.687995
		    p =  0.018494
		  case 225
		    w =  0.5
		    h =  0.687995
		    p =  0.018494
		  case 226
		    w =  0.5
		    h =  0.687995
		    p =  0.018494
		  case 227
		    w =  0.5
		    h =  0.638995
		    p =  0.018494
		  case 228
		    w =  0.5
		    h =  0.638995
		    p =  0.018494
		  case 229
		    w =  0.5
		    h =  0.746491
		    p =  0.018494
		  case 230
		    w =  0.721997
		    h =  0.4555
		    p =  0.018494
		  case 231
		    w =  0.4439945
		    h =  0.4555
		    p =  0.208997
		  case 232
		    w =  0.4439945
		    h =  0.687995
		    p =  0.018494
		  case 233
		    w =  0.4439945
		    h =  0.687995
		    p =  0.018494
		  case 234
		    w =  0.4439945
		    h =  0.687995
		    p =  0.018494
		  case 235
		    w =  0.4439945
		    h =  0.638995
		    p =  0.018494
		  case 236
		    w =  0.27799
		    h =  0.687995
		    p =  0.018494
		  case 237
		    w =  0.27799
		    h =  0.687995
		    p =  0.018494
		  case 238
		    w =  0.27799
		    h =  0.687995
		    p =  0.018494
		  case 239
		    w =  0.27799
		    h =  0.638995
		    p =  0.018494
		  case 240
		    w =  0.5
		    h =  0.687995
		    p =  0.018494
		  case 241
		    w =  0.555994
		    h =  0.638995
		    p =  0.018494
		  case 242
		    w =  0.5
		    h =  0.687995
		    p =  0.018494
		  case 243
		    w =  0.5
		    h =  0.687995
		    p =  0.018494
		  case 244
		    w =  0.5
		    h =  0.687995
		    p =  0.018494
		  case 245
		    w =  0.5
		    h =  0.638995
		    p =  0.018494
		  case 246
		    w =  0.5
		    h =  0.638995
		    p =  0.018494
		  case 247
		    w =  0.569995
		    h =  0.547498
		    p =  0.018494
		  case 248
		    w =  0.5
		    h =  0.547498
		    p =  0.130994
		  case 249
		    w =  0.555994
		    h =  0.687995
		    p =  0.018494
		  case 250
		    w =  0.555994
		    h =  0.687995
		    p =  0.018494
		  case 251
		    w =  0.555994
		    h =  0.687995
		    p =  0.018494
		  case 252
		    w =  0.555994
		    h =  0.638995
		    p =  0.018494
		  case 253
		    w =  0.4439945
		    h =  0.687995
		    p =  0.208997
		  case 254
		    w =  0.5
		    h =  0.687995
		    p =  0.208997
		  case 255
		    w =  0.4439945
		    h =  0.638995
		    p =  0.208997
		  end select
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function white() As couleur
		  return new couleur(blanc)
		End Function
	#tag EndMethod


	#tag Note, Name = Licence
		
		Copyright © 2010 CREM
		Noël Guy - Pliez Geoffrey
		
		This file is part of Apprenti Géomètre 2.
		
		Apprenti Géomètre 2 is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		Apprenti Géomètre 2 is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		
		You should have received a copy of the GNU General Public License
		along with Apprenti Géomètre 2.  If not, see <http://www.gnu.org/licenses/>.
	#tag EndNote


	#tag Property, Flags = &h0
		can As CustomCanvas1
	#tag EndProperty

	#tag Property, Flags = &h0
		Config As Configuration
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentContent As windContent
	#tag EndProperty

	#tag Property, Flags = &h0
		dret As Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		Etiquette As Integer = 64
	#tag EndProperty

	#tag Property, Flags = &h0
		LabelDefault As LabelParams
	#tag EndProperty


	#tag Constant, Name = blanc, Type = Color, Dynamic = False, Default = \"&cFFFFFF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = bleu, Type = Color, Dynamic = False, Default = \"&c0000FF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cyan, Type = Color, Dynamic = False, Default = \"&c00FFFF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Epsilon, Type = Double, Dynamic = False, Default = \"1e-2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ERROR, Type = Double, Dynamic = False, Default = \"1e+308", Scope = Public
	#tag EndConstant

	#tag Constant, Name = gris, Type = Color, Dynamic = False, Default = \"&cEEEEEE\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = jaune, Type = Color, Dynamic = False, Default = \"&cFFFF00", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kMagnetDist, Type = Double, Dynamic = False, Default = \"15", Scope = Public
	#tag EndConstant

	#tag Constant, Name = mag, Type = Color, Dynamic = False, Default = \"&cFF00FF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = noir, Type = Color, Dynamic = False, Default = \"&c000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PI, Type = Double, Dynamic = False, Default = \"3.14159265358979323846264338327950", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PIDEMI, Type = Double, Dynamic = False, Default = \"1.57079632679499661923132169163975", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PointPriority, Type = Integer, Dynamic = False, Default = \"10000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = pos, Type = Color, Dynamic = False, Default = \"&c217FC7", Scope = Public
	#tag EndConstant

	#tag Constant, Name = rouge, Type = Color, Dynamic = False, Default = \"&cFF0000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = vert, Type = Color, Dynamic = False, Default = \"&c00FF00", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Etiquette"
			Visible=false
			Group="Behavior"
			InitialValue="64"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
