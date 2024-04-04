# Spojové datové struktury
# - uzly (nodes) = nesou data
# - odkaz (link) = propojuje uzly
# - skládají se tedy z úzlů, které jsou propojeny odkazy
# - nejjednodušší: jednosměrný spojový seznam (Singly Linked List) - existují lepší alternativy
# - https://www.itnetwork.cz/algoritmy/datove-struktury/spojovy-seznam
# - https://www.freecodecamp.org/news/how-linked-lists-work/

# Abstract Base Class
# - v Python světě zkratka ABC (nachází se v dokumentaci, např. zde https://docs.python.org/3/library/collections.abc.html)
# - abstraktní bázová třída
# - reprezentuje protokol (protokol je Python název pro interface - množina metod, která má splňovat nějaký objekt, aby mohl fungovat v nějakém kontextu)

# Iterable
# - má metodu __iter__ se správným kontraktem (vrací čerstvý iterátor)
# - stavy iterátoru: čerstvý (při prvním volání), použitelný, vyčerpaný (vrací pouze StopIteration)
# - lze dynamicky kontrolovat, zda objekt splňuje protokol
# - isinstance(object, class) -> vrátí zda je objekt instance dané třídy
# - použití mixinů: ne vždy je nutno definovat všechny metody (některé se dodají automaticky na základě těch definovaných)
# - zrcadlí se v podpoře statických typových anotací

# yield = opuštění lokálního kontextu funkce bez jeho destrukce (souvisí s coroutine)
# yield vrací iterovatelný objekt, jehož iterátor (__iter__) vrací hodnoty, které vrací ten yield

if __name__ == "__main__":
    pass
