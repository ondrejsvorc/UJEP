# O(log n) je efektivnější než O(n) při větším počtu dat
# https://github.com/pavelberanek91/UJEP/blob/main/APR2/3_sekvencni_vyhledavani.ipynb

from typing import List


def linear_search(sequence: List[int], target: int):
    for i in range(len(sequence)):
        if sequence[i] == target:
            return i


# Princip: Neustále řežeme sekvenci, než dojdeme ke kýženému prvku
# 1. Seřadím
# 2. Získám prvek uprostřed
# 3. Je prvek stejný jako prvek uprostřed?
# 4. Je prvek větší než prvek uprostřed: levou část mažu
# 5. Je prvek menší než prvek uprostřed: pravou část mažu
def binary_search(sequence: List[int], target: int) -> bool:
    sequence.sort()

    index_start = 0
    index_end = len(sequence) - 1

    while index_start <= index_end:
        index_middle = (index_start + index_end) // 2
        item_middle = sequence[index_middle]

        if item_middle == target:
            return True
        elif item_middle > target:
            index_end = index_middle - 1
        elif item_middle < target:
            index_start = index_middle + 1

    return False


def main():
    # [0][1][2][3][4][5][6][7][8][9][10]
    # [1, 1, 2, 3, 3, 4, 4, 5, 7, 8, 9]
    print(binary_search(sequence=[1, 4, 3, 2, 9, 1, 8, 7, 4, 3, 5], target=3))


if __name__ == "__main__":
    main()
