load('./q-cm.sage')

repr_dict = {
    'K1': matrix([ [ q, 0, 0, 0, 0, 0, 0, 0 ], [ 0, q^-1, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, q^2, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 0, q^-2, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, q, 0 ], [ 0, 0, 0, 0, 0, 0, 0, q^-1 ] ]),
    'K2': matrix([ [ q, 0, 0, 0, 0, 0, 0, 0 ], [ 0, q^2, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, q^-1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 0, q, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, q^-2, 0 ], [ 0, 0, 0, 0, 0, 0, 0, q^-1 ] ]),
    'E1': matrix([ [ 0, 1, 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, q+q^-1, -q^2, 0, 0, 0 ], [ 0, 0, 0, 0, 0, -q^2, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0, -q ], [ 0, 0, 0, 0, 0, 0, 0, 0 ] ]),
    'E2': matrix([ [ 0, 0, 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, q^-1, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 0, q, 0 ],
      [ 0, 0, 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 0, 0, q^-1 ],
      [ 0, 0, 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 0, 0, 0 ] ]),
    'F1': matrix([ [ 0, 0, 0, 0, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, -q^-1-q^-3, 1, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 0, -q^-1, 0 ] ]),
    'F2': matrix([ [ 0, 0, 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 0, 0, 0 ],
      [ 1, 0, 0, 0, 0, 0, 0, 0 ], [ 0, q, 0, 0, 0, 0, 0, 0 ],
      [ 0, 1, 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 1, q^-1, 0, 0, 0 ], [ 0, 0, 0, 0, 0, q, 0, 0 ] ])
}

repr_dict['K'] = repr_dict['K1']*repr_dict['K2']**(-1)
repr_dict['A'] = repr_dict['K1']*repr_dict['K2']
repr_dict['B1c'] = repr_dict['F1'] - c1*repr_dict['E2']*repr_dict['K1']**(-1)
repr_dict['B2c'] = repr_dict['F2'] - c2*repr_dict['E1']*repr_dict['K2']**(-1)
repr_dict['B1d'] = repr_dict['F1'] - d1*repr_dict['E2']*repr_dict['K1']**(-1)
repr_dict['B2d'] = repr_dict['F2'] - d2*repr_dict['E1']*repr_dict['K2']**(-1)

TEST_START_LAMBDA = 3
TEST_END_LAMBDA = TEST_START_LAMBDA + 6

def compare(t1, t2):
    return (t1 - t2).is_zero()

@parallel
def test_exp(torus, exp):
    t1 = torus*exp
    t2 = bab_decomposition(torus, exp)
    truth = compare(t1.present(repr_dict), t2.present(repr_dict))
    print('{} {}'.format(str(torus*exp), truth))
    return (torus*exp, truth)

def test_bab_decomposition(exp):
    tests = [(A**i, exp) for i in range(TEST_START_LAMBDA, TEST_END_LAMBDA+1)]
    return(list(test_exp(tests)))

test_bab_decomposition(F1)
test_bab_decomposition(F2)
test_bab_decomposition(F1*F2)
test_bab_decomposition(F2*F1)
test_bab_decomposition(F1*F1)
test_bab_decomposition(F2*F2)
test_bab_decomposition(F1*F1*F1)
test_bab_decomposition(F1*F2*F1)
test_bab_decomposition(F1*F2*F2)
