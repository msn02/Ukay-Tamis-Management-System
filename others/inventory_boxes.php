<?php
// Include database connection
include '../pages/server/connection.php';

if (isset($_POST['update_box'])) {
    // Retrieve form data
    $box_id = $_POST['box_id'];
    $unit_stock = $_POST['unit_stock'];
    $price = $_POST['price'];
    $img_url = $_POST['img_url'];
    $style = $_POST['style'];

    // Check if the style exists in the style table
    $check_style_query = "SELECT COUNT(*) AS count FROM style WHERE style = '$style'";
    $result = $conn->query($check_style_query);
    $row = $result->fetch_assoc();
    $style_exists = $row['count'];

    if ($style_exists) {
        // Update the database record
        $sql = "UPDATE style_box 
                SET stock_unit = '$unit_stock', price = '$price' 
                WHERE style_box_id = '$box_id'";

        if ($conn->query($sql) === TRUE) {
            // Update the style_img_url in the style table
            $sql_update_style = "UPDATE style SET style_img_url = '$img_url' WHERE style = '$style'";
            if ($conn->query($sql_update_style) === TRUE) {
                echo "Record updated successfully";
            } else {
                echo "Error updating style_img_url: " . $conn->error;
            }
        } else {
            echo "Error updating record: " . $conn->error;
        }
    } else {
        echo "Error: The specified style ('$style') does not exist in the style table.";
    }
}

if (isset($_POST['add_box'])) {
    $style = $_POST['add_style'];
    $unit_stock = $_POST['add_unit_stock'];
    $price = $_POST['add_price'];
    $img_url = $_POST['add_img_url'];

    // Check if the style exists in the style table
    $check_style_query = "SELECT style_id FROM style WHERE style = '$style'";
    $result = $conn->query($check_style_query);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $style_id = $row['style_id'];

        // Insert into style_box table
        $sql = "INSERT INTO style_box (style_id, stock_unit, price) VALUES ('$style_id', '$unit_stock', '$price')";
        if ($conn->query($sql) === TRUE) {
            // Update the style_img_url in the style table
            $sql_update_style = "UPDATE style SET style_img_url = '$img_url' WHERE style_id = '$style_id'";
            if ($conn->query($sql_update_style) === TRUE) {
                echo "";
            } else {
                echo "Error updating style_img_url: " . $conn->error;
            }
        } else {
            echo "Error adding box: " . $conn->error;
        }
    } else {
        echo "Error: The specified style ('$style') does not exist in the style table.";
    }
}
?>

