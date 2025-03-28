<?php
include 'constants.php';

function validateReadingList(string $xmlPath, string $xsdPath = XML_SCHEMA_PATH): bool {
  libxml_use_internal_errors(true);
  $dom = new DOMDocument;
  $dom->load($xmlPath);
  $isValid = $dom->schemaValidate($xsdPath);
  libxml_clear_errors();
  return $isValid;
}

function loadReadingList(string $path = XML_IMPORT_PATH): array {
  if (!file_exists($path)) {
    return [];
  }

  if (!validateReadingList($path)) {
    return [];
  }

  $xml = simplexml_load_file($path);
  $readingList = [];

  foreach ($xml->book as $book) {
    $id = (int) $book->id;
    $status = (string) $book->status;
    $readingList[$id] = $status;
  }

  return $readingList;
}