<?php
function start_page() {
  echo <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>BookTracker</title>
  <link rel="icon" href="/resources/book.svg">
  <style>
    body {
      font-family: sans-serif;
      padding: 20px;
      max-width: 800px;
      margin: auto;
    }
    table {
      border-collapse: collapse;
      width: 100%;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 6px;
      text-align: left;
    }
    tbody tr:hover {
      background-color: #f5f5f5;
      cursor: pointer;
    }
    form {
      display: flex;
      width: 100%;
      flex-direction: column;
      gap: 10px;
    }
    input, select, button {
      padding: 6px;
      margin-bottom: 20px;
      width: max-content;
    }
    mark {
      padding: 2px;
      background-color: #FCD53F;
    }
    textarea {
      padding: 6px;
      margin-bottom: 20px;
      width: 100%;
      resize: vertical;
      font-family: sans-serif;
      font-size: 1em;
    }
    a {
      color: #0066cc;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
    .stars {
      display: inline-flex;
      font-size: 2em;
      cursor: pointer;
      user-select: none;
    }
    .star {
      position: relative;
      width: 1em;
      text-align: center;
    }
  </style>
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