<!-- box table -->
<div class="row mx-0 mt-4 p-2 card border-0 rounded-2" id="boxTable">
    <table class="table shadow-md">
        <thead class="">
            <tr class="table_head">
                <th scope="col-1">Image</th>
                <th scope="col-1">Box ID</th>
                <th scope="col-1">Style</th>
                <th scope="col-1">Unit in Stock</th>
                <th scope="col-1">Price</th>
                <th scope="col-2">Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php 
            // Include database connection
            include '../pages/server/connection.php';

            $sql = "SELECT sb.*, s.* FROM style_box sb JOIN style s ON sb.style_id = s.style_id";
            $result = $conn->query($sql);

            // Display each box as a table row
            if ($result->num_rows > 0) {
                while($row = $result->fetch_assoc()) {
                    echo "<tr class='table_body align-middle text-center'>";
                    echo "<td><img class='lh-sm text-start' style='word-wrap: break-word;min-width: 160px;max-width: 160px;' src='../resources/".$row['style_img_url']."' alt='Box Image'></td>";
                    echo "<td>" . $row['style_box_id'] . "</td>";
                    echo "<td>".$row['style']."</td>";
                    echo "<td>".$row['stock_unit']."</td>";
                    echo "<td>".$row['price']."</td>";
                    // Edit and delete actions
                    echo "             
                    <td class='text-center'>
                        <div class='m-0 p-0 hstack gap-2 d-flex justify-content-center gray_btn'>
                            <!-- edit box details -->
                            <button class='btn btn-secondary rounded-1' data-bs-toggle='modal' data-bs-target='#edit_boxes_".$row['style_box_id']."' data-box-id='".$row['style_box_id']."' data-box-style='".$row['style']."' data-box-unit='".$row['stock_unit']."' data-box-price='".$row['price']."' data-box-img='".$row['style_img_url']."'><i class='bi bi-pencil-square'></i></button>
                            <!-- delete box -->
                            <button class='btn btn-danger rounded-1'><i class='bi bi-trash3-fill'></i></button>
                        </div>
                    </td>";
                    echo "</tr>";

                    // Edit modal for each box
                    echo "<div class='modal fade' id='edit_boxes_".$row['style_box_id']."' data-bs-backdrop='static' data-bs-keyboard='false' tabindex='-1' aria-labelledby='boxes_lbl_".$row['style_box_id']."' aria-hidden='true'>";
                    echo "<div class='modal-dialog modal-dialog-centered'>";
                    echo "<div class='modal-content'>";
                    echo "<div class='modal-header modal_btn'>";
                    echo "<h3 class='modal-title fs-5 fw-bold' id='boxes_lbl_".$row['style_box_id']."'>Update Box</h3>";
                    echo "<button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>";
                    echo "</div>";
                    echo "<div class='modal-body'>";
                    echo "<form class='form_style p-3 m-0' method='POST'>";
                    echo "<div class='row mb-3'>";
                    echo "<div class='col-sm-6'>";
                    echo "<label for='box_id' class='form-label ms-1'>Box ID</label>";
                    echo "<input type='text' class='form-control focus-ring focus-ring-light' name='box_id' id='box_id' value='".$row['style_box_id']."' readonly>";
                    echo "</div>";
                    echo "<div class='col-sm-6'>";
                    echo "<label for='style' class='form-label ms-1'>Style</label>";
                    echo "<input type='hidden' name='style' value='".$row['style']."'>";
                    echo "<div>".$row['style']."</div>";
                    echo "</div>";
                    echo "</div>";
                    echo "<div class='row mb-3'>";
                    echo "<div class='col-sm-12'>";
                    echo "<label for='unit_stock' class='form-label ms-1'>Unit in Stock</label>";
                    echo "<input type='number' class='form-control focus-ring focus-ring-light' id='unit_stock' name='unit_stock' value='".$row['stock_unit']."'>";
                    echo "</div>";
                    echo "</div>";
                    echo "<div class='row mb-3'>";
                    echo "<div class='col-sm-6'>";
                    echo "<label for='price' class='form-label ms-1'>Price</label>";
                    echo "<input type='number' class='form-control focus-ring focus-ring-light' id='price' name='price' value='".$row['price']."'>";
                    echo "</div>";
                    echo "<div class='col-sm-6'>";
                    echo "<label for='img_url' class='form-label ms-1'>Image URL</label>";
                    echo "<input type='text' class='form-control focus-ring focus-ring-light' id='img_url' name='img_url' value='".$row['style_img_url']."'>";
                    echo "</div>";
                    echo "</div>";
                    echo "<div class='modal-footer'>";
                    echo "<div class='gray_btn'>";
                    echo "<button type='button' class='btn btn-secondary rounded-1 border-0' data-bs-dismiss='modal'>Cancel</button>";
                    echo "</div>";
                    echo "<div class='green_btn'>";
                    echo "<input type='submit' name='update_box' class='btn btn-dark rounded-1 border-0' value='Save Changes'>";
                    echo "</div>";
                    echo "</div>";
                    echo "</form>";
                    echo "</div>";
                    echo "</div>";
                    echo "</div>";
                    echo "</div>";
                }
            } else {
                echo "<tr><td colspan='6'>No results found</td></tr>";
            }
            ?>
        </tbody>
    </table>
</div>

<!-- Add Box Modal -->
<div class="modal fade" id="addBoxModal" tabindex="-1" aria-labelledby="addBoxLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header modal_btn">
                <h3 class="modal-title fs-5 fw-bold" id="addBoxLabel">Add Box</h3>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form class="form_style p-3 m-0" method="POST">
                    <div class="row mb-3">
                        <div class="col-sm-12">
                            <label for="add_style" class="form-label ms-1">Style</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" id="add_style" name="add_style" placeholder="">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-12">
                            <label for="add_unit_stock" class="form-label ms-1">Unit in Stock</label>
                            <input type="number" class="form-control focus-ring focus-ring-light" id="add_unit_stock" name="add_unit_stock" placeholder="">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-6">
                            <label for="add_price" class="form-label ms-1">Price</label>
                            <input type="number" class="form-control focus-ring focus-ring-light" id="add_price" name="add_price" placeholder="">
                        </div>
                        <div class="col-sm-6">
                            <label for="add_img_url" class="form-label ms-1">Image URL</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" id="add_img_url" name="add_img_url" placeholder="">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <div class="gray_btn">
                            <button type="button" class="btn btn-secondary rounded-1 border-0" data-bs-dismiss="modal">Cancel</button>
                        </div>
                        <div class="green_btn">
                            <input type="submit" name="add_box" class="btn btn-dark rounded-1 border-0" value="Add Box">
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

