class Monomial(object):
    def __init__(self, scalar, monomial):
        self.scalar = scalar
        self.monomial = monomial

    def __mul__(self, other):
        if type(other) in (int, float):
            return Monomial(other * self.scalar, self.monomial)
        elif type(other) == Monomial:
            return Monomial(self.scalar * other.scalar, self.monomial + other.monomial)
        elif type(other) == Polynomial:
            return Polynomial([self * m for m in other.monomials])
        else:
            raise TypeError('Cannot multiply this type.')

    def __rmul__(self, other):
        return Monomial(other * self.scalar, self.monomial)

    def __add__(self, other):
        return Polynomial([self, other])

    def __str__(self):
        if self.scalar == 1:
            return '*'.join(self.monomial)
        else:
            return '{}*{}'.format(self.scalar, '*'.join(self.monomial))

    def __repr__(self):
        return str(self)

    def apply_rule(self, before, scalar, after):
        new_monomial = []

        for i in range(len(self.monomial)-1):
            e1 = self.monomial[i]
            e2 = self.monomial[i+1]
            if e1 == before[0] and e2 == before[1]:
                new_monomial += after
                return True, Monomial(self.scalar * scalar, new_monomial + self.monomial[i+2:])
            else:
                new_monomial += [self.monomial[i]]

        return False, Monomial(self.scalar, self.monomial)

class Polynomial(object):
    def __init__(self, monomials):
        self.monomials = monomials

    def __iter__(self):
        for M in self.monomials:
            yield(M)

    def __add__(self, other):
        if type(other) == Monomial:
            return Polynomial(self.monomials + [other])
        if type(other) == Polynomial:
            return Polynomial(self.monomials + other.monomials)
        else:
            raise TypeError('Cannot add object this type.')

    def __mul__(self, other):
        if type(other) in (float, int):
            return Polynomial(map(lambda x : other*x, self.monomials))
        elif type(other) == Polynomial:
            return Polynomial([m*n for m in self.monomials for n in other.monomials])
        else:
            raise TypeError('Cannot multiply this type.')

    def __rmul__(self, other):
        if type(other) in (float, int):
            return Polynomial(map(lambda x : other*x, self.monomials))
        else:
            raise TypeError('Cannot multiply this type.')

    def __str__(self):
        if len(self.monomials) > 1:
            return ' + '.join(map(str, self.monomials))
        elif len(self.monomials) == 1:
            return str(self.monomials[0])
        else:
            return '0'

    def __repr__(self):
        return str(self)

    def simplify(self):
        new_monomials = list()
        for m in self.monomials:
            new_monomial = True
            for i, n in enumerate(new_monomials):
                if m.monomial == n.monomial:
                    new_monomials[i].scalar += m.scalar
                    new_monomial = False
                    continue
            if new_monomial:
                new_monomials.append(m)
        return Polynomial(new_monomials)

#m = Monomial(1, ['X1'])
#print(m)
#print(m.monomial)
#
#m1 = Monomial(2, ['X'])
#m2 = Monomial(3, ['Y'])
#print(m1)
#print(3*m1)
#print(m1 * m2)
#print(m1 + m2)
#
#p = m1 + m2 + m1 + 2*m2 + Monomial(5, ['Z'])
#print(p)
#print(p.simplify())
#print(p)
#print(2*p)
#
#print
#p1 = Polynomial([m1])
#p2 = Polynomial([m2])
#print(p1)
#print(p2)
#print(p1 + p2)
#print(m1 * (p1 + p2))
#print(p1 * p2)
#p3 = (p1 + p2 + m1 + m2) * (p1 + p2)
#print(p3)
#print(p3.simplify())
#
#print
#
#m = Monomial(1, ['Kl', 'X', 'X', 'X', 'X', 'Y'])
#
#b, nm = m.apply_rule(['X', 'Y'], 2, ['Y', 'X'])
#while b:
#    print(nm)
#    b, nm = nm.apply_rule(['X', 'Y'], 2, ['Y', 'X'])
#
#b, nm = nm.apply_rule(['Kl', 'Y'], 5, ['Y', 'Kl+1'])
#
#print(nm)
#
#print

E1 = Monomial(1, ['E1'])
E2 = Monomial(1, ['E2'])
F1 = Monomial(1, ['F1'])
F2 = Monomial(1, ['F2'])
K1 = Monomial(1, ['K1'])
K2 = Monomial(1, ['K2'])
