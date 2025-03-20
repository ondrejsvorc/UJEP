<?php
require_once __DIR__ . '/../app/services/ReservationService.php';

header("Content-Type: application/xml");

$service = new ReservationService();
$reservations = $service->getAllReservations();

// TODO: Převést data na XML
echo "<reservations></reservations>";
