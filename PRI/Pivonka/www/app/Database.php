<?php
declare(strict_types=1);

class Config {
    private static array $config = [
        'db_host' => 'database',
        'db_name' => 'restaurace',
        'db_user' => 'admin',
        'db_pass' => 'heslo',
        'db_port' => '5432'
    ];

    private function __construct() {}

    public static function get(string $key): mixed {
        return self::$config[$key] ?? null;
    }
}

class Database {
    private static ?PDO $pdo = null;

    private function __construct() {}

    public static function getConnection(): PDO {
        return self::$pdo ??= self::createConnection();
    }

    private static function createConnection(): PDO {
        $dsn = "pgsql:host=" . Config::get('db_host') .
               ";port=" . Config::get('db_port') .
               ";dbname=" . Config::get('db_name');
        return new PDO(
            $dsn,
            Config::get('db_user'),
            Config::get('db_pass'),
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false
            ]
        );
    }
}
