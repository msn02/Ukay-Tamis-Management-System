<?php
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT); // Set MySQLi to throw exceptions

    try {
        // Database configuration
        $servername = "localhost";
        $username = "root";
        $password = "";
        $dbname = "ukay_tamis";

        // Create connection
        $conn = new mysqli($servername, $username, $password, $dbname);

        // Check connection
        if ($conn->connect_error) {
            die("Connection failed: ". $conn->connect_error);
        }
        $DatabaseAvailable = true;
    } catch (mysqli_sql_exception $e) {
        $DatabaseAvailable = false;
    }

    // Check if the database is available
    if (!$DatabaseAvailable) {
    ?><h2>The website is still under construction. We'll be right back soon!</h2><?php
        die();
    }
?>