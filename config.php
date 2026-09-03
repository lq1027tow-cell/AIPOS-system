<?php
declare(strict_types=1);

function load_env(string $file): array {
    if (!is_file($file)) return [];
    $values = [];
    foreach (file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
        $line = trim($line);
        if ($line === '' || str_starts_with($line, '#') || !str_contains($line, '=')) continue;
        [$key, $value] = explode('=', $line, 2);
        $values[trim($key)] = trim(trim($value), "\"'");
    }
    return $values;
}

$env = load_env(__DIR__ . '/.env');
const DB_HOST = '127.0.0.1';
const DB_NAME = 'synergy1_liuquan_pos_system';
const DB_USER = 'synergy1_yenping';
const DB_PASS = 'R.zb0ZwEuGZ}*fW2';
const SHOP_NAME = 'shop computer';
const GEMINI_CA_BUNDLE = 'C:/xampp/phpMyAdmin/vendor/composer/ca-bundle/res/cacert.pem';
$dbHost = $env['DB_HOST'] ?? DB_HOST;
$dbName = $env['DB_NAME'] ?? DB_NAME;
$dbUser = $env['DB_USER'] ?? DB_USER;
$dbPass = $env['DB_PASS'] ?? DB_PASS;
$shopName = $env['SHOP_NAME'] ?? SHOP_NAME;
$geminiCaBundle = $env['GEMINI_CA_BUNDLE'] ?? GEMINI_CA_BUNDLE;

session_start();

function db(): PDO {
    static $pdo;
    if (!$pdo) {
        global $dbHost, $dbName, $dbUser, $dbPass;
        $pdo = new PDO('mysql:host=' . $dbHost . ';dbname=' . $dbName . ';charset=utf8mb4', $dbUser, $dbPass, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);
    }
    return $pdo;
}

function csrf(): string {
    if (empty($_SESSION['csrf'])) $_SESSION['csrf'] = bin2hex(random_bytes(32));
    return $_SESSION['csrf'];
}

function require_csrf(): void {
    if (!hash_equals($_SESSION['csrf'] ?? '', $_POST['csrf'] ?? '')) {
        http_response_code(419); exit('Invalid CSRF token');
    }
}

function user(): ?array { return $_SESSION['user'] ?? null; }
function require_login(): void { if (!user()) { header('Location: ?page=login'); exit; } }
function require_admin(): void { require_login(); if (user()['role'] !== 'admin') { http_response_code(403); exit('Forbidden'); } }
function e(?string $value): string { return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8'); }
function money(float $value): string { return 'RM' . number_format($value, 2); }
function redirect(string $url): never { header('Location: ' . $url); exit; }
