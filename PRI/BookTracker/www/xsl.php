<?php
include 'includes/constants.php';

header("Content-Type: application/xml");

$lines = file(XML_IMPORT_PATH, FILE_IGNORE_NEW_LINES);
if (!$lines) {
  http_response_code(500);
  exit("Failed to load XML.");
}

if (str_starts_with(trim($lines[0]), '<?xml')) {
  array_shift($lines);
}

$stylesheet = '<?xml-stylesheet type="text/xsl" href="' . XML_STYLES_PATH . '?v=' . time() . '"?>'; # No caching
echo '<?xml version="1.0" encoding="UTF-8"?>' . "\n" . $stylesheet . "\n" . implode("\n", $lines);