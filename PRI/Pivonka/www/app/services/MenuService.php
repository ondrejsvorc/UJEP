<?php
require_once __DIR__ . '/../Database.php';
require_once __DIR__ . '/../models/MenuItem.php';

class MenuService {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function getAllMenuItems(): array {
        // TODO: Načíst položky menu z databáze
        return [];
    }
}
