<?php
function start_page() {
  echo <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>BookTracker</title>
  <link rel="icon" href="/resources/favicon.ico">
  <link rel="stylesheet" href="/resources/styles.css">
</head>
<body>
HTML;
}

function end_page() {
  echo <<<HTML
</body>
</html>
HTML;
}