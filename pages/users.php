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
        <div class="row mt-3">
            <!-- search bar -->   
            <div class="col-8 ms-auto search_input green_btn hstack gap-1 record_btn">
                <input id="searchInput" class="form-control me-2 rounded-1 focus-ring-light focus-ring" type="search" placeholder="Search by User ID or Username" aria-label="Search">
                <button class="btn btn-secondary border-0 rounded-1" id="search_btn" type="submit">Search</button>
            </div>
        </div>

        <div class="row mx-0 mt-4 p-2 card border-0 rounded-2">
            <table id="userTable" class="table shadow-md">
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
                    <!-- PHP code to fetch and display user data -->
                    <?php
                    // Include database connection
                    include ('server/connection.php');

                    // SQL query to fetch user data
                    $sql = "SELECT * FROM user";

                    // Execute the query
                    $result = $conn->query($sql);

                    // Check if there are any rows in the result
                    if ($result->num_rows > 0) {
                        // Loop through each row in the result
                        while($row = $result->fetch_assoc()) {
                            echo "<tr class='table_body align-middle text-center'>";
                            echo "<td scope='row'>" . $row["user_id"] . "</td>";
                            echo "<td>" . $row["username"] . "</td>";
                            echo "<td style='word-wrap: break-word;min-width: 160px;max-width: 160px;'>" . $row["email"] . "</td>";
                            echo "<td style='word-wrap: break-word;min-width: 160px;max-width: 160px;'>" . $row["password"] . "</td>";
                            echo "<td> " . $row["first_name"] . "</td>";
                            echo "<td>" . $row["last_name"] . "</td>";
                            echo "<td>" . $row["phone_number"] . "</td>";
                            echo "<td>" . $row["address"] . "</td>";
                            echo "<td style='word-wrap: break-word;min-width: 160px;max-width: 160px;'>" . $row["registration_date"] . "</td>";
                            // Actions column with delete button
                            echo "<td>";
                            echo "<div class='m-0 p-0 hstack gap-2 d-flex justify-content-center gray_btn'>";
                            echo "<form method='POST' action='server/delete_user.php'>";
                            echo "<input type='hidden' name='user_id' value='" . $row["user_id"] . "'>";
                            echo "<button type='submit' class='btn btn-danger rounded-1' name='delete_user'>Disable</button>";
                            echo "</form>";
                            echo "</div>";
                            echo "</td>";
                            echo "</tr>";
                        }
                    } else {
                        // If there are no rows in the result
                        echo "<tr><td colspan='10'>No user accounts available</td></tr>";
                    }
                    // Close the database connection
                    $conn->close();
                    ?>
                    <!-- End of PHP code -->
                </tbody>
            </table>
        </div>
    </div>

    <script>
    // JavaScript for filtering user table based on search input
    document.getElementById("searchInput").addEventListener("input", function() {
        var input, filter, table, tr, tdUserId, tdUsername, i, txtValueUserId, txtValueUsername;
        input = document.getElementById("searchInput");
        filter = input.value.toUpperCase();
        table = document.getElementById("userTable");
        tr = table.getElementsByTagName("tr");
        for (i = 0; i < tr.length; i++) {
            tdUserId = tr[i].getElementsByTagName("td")[0]; // User ID column (index 0)
            tdUsername = tr[i].getElementsByTagName("td")[1]; // Username column (index 1)
            if (tdUserId || tdUsername) {
                txtValueUserId = tdUserId.textContent || tdUserId.innerText;
                txtValueUsername = tdUsername.textContent || tdUsername.innerText;
                if (txtValueUserId.toUpperCase().indexOf(filter) > -1 || txtValueUsername.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    });
</script>
</body>
</html>