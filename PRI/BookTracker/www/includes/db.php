<?php

$db = new mysqli("database", "admin", "pwd", "BookTracker");
if ($db->connect_errno) {
    die("Database connection failed: " . $db->connect_error);
}