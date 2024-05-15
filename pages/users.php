<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ukay Tamis Management System</title>
    <?php include '../others/head_resource.php';?>
    <link rel="stylesheet" href="../css/users.css">
</head>
<body class="light_bg">
    <!-- navigation bar -->
    <?php include '../others/nav_bar.php';?>

    <div class="body_con p-5">
        <h2 class="fw-bold">USER ACCOUNTS</h2>
        <div class="row record_btn mt-3">
            <!-- options -->
            <div class="col">
            
            </div>
            <!-- searh bar -->   
            <div class="col-8 ms-auto search_input">
                <form action="" class="green_btn hstack">
                    <input class="form-control me-2 rounded-1 focus-ring-light focus-ring" type="search" placeholder="Search" aria-label="Search">
                    <button class="btn btn-secondary border-0 rounded-1" type="submit">Search</button>
                </form>
            </div>
        </div>

        <div class="row mx-0 mt-4 p-2 card border-0 rounded-2">
            <table class="table shadow-md">
                <thead class="">
                    <tr class="table_head">
                        <th scope="col">User ID</th>
                        <th scope="col">Username</th>
                        <th scope="col">Email</th>
                        <th scope="col">Password</th>
                        <th scope="col">First Name</th>
                        <th scope="col">Last Name</th>
                        <th scope="col">Phone Number</th>
                        <th scope="col">Address</th>
                        <th scope="col">Registration Date</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- user details -->
                    <tr class="table_body align-middle text-center">
                        <td scope="row">user-0000</td>
                        <td>user123</td>
                        <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">example@email.com</td>
                        <td>XXXXXXXXXX</td>
                        <td>Juan</td>
                        <td>Dela Cruz</td>
                        <td>09123456789</td>
                        <td>Daraga, Albay</td>
                        <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">XXXXXXXXXX</td>
                        <!-- actions -->
                        <td>
                            <div class="m-0 p-0 hstack gap-2 d-flex justify-content-center gray_btn">
                                <button class="btn btn-danger rounded-1"><i class="bi bi-trash3-fill"></i></button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>