-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 19, 2024 at 06:20 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ukay_tamis`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `admin_role` enum('superadmin','admin') NOT NULL DEFAULT 'admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `password`, `admin_role`) VALUES
(1, 'admin1', 'password1', 'admin'),
(2, 'admin2', 'password2', 'admin'),
(3, 'admin3', 'password_3', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `item_id` varchar(10) NOT NULL,
  `style_id` varchar(10) DEFAULT NULL,
  `item_name` varchar(100) DEFAULT NULL,
  `item_description` varchar(255) DEFAULT NULL,
  `style` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `size` enum('XS','S','M','L','XL','XXL') DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `item_img_url` varchar(45) DEFAULT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `order_number` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`item_id`, `style_id`, `item_name`, `item_description`, `style`, `price`, `size`, `color`, `item_img_url`, `transaction_id`, `order_number`) VALUES
('item-00015', 'style-0001', 'Vintage Floral Blouse', 'Featuring delicate flower patterns and a classic silhouette, this blouse is perfect for adding a touch of nostalgia to your wardrobe.', 'Cottagecore', 229.00, 'XS', 'Brown', 'dress.jpg', NULL, NULL),
('item-00016', 'style-0001', 'Chunky Knit Sweater', 'Stay cozy and stylish in this chunky knit sweater. Made from soft and warm yarn, this sweater features a relaxed fit and a timeless cable knit design', 'Cottagecore', 339.00, 'M', 'Green', 'dress.jpg', NULL, NULL),
('item-00017', 'style-0002', 'Leopard Sunglasses', 'Featuring a timeless lace-up design and a durable rubber sole, these sneakers are perfect for everyday wear. ', 'Coquette', 79.00, 'L', 'Multicolor', 'dress.jpg', NULL, NULL);

--
-- Triggers `item`
--
DELIMITER $$
CREATE TRIGGER `generate_item_id` BEFORE INSERT ON `item` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    DECLARE new_item_id VARCHAR(10);
    
    -- Get the next sequence value
    INSERT INTO sequence VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    
    -- Generate the alphanumeric ID
    SET new_item_id = CONCAT('item-', LPAD(next_id, 5, '0'));
    
    -- Set the new item_id value
    SET NEW.item_id = new_item_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_order_number_item` BEFORE UPDATE ON `item` FOR EACH ROW BEGIN
    DECLARE order_number_val VARCHAR(20);
    
    -- Get the order_number corresponding to the updated transaction_id
    IF NEW.transaction_id IS NOT NULL THEN
        SELECT order_number INTO order_number_val
        FROM `transaction`
        WHERE transaction_id = NEW.transaction_id;
        
        -- Update the order_number column in the item table
        SET NEW.order_number = order_number_val;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_product`
--

CREATE TABLE `order_product` (
  `id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `item_id` varchar(10) DEFAULT NULL,
  `item_name` varchar(45) DEFAULT NULL,
  `item_price` int(11) DEFAULT NULL,
  `style_box_id` varchar(10) DEFAULT NULL,
  `style_box_name` varchar(45) DEFAULT NULL,
  `style_box_price` int(11) DEFAULT NULL,
  `style_box_quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL,
  `review` mediumtext DEFAULT NULL,
  `img_review` varchar(45) DEFAULT NULL,
  `user_id` varchar(10) DEFAULT NULL,
  `item_id` varchar(10) DEFAULT NULL,
  `style_box_id` varchar(10) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  `style_id` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `reviews`
--
DELIMITER $$
CREATE TRIGGER `generate_timestamp_and_update_style_id` BEFORE INSERT ON `reviews` FOR EACH ROW BEGIN


    -- Declare variable to store the fetched style_id
    DECLARE v_style_id VARCHAR(10);

    -- Fetch the corresponding style_id based on the inserted style_box_id
    SELECT style_id INTO v_style_id
    FROM style_box
    WHERE style_box_id = NEW.style_box_id;

    -- Update the style_id column in the inserted row with the fetched style_id
    SET NEW.style_id = v_style_id;
    
        -- Set the timestamp
    SET NEW.timestamp = NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `security_questions`
--

CREATE TABLE `security_questions` (
  `question_id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `security_questions`
--

INSERT INTO `security_questions` (`question_id`, `question`) VALUES
(1, 'What is your mother\'s maiden name?'),
(2, 'What is the name of your first pet?'),
(3, 'In which city were you born?'),
(4, 'What is the name of your favorite teacher?'),
(5, 'What is your favorite movie?'),
(6, 'What is your favorite food?'),
(7, 'What is the model of your first car?'),
(8, 'What is the name of your favorite book?'),
(9, 'What is the name of your childhood best friend?'),
(10, 'What is the brand of your first cellphone?');

