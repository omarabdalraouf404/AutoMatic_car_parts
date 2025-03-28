<?php
header("Content-Type: application/json");
require 'config.php'; // استدعاء ملف الاتصال

$sql = "SELECT * FROM products"; // استعلام جلب جميع المنتجات
$result = $conn->query($sql);

$products = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $products[] = $row; // تخزين كل منتج في المصفوفة
    }
}

// إرجاع البيانات بصيغة JSON
echo json_encode($products, JSON_PRETTY_PRINT);

$conn->close();
?>
