"""Algebra module."""


class Monomial(object):
    def __init__(self, scalar, monomial, power=None):
        self.scalar = scalar

        if type(monomial) == str:
            self.monomial = [monomial]
        elif type(monomial) == list:
            self.monomial = monomial
        else:
            serr = 'Monomial should be str or list, not {}.'.format(
                type(monomial))
            raise ValueError(serr)

        if power:
            if len(power) != len(monomial):
                serr = 'Size of power is not equal to size of monomial.' \
                        + ' ({} != {})'.format(len(power), len(monomial))
                raise AttributeError(serr)
            self.power = power
        else:
            self.power = len(monomial)*[1]


class Polynomial(object):
    def __init__(self, monomials):
        if type(monomials) != list:
            raise ValueError('Monomials should be list.')
        self.monomials = monomials
