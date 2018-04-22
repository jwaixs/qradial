import pytest

from algebra import Monomial, Polynomial


def test_create_monomial():
    m1 = Monomial(1, 'A')
    m2 = Monomial(2, ['B'])
    m3 = Monomial(1, ['A', 'B'], [2, 3])

    assert isinstance(m1, Monomial)
    assert isinstance(m2, Monomial)
    assert isinstance(m3, Monomial)

    with pytest.raises(ValueError):
        m4 = Monomial(1, 1337)

    with pytest.raises(AttributeError):
        m5 = Monomial(1, ['A'], [2, 3])


def test_assign_monomial():
    m1 = Monomial()

    assert m1.scalar == 1
    assert m1.monomial == []
    assert m1.power == []

    m1.scalar = 2
    m1.monomial = ['A']
    m1.power = [1]

    assert m1.scalar == 2
    assert m1.monomial == ['A']
    assert m1.power == [1]


def test_str_monomial():
    m1 = Monomial()

    assert str(m1) == ''

    m1.scalar = 1
    m1.monomial = ['A']

    assert str(m1) == 'A'

    m1.scalar = 2
    m1.monomial = ['A', 'B']
    m1.power = [2, 3]

    assert str(m1) == '2*A^(2)*B^(3)'


def test_mult_scalar_monomial():
    s1 = 2
    m1 = Monomial()

    s1m1 = s1 * m1
    assert isinstance(s1m1, Monomial)
    assert str(s1m1) == '2'

    m1s1 = m1 * s1
    assert isinstance(m1s1, Monomial)
    assert str(m1s1) == '2'

    m2 = Monomial(2, 'A')
    s1m2 = s1 * m2
    assert isinstance(s1m2, Monomial)
    assert str(s1m2) == '4*A'

    m2s1 = m2 * s1
    assert isinstance(m1s1, Monomial)
    assert str(m2s1) == '4*A'


def test_mult_monomial():
    m1 = Monomial()
    m2 = Monomial()

    m1m2 = m1 * m2
    assert isinstance(m1m2, Monomial)
    assert str(m1m2) == ''

    m2m1 = m2 * m1
    assert isinstance(m2m1, Monomial)
    assert str(m2m1) == ''

    m3 = Monomial(2, 'A', [1])
    m4 = Monomial(3, 'B', [2])

    m3m4 = m3 * m4
    assert isinstance(m3m4, Monomial)
    assert str(m3m4) == '6*A*B^(2)'

    m4m3 = m4 * m3
    assert isinstance(m4m3, Monomial)
    assert str(m4m3) == '6*B^(2)*A'


def test_create_polynomial():
    m1 = Monomial(1, ['A'])
    m2 = Monomial(1, ['A', 'B'], [-2, 3])

    p1 = Polynomial([m1, m2])

    assert isinstance(p1, Polynomial)

    with pytest.raises(ValueError):
        p2 = Polynomial(1337)


def test_assign_polynomial():
    p1 = Polynomial()
    assert len(p1.monomials) == 1

    p1.monomials = [Monomial()]
    assert len(p1.monomials) == 1


def test_str_polynomial():
    p = Polynomial()

    assert str(p) == ''

    m1 = Monomial(1, ['A', 'B'], [2, 3])
    m2 = Monomial(2, ['C'])
    p.monomials = [m1, m2]

    assert str(p) == 'A^(2)*B^(3) + 2*C'


def test_mult_scalar_polynomial():
    p = Polynomial()
    s = 2

    sp = s * p
    assert isinstance(sp, Polynomial)

    ps = p * s
    assert isinstance(ps, Polynomial)

    m1 = Monomial(1, ['A'])
    m2 = Monomial(2, ['B'])
    p2 = Polynomial([m1, m2])
    sp2 = s * p2
    assert isinstance(sp2, Polynomial)
    assert str(sp2) == '2*A + 4*B'

    p2s = p2 * s
    assert isinstance(sp2, Polynomial)
    assert str(sp2) == '2*A + 4*B'


def test_mult_monomial_polynomial():
    p1 = Polynomial()
    m1 = Monomial()

    m1p1 = m1 * p1
    assert isinstance(m1p1, Polynomial)

    p1m1 = p1 * m1
    assert isinstance(p1m1, Polynomial)

    m1 = Monomial(1, ['A'])
    m2 = Monomial(2, ['B'])
    p2 = Polynomial([m1, m2])
    m3 = Monomial(3, ['C'])

    p2m3 = p2 * m3
    assert isinstance(p2m3, Polynomial)
    assert str(p2m3) == '3*A*C + 6*B*C'

    m3p2 = m3 * p2
    assert isinstance(m3p2, Polynomial)
    assert str(m3p2) == '3*C*A + 6*C*B'
