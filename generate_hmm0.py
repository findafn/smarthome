with open('hmm0/proto') as file:
    proto = file.readlines()

with open('data/monophones0') as file:
    monophone = file.readlines()

with open('hmm0/vFloors') as file:
    vfloor = file.readlines()

monophone[-1] += '\n'

hmmdefs = []
for m in monophone:
    hmmdefs.append('~h "' + m[:-1] +'"\n')
    for p in proto[4:]:
        hmmdefs.append(p)

macros = []
for p in proto[:3]:
    macros.append(p)
for v in vfloor:
    macros.append(v)

with open('hmm0/hmmdefs', 'w') as file:
    file.writelines(hmmdefs)
with open('hmm0/macros', 'w') as file:
    file.writelines(macros)
    