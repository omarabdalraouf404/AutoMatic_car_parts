<?php
header('Content-Type: application/json');

// Database connection settings
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "car_tools";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Set character encoding to avoid issues with Arabic text
$conn->set_charset("utf8mb4");

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Database connection failed"]));
}

// Validate input data
if (!isset($_POST['email']) || !isset($_POST['password']) || empty(trim($_POST['email'])) || empty(trim($_POST['password']))) {
    echo json_encode(["status" => "error", "message" => "Please enter both email and password"]);
    exit();
}

$email = trim($_POST['email']);
$password = $_POST['password'];

// Validate email format
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(["status" => "error", "message" => "Invalid email address"]);
    exit();
}

// Check if user exists in the database
$stmt = $conn->prepare("SELECT id, password, name FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    // Fetch user data
    $stmt->bind_result($userId, $hashedPassword, $name);
    $stmt->fetch();

    // Verify password
    if (password_verify($password, $hashedPassword)) {
        echo json_encode([
            "status" => "success",
            "message" => "Login successful",
            "user" => [
                "userId" => $userId,
                "name" => $name,
                "email" => $email
            ]
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Incorrect password"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "User not found"]);
}

// Close connection
$stmt->close();
$conn->close();
?>
