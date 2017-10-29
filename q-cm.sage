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

Kl = Monomial(1, ['K'], [l])
X = Polynomial([Kl*F1])

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

def step2a(m1, m2):
    # Apply commutation relations:
    # Input: (K^l F_{i_1} ... F_{i_n}, E_j K_j^{-1})
    # Output: (scalar, K^l F_{i_1} ... F_{i_{n-1}}, E_j K_j^{-1}, F_{i_n} + rest)

    # Input: (m1, m2) |--> m1*m2
    # Output: (s, n1, n2, n3) |--> s*n1*n2*n3

    scalar = m1.scalar
    start = None if len(m1.monomial) == 1 else m1[:-1]
    com_elm = m1[-1]

    if m2.monomial[0] == 'E1' and m2.power[0] == 1 \
       and m2.monomial[1] == 'K2' and m2.power[1] == -1:

        if com_elm.monomial[0] == 'K':
            # K^l * E1 * K2^{-1} |--> q^l E_1 * K_2^{-1} K^l
            scalar *= q**(com_elm.power[0]) # check this
            return scalar, None, m2, com_elm

        if com_elm.monomial[0] == 'F2':
            # F2 * E1 * K2^{-1} |--> q^2 E1 * K2^{-1} * F2
            scalar *= q**(-2) # check this
            return scalar, start, m2, com_elm

        if com_elm.monomial[0] == 'F1':
            # E1 * F1 - F1 * E2 = (q - q^{-1}) * (K1 - K1^{-1})
            # F1 * E1 * K2^{-1} |--> (E1 * F1 * K2^{-1} - (q - q^{-1}) * (K1 - K1^{-1}) * K2^{-1})
            #   |--> (q * E1 * K2^{-1} * F1 - (q - q^{-1}) * (K1 - K1^{-1}) * K2^{-1})
            rest = q * F1 - ((q - q^(-1))) * (K1 - K1^(-1)) * K2^(-1)
            return scalar, start[:-1], com_elm, rest

    if m2.monomial[0] == 'E2' and m2.power[0] == 1 \
       and m2.monomial[1] == 'K1' and m2.power[1] == -1:

        if com_elm.monomial[0] == 'K':
            scalar *= q**(com_elm.power[0]) # check this
            return scalar, None, m2, com_elm

    return scalar, m1, m2, None

X = Kl * F2 * E1 * K2inv
print(X)
scalar, first, main, rest = step2a(Kl*F2, E1*K2inv)
print(scalar, first, main, rest)
scalar, first, main, rest = step2a(first, main)
print(scalar, first, main, rest)
print(step2a(Kl*F1, E1*K2inv))

def step2(P):
    ret = None

    for M in P:
        scalar = M.scalar
        monomial = M.monomial
        power = M.power

        newt = None
        if len(monomial) > 2:
            if monomial[-1] == 'K1' and power[-1] == -1 \
                and monomial[-2] == 'E2' and power[-2] == 1:
                # K^l F_{i_1} F_{i_2} ... F_{i_{n-1}} E_j K_j^{-1}
                # |-->
                # E_j K_j^{-1} K^l F_{i_1} F_{i_2} ... F_{i_{n-1}} + ...rest terms...

                continue
                # I dont know how to do it yet.

                main = M
                rest = None

                for i in range(len(monomial)-3, -1, -1):
                    print(monomial[i])
        else:
            newt = M

        if ret:
            ret += newt
        else:
            ret = newt

    return ret

#S1 = step1(X)
#print(S1)
#S2 = step2(S1)
#print(S2)
