# Zápočet:
# - společná příprava
# - samostatná práce (cca 1 hodina doplnění nějaké funkcionality)

# Zkouška:
# - teoretická diskuze nad samostatnou prací

# Absolutní chyba = vyjádřena přesně
# Relativní chyba = vyjádřena v procentech (bude jiná pro číslo 1 000 a jiná pro číslo 1 000 000)

from random import choice, random, shuffle
from math import isclose


def sum_cumulative(items: list) -> None:
    cumulative_sum = items[0]
    for i in range(1, len(items)):
        cumulative_sum += items[i]
        items[i] = cumulative_sum


def random_choice(items: list, probabilities: list):
    assert len(items) == len(probabilities)

    probabilities_sum = sum(probabilities)
    for i in range(len(probabilities)):
        probabilities[i] /= probabilities_sum
    assert isclose(sum(probabilities), 1.0)

    sum_cumulative(probabilities)
    probabilities[-1] = 1.0  # zcela bezpečná horní mez

    # Náhodné číslo s rovnoměrným rozdělením (=každé číslo může padnout se stejnou pravděpodobností)
    random_number = random()
    for i in range(len(probabilities)):
        # Leží to v rozsahu probabilities[i - 1] a probabilities[i]
        if random_number <= i:
            return items[i]

    return choice(items)


def shuffle_extended(items: list, fixed_indexes: list) -> list:
    fixed_list = []
    move_list = []
    result_list = []

    for i in range(len(items)):
        if i in fixed_indexes:
            fixed_list.append(items[i])
        else:
            move_list.append(items[i])

    shuffle(move_list)

    # Nejlepší by bylo napsat nový shuffle, nepoužívat ten vestavěný, který by zohledňoval fixní indexy
    for i in range(len(items)):
        # FIXME: pomalé vyhledávání v seznamu O(n) - všechny musím prohledat (projeví se jen, když bude hodně fixních indexů)
        if i in fixed_indexes:
            # FIXME: pomalé pop O(n) - všechny předchozí prvky se musí posunout (projeví se jen, když bude hodně items)
            result_list.append(fixed_list.pop(0))
        else:
            result_list.append(move_list.pop(0))

    return result_list


# Je tento soubor spuštěn jako hlavní program/modul? (=není spouštěn importem)
# Vykonej kód níže:
if __name__ == "__main__":

    # Frodo má pravděpodobnost výběru 50 %, Gandalf 30 % a Bilbo 20%
    people = ["Frodo", "Gandalf", "Bilbo"]
    print(random_choice(people, [0.5, 0.3, 0.2]))

    # Číslo 5 a číslo 6 bude mít pravděpodobnost výběru 20 %, že padnou
    # Zbývá 60 %, a to rozdělím mezi 4 zbývající čísla, aby jejich pravděpodobnost byla totožná.
    numbers = list(range(1, 7))
    # print(random_choice(numbers, [0.6 / 4, 0.6 / 4, 0.6 / 4, 0.6 / 4, 0.2, 0.2]))
    print(random_choice(numbers, [100, 100, 103, 105, 120, 126]))

    print(shuffle_extended(list(range(10)), [0, 1]))

# Frodo Gandalf Bilbo
# 0.5   0.3     0.2     probabilities
# 0.5   0.8     1.0     kumulativní suma (0.8 = 0.5 + 0.3), (1.0 = 0.8 + 0.2)
