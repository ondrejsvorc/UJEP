<?php
include 'includes/functions.php';
include 'includes/constants.php';

if (
  $_SERVER['REQUEST_METHOD'] === 'POST' &&
  isset($_FILES['xml']) &&
  isset($_FILES['xml']['tmp_name']) &&
  is_uploaded_file($tmpPath = $_FILES['xml']['tmp_name'])
) {
  $isXML = mime_content_type($tmpPath) === 'text/xml' || pathinfo($_FILES['xml']['name'], PATHINFO_EXTENSION) === 'xml';

  if (!$isXML) {
    exit(header("Location: list.php?import=invalid"));
  }

  if (!validateReadingList($tmpPath)) {
    exit(header("Location: list.php?import=invalid_structure"));
  }

  if (!move_uploaded_file($tmpPath, XML_IMPORT_PATH)) {
    exit(header("Location: list.php?import=fail"));
  }

  exit(header("Location: list.php?import=success"));
}

exit(header("Location: list.php?import=no_file"));