<?php
require_once __DIR__ . '/../app/services/MenuService.php';

header("Content-Type: application/xml");

$service = new MenuService();
$menuItems = $service->getAllMenuItems();

// TODO: Převést data na XML
echo "<menu></menu>";
