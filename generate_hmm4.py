with open('hmm3/hmmdefs') as file:
    hmmdefs = file.readlines()

sil = hmmdefs[-28:]

sp = list(sil)

sp[0] = '~h "sp"\n'
sp[2] = '<NUMSTATES> 3\n'

sp = sp[:3]

state3 = sil[9:15]
state3[0] = '<STATE> 2\n'

sp += state3

trans = ['<TRANSP> 3\n', ' 0.0 1.0 0.0\n', ' 0.0 0.9 0.1\n', ' 0.0 0.0 0.0\n', '<ENDHMM>\n']

sp += trans

hmmdefs += sp

with open('hmm4/hmmdefs', 'w') as file:
    file.writelines(hmmdefs)