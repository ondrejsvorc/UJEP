<?php
declare(strict_types=1);
require_once __DIR__ . '/allowedTables.php';
header('Content-Type: application/xml; charset=UTF-8');

$table = strtolower($_GET['table'] ?? '');
if (!in_array($table, $allowedTables, true)) {
    echo '<?xml version="1.0" encoding="UTF-8"?><error>Invalid table</error>';
    exit;
}

function generateTableXml(string $table): string {
    $pdo = Database::getConnection();
    $sql = "SELECT * FROM $table";
    $stmt = $pdo->query($sql);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><records></records>');
    foreach ($rows as $row) {
        $record = $xml->addChild("record");
        foreach ($row as $key => $value) {
            // Cast the value to string and escape special characters.
            $record->addChild($key, htmlspecialchars((string)($value ?? "N/A")));
        }
    }

    return $xml->asXML();
}

echo generateTableXml($table);
