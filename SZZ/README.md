## Státní závěrečná zkouška

Tento repozitář poskytuje informace pro základní orientaci a přípravu na státní závěrečné zkoušky (dále jen SZZ).

### Relevantní zdroje
- https://physics.ujep.cz/~jskvor/SZZ/BcAPI/
- https://github.com/matej-kaska/statnice-oop
- https://github.com/matej-kaska/statnice-frak
- https://github.com/matej-kaska/statnice-tk
- https://github.com/matej-kaska/statnice-rss
- https://github.com/matej-kaska/statnice-web

### Struktura SZZ
```mermaid
flowchart TB
    classDef main fill:#1f2937,stroke:#111827,color:#ffffff,stroke-width:2px;
    classDef section fill:#374151,stroke:#111827,color:#ffffff;
    classDef subject fill:#e5e7eb,stroke:#6b7280,color:#111827;

    SZZ["SZZ"]:::main

    Oral["Ústní zkouška"]:::section
    Thesis["Obhajoba Bc. práce"]:::section

    SZZ --> Oral
    SZZ --> Thesis

    TP["KI/SZZTP<br/>Teoretické základy informatiky"]:::subject
    PP["KI/SZZPP<br/>Aplikovaná informatika:<br/>povinný základ"]:::subject
    VP["KI/SZZVP<br/>Aplikovaná informatika:<br/>volitelné bloky"]:::subject

    Oral --> TP
    Oral --> PP
    Oral --> VP
```

#### KI/SZZTP Teoretické základy informatiky
```mermaid
flowchart TB
    classDef main fill:#1f2937,stroke:#111827,color:#ffffff,stroke-width:2px;
    classDef step fill:#e5e7eb,stroke:#6b7280,color:#111827;

    TP["KI/SZZTP<br/>Teoretické základy informatiky"]:::main

    Q1["12 otázek celkem"]:::step
    Q2["Vybereš 10 otázek<br/>(ty jdou do losování)"]:::step
    Q3["2 otázky vyřadíš<br/>(nebudou se losovat)"]:::step
    Q4["Vylosování otázky"]:::step
    Q5["15 minut příprava"]:::step
    Q6["15 minut zkoušení"]:::step

    TP --> Q1
    Q1 --> Q2
    Q2 --> Q3
    Q3 --> Q4
    Q4 --> Q5
    Q5 --> Q6
```

#### KI/SZZPP Aplikovaná informatika: povinný základ
```mermaid
flowchart TB
    classDef main fill:#1f2937,stroke:#111827,color:#ffffff,stroke-width:2px;
    classDef step fill:#e5e7eb,stroke:#6b7280,color:#111827;

    PP["KI/SZZPP<br/>Aplikovaná informatika:<br/>povinný základ"]:::main

    S1["16 okruhů celkem"]:::step
    S2["Z nich si sestavíš 12 okruhů<br/>(ty jdou do losování)"]:::step
    S3["Náhodné vylosování 1 okruhu"]:::step
    S4["60 minut příprava<br/>(bez internetu, včetně řešení úlohy)"]:::step
    S5["Začátek zkoušení:<br/>prezentace řešení"]:::step
    S6["Diskuse k řešení<br/>+ ověření znalostí"]:::step
    S7["Celkem cca 20 minut zkoušení"]:::step

    PP --> S1
    S1 --> S2
    S2 --> S3
    S3 --> S4
    S4 --> S5
    S5 --> S6
    S6 --> S7
```

#### KI/SZZVP Aplikovaná informatika: volitelné bloky
```mermaid
flowchart TB
    classDef main fill:#1f2937,stroke:#111827,color:#ffffff,stroke-width:2px;
    classDef step fill:#e5e7eb,stroke:#6b7280,color:#111827;

    VP["KI/SZZVP<br/>Aplikovaná informatika:<br/>volitelné bloky"]:::main

    S1["Okruhy dle absolvovaných bloků"]:::step
    S2["Z nich si sestavíš 8 okruhů<br/>(ty jdou do losování)"]:::step
    S3["Náhodné vylosování 1 okruhu"]:::step

    S4["Zadání úlohy<br/>(3–10 dní před zkouškou)"]:::step
    S5["Až 5 hodin řešení úlohy"]:::step
    S6["Povoleny materiály a zdroje<br/>Zakázána spolupráce s jinými osobami"]:::step

    S7["Zkoušení (až 20 minut)"]:::step
    S8["7–10 minut prezentace řešení"]:::step
    S9["Diskuse + ověření znalostí"]:::step

    VP --> S1
    S1 --> S2
    S2 --> S3

    S3 --> S4
    S4 --> S5
    S5 --> S6

    S6 --> S7
    S7 --> S8
    S8 --> S9
```
