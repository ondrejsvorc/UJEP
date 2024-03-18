from helpers import get_as_int


class CharacterDate:
    def __init__(
        self,
        year: int,
        month: int = None,
        week: int = None,
        day: int = None,
    ):
        # TODO: Validate
        self._year = year
        self._month = month
        self._week = week
        self._day = day

    @staticmethod
    def from_repr(repr: str) -> "CharacterDate":
        date_parts = repr.split(".")
        # Rozvinutí seznamu do parametrů pomocí *
        return CharacterDate(*[get_as_int(date_parts, i) for i in range(4)])

    @staticmethod
    def do_intersect(
        interval1: tuple["CharacterDate", "CharacterDate"],
        interval2: tuple["CharacterDate", "CharacterDate"],
    ) -> bool:
        a1 = interval1[0].ordinal()
        a2 = interval1[1].ordinal()
        b1 = interval2[0].ordinal()
        b2 = interval2[1].ordinal()
        return a2 >= b1 and b2 >= a1

    def ordinal(self) -> int:
        assert (
            not self.is_precise()
        ), "Ordinal method can be used only for precise data."
        return self._year * (12 * 15) * self._month * 35 * 7 + self._day

    def as_interval(self) -> tuple["CharacterDate", "CharacterDate"]:
        pass

    def is_precise(self) -> bool:
        return self._day is not None

    def __repr__(self):
        if self._month is None:
            return f"{self._year}"
        elif self._week is None:
            return f"{self._year}.{self._month}"
        elif self._day is None:
            return f"{self._year}.{self._month}.{self._week}"
        else:
            return f"{self._year}.{self._month}.{self._week}.{self._day}"

    # Shorter, but less flexible for changes and less readable
    # def __repr__(self):
    #     date_parts = [
    #         str(part)
    #         for part in [self._year, self._month, self._week, self._day]
    #         if part is not None
    #     ]
    #     return ".".join(date_parts)


if __name__ == "__main__":
    date = CharacterDate(1572, 5, 3, 7)
    s = repr(date)
    test = CharacterDate.from_repr(s)
    print(test)

# Kardinální číslo = počet prvků množiny
# Ordinální číslo =
