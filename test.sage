load('./casimir.sage')

t1 = 1/(1 - d1/c1*q**(2*l)) * (A**l*B1d - d1/c1*q**l*B1c*A**l)
print(A**l*F1, compare(t1, bab_decomposition(Al, F1)))

t12 = (d2 + q**(2*l+4)/c2)/((1 - q**(4*l+2))*(q - q**(-1))) * A**(l-1) \
        - (d2 + q**(2*l+4)/c2)/((1 - q**(4*l+2))*(q - q**(-1))) * A**l
bab_f12 = apply_trivial_rep(bab_decomposition(Al, F1*F2)).simplify().simplify()
print(A**l*F1*F2, compare(t12, bab_f12))

f1212 = 1/((1 - q**2)**2) * (q**(2*l+5) + d2**2*q**2 + q**4 * d2/c2*q**(2*l+4))*(1 + q**(2*l+1)) / ((1 - q**(4*l+2))*(1 - q**(4*l)))
h1212 = 1/((1 - q**2)**2) * (q**4 + q**(2*l+3) + d2**2 + d2/c2*q**(2*l+4)) / ((1 - q**(4*l))*(1 - q**(4*l-2)))
g1212 = -(f1212 + h1212)
t1212 = f1212*A**l + g1212*A**(l-1) + h1212*(A**(l-2))
bab_f1212 = apply_trivial_rep(bab_decomposition(Al, F1*F2*F1*F2)).simplify().simplify()
print(A**l*F1*F2*F1*F2, compare(t1212, bab_f1212))
