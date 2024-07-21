from time import sleep
from math import inf

# http://www.myty.info/rservice.php?akce=tisk&cisloclanku=2008010002


class VystrojError(Exception):
    pass


class Vykoupeni(Exception):
    pass


class Buh:
    def __init__(self, jmeno: str, vystroj: list[str]):
        self.jmeno = jmeno
        self.vystroj = vystroj

    def odevzdej(self) -> str:
        try:
            return self.vystroj.pop()
        except:
            raise VystrojError("Nedostatek vystroje")

    def prijmi(self, vystroj_soucastka: str) -> None:
        self.vystroj.append(vystroj_soucastka)

    def __repr__(self):
        return f"{self.jmeno}: {self.vystroj}"


class Podsveti:
    # Děláme kopii, jinak by se bůh dostal z podsvětí tím, že by byl odstraněn z původního seznamu osazenstvo
    def __init__(self, osazenstvo: list[Buh]):
        self._osazenstvo = list(osazenstvo)

    # Rychlejší vstup do podsvětí
    def uvrzeni(self, obet: Buh, vykoupeny: Buh):
        assert obet not in self._osazenstvo
        assert vykoupeny in self._osazenstvo
        self._zatraceni(obet, vecne_cekani=False)
        self._osazenstvo.remove(vykoupeny)
        raise Vykoupeni(f"Vykoupení uvržením boha {obet}")

    def vstup(self, buh: Buh):
        # Bůh vždy odevzdá průvodci všechny své věci
        # Každý bůh má svého průvodce
        # Při odchodu z podsvětí dostane své věci
        pruvodce = Buh("Anonym", [])
        self._osazenstvo.append(pruvodce)
        self._brana(buh, pruvodce, 1)

    def _brana(self, buh: Buh, pruvodce: Buh, poradi_brany: int):
        try:
            pruvodce.prijmi(buh.odevzdej())
            if poradi_brany < 7:  # Počet bran
                self._brana(buh, pruvodce, poradi_brany + 1)
            else:
                self._zatraceni(buh)
        finally:
            buh.prijmi(pruvodce.odevzdej())

    def _zatraceni(self, buh: Buh, vecne_cekani: bool = True):
        while buh.vystroj:
            buh.odevzdej()
        self._osazenstvo.append(buh)
        if vecne_cekani:
            while True:
                try:
                    sleep(1)
                    self.uvrzeni(damuzi, buh)
                except Vykoupeni:
                    raise
                except:
                    pass


if __name__ == "__main__":
    ishtar = Buh(
        "Ištar",
        [
            "rouška cudnosti",
            "náramky",
            "pás",
            "ozdoby",
            "náhrdelník",
            "náušnice",
            "koruna",
        ],
    )
    eres = Buh("Ereškigal", [])
    damuzi = Buh("Damuzi", [])

    podsveti = Podsveti([eres])

    try:
        podsveti.vstup(ishtar)
    except Exception as e:
        print(f"výstup {e.__class__.__name__} {e}")
        print(ishtar)
