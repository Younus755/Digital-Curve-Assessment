<?php require __DIR__ . '/db.php'; ?>
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>PHP + MySQL Test</title>
<style>body{font-family:sans-serif;max-width:600px;margin:40px auto}.ok{color:#0a7d2c}.err{color:#c00}</style>
</head>
<body>
<h1>PHP + MySQL Connectivity Test</h1>
<p class="ok">✔ PHP is working (version <?= htmlspecialchars(PHP_VERSION) ?>)</p>
<?php
try {
    $pdo = getConnection();
    $row = $pdo->query('SELECT * FROM test_records ORDER BY id LIMIT 1')->fetch(PDO::FETCH_ASSOC);
    $user = $pdo->query('SELECT CURRENT_USER()')->fetchColumn();
    echo '<p class="ok">✔ Connected to MySQL as <b>' . htmlspecialchars($user) . '</b></p>';
    echo '<p class="ok">✔ Test record: <b>' . htmlspecialchars($row['message']) . '</b></p>';
    echo '<h2 class="ok">Database connectivity: SUCCESS</h2>';
} catch (Throwable $e) {
    echo '<h2 class="err">Database connection failed</h2>';
}
?>
<p>JSON version: <a href="api.php">api.php</a></p>
</body>
</html>
