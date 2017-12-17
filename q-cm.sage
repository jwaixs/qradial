from que import Monomial, Polynomial

print('=== Start q-cm.sage ===')

q = var('q')

E1 = Monomial(1, ['E1'])
E2 = Monomial(1, ['E2'])
F1 = Monomial(1, ['F1'])
F2 = Monomial(1, ['F2'])
K1 = Monomial(1, ['K1'])
K2 = Monomial(1, ['K2'])
K1inv = Monomial(1, ['K1'], [-1])
K2inv = Monomial(1, ['K2'], [-1])

c1, c2, d1, d2 = var('c1 c2 d1 d2')

l = var('l')

# B1c = F1 - c1 * E2*K1inv
# B2c = F2 - c2 * E1*K2inv
# B1d = F1 - d1 * E2*K1inv
# B2d = F2 - d2 * E1*K2inv

# right coideal generators
K = Monomial(1, ['K'])
B1c = Monomial(1, ['B1c'])
B2c = Monomial(1, ['B2c'])
B1d = Monomial(1, ['B1d'])
B2d = Monomial(1, ['B2d'])

A = Monomial(1, ['A'])

Al = Monomial(1, ['A'], [l])

def step1(P):
    '''Replace the last Fi with Bid + ci * Ej*Kiinv.'''
    ret = None

    for M in P:
        scalar = M.scalar
        power = M.power
        start = M.monomial[:-1]
        end = M.monomial[-1]

        newt = None
        if end == 'F1':
            # F1 = B1d + c1 * E2*K1inv
            newt = Monomial(scalar, start, power[:-1]) * (B1d + c1 * E2*K1inv)
        elif end == 'F2':
            # F2 = B2d + c2 * E1*K2inv
            newt = Monomial(scalar, start, power[:-1]) * (B2d + c2 * E1*K1inv)
        else:
            newt = P

        if ret:
            ret += newt
        else:
            ret = newt

    return ret

test1 = Polynomial([Al*F1])
print('Test 1: {}'.format(str(test1)))
t1s1 = step1(test1)
print('Step 1: {}'.format(str(t1s1)))

print('')

test2 = Polynomial([Al*F1*F2])
print('Test 2: {}'.format(str(test2)))
t2s1 = step1(test2)
print('Step 1: {}'.format(str(t2s1)))

def step2a(FI, Ek):
    if len(FI.monomial) == 0:
        return Ek

    F_last = FI[-1]
    F_rest = FI[:-1]

    if Ek.monomial[0] == 'E1':
        Eind = 1
    else:
        Eind = 2

    if F_last.monomial[0] == 'F1':
        Find = 1
    else:
        Find = 2

    if Find == 1 and Eind == 1:
        r = step2a(F_rest, Ek)
        main = q * step2a(F_rest, Ek) * F1
        if len(F_rest.monomial) > 0:
            rest = 1 / (q - q**(-1)) * F_rest * A**(-1) \
                - 1 / (q - q**(-1)) * F_rest *  K
        else:
            rest = 1 / (q - q**(-1)) * A**(-1) - 1 / (q - q**(-1)) * K
        return main + rest
    elif Find == 1 and Eind == 2:
        return q**(-2) * step2a(F_rest, Ek) * F1
    elif Find == 2 and Eind == 1:
        return q**(-2) * step2a(F_rest, Ek) * F2
    elif Find == 2 and Eind == 2:
        main = q * step2a(F_rest, Ek) * F2
        if len(F_rest.monomial) > 0:
            rest = 1 / (q - q**(-1)) * F_rest * (A**(-1) - K**(-1))
        else:
            rest = 1 / (q - q**(-1)) * (A**(-1) - K**(-1))
        return main + rest

#print(step2a(F1, E1*K2inv))
print(step2a(F1*F2*F1*F2, E1*K2inv))

def step2b(torus, Ek):
    power = torus.power[0]
    return q**power * Ek * torus

print(step2b(Al, E1*K2inv))

def step3(P):
    pass

    

def step2(P):
    ret = None

    for M in P:
        scalar = M.scalar
        power = M.power

        start = 0
        end = 0

        found_start = False
        found_end = False

        for i in range(len(M.monomial)):
            if M.monomial[i] == 'K':
                start = i
                found_start = True
                break

        for j in range(len(M.monomial)-1, start, -1):
            if M.monomial[j] == 'E1' or M.monomial[j] == 'E2':
                end = j+2
                found_end = True
                break

        if found_start and found_end:
            if ret == None:
                ret = scalar * M[start:end]
            else:
                ret += scalar * M[start:end]
        else:
            if ret == None:
                ret = scalar * M
            else:
                ret += scalar * M

    return ret

#t1s2 = step2(t1s1)
#print('Step 2: {}'.format(str(t1s2)))
#
#t2s2 = step2(t2s1)
#print('Step 2: {}'.format(str(t2s2)))
