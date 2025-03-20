<?php
declare(strict_types=1);

final class Position {
    // Id_Pozice, Id_PoziceNadrizeny, Nazev, Plat
    public function __construct(
        public ?int $id,
        public ?int $supervisorId,
        public string $name,
        public int $salary
    ) {}
}

final class PhonePrefix {
    // Id_Predcisli, Predcisli, Poradi
    public function __construct(
        public ?int $id,
        public string $prefix,
        public int $order
    ) {}
}

final class Employee {
    // Id_Zamestnanec, Id_Pozice, Jmeno, Prijmeni, Email, Id_Predcisli, TelefonniCislo, DatumNastupu
    public function __construct(
        public ?int $id,
        public ?int $positionId,
        public string $firstName,
        public string $lastName,
        public string $email,
        public int $phonePrefixId,
        public int $phoneNumber,
        public string $startDate
    ) {}
}

final class Customer {
    // Id_Zakaznik, Jmeno, Prijmeni, Email, Id_Predcisli, TelefonniCislo
    public function __construct(
        public ?int $id,
        public string $firstName,
        public string $lastName,
        public string $email,
        public int $phonePrefixId,
        public int $phoneNumber
    ) {}
}

final class Reservation {
    // Id_Rezervace, Id_Zakaznik, Id_Stul, Datum, CasOd, CasDo
    public function __construct(
        public ?int $id,
        public int $customerId,
        public int $tableId,
        public string $date,
        public string $timeFrom,
        public string $timeTo
    ) {}
}

final class Table {
    // Id_Stul, PocetMist
    public function __construct(
        public ?int $id,
        public int $seatCount
    ) {}
}

final class Menu {
    // Id_Menu, DatumPlatnosti
    public function __construct(
        public ?int $id,
        public string $validFromDate
    ) {}
}

final class MenuMenuItem {
    // Id_Menu, Id_PolozkaMenu
    public function __construct(
        public int $menuId,
        public int $menuItemId
    ) {}
}

final class MenuItem {
    // Id_PolozkaMenu, Nazev, Cena
    public function __construct(
        public ?int $id,
        public string $name,
        public float $price
    ) {}
}

final class Order {
    // Id_Objednavka, Id_Rezervace, Id_ZamestnanecCisnik, Id_ZamestnanecKuchar, Datum, CasPrijeti, CasVyrizeni
    public function __construct(
        public ?int $id,
        public int $reservationId,
        public int $waiterId,
        public int $chefId,
        public string $date,
        public string $timeReceived,
        public string $timeCompleted
    ) {}
}

final class OrderItem {
    // Id_Objednavka, Id_PolozkaMenu, Mnozstvi
    public function __construct(
        public int $orderId,
        public int $menuItemId,
        public int $quantity
    ) {}
}
