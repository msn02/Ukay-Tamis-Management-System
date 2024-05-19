
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
         
            <div class="col-sm-8 search_input d-flex justify-content-end">
                <form action="" method="GET" class="green_btn hstack">
                    <div class="m-0 p-0 hstack" id="searchItem">
                        <input class="form-control me-2 rounded-1 focus-ring-light focus-ring" id="searchInput" type="search" name="search_item" placeholder="Search by Item ID" aria-label="Search">
                        <button class="btn btn-secondary border-0 rounded-1" id="search_item_btn" type="submit">Search</button>
                    </div>
                    <div class="m-0 p-0 hstack" id="searchBox" style="display: none;">
                        <input class="form-control me-2 rounded-1 focus-ring-light focus-ring" id="searchBoxInput" type="text" onkeyup="filterTable()" placeholder="Search by Box ID">
                        <button class="btn btn-secondary border-0 rounded-1" id="search_box_btn" type="submit">Search</button>
                    </div>
                    <button type="button" class="btn btn-dark ms-2 border-0 rounded-1" id="addItem" data-bs-toggle="modal" data-bs-target="#addItemModal">Add an Item</button>
                    <button type="button" class="btn btn-dark ms-2 border-0 rounded-1" id="addBoxes" style="display: none;" data-bs-toggle="modal" data-bs-target="#addBoxModal">Add a Box</button>
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
            // Load table depending on the category
            $(document).ready(function() {
                $('input[name="record_option"]').change(function() {
                    if ($(this).val() === 'inventory_items') {
                        // Show single items 
                        $('#inventoryItemsDiv').show();
                        $('#inventoryBoxesDiv').hide();
                        $('#searchItem').show();
                        $('#searchBox').hide();
                        $('#addItem').show();
                        $('#addBoxes').hide();
                    } else {
                        // Show boxes
                        $('#inventoryItemsDiv').hide();
                        $('#inventoryBoxesDiv').show();
                        $('#searchItem').hide();
                        $('#searchBox').show();
                        $('#addItem').hide();
                        $('#addBoxes').show();
                    }
                });
            });

// JavaScript for filtering table based on search input
document.getElementById("searchInput").addEventListener("input", function() {
    var input, filter, table, tr, tdStyleBoxId, i, txtValueStyleBoxId;
    input = this.value.toUpperCase();

    // Get the specific table body
    var tableBody = document.getElementById("boxTable");

    // Get all rows inside the table body
    tr = tableBody.getElementsByTagName("tr");

    // Loop through all rows
    for (i = 0; i < tr.length; i++) {
        // Get the cell containing the style_box_id
        tdStyleBoxId = tr[i].getElementsByTagName("td")[1]; // Assuming style_box_id is in the second column

        if (tdStyleBoxId) {
            // Get the text value of the style_box_id cell
            txtValueStyleBoxId = tdStyleBoxId.textContent || tdStyleBoxId.innerText;

            // Check if the input text matches the style_box_id
            if (txtValueStyleBoxId.toUpperCase().indexOf(input) > -1) {
                // If there's a match, display the row
                tr[i].style.display = "";
            } else {
                // If there's no match, hide the row
                tr[i].style.display = "none";
            }
        }
    }
});
        </script>
    </div>

    <!-- modals -->
    <!-- add items in inventory -->
    <div class="modal fade" id="addItemModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="addItemLbl" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header modal_btn">
                    <h3 class="modal-title fs-5 fw-bold" id="addItemLbl">Add Item</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="form_style p-3 m-0" method="POST">
                        <div class="row mb-3">
                            <div class="col-sm-12">
                                <label for="style" class="form-label ms-1">Style</label>
                                <input type="text" class="form-control focus-ring focus-ring-light" name="style" id="style" placeholder="">
                            </div>
                        </div>
                        <!-- item name -->
                        <div class="row mb-3">
                            <div class="col-sm-12">
                                <label for="item_name" class="form-label ms-1">Item Name</label>
                                <input type="text" class="form-control focus-ring focus-ring-light" name="item_name" id="item_name" placeholder="">
                            </div>
                        </div>
                        <!-- size and color -->
                        <div class="row mb-3">
                            <div class="col-sm-6 form_option">
                                <label for="size" class="form-label ms-1">Size</label>
                                <select id="size" class="form-select" name="size" aria-label="Default select example">
                                    <option selected>Select your size</option>
                                    <option value="1">Small</option>
                                    <option value="2">Medium</option>
                                    <option value="3">Large</option>
                                    <option value="4">Extra Large</option>
                                    <option value="5">XXL</option>
                                </select>
                            </div>
                            <div class="col-sm-6">
                                <label for="color" class="form-label ms-1">Color</label>
                                <input type="text" class="form-control focus-ring focus-ring-light" id="color" name="color" placeholder="">
                            </div>
                        </div>
                        <!-- stocks and price -->
                        <div class="row mb-3">
                            <div class="col-sm-6">
                                <label for="unit_stock" class="form-label ms-1">Unit in Stock</label>
                                <input type="number" class="form-control focus-ring focus-ring-light" id="unit_stock" placeholder="1" disabled>
                            </div>
                            <div class="col-sm-6">
                                <label for="price" class="form-label ms-1">Price</label>
                                <input type="number" class="form-control focus-ring focus-ring-light" id="price" placeholder="" name="price">
                            </div>
                        </div>

                        <div class="pe-0 hstack d-flex justify-content-end gap-2 mt-4">
                            <div class="gray_btn">
                                <button type="button" class="btn btn-secondary rounded-1 border-0" data-bs-dismiss="modal">Cancel</button>
                            </div>
                            <div class="gray_btn">
                                <input type="submit" name="add_item" class="btn btn-dark rounded-1 border-0" value="Add Item"></input>
                            </div>
                        </div>   
                    </form>
                </div>
            </div>
        </div>
    </div>

