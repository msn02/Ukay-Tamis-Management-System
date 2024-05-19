<?php
include('server/connection.php');

// Check if it's a POST request for updating order status
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $transaction_id = $_POST['transaction_id'];
    $status = $_POST['status'];

    // Check if status column exists in the transaction table before attempting to update
    $check_column_query = "SHOW COLUMNS FROM transaction LIKE 'status'";
    $column_exists_result = $conn->query($check_column_query);

    if ($column_exists_result->num_rows > 0) {
        // Update the order status in the database
        $sql_update_status = "UPDATE transaction SET status = '$status' WHERE transaction_id = '$transaction_id'";
        
        if ($conn->query($sql_update_status) === TRUE) {
            header("Location: orders.php");
            exit();
        } else {
            echo "Error updating order status: " . $conn->error;
        }        
    } else {
        echo "Error: The 'status' column does not exist in the transaction table.";
    }
}

// SQL query to fetch order items data
$sql = "SELECT op.transaction_id, t.user_id, op.item_id, op.item_name, op.style_box_quantity AS quantity, t.shipping_fee, op.item_price AS total_price, t.payment_method, op.style_box_id AS status
        FROM order_product op
        INNER JOIN transaction t ON op.transaction_id = t.transaction_id";

$result = $conn->query($sql);

?>

<div class="row mx-0 mt-4 p-2 card border-0 rounded-2">
    <table id="order_items" class="table shadow-md">
        <thead class="">
            <tr class="table_head">
                <th scope="col">Transaction ID</th>
                <th scope="col">User ID</th>
                <th scope="col">Item ID</th>
                <th scope="col">Item Name</th>
                <th scope="col">Shipping Fee</th>
                <th scope="col">Total Price</th>
                <th scope="col">Payment Method</th>
                <th scope="col">Order Status</th>
            </tr>
        </thead>
        <tbody>
            <?php
            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    // Skip displaying the entire row if item_id is empty
                    if (empty($row["item_id"])) {
                        continue;
                    }

                    echo "<tr class='table_body text-center align-middle'>";
                    echo "<td scope='row'>" . $row["transaction_id"] . "</td>";
                    echo "<td>" . $row["user_id"] . "</td>";
                    echo "<td>" . $row["item_id"] . "</td>";
                    echo "<td>" . $row["item_name"] . "</td>";
                    echo "<td>" . $row["shipping_fee"] . "</td>";
                    echo "<td>" . $row["total_price"] . "</td>";
                    echo "<td>" . $row["payment_method"] . "</td>";
                    // Order Status column
                    echo "<td class='text-center hstack gap-2 d-flex justify-content-center'>";
                    echo "<form method='POST' class='form_option hstack'>";
                    echo "<input type='hidden' name='transaction_id' value='" . $row["transaction_id"] . "'>";
                    echo "<select name='status' class='form-select rounded-1'>";
                    echo "<option value='Pending' " . ($row["status"] == 'Pending' ? "selected" : "") . ">Pending</option>";
                    echo "<option value='Packed' " . ($row["status"] == 'Packed' ? "selected" : "") . ">Packed</option>";
                    echo "<option value='Shipped' " . ($row["status"] == 'Shipped' ? "selected" : "") . ">Shipped</option>";
                    echo "</select>";
                    echo "<div class='gray_btn ms-1'>";
                    echo "<button type='submit' class='btn btn-secondary'>Update</button>";
                    echo "</div>";
                    echo "</form>";
                    echo "</td>";
                    // Actions column
                    echo "<td class='text-center'>";
                    echo "</td>";
                    echo "</tr>";
                }
            } else {
                echo "<tr><td colspan='10'>No order items available</td></tr>";
            }
            $conn->close();
            ?>
        </tbody>
    </table>
</div>
