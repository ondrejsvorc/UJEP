<?php
include 'includes/constants.php';

$xml = new DOMDocument;
$xml->load(XML_IMPORT_PATH);
$xsl = new DOMDocument;
$xsl->load(XML_STYLES_PATH);

$processor = new XSLTProcessor;
$processor->importStylesheet($xsl);
echo $processor->transformToXML($xml);