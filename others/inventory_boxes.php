<!-- box table -->
<div class="row mx-0 mt-4 p-2 card border-0 rounded-2" id="boxTable">
    <table class="table shadow-md">
        <thead class="">
            <tr class="table_head">
                <th scope="col-1">Image</th>
                <th scope="col-1">Box ID</th>
                <th scope="col-1">Box Name</th>
                <th scope="col-1">Style</th>
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
                <td>1</td>
                <td class="fw-bold">PHP 250</td>
                <!-- actions -->
                <td class="text-center">
                    <div class="m-0 p-0 hstack gap-2 d-flex justify-content-center gray_btn">
                        <!-- edit order status -->
                        <button id="edit_button" class="btn btn-secondary rounded-1"><i class="bi bi-pencil-square"></i></button>
                        <!-- delete order -->
                        <button class="btn btn-danger rounded-1"><i class="bi bi-trash3-fill"></i></button>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
</div>