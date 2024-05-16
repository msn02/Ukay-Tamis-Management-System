<?php
 include '../pages/server/connection.php';

if (isset($_POST['update_item'])) {
    // Code to execute when edit button is clicked
    $item_id = $_POST['item_id'];
    $item_name = $_POST['item_name'];
    $color = $_POST['color'];
    $size = $_POST['size'];
    $price = $_POST['price'];
    $style = $_POST['style'];

    if ($item_id && $item_name && $color && $size && $price && $style) {
    // Perform SQL update query based on the item_id
        $sql = "UPDATE item SET item_name = '$item_name', color = '$color', size = '$size', price = '$price', style = '$style' WHERE item_id = '$item_id'";
        // Execute the SQL query
        $conn->query($sql);
    } else {
       echo "Error on Post";
    }
}

?>

<?php
include '../pages/server/connection.php';

if (isset($_GET['search'])) {
    $search_term = $_GET['search'];
    $stmt = $conn->prepare("SELECT * FROM item WHERE item_name LIKE ?");
    $like_term = "%" . $search_term . "%";
    $stmt->bind_param("s", $like_term);
    $stmt->execute();
    $result = $stmt->get_result();
} else {
    $sql = "SELECT * FROM item";
    $result = $conn->query($sql);
}
?>

<!-- single items -->
<div class="row mx-0 mt-4 p-2 card border-0 rounded-2">
    <table class="table shadow-md">
        <thead class="">
            <tr class="table_head">
                <th scope="col-1">Image</th>
                <th scope="col-1">Item ID</th>
                <th scope="col-1">Name</th>
                <th scope="col-1">Style</th>
                <th scope="col-1">Size</th>
                <th scope="col-1">Color</th>
                <th scope="col-1">Unit in Stock</th>
                <th scope="col-1">Price</th>
                <th scope="col-2">Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php 
            if ($result->num_rows > 0) {
                while($row = $result->fetch_assoc()) {
                    echo "<tr class='table_body align-middle text-center'>";
                    echo "<td><img class='lh-sm text-start' style='word-wrap: break-word;min-width: 160px;max-width: 160px;' src='../resources/".$row['item_img_url']."' alt='Item Image'></td>";
                    echo "<td>" . $row['item_id'] . "</td>";
                    echo "<td>".$row['item_name']."</td>";
                    echo "<td>".$row['style']."</td>";
                    echo "<td>".$row['color']."</td>";
                    echo "<td>".$row['size']."</td>";
                    echo "<td>"."1"."</td>";
                    echo "<td>".$row['price']."</td>";
                    echo "             
                    <td class='text-center'>
                        <div class='m-0 p-0 hstack gap-2 d-flex justify-content-center gray_btn'>
                            <button class='btn btn-secondary rounded-1' data-bs-toggle='modal' data-bs-target='#edit_items'><i class='bi bi-pencil-square'></i></button>
                            <button class='btn btn-danger rounded-1'><i class='bi bi-trash3-fill'></i></button>
                        </div>
                    </td>";
                    echo "</tr>";
                }
            } else {
                echo "<tr><td colspan='9'>No results found</td></tr>";
            }
            ?>
        </tbody>
    </table>
</div>
<!-- edit items in inventory -->
<div class="modal fade" id="edit_items" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="items_lbl" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header modal_btn">
                <h3 class="modal-title fs-5 fw-bold" id="items_lbl">Update Item</h3>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form class="form_style p-3 m-0" method="POST">
                    <!-- item id and style -->
                    <div class="row mb-3">
                        <div class="col-sm-6">
                            <label for="item_id" class="form-label ms-1">Item ID</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" name="item_id" id="item_id" placeholder="item-XXXX">
                        </div>
                        <div class="col-sm-6">
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
                            <select id="size" class="form-select" name = "size" aria-label="Default select example">
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
                            <input type="number" class="form-control focus-ring focus-ring-light" id="unit_stock" placeholder="1" readonly>
                        </div>
                        <div class="col-sm-6">
                            <label for="price" class="form-label ms-1">Price</label>
                            <input type="number" class="form-control focus-ring focus-ring-light" id="price" placeholder="" name="price">
                        </div>
                    </div>

                    <div class="modal-footer">
                    <div class="gray_btn">
                        <button type="button" class="btn btn-secondary rounded-1 border-0" data-bs-dismiss="modal">Cancel</button>
                    </div>
                    <div class="green_btn">
                        <input type="submit" name="update_item" class="btn btn-dark rounded-1 border-0" value="Save Changes"></input>
                    </div>
                </div>   

                </form>
                
            </div>
        </div>
    </div>
</div>
<script>

</script>