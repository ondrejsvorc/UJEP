<?php
include 'includes/functions.php';
include 'includes/constants.php';

$readingList = loadReadingList();

$dom = new DOMDocument('1.0', 'UTF-8');
$dom->formatOutput = true;
$root = $dom->createElement('readingList');

foreach ($readingList as $id => $status) {
  $book = $dom->createElement('book');
  $book->appendChild($dom->createElement('id', $id));
  $book->appendChild($dom->createElement('status', $status));
  $root->appendChild($book);
}

$dom->appendChild($root);

header('Content-Type: application/xml');
header('Content-Disposition: attachment; filename="' . XML_FILENAME . '"');
echo $dom->saveXML();
exit;
