# __init__: v Pythonu se nazývá initor (jinak konstruktor)
# self.name = atribut / datový člen
# cat = objekt / instance třídy
# metoda = funkce uvnitř třídy
# getter se také nazývá accessor (@property)
# setter se také nazývá mutator

# V Pythonu nelze omezit přístup k atributům (označit je jako private/protected), všechno je public
# Čili dle konvence si označím, že _nazev jsou private a __nazev protected
# _nazev = private
# __nazev = protected

# Ptám se na informaci, ale musím vyvolat chování
# dvojice getter a setter se nazývá property
# V Pythonu není polymorfismus (nemohou bý))

# Magické / Dunder metody
# např. přetěžování operátorů (a daleko více)

# 5 + 2
# var1 = int(5)
# var2 = int(2)
# var1.__add__(other=var2)

# @classmethod = statická metoda (můžeme přistupovat k atributům třídy - preferovanější)
# @staticmethod = statická metoda (neměly bychom přistupovat k atributům třídy)

from random import choice


class Cat:
    MAX_CAT_COUNT = 10

    @classmethod
    def cat_sound(cls):
        return "mew"

    @staticmethod
    def cat_sound2():
        return "mew"

    def __init__(self, name, age, owners):
        self._name = name
        self._age = age
        self._owners = owners

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, value):
        self._name = value

    @property
    def age(self):
        return self._age

    @property
    def owners(self):
        return self._owners

    def make_sound(self):
        print(f"{self.name}, mew mew!")

    # Přetěžování operátoru >= (ge = greater or equal)
    def __ge__(self, other):
        if not isinstance(other, Cat):
            raise Exception(f"Object {other} is not an instance of class Cat")
        return self._age >= other.age

    def __add__(self, other):
        if not isinstance(other, Cat):
            raise Exception(f"Object {other} is not an instance of class Cat")
        kitten = Cat(
            name=f"{self._name} {other.name}",
            age=1,
            owners=choice(self._owners + other.owners),
        )
        return kitten


def main():
    cat = Cat(name="Mica", age=5, owners=["Petr", "Milan"])
    cat2 = Cat(name="Bajun", age=3, owners=["Alex"])

    print(cat >= cat2)  # cat.__get__(other=bajun)

    cat_newborn = cat + cat2
    print(cat_newborn.name)
    print(cat_newborn.age)
    print(cat_newborn.owners)


main()
