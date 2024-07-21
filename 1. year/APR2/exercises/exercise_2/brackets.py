# Aplikace zásobníku - Vyrovnané závorky
# Jedna z užitečných aplikací zásobníků vyplývá z teoretické informatiky,
# konkrétně z tématu zásobníkové automaty.
# To jsou automaty (matematické modely výpočetních strojů = počítačů),
# které mají primitivní paměť řešenou jako zásobník.
# Těmito automaty lze řešit úlohy typu převod do různých číselných soustav,
# vyhodnocování výrazů v infixové, prefixové a postfixové notaci a problémy vyrovnaného počtu.
# Typickém příkladem problémů vyrovnaného počtu je vyrovnaný počet otevíracích a uzavíracích závorek
# - důležité v parserech funkcionálních jazyků.

from stack_custom import Stack


class BracketValidator:
    _BRACKET_DICT = {
        ")": "(",
        "]": "[",
        "}": "{",
    }

    def __init__(self):
        self._stack = Stack()

    def validate(self, brackets: str) -> bool:
        if not brackets:
            return True

        values = self._BRACKET_DICT.values()
        for bracket in brackets:
            if bracket in values:
                self._stack.push(bracket)
            else:
                bracket_left_needed = self._BRACKET_DICT[bracket]
                bracket_left_actual = self._stack.pop()
                if bracket_left_needed != bracket_left_actual:
                    return False

        if self._stack.isEmpty():
            return True

        return False


if __name__ == "__main__":
    validator = BracketValidator()
    print(validator.validate("([{}])"))
    print(validator.validate("([({})[{}]])"))
    print(validator.validate("([)"))
    print(validator.validate("(])"))
    print(validator.validate("((])"))
