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
            <div class="col">
                <form class="" action="">
                    <input type="radio" class="btn-check rounded-1" name="record_option" id="items" autocomplete="off" value="order_items" checked>
                    <label class="btn btn-outline-dark px-3 py-2" for="items">SINGLE ITEMS</label>

                    <input type="radio" class="btn-check rounded-1" name="record_option" id="box" autocomplete="off">
                    <label class="btn btn-outline-dark px-3 py-2" for="box">BOXES</label>
                </form>
            </div>
            <!-- searh bar -->   
            <div class="col-8 ms-auto search_input">
                <form action="" class="green_btn hstack">
                    <input class="form-control me-2 rounded-1 focus-ring-light focus-ring" type="search" placeholder="Search" aria-label="Search">
                    <button class="btn btn-secondary border-0 rounded-1" type="submit">Search</button>
                </form>
            </div>
        </div>
        <!-- view orders -->
        <div class="m-0 p-0" id="orderItemsDiv">
            <!-- single featured items -->
            <?php include '../others/order_items.php';?>
        </div>

        <div class="m-0 p-0" id="orderBoxesDiv" style="display: none;">
            <!-- style and mystery boxes -->
            <?php include '../others/order_boxes.php';?>
        </div>

        <script>
        // load table depending on the category
        $(document).ready(function() {
            $('input[name="record_option"]').change(function() {
                if ($(this).val() === 'order_items') {
                    // show single items 
                    $('#orderItemsDiv').show();
                    $('#orderBoxesDiv').hide();
                } else {
                    // show mystery boxes
                    $('#orderItemsDiv').hide();
                    $('#orderBoxesDiv').show();
                }
            });
        });
        </script>
    </div>
</body>
</html>