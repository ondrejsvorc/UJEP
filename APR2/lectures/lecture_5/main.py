from typing import Iterable


def nones_at_end(lst: Iterable):
    """
    Kontroluje, zda jsou všechny hodnoty None soustředěny v souvislém bloku
    na úplném konci iterovatelného objektu.

    :param lst: iterovatelný objekt k testování.
    :return: True, pokud jsou všechny None na konci, jinak False.
    """
    # Stavová proměnná označující, zda jsme už narazili na None
    found_none = False
    for item in lst:
        if item is None:
            found_none = True
        elif found_none:
            # Narazili jsme na hodnotu, která není None po prvním None
            return False
    return True


def get_as_int(s: list, i: int, default=None):
    return int(s[i]) if i < len(s) else default


class VDate:
    """
    Representace data ve venetském kalendáři (viz https://www.jf.cz/…89).
    """

    def __init__(self, year: int, month: int = None, week: int = None, day: int = None):
        self.year = year
        self.month = month
        self.week = week
        self.day = day
        assert (self.year is not None) and (nones_at_end(self.long_date))
        assert (self.day is None) or (1 <= self.day <= 7)
        assert (self.week is None) or (
            1 <= self.week <= (5 if self.month % 3 == 1 else 4)
        )
        assert (self.month is None) or (1 <= self.month <= 12)

    @property
    def long_date(self):
        return self.year, self.month, self.week, self.day

    @staticmethod
    def from_repr(rstr: str) -> "VDate":
        items = rstr.split(".")
        return VDate(*[get_as_int(items, i) for i in range(4)])

    def __str__(self):
        months = [
            "traven",
            "travenec",
            "lipenec",
            "červen",
            "červenec",
            "srpenec",
            "říjen",
            "říjenec",
            "studenec",
            "sečen",
            "sečenec",
            "březenec",
        ]
        weeks = ["černé", "bílý", "rudý", "zelený", "modrý"]
        days = ["pondělí", "úterý", "středa", "čtvrtek", "pátek", "sobota", "neděle"]
        if self.month is None:
            return f"{self.year}"
        elif self.week is None:
            return f"{self.year}.{months[self.month-1]}"
        elif self.day is None:
            return f"{self.year}.{months[self.month-1]}.{weeks[self.week-1]}"
        else:
            return f"{self.year}.{months[self.month-1]}.{weeks[self.week-1]}.{days[self.day-1]}"

    def __repr__(self):
        d = [str(n) for n in self.long_date if n is not None]
        return ".".join(d)

    def precise_from_date(self) -> "VDate":
        return VDate(self.year, self.month or 1, self.week or 1, self.day or 1)

    def precise_from_date(self) -> "VDate":
        month = self.month or 12
        return VDate(
            self.year,
            self.month or 12,
            self.week or (5 if month % 3 == 1 else 4),
            self.day or 7,
        )

    def is_precise(self) -> bool:
        return self.day is not None

    def __le__(self, other: "VDate"):
        return (
            self.precise_from_date().ordinalNumber()
            <= other.precise_to_date().ordinalNumber()
        )

    @staticmethod
    def is_intersection(interval1: "VDateInterval", interval2: "VDateInterval") -> bool:
        int1_min = interval1.from_date.precise_from_date().ordinalNumber()
        int1_max = interval1.from_date.precise_to_date().ordinalNumber()
        int2_min = interval2.from_date.precise_from_date().ordinalNumber()
        int2_max = interval2.from_date.precise_to_date().ordinalNumber()

        return int1_max >= int1_min and int2_max >= int1_min

    def ordinalNumber(self) -> int:
        return self.year * (12 * 35) + self.month * 35 + self.week * 7 + self.day

    def is_precise(self) -> bool:
        return self.day is not None


# Návrhový vzor Přepravka
# Zde si můžeme dovolit nezapouzdřovat?
class VDateInterval:
    def __init__(self, from_date: VDate, to_date: VDate) -> None:
        if to_date is None:
            to_date = from_date
        assert from_date <= to_date
        self.from_date = from_date
        self.to_date = to_date

    def __repr__(self):
        if self.from_date.long_date == self.to_date.long_date:
            return f"{repr(self.from_date)}"
        return f"{repr(self.from_date)}:{repr(self.to_date)}"


# povinně poziční (*)
# pozičně pojmenované
# pojmenované
class Circumstance:
    def __init__(
        self, duration: VDateInterval, description: str, *, location: str = None
    ):
        self.duration = duration
        self.description = description
        self.location = location

    @staticmethod
    def from_dict(json_dict: dict) -> "Circumstance":
        pass

    def to_dict(self) -> dict:
        return dict(
            duration=self.duration,
            description=self.description,
            location=self.location,
        )


class Character:
    def __init__(
        self,
        name: str,
        birthdate: VDate,
        *,
        nickname: str = None,
        deathdate: VDate = None,
    ):
        pass

    @staticmethod
    def from_dict(json_dict: dict) -> "Character":
        pass

    def to_dict(self) -> dict:
        pass

    def add_circumstance(self, circumstance: Circumstance):
        pass

    def __repr__(self):
        pass

    def get_concurrent_circumstances(
        self, date_from: VDate, date_to: VDate
    ) -> list[Circumstance]:
        pass


if __name__ == "__main__":
    d = VDate(1572, 10, 5, 1)
    s = repr(d)
    d2 = VDate.from_repr(s)
    print(repr(d2))
    print(d2)
