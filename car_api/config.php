<?php
$servername = "localhost";
$username = "root"; // اسم المستخدم الافتراضي
$password = ""; // بدون كلمة مرور افتراضيًا في XAMPP
$dbname = "car_tools"; // اسم قاعدة البيانات

// إنشاء الاتصال
$conn = new mysqli($servername, $username, $password, $dbname);

// التحقق من الاتصال
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// تعيين ترميز UTF-8 لتفادي مشاكل اللغة العربية
$conn->set_charset("utf8mb4");
?>
