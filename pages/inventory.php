<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ukay Tamis Management System</title>
    <?php include '../others/head_resource.php';?>
    <link rel="stylesheet" href="../css/inventory.css">
</head>
<body class="light_bg">
    <!-- navigation bar -->
    <?php include '../others/nav_bar.php';?>

    <div class="body_con p-5">
        <h2 class="fw-bold">INVENTORY</h2>
        <div class="row record_btn mt-3">
            <!-- options -->
            <div class="col">
                <form class="" action="">
                    <!-- single items -->
                    <input type="radio" class="btn-check rounded-1" name="record_option" id="items" autocomplete="off" value="inventory_items" checked>
                    <label class="btn btn-outline-dark px-3 py-2" for="items">SINGLE ITEMS</label>
                    <!-- boxes -->
                    <input type="radio" class="btn-check rounded-1" name="record_option" id="box" autocomplete="off" value="inventory_boxes">
                    <label class="btn btn-outline-dark px-3 py-2" for="box">BOXES</label>
                </form>
            </div>
            <!-- searh bar -->   
            <div class="col-8 ms-auto search_input">
                <form action="" class="green_btn hstack">
                    <input class="form-control me-2 rounded-1 focus-ring-light focus-ring" type="search" placeholder="Search" aria-label="Search">
                    <button class="btn btn-secondary border-0 rounded-1" id="search_btn" type="submit">Search</button>
                </form>
            </div>
        </div>
        <!-- view inventory -->
        <div class="m-0 p-0" id="inventoryItemsDiv">
            <!-- single featured items -->
            <?php include '../others/inventory_items.php';?>

            
        </div>

        <div class="m-0 p-0" id="inventoryBoxesDiv" style="display: none;">
            <!-- style and mystery boxes -->
            <?php include '../others/inventory_boxes.php';?>
        </div>

        <script>
        // load table depending on the category
        $(document).ready(function() {
            $('input[name="record_option"]').change(function() {
                if ($(this).val() === 'inventory_items') {
                    // show single items 
                    $('#inventoryItemsDiv').show();
                    $('#inventoryBoxesDiv').hide();
                } else {
                    // show mystery boxes
                    $('#inventoryItemsDiv').hide();
                    $('#inventoryBoxesDiv').show();
                }
            });
        });
        </script>
    </div>
</body>
</html>