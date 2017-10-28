from que import Monomial, Polynomial

q = var('q')

E1 = Monomial(1, ['E1'])
E2 = Monomial(1, ['E2'])
F1 = Monomial(1, ['F1'])
F2 = Monomial(1, ['F2'])
K1 = Monomial(1, ['K1'])
K2 = Monomial(1, ['K2'])
K1inv = Monomial(1, ['K1inv'])
K2inv = Monomial(1, ['K2inv'])

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

Kl = Monomial(1, ['K'], l)
print(Kl)
X = Polynomial([Kl*F1])

print(X)

def step1(P):
    '''Replace the last Fi with Bid + ci * Ej*Kiinv.'''
    ret = None

    for M in P:
        scalar = M.scalar
        start = M.monomial[:-1]
        end = M.monomial[-1]

        newt = None
        if end == 'F1':
            # F1 = B1d + c1 * E2*K1inv
            newt = Monomial(scalar, start) * (B1d + c1 * E2*K1inv)
        elif end == 'F2':
            # F2 = B2d + c2 * E1*K2inv
            newt = Monomial(scalar, start) * (B2d + c2 * E1*K1inv)
        else:
            newt = P

        if ret:
            ret += newt
        else:
            ret = newt

    return ret

def step2(P):
    ret = None

    for M in P:
        scalar = M.scalar
        monomial = M.monomial

        newt = None
        if len(monomial) > 2:
            if monomial[-1] == 'K1inv' and monomial[-2] == 'E2':
                for i in range(len(monomial)-3, -1, -1):
                    if monomial[i] == 'K_{l}':
                        power = monomial[i].split('_')[1][1:-1]
                        print(power)
                        # K_{l} * E2*K1inv = q^{l} * E2*K1inv * K_{l}
                newt = M

            if monomial[-1] == 'K2inv' and monomial[-2] == 'E1':
                newt = M

            else:
                newt = M
        else:
            newt = M

        if ret:
            ret += newt
        else:
            ret = newt

    return ret
 
S1 = step1(X)
print(S1)
#S2 = step2(S1)
#print(S2)
