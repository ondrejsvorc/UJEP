<?php
require_once __DIR__ . '/../app/Database.php';
header("Content-Type: text/html; charset=UTF-8");
?>

<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurace Pivoňka</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Administrace Restaurace</h1>
    <p>Vyberte sekci:</p>
    <ul>
        <li><a href="reservations.php">Správa rezervací</a></li>
        <li><a href="menu.php">Správa jídelního lístku</a></li>
        <li><a href="employees.php">Správa zaměstnanců</a></li>
    </ul>
</body>
</html>
