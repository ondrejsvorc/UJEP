<?php
declare(strict_types=1);

require_once __DIR__ . '/../app/Database.php';
require_once __DIR__ . '/allowedTables.php';

header('Content-Type: text/plain; charset=UTF-8');

function saveTableXml(string $tableName): void {
    $xmlFolder = __DIR__ . '/xml';
    if (!is_dir($xmlFolder)) {
        mkdir($xmlFolder, 0777, true);
    }

    $filename = $xmlFolder . '/' . str_replace('.', '_', $tableName) . '.xml';

    $pdo = Database::getConnection();
    $sql = "SELECT * FROM $tableName";
    $stmt = $pdo->query($sql);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><records></records>');
    foreach ($rows as $row) {
        $record = $xml->addChild("record");
        foreach ($row as $key => $value) {
            $record->addChild($key, htmlspecialchars((string)($value ?? "N/A")));
        }
    }

    $dom = new DOMDocument('1.0', 'UTF-8');
    $dom->preserveWhiteSpace = false;
    $dom->formatOutput = true;
    $dom->loadXML($xml->asXML());

    file_put_contents($filename, $dom->saveXML());
}

function saveAllTablesXml(array $allowedTables): void {
    foreach ($allowedTables as $tableName) {
        saveTableXml($tableName);
    }
}

saveAllTablesXml($allowedTables);
echo "XML files have been saved for all allowed tables.";