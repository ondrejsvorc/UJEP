<?php
require_once __DIR__ . '/../Database.php';
require_once __DIR__ . '/../models/Reservation.php';

class ReservationService {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function getAllReservations(): array {
        // TODO: Načíst rezervace z databáze
        return [];
    }

    public function createReservation(Reservation $reservation): bool {
        // TODO: Uložit rezervaci do databáze
        return false;
    }
}
