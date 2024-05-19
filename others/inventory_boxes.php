<!-- box table -->
<?php
// Include database connection
include '../pages/server/connection.php';

if (isset($_POST['update_box'])) {
    // Retrieve form data
    $box_id = $_POST['box_id'];
    $unit_stock = $_POST['unit_stock'];
    $price = $_POST['price'];
    $img_url = $_POST['img_url'];

    // Update the database record
    $sql = "UPDATE style_box 
        SET stock_unit = '$unit_stock', price = '$price' 
        WHERE style_box_id = '$box_id'";

    if ($conn->query($sql) === TRUE) {
        // Update the style_img_url in the style table
        $sql_update_style = "UPDATE style SET style_img_url = '$img_url' WHERE style_id = (SELECT style_id FROM style_box WHERE style_box_id = '$box_id')";
        if ($conn->query($sql_update_style) === TRUE) {
            echo "";
        } else {
            echo "Error updating style_img_url: " . $conn->error;
        }
    } else {
        echo "Error updating record: " . $conn->error;
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
        <tbody id="boxTable">
            <?php 
            // Include database connection
            include '../pages/server/connection.php';

            $sql = "SELECT sb.*, s.* FROM style_box sb JOIN style s ON sb.style_id = s.style_id";
            $result = $conn->query($sql);

            // Display each box as a table row
            if ($result->num_rows > 0) {
                while($row = $result->fetch_assoc()) {
                    echo "<tr class='table_body align-middle text-center'>";
                    echo "<td class='item_img'><img src='../resources/".$row['style_img_url']."' alt='Box Image'></td>";
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
                    echo "<form class='form_style mx-3 my-3' method='POST'>";
                    echo "<div class='row mb-3'>";
                    echo "<div class='col-sm-6 form_style'>";
                    echo "<label for='box_id' class='form-label'>Box ID</label>";
                    echo "<input type='text' class='form-control focus-ring focus-ring-light' name='box_id_display' id='box_id_display' value='".$row['style_box_id']."' disabled>";
                    echo "<input type='hidden' name='box_id' id='box_id' value='".$row['style_box_id']."'>";
                    echo "</div>";
                    echo "<div class='col-sm-6 form_style'>";
                    echo "<label for='style' class='form-label'>Style</label>";
                    echo "<input type='text' name='style' value='".$row['style']."' class='form-control focus-ring focus-ring-light' disabled>";
                    echo "</div>";
                    echo "</div>";
                    echo "<div class='row mb-3'>";
                    echo "<div class='col-sm-6 form_style'>";
                    echo "<label for='price' class='form-label'>Price</label>";
                    echo "<input type='number' class='form-control focus-ring focus-ring-light' id='price' name='price' value='".$row['price']."'>";
                    echo "</div>";
                    echo "<div class='col-sm-6 form_style'>";
                    echo "<label for='unit_stock' class='form-label'>Unit in Stock</label>";
                    echo "<input type='number' class='form-control focus-ring focus-ring-light' id='unit_stock' name='unit_stock' value='".$row['stock_unit']."'>";
                    echo "</div>";
                    echo "</div>";
                    echo "<div class='row mb-3'>";
                    echo "<div class='col-sm-12 form_style'>";
                    echo "<label for='img_url' class='form-label'>Image URL</label>";
                    echo "<input type='text' class='form-control focus-ring focus-ring-light' id='img_url' name='img_url' value='".$row['style_img_url']."'>";
                    echo "</div>";
                    echo "</div>";
                    echo "<div class='mt-4 hstack gap-2 d-flex justify-content-end'>";
                    echo "<div class='gray_btn'>";
                    echo "<button type='button' class='btn btn-secondary rounded-1 border-0' data-bs-dismiss='modal'>Cancel</button>";
                    echo "</div>";
                    echo "<div class='gray_btn'>";
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

    
