<?php
function getConnection(): PDO {
    $c = require __DIR__ . '/config.php';
    return new PDO(
        "mysql:host={$c['host']};dbname={$c['db']};charset=utf8mb4",
        $c['user'], $c['pass'],
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
}
