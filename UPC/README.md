## Úvod do programování v jazyce C

### Užitečné zdroje
- https://github.com/JanBurle/UJEP/tree/main/LS/KI-UPC

Kompilace C kódu do .exe
```bash
gcc main.c
```

Kompilace C kódu do .exe a jeho spuštění (PowerShell)
```bash
gcc main.c -o main.exe; if ($?) { .\main.exe }
```

Kompilace C kódu do .exe a jeho spuštění (CMD)
```bash
gcc main.c -o main.exe && main.exe
```