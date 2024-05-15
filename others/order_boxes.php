<div class="row mx-0 mt-4 p-2 card border-0 rounded-2">
    <table id="order_boxes" class="table shadow-md"> 
        <thead class="">
            <tr class="table_head">
                <th scope="col">Transaction ID</th>
                <th scope="col">User ID</th>
                <th scope="col">Box ID</th>
                <th scope="col">Name</th>
                <th scope="col">Quantity</th>
                <th scope="col">Shipping Fee</th>
                <th scope="col">Total Price</th>
                <th scope="col">Payment Method</th>
                <th scope="col">Status</th>
                <th scope="col">Actions</th>
            </tr>
        </thead>
        <tbody>
            <!-- PHP code to fetch and display order boxes -->
            <?php
            include ('server/connection.php');

            $sql = "SELECT op.transaction_id, t.user_id, op.style_box_id, op.style_box_name, op.style_box_quantity, t.shipping_fee, op.style_box_price, t.payment_method
            FROM order_product op
            INNER JOIN transaction t ON op.transaction_id = t.transaction_id";

            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                while($row = $result->fetch_assoc()) {
                    // Check if the style_box_id has a value
                    if (empty($row["style_box_id"])) {
                        continue; // Skip the row if style_box_id is empty
                    }

                    // Display the row if style_box_id is not empty
                    echo "<tr class='table_body align-middle'>";
                    echo "<td scope='row' class='text-start'>" . $row["transaction_id"] . "</td>";
                    echo "<td class='text-start'>" . $row["user_id"] . "</td>";
                    echo "<td class='text-center'>" . $row["style_box_id"] . "</td>";
                    echo "<td class='text-center'>" . $row["style_box_name"] . "</td>";
                    echo "<td class='text-center'>" . $row["style_box_quantity"] . "</td>";
                    echo "<td class='text-end'>" . $row["shipping_fee"] . "</td>";
                    echo "<td class='text-end fw-bold'>" . $row["style_box_price"] . "</td>";
                    echo "<td class='text-center'>" . $row["payment_method"] . "</td>";
                    // Status column
                    echo "<td class='text-center hstack gap-2 d-flex justify-content-center'>";
                    echo "<form class='form_option'>";
                    echo "<select id='status' class='form-select rounded-1'>";
                    echo "<option value='0'>Pending</option>";
                    echo "<option value='1'>Packed</option>";
                    echo "<option value='2'>Shipped</option>";
                    echo "</select>";
                    echo "</form>";
                    echo "</td>";
                    // Actions column
                    echo "<td class='text-center'>";
                    echo "<div class='m-0 p-0 hstack gap-2 d-flex justify-content-center gray_btn'>";
                    echo "<button id='edit_button' class='btn btn-secondary rounded-1'><i class='bi bi-pencil-square'></i></button>";
                    echo "<button class='btn btn-danger rounded-1'><i class='bi bi-trash3-fill'></i></button>";
                    echo "</div>";
                    echo "</td>";
                    echo "</tr>";
                }
            } else {
                // If there are no rows in the result
                echo "<tr><td colspan='10'>No order boxes available</td></tr>";
            }
            $conn->close();
            ?>
            <!-- End of PHP code -->
        </tbody>
    </table>
</div>
