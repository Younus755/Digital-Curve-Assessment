<?php
header('Content-Type: application/json');
require __DIR__ . '/db.php';

try {
    $pdo = getConnection();
    $row = $pdo->query('SELECT id, message, created_at FROM test_records ORDER BY id LIMIT 1')->fetch(PDO::FETCH_ASSOC);
    echo json_encode([
        'status'      => 'success',
        'php_version' => PHP_VERSION,
        'db_user'     => $pdo->query('SELECT CURRENT_USER()')->fetchColumn(),
        'record'      => $row,
    ], JSON_PRETTY_PRINT);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
}
