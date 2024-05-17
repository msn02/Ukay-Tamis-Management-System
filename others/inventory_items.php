<?php 
// Include database connection
include '../pages/server/connection.php';

// Function to add a new item
function addNewItem($item_name, $style, $size, $color, $price, $conn) {
    // Check if the style exists in the style table
    $check_style_query = "SELECT COUNT(*) AS count FROM style WHERE style = ?";
    $stmt = $conn->prepare($check_style_query);
    $stmt->bind_param("s", $style);
    $stmt->execute();
    $result = $stmt->get_result();
    $row = $result->fetch_assoc();
    $style_exists = $row['count'];

    if ($style_exists) {
        $sql = "INSERT INTO item (item_name, style, size, color, price) VALUES (?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssi", $item_name, $style, $size, $color, $price);
        $stmt->execute();
        return "";
    } else {
        throw new Exception("The specified style ('$style') does not exist in the style table.");
    }
}


// Handle form submission to add a new item
if (isset($_POST['add_item'])) {
    $item_name = $_POST['item_name'];
    $style = $_POST['style'];
    $size = $_POST['size'];
    $color = $_POST['color'];
    $price = $_POST['price'];

    try {
        $add_item_result = addNewItem($item_name, $style, $size, $color, $price, $conn);
        echo $add_item_result;
    } catch (Exception $e) {
        echo 'Error adding new item: ' . $e->getMessage();
    }
}



// Handle search
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
                    echo "<td style='word-wrap: break-word;min-width: 160px;max-width: 160px;'>".$row['size']."</td>";
                    echo "<td>".$row['color']."</td>";
                    echo "<td>"."1"."</td>";
                    echo "<td>".$row['price']."</td>";
                    echo "<td class='text-center'>
                            <div class='m-0 p-0 hstack gap-2 d-flex justify-content-center gray_btn'>
                                <form method='POST'>
                                    <input type='hidden' name='edit_item_id' value='".$row['item_id']."'>
                                    <input type='hidden' name='edit_item_name' value='".$row['item_name']."'>
                                    <input type='hidden' name='edit_style' value='".$row['style']."'>
                                    <input type='hidden' name='edit_size' value='".$row['size']."'>
                                    <input type='hidden' name='edit_color' value='".$row['color']."'>
                                    <input type='hidden' name='edit_price' value='".$row['price']."'>
                                    <button type='submit' class='btn btn-secondary rounded-1' name='edit_item_button'><i class='bi bi-pencil-square'></i></button>
                                </form>
                                <form method='POST'>
                                    <input type='hidden' name='delete_item_id' value='".$row['item_id']."'>
                                    <button type='submit' class='btn btn-danger rounded-1' name='delete_item'><i class='bi bi-trash3-fill'></i></button>
                                </form>
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

<!-- Modal for adding new items -->
<div class="modal fade" id="addItemModal" tabindex="-1" aria-labelledby="addItemModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header modal_btn">
                <h5 class="modal-title fs-5 fw-bold" id="addItemModalLabel">Add Item</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form class="form_style p-3 m-0" method="POST" action="">
                    <div class="row mb-3">
                        <div class="col-sm-12">
                            <label for="add_style" class="form-label ms-1">Item Name</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" name="item_name" placeholder="Item Name">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-12">
                            <label for="add_unit_stock" class="form-label ms-1">Style</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" name="style" placeholder="Style">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-6">
                            <label for="add_price" class="form-label ms-1">Size</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" name="size" placeholder="Size">
                        </div>
                        <div class="col-sm-6">
                            <label for="add_img_url" class="form-label ms-1">Color</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" name="color" placeholder="Color">
                        </div>
                        <div class="col-sm-6">
                            <label for="add_img_url" class="form-label ms-1">Price</label>
                            <input type="number" class="form-control focus-ring focus-ring-light" name="price" placeholder="Price">
                        </div>
                    </div>
            </div>
            <div class="modal-footer">
                <div class="gray_btn">
                    <button type="button" class="btn btn-secondary rounded-1 border-0" data-bs-dismiss="modal">Cancel</button>
                </div>
                <div class="green_btn">
                    <button type="submit" class="btn btn-dark rounded-1 border-0" name="add_item">Add Item</button>
                </div>
                </form> <!-- Close the form here -->
            </div>
        </div>
    </div>
</div>
