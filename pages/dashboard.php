<?php
// Include database connection
include ('server/connection.php');

// Initialize user count
$user_count = 0;

// SQL query to fetch the count of rows in the "users" table
$sql = "SELECT COUNT(*) AS user_count FROM user";

// Execute the query
$result = $conn->query($sql);

// Check if the query executed successfully and if there are any rows in the result
if ($result && $result->num_rows > 0) {
    // Fetch the row containing the count
    $row = $result->fetch_assoc();
    // Extract the user count
    $user_count = $row['user_count'];
}

// Close the database connection
$conn->close();

// Include database connection
include ('server/connection.php');

// SQL query to count the number of orders
$sql_orders = "SELECT COUNT(*) as order_count FROM order_product";

// Execute the query
$result_orders = $conn->query($sql_orders);

// Check if there are any rows in the result
if ($result_orders->num_rows > 0) {
    // Fetch the row
    $row_orders = $result_orders->fetch_assoc();
    // Get the number of orders
    $order_count = $row_orders['order_count'];
} else {
    $order_count = 0;
}

// Close the result set
$result_orders->close();

// SQL query to count the number of items
$sql_items = "SELECT COUNT(*) as item_count FROM item";

// Execute the query
$result_items = $conn->query($sql_items);

// Check if there are any rows in the result
if ($result_items->num_rows > 0) {
    // Fetch the row
    $row_items = $result_items->fetch_assoc();
    // Get the number of items
    $item_count = $row_items['item_count'];
} else {
    $item_count = 0;
}

// Close the result set
$result_items->close();
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ukay Tamis Management System</title>
    <?php include '../others/head_resource.php';?>
    <link rel="stylesheet" href="../css/dashboard.css">
    <script src="../javascript/date_time.js" defer></script>
</head>
<body class="light_bg">
    <!-- navigation bar -->
    <?php include '../others/nav_bar.php';?>

    <div class="body_con p-5">
        <div class="row">
            <div class="col-5"><h2 class="fw-bold">ADMIN DASHBOARD</h2></div>
            <div class="col-7 text-end d-flex justify-content-end align-items-center clock_container opacity-75">
                <i class="bi bi-clock-fill me-3"></i>
                <div class="clock_elements">
                    <span id="hour"></span>
                    <span id="point">:</span>
                    <span id="minute"></span>
                    <span id="point">:</span>
                    <span id="second"></span>
                    <span id="am_pm"></span>
                </div>
            </div>
        </div>
        <!-- basic stats -->
        <div class="row mx-0 mt-3 p-4 card border-0 rounded-2 hstack gap-1 d-flex justify-content-center">
            <div class="col-sm-3 p-2 text-center header_num m-0">
                <div class="card border-0 px-4">
                    <h1 class="fw-bold"><?php echo $order_count; ?></h1>
                    <h5 class="fw-bold mb-1 p-0">Orders</h5>
                    <p>Number of Orders made</p>
                </div>
            </div>
            <div class="col-sm-3 p-2 text-center header_num m-0">
                <div class="card px-4 border-0">
                    <h1 class="fw-bold"><?php echo $item_count; ?></h1>
                    <h5 class="fw-bold mb-1 p-0">Products</h5>
                    <p>Available in Inventory</p>
                </div>
            </div>
            <!-- Display the user count in the dashboard -->
            <div class="col-sm-3 p-2 text-center header_num m-0">
                <div class="card px-4 border-0">
                    <h1 class="fw-bold"><?php echo $user_count; ?></h1>
                    <h5 class="fw-bold mb-1 p-0">Users</h5>
                    <p>Registered Users</p>
                </div>
            </div>
        </div>
        <h5 class="fw-bold mt-4 opacity-75">USER ACTIVITY LOG</h5>
        <!-- user logins -->
        <div class="row mx-0 mt-3 p-2 card border-0 rounded-2">
            <table class="table shadow-md">
                <thead class="">
                    <tr class="table_head">
                        <th scope="col">Log ID</th>
                        <th scope="col">User ID</th>
                        <th scope="col">Timestamp</th>
                        <th scope="col">Task</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- PHP code to fetch and display user log data -->
                    <?php
                    // Include database connection
                    include ('server/connection.php');

                    // SQL query to fetch user log data
                    $sql = "SELECT * FROM user_logs";

                    // Execute the query
                    $result = $conn->query($sql);

                    // Check if there are any rows in the result
                    if ($result->num_rows > 0) {
                        // Loop through each row in the result
                        while($row = $result->fetch_assoc()) {
                            echo "<tr class='table_body align-middle'>";
                            echo "<td scope='row' class='text-start'>" . $row["log_id"] . "</td>";
                            echo "<td class='text-start'>" . $row["user_id"] . "</td>";
                            echo "<td class='text-center'>" . $row["timestamp"] . "</td>";
                            echo "<td class='text-center'>" . $row["action"] . "</td>";
                            echo "</tr>";
                        }
                    } else {
                        // If there are no rows in the result
                        echo "<tr><td colspan='4'>No user activity log data available</td></tr>";
                    }
                    // Close the database connection
                    $conn->close();
                    ?>
                    <!-- End of PHP code -->
                </tbody>
            </table>
        </div>
        </div>
    </div>
</body>
</html>
