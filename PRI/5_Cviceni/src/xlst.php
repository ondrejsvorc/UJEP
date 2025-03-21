<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$xml = new DOMDocument;
$xml->load('pivonka_pozice.xml');

$xsl = new DOMDocument;
$xsl->load('pivonka_pozice.xsl');

$proc = new XSLTProcessor;
$proc->importStyleSheet($xsl);

echo $proc->transformToXML($xml);
