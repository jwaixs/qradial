"""Algebra module."""

# pylint: disable=attribute-defined-outside-init


class Monomial(object):
    """Monomial object."""

    def __init__(self, scalar=1, monomial=None, power=None):
        """Monomial object.

        Inputs:
            scalar
            monomial (str or list): list of monomial elements.
            power (optional, list): power of each element in monomial.
        """
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


class Polynomial(object):
    """Polynomial object."""

    def __init__(self, monomials=None):
        """Polynomial object.

        Inputs:
            monomials (list of monomials)
        """
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
