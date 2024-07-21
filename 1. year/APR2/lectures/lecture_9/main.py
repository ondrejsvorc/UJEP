from abc import ABC, abstractmethod
from enum import Enum

# Abstraktní třída
# - nabízí společnou nadtřídu pro polymorfismus
# - může poskytovat i vlastní metody a vlastní atributy
# - nemá vlastní instance (všechno jsou instance odvozených tříd, které jsou automaticky i instance nadtřídy)

# Abstraktní metoda
# - metodu označíme jako abstraktní tehdy, je-li třída příliš obecná na to, aby byla implementovaná
# - může být pouze v abstraktní třídě
# - musí být implementována v odvozených třídách

# V Pythonu lze vytvořit instanci abstraktní třídy, ale je to špatně - tedy pokud nevoláme přes super().__init__
# Špatně je to ve smyslu displayer = Displayer() - pokud bude dědit z ABC, vyhodí to výjimku, pokud ne, projde to.


class Color(Enum):
    RED = "\033[91m"
    GREEN = "\033[92m"
    BLUE = "\033[94m"


class Displayer(ABC):
    def __init__(self, text: str):
        self._text = text

    @abstractmethod
    def display(self) -> None:
        raise NotImplemented("Abstract method.")


class StdIoDisplayer(Displayer):
    def __init__(self, text: str):
        super().__init__(text)

    def display(self) -> None:
        print(self._text)


class ColoredStdIoDisplayer(StdIoDisplayer):
    def __init__(self, text: str, color: Color):
        super().__init__(text)
        self._color = color

    def display(self) -> None:
        color_start = self._color.value
        color_end = "\033[00m"
        print(f"{color_start}{self._text}{color_end}")


if __name__ == "__main__":
    displayer = StdIoDisplayer("Hello world (no color)")
    displayer.display()

    colorDisplayer = ColoredStdIoDisplayer("Hello world (red)", Color.RED)
    colorDisplayer.display()

    colorDisplayer = ColoredStdIoDisplayer("Hello world (green)", Color.GREEN)
    colorDisplayer.display()

    colorDisplayer = ColoredStdIoDisplayer("Hello world (blue)", Color.BLUE)
    colorDisplayer.display()
