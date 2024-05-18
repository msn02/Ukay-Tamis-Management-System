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
            include('server/connection.php');

            // SQL query to fetch order items data
            $sql = "SELECT op.transaction_id, t.user_id, op.item_id, op.item_name, op.style_box_quantity AS quantity, t.shipping_fee, op.item_price AS total_price, t.payment_method, op.style_box_id AS status
                    FROM order_product op
                    INNER JOIN transaction t ON op.transaction_id = t.transaction_id";

            $result = $conn->query($sql);

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
                    echo "<form class='form_option hstack'>";
                    echo "<select id='status' class='form-select rounded-1'>";
                    echo "<option value='0' " . ($row["status"] == 0 ? "selected" : "") . ">Pending</option>";
                    echo "<option value='1' " . ($row["status"] == 1 ? "selected" : "") . ">Packed</option>";
                    echo "<option value='2' " . ($row["status"] == 2 ? "selected" : "") . ">Shipped</option>";
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


