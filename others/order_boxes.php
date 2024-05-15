<div class="row mx-0 mt-4 p-2 card border-0 rounded-2">
    <table class="table shadow-md">
        <thead class="">
            <tr class="table_head">
                <th scope="col">Transaction ID</th>
                <th scope="col">User ID</th>
                <th scope="col">Box ID</th>
                <th scope="col">Name</th>
                <th scope="col">Quantity</th>
                <th scope="col">Shipping Fee</th>
                <th scope="col">Total Price</th>
                <th scope="col">Payment Method</th>
                <th scope="col-1">Status</th>
                <th scope="col">Actions</th>
            </tr>
        </thead>
        <tbody>
            <!-- order details -->
            <tr class="table_body align-middle">
                <td scope="row" class="text-start">1234</td>
                <td class="text-start">1234</td>
                <td class="text-center">1234</td>
                <td class="text-center">Summer Fest</td>
                <td class="text-center">1</td>
                <td class="text-end">PHP 100</td>
                <td class="text-end fw-bold">PHP 600</td>
                <td class="text-center">GCash</td>
                <!-- order status -->
                <td class="text-center hstack gap-2 d-flex justify-content-center">
                    <form class="form_option">
                        <select id="status" class="form-select rounded-1" disabled>
                            <option selected>Pending</option>
                            <option value="1">Packed</option>
                            <option value="2">Shipped</option>
                        </select>
                    </form>
                </td>
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