load('que.py')

q = var('q')
M1 = Monomial(1, ['M1'])
M2 = Monomial(1, ['M2'])

repr_dict = {
    'M1': matrix([[0, 1], [0, 0]]),
    'M2': matrix([[0, 0], [1, 0]])
}

print('')
print(M1.present(repr_dict))
print('')
print(M2.present(repr_dict))
print('')
print((M1*M2).present(repr_dict))
print('')
print((q*M1).present(repr_dict))
print('')
print((q*M1*M2).present(repr_dict))
print('')
print(((q*M1)**2*(M2)).present(repr_dict))
print('')
print((M1 + M2).present(repr_dict))
print('')
print((q*M1 + M2).present(repr_dict))
