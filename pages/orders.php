<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ukay Tamis Management System</title>
    <?php include '../others/head_resource.php';?>
    <link rel="stylesheet" href="../css/orders.css">
</head>
<body class="light_bg">
    <!-- navigation bar -->
    <?php include '../others/nav_bar.php';?>

    <div class="body_con p-5">
        <h2 class="fw-bold">ORDERS</h2>
        <div class="row record_btn mt-3">
            <!-- options -->
            <form class="" action="">
                <input type="radio" class="btn-check rounded-1" name="record_option" id="items" autocomplete="off" checked>
                <label class="btn btn-dark px-3 py-2" for="items">SINGLE ITEMS</label>

                <input type="radio" class="btn-check rounded-1" name="record_option" id="box" autocomplete="off">
                <label class="btn btn-dark px-3 py-2" for="box">BOXES</label>

                <!-- <button class="px-4 py-2 btn btn-secondary border rounded-1" onclick="">SUBSCRIPTION</button> -->
            </form>
        </div>

        <!-- view records -->
        <div class="row mx-0 mt-4 p-2 card border-0 rounded-2">
            <table class="table shadow-md">
                <thead class="">
                    <tr class="table_head">
                        <th scope="col">Transaction ID</th>
                        <th scope="col">User ID</th>
                        <th scope="col">Product ID</th>
                        <th scope="col">Product Name</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Shipping Fee</th>
                        <th scope="col">Total Price</th>
                        <th scope="col">Payment Method</th>
                        <th scope="col">Status</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="table_body">
                        <td scope="row" class="text-start">1234</td>
                        <td class="text-start">1234</td>
                        <td class="text-center">1234</td>
                        <td class="text-center">Summer Fest</td>
                        <td class="text-end">1</td>
                        <td class="text-end">PHP 100</td>
                        <td class="text-end fw-bold">PHP 600</td>
                        <td class="text-center">GCash</td>
                        <td class="text-center">Dropdown</td>
                        <td class="text-center">GCash</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>