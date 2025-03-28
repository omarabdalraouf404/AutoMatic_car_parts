<?php
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "car_tools";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed"]));
}

error_log("🔵 Connection successful");

if (isset($_POST['name']) && isset($_POST['email']) && isset($_POST['password'])) {
    $name = trim($_POST['name']);
    $email = trim($_POST['email']);
    $password = $_POST['password'];

    error_log("🔵 Received input: Name = $name, Email = $email");

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(["status" => "error", "message" => "Invalid email address"]);
        exit();
    }

    if (strlen($password) < 6) {
        echo json_encode(["status" => "error", "message" => "Password must be at least 6 characters"]);
        exit();
    }

    error_log("🔵 Valid input, checking if email exists...");

    $check_email = $conn->prepare("SELECT id FROM users WHERE email = ?");
    $check_email->bind_param("s", $email);
    $check_email->execute();
    $check_email->store_result();

    if ($check_email->num_rows > 0) {
        error_log("🔴 Email already exists: $email");
        echo json_encode(["status" => "error", "message" => "Email already exists"]);
        $check_email->close();
        exit();
    }
    $check_email->close();

    error_log("🟢 Email is new, proceeding with registration...");

    $hashed_password = password_hash($password, PASSWORD_BCRYPT);

    $stmt = $conn->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $name, $email, $hashed_password);

    if ($stmt->execute()) {
        $userId = $stmt->insert_id;
        error_log("🟢 User registered successfully: ID = $userId");

        echo json_encode([
            "status" => "success",
            "message" => "User registered successfully",
            "user" => [
                "userId" => $userId,
                "name" => $name,
                "email" => $email
            ]
        ]);
    } else {
        error_log("🔴 Registration failed");
        echo json_encode(["status" => "error", "message" => "Registration failed"]);
    }

    $stmt->close();
} else {
    error_log("🔴 Invalid input received");
    echo json_encode(["status" => "error", "message" => "Invalid input"]);
}

$conn->close();
error_log("🔵 Connection closed");
?>
