# UML Diagram
# Activity Diagram
# Use Case Diagram

# Visual Paradime

# Class Diagram - jedna z reprezentací UML modelu
# abstraktní třída = kurzívou

# agregace
# kompozice = něco je součástí něčeho a samostatně většinou neexisutuje (motor a auto - motor bez auta neexistuje)
# asociace = trvalý stav, trvalý odkaz na nějaký objekt

# Výjimka
# - objekt nesoucí informaci o výjimečné situaci (jakákoliv instance třídy odvozená ze třídy BaseException)
#   - je to jediný objekt, který nese tuto informaci, lokální kontext totiž zanikne - musí ji mít v sobě proto, aby bylo jasné, jak výjimku ošetřit
# - chybové situace jsou podmnožinou výjimečných situací (ne naopak)
# - situace, která nenastává příliš často (malá frekvence výskytu)
# - vyhození zaměstnance - výjimečná situace, ale neřeší se výjimkou, že... - špatná analogie
# - výjimečná situace je situace, kterou nelze vyřešit v místě vzniku - vyhozením výjimky se vzdáváme odpovědnosti
# - řešení výjimečné situace je možné v jiné vrstvě programu (typicky I/O chyba -> řešení v prezenční GUI vrstvě)
# - výjimečné situace nebyly modelovány (90/10 = situace nastává v 10 % případů, ale zaujímá 90 % modelu nebo kódu - čili řešíme problém, který třeba ani nenastane, a to zabere hodně kódu)
# - např. neřešíme, že dojde zařízení paměť, protože to může nastat kdykoliv

# Mechanismus šíření výjimek
# - dlouhý skok:
#   - skok z vnitřku vnořených funkcí (rámců - aktuální volaná funkce) do nadřízených (do těch, které je volají)
#   - řeší uzavírání lokálních prostředí (uvolňuje prostředky apod. - zaniká prostřední, kde byla výjimečná situace, čili kde výjimka vzniká)
#   - výjimka se šíří "nahoru" - musí se neustále uklízet prostředí/kontexty, nimiž prochází

# 1. Detekce výjimečné situace (+ výjimečné situace řešené běhovým prostředním - automatické výjimky - dojde paměť apod.)
# 2. Vytvoření objektu výjimky (zavoláme její konstruktor) - třída výjimky (třída odvozená z Exception)
#    - složité hiearchie výjimek nejsou velmi dobré - komplikujeme tím část, kterou bychom neměli komplikovat
#    - message: pouze pro ladění (nejsou určeny nezasvěceným - tedy uživatelům)
#    - libovolné další atributy (číslo výjimky, druh výjimky, části kontextu) - většinou nevyužíváno)
#    - lokalizace výjimky:
#      - statické: číslo řádku
#      - dynamické: rámce volaných funkcí
# 3. Vyhození výjimky - raise
# 4. Šíření výjimky - statická část
# 5. Zachycení - throw blok
# 6. Obsloužení - ignorování (ať to řeší někdo nade mnou - nezachycení výjimky), soft ukončení aplikace, ...


class DataError(ValueError):
    pass


if __name__ == "__main__":
    try:
        ...
    except DataError as e:
        # Vyhoď obecnější výjimku a původní výjimka se připojí
        raise Exception("Internal error") from e
    except ValueError as e:
        ...
    except Exception as e:
        ...
        # Typicky ukončení programu
        # Uživatelsky rozumné ukončení

# Vždy lepší zachytávat konkrétnější výjimky (záleží na pořadí, nejobecnější se dávají na konec)
# Exception: béžné výjimky (běhové, např. TypeError, ValueError), instance třídy Exception a instance tříd z ní dědících
# BaseException: bázová třída všech výjimek (i třídy Exception)
# SyntaxError, KeyboardInterrupt = výjimky, které typicky nezachytáváme

# Exception - nejuniverzálnější, zachytávat pouze na nejvyšší úrovni programu (uživatelsky rozumné ukončení)
# ValueError -

# př.
# column se špatnou šířkou (každý řádek musí mít stejný počet?)
# class DataError(Exception) - ale netvořit složité hiearchie (neměli bychom tvořil alternativní strukturu chybného programu)

# finally - uvolnění prostředků
