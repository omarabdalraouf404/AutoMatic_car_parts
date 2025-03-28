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

// التحقق من البيانات المرسلة
if (isset($_POST['email']) && isset($_POST['new_password']) && isset($_POST['otp_code'])) {
    $email = $_POST['email'];
    $new_password = password_hash($_POST['new_password'], PASSWORD_BCRYPT);
    $otp_code = $_POST['otp_code'];

    // التحقق مما إذا كان رمز OTP صحيحًا
    $stmt = $conn->prepare("SELECT id FROM users WHERE email = ? AND reset_token = ?");
    $stmt->bind_param("ss", $email, $otp_code);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        // تحديث كلمة المرور ومسح رمز OTP بعد الاستخدام
        $update_stmt = $conn->prepare("UPDATE users SET password = ?, reset_token = NULL WHERE email = ?");
        $update_stmt->bind_param("ss", $new_password, $email);

        if ($update_stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Password changed successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to update password"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid OTP code"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid input"]);
}

$conn->close();
?>
