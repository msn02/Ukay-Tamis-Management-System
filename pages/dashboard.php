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
                    <h1 class="fw-bold">12</h1>
                    <h5 class="fw-bold mb-1 p-0">Orders</h5>
                    <p>Orders for Today</p>
                </div>
            </div>
            <div class="col-sm-3 p-2 text-center header_num m-0">
                <div class="card px-4 border-0">
                    <h1 class="fw-bold">90</h1>
                    <h5 class="fw-bold mb-1 p-0">Products</h5>
                    <p>Available in Inventory</p>
                </div>
            </div>
            <div class="col-sm-3 p-2 text-center header_num m-0">
                <div class="card px-4 border-0">
                    <h1 class="fw-bold">20</h1>
                    <h5 class="fw-bold mb-1 p-0">Users</h5>
                    <p>Platform Users</p>
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
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- order details -->
                    <tr class="table_body align-middle">
                        <td scope="row" class="text-start">tran-0000</td>
                        <td class="text-start">user-0000</td>
                        <td class="text-center">XXXXXXXXXXXX</td>
                        <td class="text-center">signup</td>
                        <!-- actions -->
                        <td class="text-center">
                            <div class="m-0 p-0 hstack gap-2 d-flex justify-content-center gray_btn">
                                <!-- delete -->
                                <button class="btn btn-danger rounded-1"><i class="bi bi-trash3-fill"></i></button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        </div>
    </div>
</body>
</html>