<?php

if (!defined('XML_FILENAME')) {
  define('XML_FILENAME', 'reading-list.xml');
  define('XML_BASENAME', 'reading-list');

  define('XML_IMPORT_DIR', 'resources/xml/imported/');
  define('XML_SCHEMA_DIR', 'resources/xml/static/');

  define('XML_IMPORT_PATH', XML_IMPORT_DIR . XML_FILENAME);
  define('XML_SCHEMA_PATH', XML_SCHEMA_DIR . XML_BASENAME . '.xsd');
  define('XML_STYLES_PATH', XML_SCHEMA_DIR . XML_BASENAME . '.xsl');
}