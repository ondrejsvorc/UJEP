https://github.com/JanBurle/UJEP/tree/main/KI-PRI  
https://github.com/pavelberanek91/UJEP/tree/main/PRI

https://validator.w3.org/

Spuštění docker kontejnerů.
```
docker compose up
```

Zobrazení kontejnerů.
```
docker ps
```

Administrace
```
docker exec -ti project-vps bash
```

Verze PHP
```
php -v
```

Informace o XDebug
```
php -i | grep xdebug
```

Zjištění cesty php.ini
```
php -i | grep php.ini
```

short_open_tag = On
```
php -i | grep short
```
Povolí zápis níže:
```
<?

?>
```
Nemusíme tedy potom psát:
```
<?php

?>
```

Ekvivalentní zápisy
```
<?php echo($x) ?>
<?= echo($x) ?>
```