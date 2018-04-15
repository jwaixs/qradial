import pytest

from algebra import Monomial, Polynomial


def test_create_monomial():
    m1 = Monomial(1, 'A')
    m2 = Monomial(2, ['B'])
    m3 = Monomial(1, ['A', 'B'], [2, 3])

    assert type(m1) == Monomial
    assert type(m2) == Monomial
    assert type(m3) == Monomial

    with pytest.raises(ValueError):
        m4 = Monomial(1, 1337)

    with pytest.raises(AttributeError):
        m5 = Monomial(1, ['A'], [2, 3])


def test_create_polynomial():
    m1 = Monomial(1, ['A'])
    m2 = Monomial(1, ['A', 'B'], [-2, 3])

    p1 = Polynomial([m1, m2])

    assert type(p1) == Polynomial

    with pytest.raises(ValueError):
        p2 = Polynomial(1337)