<!-- add box in inventory -->
    <div class="modal fade" id="addBoxModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="addBoxLbl" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header modal_btn">
                    <h3 class="modal-title fs-5 fw-bold" id="addBoxLbl">Add a Box</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="form_style p-3 m-0" method="POST">
                        <div class="row mb-3">
                            <div class="col-sm-12">
                                <label for="box_style" class="form-label ms-1">Style</label>
                                <input type="text" class="form-control focus-ring focus-ring-light" name="style" id="box_style" placeholder="">
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-sm-6">
                                <label for="price" class="form-label ms-1">Price</label>
                                <input type="number" class="form-control focus-ring focus-ring-light" id="price" placeholder="" name="price">
                            </div>
                            <div class="col-sm-6">
                                <label for="unit_stock" class="form-label ms-1">Unit in Stock</label>
                                <input type="number" class="form-control focus-ring focus-ring-light" id="unit_stock" placeholder="" name="unit_stock">
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-sm-12">
                                <label for="img_url" class="form-label ms-1">Image URL</label>
                                <input type="text" class="form-control focus-ring focus-ring-light" id="img_url" name="img_url" placeholder="">
                            </div>
                        </div>

                        <div class="pe-0 hstack d-flex justify-content-end gap-2 mt-4">
                            <div class="gray_btn">
                                <button type="button" class="btn btn-secondary rounded-1 border-0" data-bs-dismiss="modal">Cancel</button>
                            </div>
                            <div class="gray_btn">
                                <input type="submit" name="add_box" class="btn btn-dark rounded-1 border-0" value="Add Box"></input>
                            </div>
                        </div>   
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>


<script>
    // Load table depending on the category
    $(document).ready(function() {
        $('input[name="record_option"]').change(function() {
            if ($(this).val() === 'inventory_items') {
                // Show single items 
                $('#inventoryItemsDiv').show();
                $('#inventoryBoxesDiv').hide();
                $('#searchItem').show();
                $('#searchBox').hide();
                $('#addItem').show();
                $('#addBoxes').hide();
            } else {
                // Show boxes
                $('#inventoryItemsDiv').hide();
                $('#inventoryBoxesDiv').show();
                $('#searchItem').hide();
                $('#searchBox').show();
                $('#addItem').hide();
                $('#addBoxes').show();
            }
        });
    });

    // JavaScript for filtering table based on search input
    function filterTable() {
        var input = document.getElementById("searchBoxInput");
        var filter = input.value.toUpperCase();
        var tableBody = document.getElementById("boxTableBody");
        var rows = tableBody.getElementsByTagName("tr");

        for (var i = 0; i < rows.length; i++) {
            var td = rows[i].getElementsByTagName("td")[1];
            if (td) {
                var txtValue = td.textContent || td.innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }
            }
        }
    }

    // Event listener for search input
    document.getElementById("searchBoxInput").addEventListener("input", filterTable);
</script>


