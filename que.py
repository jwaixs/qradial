class Monomial(object):
    def __init__(self, scalar, monomial, power=None):
        self.scalar = scalar
        self.monomial = monomial
        if power:
            self.power = power
        else:
            self.power = len(monomial)*[1]

    def __getitem__(self, index):
        if type(index) == slice:
            r = None
            if index.start and index.stop:
                r = range(index.start, index.stop)
            elif index.start:
                r = range(index.start, len(self.monomial))
            elif index.stop:
                if index.stop >= 0:
                    r = range(0, index.stop)
                else:
                    r = range(0, len(self.monomial) + index.stop)
            else:
                raise ValueError('No start or end given.')
            return Monomial(1, [self.monomial[i] for i in r], [self.power[i] for i in r])
        else:
            return Monomial(1, [self.monomial[index]], [self.power[index]])

    def __len__(self):
        return len(self.monomial)

    def __mul__(self, other):
        if type(other) in (int, float):
            return Monomial(other * self.scalar, self.monomial, self.power)
        elif type(other) == Monomial:
            return Monomial(self.scalar * other.scalar,
                            self.monomial + other.monomial,
                            self.power + other.power)
        elif type(other) == Polynomial:
            return Polynomial([self * m for m in other.monomials])
        else:
            raise TypeError('Cannot multiply this type.')

    def __rmul__(self, other):
        return Monomial(other * self.scalar, self.monomial, self.power)

    def __add__(self, other):
        return Polynomial([self, other])

    def __sub__(self, other):
        return Polynomial([self, -1 * other])

    def __pow__(self, power):
        return Monomial(self.scalar, self.monomial, [power * p for p in self.power])

    def __str__(self):
        ret = ""

        if self.scalar != 1:
            ret += str(self.scalar) + '*'

        for m, p in zip(self.monomial, self.power):
            if p != 1:
                ret += '{}^({})*'.format(m, p)
            else:
                ret += '{}*'.format(m)

        return ret[:-1]

    def __repr__(self):
        return str(self)

    def simplify(self):
        try:
            scalar = self.scalar.simplify()
        except AttributeError:
            scalar = self.scalar
        try:
            scalar = self.scalar.factor()
        except:
            scalar = self.scalar
        monomial = list()
        power = list()

        for m, p in zip(self.monomial, self.power):
            if len(monomial) > 0 and m == monomial[-1]:
                power[-1] += p
            else:
                monomial.append(m)
                power.append(p)

        return Monomial(scalar, monomial, power)

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
            raise TypeError('Cannot add object of this type {}.'.format(type(other)))

    def __sub__(self, other):
        if type(other) == Monomial:
            return Polynomial(self.monomials + [other])
        if type(other) == Polynomial:
            return Polynomial(self.monomials + other.monomials)
        else:
            raise TypeError('Cannot add object of this type {}.'.format(type(other)))

    def __mul__(self, other):
        if type(other) in (float, int):
            return Polynomial(map(lambda x : other*x, self.monomials))
        elif type(other) == Polynomial:
            ret = list()
            for m in self.monomials:
                for n in other.monomials:
                    if type(m) == Monomial and type(n) == Monomial:
                        ret.append(m*n)
                    elif type(m) == Monomial and type(n) == Polynomial:
                        ret.append(Polynomial([m]) * n)
                    elif type(m) == Polynomial and type(n) == Monomial:
                        ret.append(m * Polynomial([n]))
            return Polynomial(ret)
        elif type(other) == Monomial:
            return Polynomial([m*Polynomial([other]) for m in self.monomials])
        else:
            return Polynomial(map(lambda x : other*x, self.monomials))
            #raise TypeError('Cannot multiply this type. {} vs {}'.format(
            #    type(self), type(other)))

    def __rmul__(self, other):
        if type(other) in (float, int):
            return Polynomial(map(lambda x : other*x, self.monomials))
        else:
            try:
                return Polynomial(map(lambda x : other*x, self.monomials))
            except:
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
            m = m.simplify()

            if m.scalar == 0:
                continue

            new_monomial = True
            for i, n in enumerate(new_monomials):
                if m.monomial == n.monomial and m.power == n.power:
                    new_monomials[i].scalar += m.scalar
                    new_monomial = False
                    continue
            if new_monomial:
                new_monomials.append(m)
        return Polynomial(new_monomials)

    def flatten(self):
        new_monomials = list()
        for m in self.monomials:
            if type(m) == Monomial:
                new_monomials.append(m)
            elif type(m) == Polynomial:
                for n in m.flatten():
                    new_monomials.append(n)
            else:
                raise TypeError('Cannot flatten this polynomial.')

        self.monomials = new_monomials
        return self

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

X = E1**2*E2*E2
print(X)
print(X.simplify())

print(X[0], X[1], X[0:2])
