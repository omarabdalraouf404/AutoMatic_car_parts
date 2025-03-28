<?php
header('Content-Type: application/json');

// Database connection settings
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "car_tools";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Database connection failed"]));
}

// Check if userId is set
if (isset($_POST['userId'])) {
    $userId = $_POST['userId'];

    // Validate userId
    if (!is_numeric($userId)) {
        echo json_encode(["status" => "error", "message" => "Invalid user ID"]);
        exit();
    }

    // Delete user from database
    $stmt = $conn->prepare("DELETE FROM users WHERE id = ?");
    $stmt->bind_param("i", $userId);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "User account deleted successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to delete user account"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "userId is required"]);
}

// Close connection
$conn->close();
?>
