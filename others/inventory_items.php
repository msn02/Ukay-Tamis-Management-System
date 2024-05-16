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
            <!-- product details -->
            <tr class="table_body align-middle text-center text_wrap">
                <!-- product image -->
                <td class="item_img">
                    <img src="../resources/summer_fest2.png" class="rounded-2" alt="">
                </td>
                <td>1234</td>
                <td class="lh-sm text-start" style="word-wrap: break-word;min-width: 160px;max-width: 160px;">Lorem ipsum dolor sit amet</td>
                <td>Cottagecore</td>
                <td>XXL</td>
                <td>Nude</td>
                <td>1</td>
                <td class="fw-bold">PHP 250</td>
                <!-- actions -->
                <td class="text-center">
                    <div class="m-0 p-0 hstack gap-2 d-flex justify-content-center gray_btn">
                        <!-- edit order status -->
                        <button class="btn btn-secondary rounded-1" data-bs-toggle="modal" data-bs-target="#edit_items"><i class="bi bi-pencil-square"></i></button>
                        <!-- delete order -->
                        <button class="btn btn-danger rounded-1"><i class="bi bi-trash3-fill"></i></button>
                    </div>
                </td>
            </tr>
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
                <form class="form_style p-3 m-0">
                    <!-- item id and style -->
                    <div class="row mb-3">
                        <div class="col-sm-6">
                            <label for="item_id" class="form-label ms-1">Item ID</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" id="item_id" placeholder="item-XXXX">
                        </div>
                        <div class="col-sm-6">
                            <label for="style" class="form-label ms-1">Style</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" id="style" placeholder="">
                        </div>
                    </div>
                    <!-- item name -->
                    <div class="row mb-3">
                        <div class="col-sm-12">
                            <label for="item_name" class="form-label ms-1">Item Name</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" id="item_name" placeholder="">
                        </div>
                    </div>
                    <!-- size and color -->
                    <div class="row mb-3">
                        <div class="col-sm-6 form_option">
                            <label for="size" class="form-label ms-1">Size</label>
                            <select id="size" class="form-select" aria-label="Default select example">
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
                            <input type="text" class="form-control focus-ring focus-ring-light" id="color" placeholder="">
                        </div>
                    </div>
                    <!-- stocks and price -->
                    <div class="row mb-3">
                        <div class="col-sm-6">
                            <label for="unit_stock" class="form-label ms-1">Unit in Stock</label>
                            <input type="number" class="form-control focus-ring focus-ring-light" id="unit_stock" placeholder="">
                        </div>
                        <div class="col-sm-6">
                            <label for="price" class="form-label ms-1">Price</label>
                            <input type="number" class="form-control focus-ring focus-ring-light" id="price" placeholder="">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-12">
                            <label for="img_url" class="form-label ms-1">Image URL</label>
                            <input type="text" class="form-control focus-ring focus-ring-light" id="img_url" placeholder="">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <div class="gray_btn">
                    <button type="button" class="btn btn-secondary rounded-1 border-0" data-bs-dismiss="modal">Cancel</button>
                </div>
                <div class="green_btn">
                    <button type="button" class="btn btn-dark rounded-1 border-0">Save Changes</button>
                </div>
            </div>
        </div>
    </div>
</div>