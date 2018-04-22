"""Algebra module."""


class Monomial(object):
    """Monomial object."""

    def __init__(self, scalar=1, monomial=None, power=None):
        """Monomial object.

        Inputs:
            scalar
            monomial (str or list): list of monomial elements.
            power (optional, list): power of each element in monomial.
        """
        self._scalar = 1
        self._monomial = None
        self._power = None

        self.scalar = scalar
        self.monomial = monomial
        self.power = power

    @property
    def scalar(self):
        """Scalar value of monomial."""
        return self._scalar

    @scalar.setter
    def scalar(self, value):
        self._scalar = value

    @property
    def monomial(self):
        """Monomial elements, str or list."""
        return self._monomial

    @monomial.setter
    def monomial(self, value):
        if not value:
            self._monomial = list()
        elif isinstance(value, str):
            self._monomial = [value]
        elif isinstance(value, list):
            self._monomial = value
        else:
            serr = 'Monomial should be str or list, not {}.'.format(
                type(value))
            raise ValueError(serr)

        if not self.power or len(self.power) != len(value):
            self.power = None

    @property
    def power(self):
        """Power values for monomial elements, list."""
        return self._power

    @power.setter
    def power(self, value):
        if value:
            if len(value) != len(self.monomial):
                serr = 'Size of power is not equal to size of monomial.' \
                        + ' ({} != {})'.format(len(value), len(self.monomial))
                raise AttributeError(serr)
            self._power = value
        else:
            self._power = len(self.monomial) * [1]

    def __len__(self):
        """Return number of monomial elements."""
        return len(self.monomial)

    def __str__(self):
        """Return string representation of monomial."""
        ret = ''
        if self.scalar != 1:
            ret = '{}*'.format(str(self.scalar))

        for ind_m, ind_p in zip(self.monomial, self.power):
            if ind_p != 1:
                ret += '{}^({})*'.format(ind_m, ind_p)
            else:
                ret += '{}*'.format(ind_m)

        return ret[:-1]

    def __mul__(self, other):
        """Left multiplication for monomials and polynomials."""
        if isinstance(other, (int, float)):
            return Monomial(other * self.scalar, self.monomial, self.power)
        elif isinstance(other, Monomial):
            return Monomial(self.scalar * other.scalar,
                            self.monomial + other.monomial,
                            self.power + other.power)

    def __rmul__(self, other):
        """Right multiplication for monomials and polynomials."""
        if isinstance(other, (int, float)):
            return Monomial(other * self.scalar, self.monomial, self.power)
        elif isinstance(other, Monomial):
            return Monomial(self.scalar * other.scalar,
                            other.monomial + other.monomial,
                            other.power + self.power)


class Polynomial(object):
    """Polynomial object."""

    def __init__(self, monomials=None):
        """Polynomial object.

        Inputs:
            monomials (list of monomials)
        """
        self._monomials = None

        self.monomials = monomials

    @property
    def monomials(self):
        """Additive list of monomials."""
        return self._monomials

    @monomials.setter
    def monomials(self, value):
        if not value:
            self._monomials = []
        elif not isinstance(value, list):
            raise ValueError('Monomials should be list.')
        self._monomials = value

    def __len__(self):
        """Return number of monomials in polynomial."""
        return len(self.monomials)

    def __str__(self):
        """Return string representation of polynomial."""
        if self.monomials:
            return ' + '.join(map(str, self.monomials))
        return ''
