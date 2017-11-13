a1 = var('a1')
a2 = var('a2')
q = var('q')
x = var('x')


def nu(x, p1, p2, Y, Z, X):
    '''Force the nu's with hard calculations.'''
    if p1 == 0 and p2 == 0 and Y == (1, 1) and Z == (2) and X == (1, 1, 2):
        return (1 - a1**2 * a2 * q**(6*x))**(-1)

    return 0

print(nu(x, 0, 0, (1, 1), 2, (1, 1, 2)))

import itertools

def range1(X):
    range_output = list()
    for i in range(1, len(X)):
        for Y in itertools.product((1, 2), repeat = len(X) - i):
            range_output += [Y]
    range_output += [()]
    return range_output

def range2(Y, T):
    range_output1 = list()
    for i in range(1, len(Y)):
        for W in itertools.product((1, 2), repeat = len(Y) - i):
            range_output1 += [W]
    range_output1 += [()]

    range_output2 = list()
    for j in range(0, len(T)):
        for Z in itertools.product((1, 2), repeat = len(T) - j):
            range_output2 += [Z]
    range_output2 += [()]

    range_output = list()
    for W in range_output1:
        for Z in range_output2:
            if W + Z == T:
                range_output += [(W, Z)]

    return range_output

def range3():
    return itertools.product((-2, -1, 0, 1, 2), repeat = 4)

def mu(x, s1, s2, T, X):
    # Force the basic mu's
    if s1 == 0 and s2 == 0 and T == (1, 1) and X == (1, 1):
        return (1 - a1*q**(2*x - 2))**(-1) * (1 - a1 * q**(2*x))**(-1)

    # Did not find basic mu, continue constructing complex mu
    ret = 0

    for Y in range1(X):
        for W, Z in range2(Y, T):
            for r1, p1, r2, p2 in range3():
                print(Y, W, Z, r1, p1, r2, p2)
                ret += nu(x, p1, p2, Y, Z, X) * mu(x, r1, r2, W, Y)

    return ret

print(mu(x, 0, 0, (1, 1), (1, 1, 2)))
