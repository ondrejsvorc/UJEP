# Funkce
# - nevytváříme je jen tehdy, když kód uvnitř ní voláme vícekrát, ale i když pouze jednou
# - děláme tak proto, že funkce má svůj vlastní lokální kontext (své vlastní proměnné, apod.)
# - jednodušší testování - Unit testing

# Kód bez funkcí
# - mezi různým kódem vzikají různé závislosti
# - kolize identifikátorů (názvů proměnných apod.)
# - obtížné ladění

# Organizace kódu
# - funkce = konec 50. let
# - modulární programování (shromáždění kódu v modulech / package) = polovina 60. let (70. léta)
# - modulární programování shromažďuje kód, ale nezohledňuje data
# - OOP (objektově orientované programování) - (1968, jazyk Simula), více se začal prosazovat v 80. letech

# Objekt
# - datová struktura (hodnota) v operační paměti
# - programová reprezentace reálné entity (ne nutně fyzicky reálné - čísla jsou reálná, seznamy taky, ale nemůžeme se jich dotknout, i přesto jsou reálná a existují)
# - každý objekt má identitu (můžeme říct, že se jedná o nějaký konkrétní objekt)
# - třeba rohlík nemá identitu - v programu obchodního řetězce bychom je nereprezentovali objektem, nejsou od sebe rozeznatelné (max. třeba počet rohlíků apod.)
# - každý objekt má lifetime - vzniká, zaniká
# - dva pohledy na objekt - jak funguje uvnitř nebo jak se chová (víme, že má nějaké metody, že o objektu můžeme získávat informace, a to nás zajímá)
# - má vnitřní stav

# Třída
# - množina objektů, které mají stejné chování (objekty se chovají stejně, tak můžeme říct, že spadají pod stejnou třídu) - to je ale pouze relativní
# - všechny objekty, které mají stejné rozhraní, kde rozhraním je množina metod, která mají stejná jména, stejné parametry, stejné podmínky použití a stejné chování
# - metoda - mění stav objektu nebo vytváří nový objekt (případně obojí naráz) - neměl by nic vypisovat třeba, ale vracet hodnotu k vypsání


# Reprezentace listu papíru, kde nás bude zajímat pouze váha a rozměr (má i další vlastnosti)
class Sheet:
    # Konstruktor (inicializátor)
    # Určuje počáteční stav objektu.
    # Nikdy nevytvářet konstruktorem objekty, které jsou neplatné (nevalidní, nepoužitelné)
    # Měly bychom zajistit, aby objekt vytvořený konstruktorem byl vždy platný.
    # Pokud něco vynucujeme, tak bychom to měly vynucovat (nenastavovat implicitní hodnotu).
    # Třeba kdyby prohodil programátor width a height parametry, mohu je v konstruktoru prohodit, ale to není dobré řešení - obecně.
    def __init__(self, width: int, height: int, weight: int):
        """
        Initializes new representation of paper sheet.
        :param width: in mm
        :param height: in mm (height >= width)
        :param weight: weight of 1m^2 of paper
        """

        assert isinstance(width, int), "Width must be an integer."
        assert isinstance(height, int), "Height must be an integer."
        assert isinstance(weight, int), "Weight must be an integer."

        assert width > 0, "Width must be bigger than 0."
        assert height > 0, "Height must be bigger than 0."
        assert weight > 0, "Weight must be bigger than 0."

        assert height >= width, "Height cannot be less than width!"

        self.width = width
        self.height = height
        self.weight = weight

    def half_sheet(self) -> "Sheet":
        """
        Folds the sheet in half according to height.
        :return: New folded sheet.
        """
        return Sheet(self.height // 2, self.width, self.weight)

    def sheet_weight(self) -> float:
        return self.weight * (self.height * (self.width / 1e6))

    # Metoda určená programátorovi (ladící výstup)
    # Výstup pro uživatele: __str__
    def __repr__(self):
        return f"height: {self.height}, width: {self.width}, weight per 1m^2: {self.weight}"

    @staticmethod
    # @staticmethod = dekorátor
    # Factory function / Tovární funkce - funkce, jejíž hlavní funkcí je vytvořit objekt
    # Častým použitím statických funkcí jsou funkce tovární
    def from_iso(format: str, weight: int) -> "Sheet":
        iso_formats = {
            "A4": (210, 297),
            "A3": (297, 420),
            "A5": (140, 210),
        }
        if format not in iso_formats:
            raise Exception("Unsupported ISO format.")
        return Sheet(iso_formats[format][0], iso_formats[format][1], weight)

    @staticmethod
    def square(size: int, weight: int) -> "Sheet":
        return Sheet(size, size, weight)


if __name__ == "__main__":
    sheet = Sheet(width=50, height=60, weight=80)
    sheet2 = Sheet.from_iso("A4", 80)

    # width i weight odkazují na stejný objekt typu int (80)
    # proto, když porovnávám čísla, tak jsou si rovna

    # print funguje tak, že se podívá, jestli daný objekt má __repr__ metodu, tu na objektu zavolá,
    # a pak vypíše hodnotu, kterou vrátí.
    print(sheet.half_sheet())
