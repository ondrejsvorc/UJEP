## Musí váha (Flyweight)

### Implementace Rich Text editoru

#### Edit
- kolekce odstavců
- každý odstavec se skládá ze znaků
  - znak:
    - glyf (kód znaku)
    - font
    - velikost
    - tučný
    - kurzíva
    - barva
    - je součástí hypertextového odkazu

Jak velký je každý znak?
4 byty + 4 byty + 4 byty (bitové příznaky) + ... = jeden znak 16 bytů + 8-20 bytů hlavička

Řešení:
- atributy znaků ukládat do odstavců (lze jít i dál, a ukládat něco i do celého dokumentu, co je platné pro vše)
- pomocný objekt => span (reprezentuje souvislou posloupnost znaků s jistým formátem)
- span:
  - počáteční pozice v odstavci
  - koncová pozice v odstavci
  - atributy týkající se formátu
- znak může být zcela eliminován, nahrazen pozicí v řetězci

Nepoužívat pole struktur ale struktury polí

NE
struct Particle {
  double x;
  double y;
  double m;
  string type;
}
particles[i].x

ANO
struct ParticleSystem {
  double[] x;
  double[] y;
  double[] m;
  string[] types;
}
particles.x[i]

Sběrnice k paměti je jen jedna, pokud musí CPU přistupovat k RAM, tak se může stát, že se při paralelním zpracování budou jádra o paměť prát

Do cache se nenačítají jednotlivé hodnoty, ale celé řádky (cca 64 bytů)
- horká a chladná data
- cache hit

## Fasáda (Facade)
- další úroveň zapouzdření
- cílem je zmenšení závislostí (závislosti rostou kvadraticky, u fasády pak už jen lineárně)

## Most (Bridge)
- A1, A2, A3 : IA (implementují high level interface)
- B1, B2, B3 : IB (implementují low level interface)
- A1, A2, A3 ... používají metody z rozhraní IB

A1 na venek poskytuje A1 metody, ale používá k tomu rozhraní B1 (interně)
A1 na venek poskytuje A2 metody, ale používá k tomu rozhraní B2 (interně)

lze ale i (A3)B1, ...

m * n = 9 tříd implementačních

Implementace bridge zařídí, aby existovalo pouze m + n tříd

Rectangle, Circle, Ellipse, Line, Polygon : IShape
GUI knihovna (low level interface): WPF, Winforms, Qt
Bridge snižuje závislost mezi tvary a GUI knihovnami

Každý objekt třídy implementující IShape má odkaz na IMultiPainter
IMultiPainter:
- kreslení primitiv: DrawPath

r = new Rectangle(canvas/window, ...) # canvas pak obsahuje odkaz na IMultiPainter
r.Draw()
IMultiPainter.DrawPath(...)