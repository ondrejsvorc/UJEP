# Generalizace = zobecnění tříd (rodič, nadtyp, typ, podtyp) -

# Zamestnanec je generalizace/typ (programátor a uklízečka jsou jeho potomci/podtypy)
# Abstraktní metoda = závazek pro potomky (potomek je povinen tuto metodu implementovat)
# Jakmile dám něco @abstractclass, tak už nepůjde vytvořit instanci abstraktní třídy
# Interface (z OOP) = Protokol (z funkcionálního programování) - de facto abstraktní třída pouze s abstraktními metodami, nemá data
# Vícenásobná dědičnost je v Pythonu povolena (smrtící diamant smrti - python) - nedoporučováno
# metody Python vnímá jako proměnné, aby šli uložit třeba do seznamu (proto neexistuje přetěžování metod)

# SOLID
# Dependency inversion, Liskovský substituční princip (rodiče můžeme nahradit potomkem, protože potomek umí vše, co rodič + něco dalšího)
# Database db = new PostgreSQL()

# https://refactoring.guru/design-patterns


from abc import ABC, abstractmethod


class Employee(ABC):
    def __init__(self, name, surname, email):
        self.name = name
        self.surname = surname
        self.email = email

    def greet(self):
        return "cau"

    @abstractmethod
    def work(self):
        raise NotImplemented("Abstract method")


class Programmer(Employee):
    def __init__(self, name, surname, email, programming_language):
        super().__init__(name, surname, email)
        self.programming_language = programming_language

    def work(self):
        return f"Programuju v jazyce {self.programming_language}"


class Cleaner(Employee):
    def __init__(self, name, surname, email, favourite_broom):
        super().__init__(name, surname, email)
        self.favourite_broom = favourite_broom

    def work(self):
        return f"Svym kostetem {self.favourite_broom} uklizim."


p1 = Programmer("Petr", "Novak", "novak@spsul.cz", "java")
p1.work()
u1 = Cleaner("Alena", "Novotna", "nov@email.cz", "Nimbus2000")
u1.work()
