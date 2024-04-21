import collections
import random

class SequenceRandomChoose:  # mixin (příměs)
    def random_choose(self):
        return self[random.randrange(len(self))]


class ListRandom(list, SequenceRandomChoose):
    pass


class TupleRandom(tuple, SequenceRandomChoose):
    pass

class MyContainer(collections.Container):



a = TupleRandom((4, 2, 1))
print(a.random_choose())

# realizace specializace

class ListRandom2(list):
    def random_choose(self):
        return self[random.randrange(len(self))]

# specializace
    # modelování specicializace podobjektů (dědí se málo, a hodně se přidává a předefinovává)
    # rozšíření funkčnosti (dědí hodně, něco málo přidáte resp. předefinujete)


