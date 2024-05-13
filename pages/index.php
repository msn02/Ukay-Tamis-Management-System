<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="vi1ewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome Admins!</title>
    <?php include '../others/head_resource.php';?>
    <link rel="stylesheet" href="../css/login.css">
</head>
<body class="dark_bg">
    <div class="container-fluid mt-5">
        <div class="container text-center">
            <!-- header -->
            <div class="white_text pt-4">
                <h1 class="bold_text m-0 p-0 lh-1"><span class="green_highlight">UKAY</span> TAMIS</h1>
                <span class="subtext fw-bold"><p class="m-0 p-0">MANAGEMENT SYSTEM</p></span>
                <p class="mt-3 p-0">Version 1.0.0</p>
            </div>

            <!-- log in -->
            <div class="d-flex justify-content-center">
                <div class="card rounded-2 border-0 col-sm-3 py-5 px-4 mt-4">
                    <form class="form_style px-2" method="POST">
                        <h3 class="fw-bold mb-4">Admin Log in</h3>
                        <!-- user input -->
                        <div class="mb-3 text-start">
                            <label for="input_uname" class="form-label ms-1">Username</label>
                            <input type="text" class="form-control" id="input_uname" name = "username" placeholder="Enter your username" required>
                        </div>
                        <div class="mb-4 text-start">
                            <label for="input_pass" class="form-label ms-1">Password</label>
                            <input type="password" class="form-control" id="input_pass" name = "username" placeholder="Enter your password" required>
                        </div>
                        <!-- log in button -->
                        <div class="green_btn">
                            <button class="btn btn-dark px-4 border-0">Log in</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <footer class="white_text opacity-75 p-5">
                <p class=""><i class="bi bi-c-circle"></i>UKAY TAMIS 2024 | All Rights Reserved</p>
            </footer>
        </div>
    </div>
</body>
</html>