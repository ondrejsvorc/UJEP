from random_choice import random_choice

tset = []
for _ in range(1_000):
    tset.append(random_choice(list(range(1, 7)), [100, 101, 103, 105, 120, 126]))
print(tset)
