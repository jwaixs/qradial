load('./q-cm.sage')

F3 = F1*F2 - q*F2*F1

# Quantum Iwasawa decomposition of the first Casimir K^(-1/2) Omega_1
Omega1t = q^(-2)/((q - q**(-1))**2) * A**(l+1) \
        + 1/((q - q**(-1))**2) * K**(-1) * A**(l) \
        + q^(2)/((q - q**(-1))**2) * A**(l-1) \
        + q**(2*l+3)/c2 * K**(-1) * A**(l+1) * F2 * F1 \
        - q**(l-1)/c2 * B2c * K**(-1) * A**(l+1) * F1 \
        + q**(2*l+1)/c1 * A**l * F1 * F2 \
        - q**(l+1)/c1 * B1c * A**l * F2 \
        - q**(2*l+1) / (c1*c2) * B1c * B2c * A**(l+1) * F3 \
        + q**(2*l+2) / (c1*c2) * B2c * B1c * A**(l+1) * F3 \
        + q**(4*l+3) / (c1*c2) * A**(l+1) * F3 * F3 \
        + q**(2*l+3) * (q - q**(-1)) * A**(l+1) * F1 * F2 * F3 \
        - q**(l+2) * (q - q**(-1)) * B1c * A**(l+1) * F1 * F3 \
        + c2 / (q - q**(-1)) * K * A**(l+1) * F3 \
        + (c1*q - c2) / (q - q**(-1)) * A**l * F3 \
        - c1*q / (q - q**(-1)) * K**(-1) * A**(l+1) * F3

def split_term_in_torus(term):
    try:
        torus_index = term.monomial.index('A')
    except:
        return term.scalar, term, [], [], []

    F_index = torus_index
    for i, m in enumerate(term.monomial[torus_index+1:]):
        if m[0] == 'F':
            F_index += 1
        else:
            break

    scalar = term.scalar

    if torus_index > 0:
        front_term = term[:torus_index]
    else:
        front_term = []

    torus = term[torus_index]

    if F_index > torus_index:
        F_term = term[torus_index+1:F_index+1]
    else:
        F_term = []

    if F_index + 1 < len(term.monomial):
        back_term = term[F_index+1:]
    else:
        back_term = []

    return scalar, front_term, torus, F_term, back_term

def bab_decomposition_polynomial(poly):
    ret = None

    for m in poly.monomials:
        scalar, front_term, torus, F_term, back_term = split_term_in_torus(m)
        if len(F_term) > 0:
            bab = bab_decomposition(torus, F_term)
            if len(front_term) > 0:
                bab = front_term * bab
            if len(back_term) > 0:
                bab = bab * back_term
            bab = scalar * bab
            if ret:
                ret += bab
            else:
                ret = bab
        else:
            if ret:
                ret += m
            else:
                ret = m

    return ret