-- --------------------------------------------------------

--
-- Table structure for table `sequence`
--

CREATE TABLE `sequence` (
  `sequence_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sequence`
--

INSERT INTO `sequence` (`sequence_id`) VALUES
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11);

-- --------------------------------------------------------

--
-- Table structure for table `style`
--

CREATE TABLE `style` (
  `style_id` varchar(10) NOT NULL,
  `style` varchar(50) DEFAULT NULL,
  `style_description` text DEFAULT NULL,
  `style_img_url` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `style`
--

INSERT INTO `style` (`style_id`, `style`, `style_description`, `style_img_url`) VALUES
('style-0001', 'Cottagecore', 'Embrace countryside charm with floral prints and rustic details.', 'cottagecore.jpg'),
('style-0002', 'Coquette', 'Channel elegance and femininity with lace and delicate fabrics.', 'coquette.jpg'),
('style-0003', 'Gothic Lolita', ' Explore dark whimsy with Victorian-inspired dresses.', 'gothic_lolita.jpg'),
('style-0004', 'Streetwear', 'Make a statement with bold graphics and urban designs.', 'streetwear.jpg'),
('style-0005', 'Y2K', 'Relive early 2000s nostalgia with shimmering metallic accents and playful, retro styles.', 'dress.jpg'),
('style-0006', 'Dark Academia', 'Dive into scholarly elegance with tweed and vintage pieces.', 'dress.jpg'),
('style-0007', 'Old Money', 'Elevate your look with timeless sophistication and classic silhouettes.', 'dress.jpg'),
('style-0008', 'Alt', 'Express your individuality with edgy punk and grunge influences.', 'dress.jpg'),
('style-0009', 'Indie', 'Embrace bohemian vibes with eclectic prints and laid-back styles.', 'dress.jpg'),
('style-0010', 'Star Girl', 'Reach for the stars with celestial prints and dreamy designs.', 'dress.jpg'),
('style-0068', 'Mystery', 'Random box for every occasion. Each surprise item is like reaching for the stars! ', 'mystery_box_logo2.png');

--
-- Triggers `style`
--
DELIMITER $$
CREATE TRIGGER `generate_style_id` BEFORE INSERT ON `style` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    DECLARE new_style_id VARCHAR(10);
    
    -- Get the next sequence value
    INSERT INTO sequence VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    
    -- Generate the alphanumeric ID
    SET new_style_id = CONCAT('style-', LPAD(next_id, 4, '0'));
    
    -- Set the new item_id value
    SET NEW.style_id = new_style_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `style_box`
--

CREATE TABLE `style_box` (
  `style_box_id` varchar(10) NOT NULL,
  `style_id` varchar(10) DEFAULT NULL,
  `style_box_description` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT 229.00,
  `stock_unit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `style_box`
--

INSERT INTO `style_box` (`style_box_id`, `style_id`, `style_box_description`, `price`, `stock_unit`) VALUES
('box-000019', 'style-0001', 'Embrace the charm of countryside living with Cottagecore fashion. Floral prints, flowing dresses, and rustic details create a whimsical and nostalgic look inspired by nature and traditional craftsmanship.', 229.00, 50),
('box-000020', 'style-0002', 'Channel elegance and femininity with Coquette fashion. Lace, bows, and delicate fabrics evoke a romantic and playful aesthetic, perfect for those who embrace their flirtatious side.', 229.00, 3),
('box-000021', 'style-0003', 'Explore the darker side of kawaii with Gothic Lolita fashion. Victorian-inspired dresses and doll-like accessories create a striking and elegant look that\'s both gothic and cute.', 229.00, NULL),
('box-000022', 'style-0004', 'Make a statement with Streetwear fashion. Bold graphics, casual silhouettes, and urban-inspired designs reflect the energy and creativity of city life, perfect for those who love to stand out.', 229.00, NULL),
('box-000023', 'style-0005', 'Embrace nostalgia with Y2K fashion. Low-rise jeans, metallic accents, and futuristic designs capture the spirit of the early 2000s, offering a playful and eclectic style for the modern era.', 229.00, NULL),
('box-000024', 'style-0006', 'Dive into the world of academia with Dark Academia fashion. Tweed blazers, turtleneck sweaters, and vintage-inspired pieces create a moody and scholarly look that\'s both intellectual and stylish.', 229.00, NULL),
('box-000025', 'style-0007', 'Elevate your wardrobe with Old Money fashion. Tailored suits, classic accessories, and timeless silhouettes exude elegance and sophistication, perfect for those with a taste for luxury.', 229.00, NULL),
('box-000026', 'style-0008', 'Express your individuality with Alt fashion. Punk, goth, and grunge influences combine for a non-conformist style that\'s bold, edgy, and unapologetically unique.', 229.00, NULL),
('box-000027', 'style-0009', 'Embrace bohemian vibes with Indie fashion. Vintage finds, eclectic prints, and handmade accessories create a laid-back and carefree look that\'s effortlessly cool.', 229.00, NULL),
('box-000028', 'style-0010', 'Reach for the stars with Star Girl fashion. Celestial prints, metallic accents, and futuristic designs capture the magic of the cosmos, offering a dreamy and ethereal style for stargazers and dreamers alike.', 229.00, NULL),
('box-000073', 'style-0068', 'Random box for mystery stuffs', 229.00, NULL);

--
-- Triggers `style_box`
--
DELIMITER $$
CREATE TRIGGER `generate_style_box_id` BEFORE INSERT ON `style_box` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    DECLARE new_style_box_id VARCHAR(10);
    
    -- Get the next sequence value
    INSERT INTO sequence VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    
    -- Generate the alphanumeric ID
    SET new_style_box_id = CONCAT('box-', LPAD(next_id, 6, '0'));
    
    -- Set the new item_id value
    SET NEW.style_box_id = new_style_box_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `style_box_details`
-- (See below for the actual view)
--
CREATE TABLE `style_box_details` (
`style_id` varchar(10)
,`style_box_id` varchar(10)
,`style` varchar(50)
,`style_description` text
,`style_box_description` varchar(255)
,`price` decimal(10,2)
,`style_img_url` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `style_box_transaction`
--

CREATE TABLE `style_box_transaction` (
  `style_box_id` varchar(10) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `order_number` varchar(20) DEFAULT NULL,
  `style_box_quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `style_box_transaction`
--
DELIMITER $$
CREATE TRIGGER `set_order_number` BEFORE INSERT ON `style_box_transaction` FOR EACH ROW BEGIN
    DECLARE order_number_val VARCHAR(20);
    
    -- Get the order_number corresponding to the inserted transaction_id
    SELECT order_number INTO order_number_val
    FROM `transaction`
    WHERE transaction_id = NEW.transaction_id;
    
    -- Set the order_number column in style_box_transaction
    SET NEW.order_number = order_number_val;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `subscription`
--

CREATE TABLE `subscription` (
  `sub_id` int(11) NOT NULL,
  `user_id` varchar(10) DEFAULT NULL,
  `plan_id` varchar(10) DEFAULT NULL,
  `sub_start_date` date DEFAULT NULL,
  `sub_end_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `subscription`
--
DELIMITER $$
CREATE TRIGGER `set_subscription_dates` BEFORE INSERT ON `subscription` FOR EACH ROW BEGIN
   
        -- Set sub_start_date to now
        SET NEW.sub_start_date = NOW();

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `subscription_plan`
--

CREATE TABLE `subscription_plan` (
  `plan_id` varchar(10) NOT NULL,
  `plan_tier` enum('Starter Pack','Fashionista Bundle','Wardrobe Refresh') DEFAULT NULL,
  `plan_duration` varchar(20) DEFAULT NULL,
  `plan_tier_description` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `monthly_price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subscription_plan`
--

INSERT INTO `subscription_plan` (`plan_id`, `plan_tier`, `plan_duration`, `plan_tier_description`, `price`, `monthly_price`) VALUES
('plan-00029', 'Starter Pack', '1 Month', 'Receive 2 curated tops and 1 curated bottom per month.', 249.00, 249.00),
('plan-00030', 'Starter Pack', '3 Months', 'Receive 2 curated tops and 1 curated bottom per month.', 699.00, 216.33),
('plan-00031', 'Starter Pack', '6 Months', 'Receive 2 curated tops and 1 curated bottom per month.', 1299.00, 199.83),
('plan-00032', 'Starter Pack', '12 Months', 'Receive 2 curated tops and 1 curated bottom per month.', NULL, NULL),
('plan-00033', 'Fashionista Bundle', '1 Month', 'Unlock 3 curated tops and 2 curated bottoms per month.', 349.00, 349.00),
('plan-00034', 'Fashionista Bundle', '3 Months', 'Unlock 3 curated tops and 2 curated bottoms per month.', 949.00, 316.33),
('plan-00035', 'Fashionista Bundle', '6 Months', 'Unlock 3 curated tops and 2 curated bottoms per month.', 1699.00, 283.17),
('plan-00036', 'Fashionista Bundle', '12 Months', 'Unlock 3 curated tops and 2 curated bottoms per month.', NULL, NULL),
('plan-00037', 'Wardrobe Refresh', '1 Month', 'Enjoy a generous selection of 4 curated tops and 3 curated bottoms per month.', 449.00, 449.00),
('plan-00038', 'Wardrobe Refresh', '3 Months', 'Enjoy a generous selection of 4 curated tops and 3 curated bottoms per month.', 1199.00, 383.00),
('plan-00039', 'Wardrobe Refresh', '6 Months', 'Enjoy a generous selection of 4 curated tops and 3 curated bottoms per month.', 2199.00, 366.50),
('plan-00040', 'Wardrobe Refresh', '12 Months', 'Enjoy a generous selection of 4 curated tops and 3 curated bottoms per month.', NULL, NULL);

--
-- Triggers `subscription_plan`
--
DELIMITER $$
CREATE TRIGGER `generate_plan_id` BEFORE INSERT ON `subscription_plan` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    DECLARE new_plan_id VARCHAR(10);
    
    -- Get the next sequence value
    INSERT INTO sequence VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    
    -- Generate the alphanumeric ID
    SET new_plan_id = CONCAT('plan-', LPAD(next_id, 5, '0'));
    
    -- Set the new item_id value
    SET NEW.plan_id = new_plan_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `transaction_id` int(11) NOT NULL,
  `order_number` varchar(20) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  `user_id` varchar(10) DEFAULT NULL,
  `shipping_fee` decimal(10,2) DEFAULT 100.00,
  `total_items` int(11) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `payment_method` enum('Cash on Delivery','GCash') DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `status` varchar(45) DEFAULT 'Processing'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `transaction`
--
DELIMITER $$
CREATE TRIGGER `generate_order_number_and_delivery_date` BEFORE INSERT ON `transaction` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    DECLARE new_order_number VARCHAR(20);
    
    -- Get the next sequence value
    INSERT INTO sequence VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    
    -- Generate the alphanumeric ID
    SET new_order_number = CONCAT('ORD-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(next_id, 7, '0'));
    
    -- Set the new order_number value
    SET NEW.order_number = new_order_number;
    
    -- Set the delivery_date 7 days after the transaction_date
    SET NEW.delivery_date = DATE_ADD(NOW(), INTERVAL 7 DAY);
    
    -- Set the timestamp
    SET NEW.timestamp = NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` varchar(10) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(500) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `registration_date` datetime DEFAULT current_timestamp(),
  `salt` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `username`, `email`, `password`, `first_name`, `last_name`, `phone_number`, `address`, `registration_date`, `salt`, `status`) VALUES
('user-00002', 'jkLover', 'bacodav896@syinxun.com', '054e3b308708370ea029dc2ebd1646c498d59d7203c9e1a44cf0484df98e581a', 'Joseph', 'Jungkook', '09175883947', 'Seoul', '2024-05-19 21:47:08', NULL, 'active'),
('user-00005', 'baconLover', 'bacon6@sryup', 'ed6337a2e299179937e6ac0cc2ac2d84b9ef69558ecdb8f27a1ec5e2c82b22fd', 'Alex', 'Riosa', '09175883947', 'Seoul', '2024-05-19 21:49:17', '75fa0a8190049acab646810241e561fd', 'active'),
('user-00008', 'pooLover', 'poo@poo', 'f7b5d49d8ea62ba619b433b65fd52c792ac613671d20a554f3ad592cae3d482f', 'Felix', 'Dantes', '09175883947', 'Seoul', '2024-05-19 21:51:10', 'c7ce9e9243b332878b1a69a4715024fa', 'active'),
('user-00330', 'Doe', 'dee@outlook.com', '9a900403ac313ba27a1bc81f0932652b8020dac92c234d98fa0b06bf0040ecfd', 'Douglas', 'Levi', '09468381717', 'Zone 8, Labnig, Malinao, Albay', '2024-05-14 14:56:39', NULL, 'active'),
('user-00375', 'Minnie', 'deedasdasd@outlook.com', '9a900403ac313ba27a1bc81f0932652b8020dac92c234d98fa0b06bf0040ecfd', 'Douglas', 'Levi', '09468381717', 'Sagpon, Daraga, Albay', '2024-05-16 10:27:42', NULL, 'active'),
('user-00391', 'Dawnut', 'dawnbdddc@gmail.com', '9a900403ac313ba27a1bc81f0932652b8020dac92c234d98fa0b06bf0040ecfd', 'Dawn', 'Bande', '09562849189', 'Zone 8, Labnig, Malinao, Albay', '2024-05-16 15:01:27', NULL, 'active');

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `generate_user_id` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    DECLARE new_user_id VARCHAR(10);
    
    -- Get the next sequence value
    INSERT INTO sequence VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    
    -- Generate the alphanumeric ID
    SET new_user_id = CONCAT('user-', LPAD(next_id, 5, '0'));
    
    -- Set the new item_id value
    SET NEW.user_id = new_user_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `user_AFTER_INSERT` AFTER INSERT ON `user` FOR EACH ROW BEGIN
	INSERT INTO user_logs (user_id, timestamp, action)
    VALUES (NEW.user_id, NOW(), 'signup');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_logs`
--

CREATE TABLE `user_logs` (
  `log_id` varchar(10) NOT NULL,
  `user_id` varchar(10) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `action` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_logs`
--

INSERT INTO `user_logs` (`log_id`, `user_id`, `timestamp`, `action`) VALUES
('logs-00003', 'user-00002', '2024-05-19 13:47:08', 'signup'),
('logs-00004', 'user-00002', '2024-05-19 13:48:14', 'logout'),
('logs-00006', 'user-00005', '2024-05-19 13:49:17', 'signup'),
('logs-00007', 'user-00005', '2024-05-19 13:49:21', 'logout'),
('logs-00009', 'user-00008', '2024-05-19 13:51:10', 'signup'),
('logs-00010', 'user-00008', '2024-05-19 13:52:07', 'logout'),
('logs-00011', 'user-00008', '2024-05-19 13:55:41', 'login');

--
-- Triggers `user_logs`
--
DELIMITER $$
CREATE TRIGGER `generate_log_id` BEFORE INSERT ON `user_logs` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    DECLARE new_log_id VARCHAR(10);
    
    -- Get the next sequence value
    INSERT INTO sequence VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    
    -- Generate the alphanumeric ID
    SET new_log_id = CONCAT('logs-', LPAD(next_id, 5, '0'));
    
    -- Set the new item_id value
    SET NEW.log_id = new_log_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_preference`
--

CREATE TABLE `user_preference` (
  `user_preference_id` varchar(10) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `height` int(11) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `bust_size` varchar(10) DEFAULT NULL,
  `hip_size` varchar(10) DEFAULT NULL,
  `shoe_size` varchar(5) DEFAULT NULL,
  `clothing_size` enum('XS','S','M','L','XL','XXL') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `user_preference`
--
DELIMITER $$
CREATE TRIGGER `generate_user_preference_id` BEFORE INSERT ON `user_preference` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    DECLARE new_user_preference_id VARCHAR(10);
    
    -- Get the next sequence value
    INSERT INTO sequence VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    
    -- Generate the alphanumeric ID
    SET new_user_preference_id = CONCAT('pref-', LPAD(next_id, 5, '0'));
    
    -- Set the new item_id value
    SET NEW.user_preference_id = new_user_preference_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_security_questions`
--

CREATE TABLE `user_security_questions` (
  `user_question_id` int(11) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `question_id` int(11) NOT NULL,
  `answer` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure for view `style_box_details`
--
DROP TABLE IF EXISTS `style_box_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `style_box_details`  AS SELECT `s`.`style_id` AS `style_id`, `sb`.`style_box_id` AS `style_box_id`, `s`.`style` AS `style`, `s`.`style_description` AS `style_description`, `sb`.`style_box_description` AS `style_box_description`, `sb`.`price` AS `price`, `s`.`style_img_url` AS `style_img_url` FROM (`style` `s` join `style_box` `sb` on(`s`.`style_id` = `sb`.`style_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `style_id` (`style_id`),
  ADD KEY `transaction_id` (`transaction_id`),
  ADD KEY `style` (`style`),
  ADD KEY `item_ibfk_3_idx` (`order_number`);

--
-- Indexes for table `order_product`
--
ALTER TABLE `order_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_order_product_item` (`item_id`),
  ADD KEY `fk_order_product_style_box` (`style_box_id`),
  ADD KEY `fk_order_product_transaction` (`transaction_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `fk_reviews_user_id` (`user_id`),
  ADD KEY `fk_reviews_item_id` (`item_id`),
  ADD KEY `fk_reviews_style_box_id` (`style_box_id`),
  ADD KEY `fk_reviews_style_id` (`style_id`);

--
-- Indexes for table `security_questions`
--
ALTER TABLE `security_questions`
  ADD PRIMARY KEY (`question_id`);

--
-- Indexes for table `sequence`
--
ALTER TABLE `sequence`
  ADD PRIMARY KEY (`sequence_id`);

--
-- Indexes for table `style`
--
ALTER TABLE `style`
  ADD PRIMARY KEY (`style_id`),
  ADD UNIQUE KEY `style_UNIQUE` (`style`);

--
-- Indexes for table `style_box`
--
ALTER TABLE `style_box`
  ADD PRIMARY KEY (`style_box_id`),
  ADD KEY `style_id` (`style_id`);

--
-- Indexes for table `style_box_transaction`
--
ALTER TABLE `style_box_transaction`
  ADD PRIMARY KEY (`style_box_id`,`transaction_id`),
  ADD KEY `style_box_transaction_ibfk_2_idx` (`transaction_id`),
  ADD KEY `style_box_transaction_ibfk_2_idx1` (`order_number`);

--
-- Indexes for table `subscription`
--
ALTER TABLE `subscription`
  ADD PRIMARY KEY (`sub_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `subscription_plan`
--
ALTER TABLE `subscription_plan`
  ADD PRIMARY KEY (`plan_id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD UNIQUE KEY `order_number_UNIQUE` (`order_number`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user_preference`
--
ALTER TABLE `user_preference`
  ADD PRIMARY KEY (`user_preference_id`),
  ADD KEY `user_preference_ibfk_1` (`user_id`);

--
-- Indexes for table `user_security_questions`
--
ALTER TABLE `user_security_questions`
  ADD PRIMARY KEY (`user_question_id`),
  ADD UNIQUE KEY `user_question_unique` (`user_id`,`question_id`),
  ADD KEY `fk_question_id` (`question_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `order_product`
--
ALTER TABLE `order_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `security_questions`
--
ALTER TABLE `security_questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `sequence`
--
ALTER TABLE `sequence`
  MODIFY `sequence_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `subscription`
--
ALTER TABLE `subscription`
  MODIFY `sub_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_security_questions`
--
ALTER TABLE `user_security_questions`
  MODIFY `user_question_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `item`
--
ALTER TABLE `item`
  ADD CONSTRAINT `item_ibfk_1` FOREIGN KEY (`style_id`) REFERENCES `style` (`style_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `item_ibfk_2` FOREIGN KEY (`style`) REFERENCES `style` (`style`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `item_ibfk_3` FOREIGN KEY (`order_number`) REFERENCES `transaction` (`order_number`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `order_product`
--
ALTER TABLE `order_product`
  ADD CONSTRAINT `fk_order_product_item` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_order_product_style_box` FOREIGN KEY (`style_box_id`) REFERENCES `style_box` (`style_box_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_order_product_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `transaction` (`transaction_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_reviews_item_id` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`),
  ADD CONSTRAINT `fk_reviews_style` FOREIGN KEY (`style_id`) REFERENCES `style` (`style_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_reviews_style_box_id` FOREIGN KEY (`style_box_id`) REFERENCES `style_box` (`style_box_id`),
  ADD CONSTRAINT `fk_reviews_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `style_box`
--
ALTER TABLE `style_box`
  ADD CONSTRAINT `style_box_ibfk_1` FOREIGN KEY (`style_id`) REFERENCES `style` (`style_id`);

--
-- Constraints for table `style_box_transaction`
--
ALTER TABLE `style_box_transaction`
  ADD CONSTRAINT `style_box_transaction_ibfk_1` FOREIGN KEY (`style_box_id`) REFERENCES `style_box` (`style_box_id`),
  ADD CONSTRAINT `style_box_transaction_ibfk_2` FOREIGN KEY (`order_number`) REFERENCES `transaction` (`order_number`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `subscription`
--
ALTER TABLE `subscription`
  ADD CONSTRAINT `subscription_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `subscription_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plan` (`plan_id`);

--
-- Constraints for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD CONSTRAINT `user_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `user_preference`
--
ALTER TABLE `user_preference`
  ADD CONSTRAINT `user_preference_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `user_security_questions`
--
ALTER TABLE `user_security_questions`
  ADD CONSTRAINT `fk_question_id` FOREIGN KEY (`question_id`) REFERENCES `security_questions` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
