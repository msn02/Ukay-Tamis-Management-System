-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 19, 2024 at 12:31 PM
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
('item-00286', NULL, 'Vintage Floral ', NULL, 'Cottagecore', 123.00, 'XL', 'Brown', NULL, NULL, NULL),
('item-00289', NULL, 'Vintage Floral ', NULL, 'Cottagecore', 123.00, 'XL', 'Brown', NULL, NULL, NULL);

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

--
-- Dumping data for table `order_product`
--

INSERT INTO `order_product` (`id`, `transaction_id`, `item_id`, `item_name`, `item_price`, `style_box_id`, `style_box_name`, `style_box_price`, `style_box_quantity`) VALUES
(10, 49, NULL, NULL, NULL, 'box-000019', 'Cottagecore', 229, 0),
(11, 50, NULL, NULL, NULL, 'box-000019', 'Cottagecore', 229, 1),
(12, 51, NULL, NULL, NULL, 'box-000020', 'Coquette', 229, 3),
(13, 51, NULL, NULL, NULL, 'box-000021', 'Gothic Lolita', 229, 3),
(14, 52, NULL, NULL, NULL, 'box-000073', 'Mystery', 229, 3),
(15, 53, NULL, NULL, NULL, 'box-000019', 'Cottagecore', 229, 2),
(16, 53, NULL, NULL, NULL, 'box-000073', 'Mystery', 229, 1),
(17, 55, NULL, NULL, NULL, 'box-000020', 'Coquette', 229, 2),
(20, 58, NULL, NULL, NULL, 'box-000019', 'Cottagecore', 229, 1),
(21, 59, NULL, NULL, NULL, 'box-000073', 'Mystery', 229, 3),
(22, 60, NULL, NULL, NULL, 'box-000021', 'Gothic Lolita', 229, 1),
(23, 61, NULL, NULL, NULL, 'box-000019', 'Cottagecore', 229, 3);

--
-- Triggers `order_product`
--
DELIMITER $$
CREATE TRIGGER `insert_and_update_order_info` AFTER INSERT ON `order_product` FOR EACH ROW BEGIN
    DECLARE order_number_val VARCHAR(20);
    
    -- Get the order_number corresponding to the inserted transaction_id
    SELECT order_number INTO order_number_val
    FROM `transaction`
    WHERE transaction_id = NEW.transaction_id;
    
    -- Insert data into style_box_transaction table
    INSERT INTO `style_box_transaction` (`style_box_id`, `transaction_id`, `style_box_quantity`, `order_number`)
    VALUES (NEW.style_box_id, NEW.transaction_id, NEW.style_box_quantity, order_number_val);
    
    -- Update the item table with the order_number and transaction_id
    UPDATE `item`
    SET order_number = order_number_val,
        transaction_id = NEW.transaction_id
    WHERE item_id = NEW.item_id;
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
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(15),
(16),
(17),
(19),
(20),
(21),
(22),
(23),
(24),
(25),
(26),
(27),
(28),
(29),
(30),
(31),
(32),
(33),
(34),
(35),
(36),
(37),
(38),
(39),
(40),
(41),
(42),
(43),
(44),
(47),
(48),
(49),
(50),
(51),
(54),
(55),
(56),
(57),
(58),
(59),
(60),
(61),
(62),
(63),
(64),
(65),
(66),
(67),
(68),
(69),
(70),
(71),
(72),
(73),
(74),
(75),
(76),
(77),
(78),
(79),
(80),
(81),
(82),
(83),
(84),
(85),
(86),
(87),
(88),
(89),
(90),
(91),
(92),
(93),
(94),
(95),
(96),
(97),
(98),
(99),
(100),
(101),
(102),
(103),
(104),
(105),
(106),
(107),
(108),
(109),
(110),
(111),
(112),
(113),
(114),
(115),
(116),
(117),
(118),
(119),
(120),
(121),
(122),
(123),
(124),
(125),
(126),
(127),
(128),
(129),
(130),
(131),
(132),
(133),
(134),
(135),
(136),
(137),
(138),
(139),
(140),
(141),
(142),
(143),
(144),
(145),
(146),
(147),
(148),
(149),
(150),
(151),
(152),
(153),
(154),
(155),
(156),
(157),
(158),
(159),
(160),
(161),
(162),
(163),
(164),
(165),
(166),
(169),
(170),
(171),
(172),
(173),
(174),
(175),
(176),
(177),
(178),
(179),
(180),
(186),
(187),
(188),
(189),
(190),
(191),
(192),
(193),
(194),
(195),
(196),
(197),
(198),
(199),
(200),
(201),
(202),
(203),
(204),
(205),
(206),
(207),
(212),
(213),
(214),
(215),
(218),
(219),
(220),
(221),
(222),
(223),
(224),
(225),
(226),
(227),
(228),
(229),
(230),
(231),
(232),
(233),
(234),
(235),
(236),
(237),
(238),
(239),
(240),
(241),
(242),
(243),
(244),
(245),
(246),
(247),
(248),
(249),
(250),
(251),
(252),
(253),
(254),
(255),
(256),
(257),
(258),
(259),
(260),
(261),
(262),
(263),
(264),
(265),
(266),
(267),
(268),
(269),
(270),
(271),
(272),
(273),
(274),
(275),
(276),
(277),
(278),
(279),
(280),
(281),
(282),
(283),
(284),
(285),
(286),
(287),
(288),
(289),
(290),
(291),
(292),
(293),
(294),
(295),
(296),
(297),
(298),
(299);

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
('style-0001', 'Cottagecore', 'Embrace countryside charm with floral prints and rustic details.', ''),
('style-0002', 'Coquette', 'Channel elegance and femininity with lace and delicate fabrics.', 'coquette.jpg'),
('style-0003', 'Gothic Lolita', ' Explore dark whimsy with Victorian-inspired dresses.', 'gothic_lolita.jpg'),
('style-0004', 'Streetwear', 'Make a statement with bold graphics and urban designs.', 'streetwear.jpg'),
('style-0005', 'Y2K', 'Relive early 2000s nostalgia with shimmering metallic accents and playful, retro styles.', ''),
('style-0006', 'Dark Academia', 'Dive into scholarly elegance with tweed and vintage pieces.', 'dress.jpg'),
('style-0007', 'Old Money', 'Elevate your look with timeless sophistication and classic silhouettes.', 'dress.jpg'),
('style-0008', 'Alt', 'Express your individuality with edgy punk and grunge influences.', 'dress.jpg'),
('style-0009', 'Indie', 'Embrace bohemian vibes with eclectic prints and laid-back styles.', 'dress.jpg'),
('style-0010', 'Star Girl', 'Reach for the stars with celestial prints and dreamy designs.', 'dress.jpg'),
('style-0068', 'Mystery', 'Random box', 'mystery_box_logo.png');

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
  `reviews` varchar(255) DEFAULT NULL,
  `stock_unit` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `style_box`
--

INSERT INTO `style_box` (`style_box_id`, `style_id`, `style_box_description`, `price`, `reviews`, `stock_unit`) VALUES
('box-000019', 'style-0001', 'Embrace the charm of countryside living with Cottagecore fashion. Floral prints, flowing dresses, and rustic details create a whimsical and nostalgic look inspired by nature and traditional craftsmanship.', 229.00, NULL, '126'),
('box-000020', 'style-0002', 'Channel elegance and femininity with Coquette fashion. Lace, bows, and delicate fabrics evoke a romantic and playful aesthetic, perfect for those who embrace their flirtatious side.', 209.00, NULL, '6'),
('box-000021', 'style-0003', 'Explore the darker side of kawaii with Gothic Lolita fashion. Victorian-inspired dresses and doll-like accessories create a striking and elegant look that\'s both gothic and cute.', 229.00, NULL, '4'),
('box-000022', 'style-0004', 'Make a statement with Streetwear fashion. Bold graphics, casual silhouettes, and urban-inspired designs reflect the energy and creativity of city life, perfect for those who love to stand out.', 229.00, NULL, NULL),
('box-000023', 'style-0005', 'Embrace nostalgia with Y2K fashion. Low-rise jeans, metallic accents, and futuristic designs capture the spirit of the early 2000s, offering a playful and eclectic style for the modern era.', 229.00, NULL, NULL),
('box-000024', 'style-0006', 'Dive into the world of academia with Dark Academia fashion. Tweed blazers, turtleneck sweaters, and vintage-inspired pieces create a moody and scholarly look that\'s both intellectual and stylish.', 229.00, NULL, NULL),
('box-000025', 'style-0007', 'Elevate your wardrobe with Old Money fashion. Tailored suits, classic accessories, and timeless silhouettes exude elegance and sophistication, perfect for those with a taste for luxury.', 229.00, NULL, NULL),
('box-000026', 'style-0008', 'Express your individuality with Alt fashion. Punk, goth, and grunge influences combine for a non-conformist style that\'s bold, edgy, and unapologetically unique.', 229.00, NULL, NULL),
('box-000027', 'style-0009', 'Embrace bohemian vibes with Indie fashion. Vintage finds, eclectic prints, and handmade accessories create a laid-back and carefree look that\'s effortlessly cool.', 229.00, NULL, NULL),
('box-000028', 'style-0010', 'Reach for the stars with Star Girl fashion. Celestial prints, metallic accents, and futuristic designs capture the magic of the cosmos, offering a dreamy and ethereal style for stargazers and dreamers alike.', 229.00, NULL, NULL),
('box-000073', 'style-0068', 'Random box for mystery stuffs', 229.00, 'Nice box, got good items out of it.', NULL),
('box-000283', 'style-0001', NULL, 234.00, NULL, '34'),
('box-000284', 'style-0005', NULL, 1234.00, NULL, '6'),
('box-000287', 'style-0005', NULL, 1239.00, NULL, '23456'),
('box-000288', 'style-0005', NULL, 2314.00, NULL, '56'),
('box-000292', 'style-0001', NULL, 123.00, NULL, '5'),
('box-000293', 'style-0001', NULL, 44444.00, NULL, '44444'),
('box-000294', 'style-0001', NULL, 44444.00, NULL, '44444'),
('box-000295', 'style-0005', NULL, 333333.00, NULL, '333333'),
('box-000296', 'style-0005', NULL, 333333.00, NULL, '333333'),
('box-000297', 'style-0005', NULL, 333333.00, NULL, '333333'),
('box-000298', 'style-0005', NULL, 12345678.00, NULL, '9999');

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
,`reviews` varchar(255)
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
-- Dumping data for table `style_box_transaction`
--

INSERT INTO `style_box_transaction` (`style_box_id`, `transaction_id`, `order_number`, `style_box_quantity`) VALUES
('box-000019', 0, 'ORD-20240512-0000191', 1),
('box-000019', 61, 'ORD-20240512-0000194', 3),
('box-000019', 73, 'ORD-20240513-0000215', 1),
('box-000021', 60, 'ORD-20240512-0000193', 1),
('box-000073', 0, 'ORD-20240512-0000192', 3),
('box-000073', 3, 'ORD-20240511-0000084', 2),
('box-000073', 17, NULL, 1),
('box-000073', 30, 'ORD-20240511-0000138', 1),
('box-000073', 66, NULL, 1),
('box-000073', 68, NULL, 3),
('box-000073', 70, 'ORD-20240512-0000203', 1);

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
  `sub_id` varchar(10) NOT NULL,
  `user_id` varchar(10) DEFAULT NULL,
  `plan_id` varchar(10) DEFAULT NULL,
  `sub_start_date` date DEFAULT NULL,
  `sub_end_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `subscription`
--
DELIMITER $$
CREATE TRIGGER `generate_sub_id` BEFORE INSERT ON `subscription` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    DECLARE new_sub_id VARCHAR(10);
    
    -- Get the next sequence value
    INSERT INTO sequence VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    
    -- Generate the alphanumeric ID
    SET new_sub_id = CONCAT('sub-', LPAD(next_id, 6, '0'));
    
    -- Set the new item_id value
    SET NEW.sub_id = new_sub_id;
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
  `plan_duration` enum('1 Month','3 Months','6 Months','12 Months') DEFAULT NULL,
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
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`transaction_id`, `order_number`, `timestamp`, `user_id`, `shipping_fee`, `total_items`, `total_price`, `payment_method`, `status`) VALUES
(1, 'ORD-20240511-0000080', '2024-05-11 11:41:38', 'user-00049', 100.00, 3, 1703.00, NULL, ''),
(2, 'ORD-20240511-0000082', '2024-05-11 11:41:38', 'user-00049', 100.00, 3, 1703.00, NULL, ''),
(3, 'ORD-20240511-0000084', '2024-05-11 11:41:38', 'user-00049', 100.00, 3, 1703.00, NULL, ''),
(4, 'ORD-20240511-0000086', '2024-05-11 11:41:38', 'user-00049', 100.00, 3, 1703.00, NULL, ''),
(5, 'ORD-20240511-0000088', '2024-05-11 11:43:32', 'user-00049', 100.00, 0, 100.00, 'Cash on Delivery', ''),
(6, 'ORD-20240511-0000090', '2024-05-11 11:50:07', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(7, 'ORD-20240511-0000092', '2024-05-11 11:50:07', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(8, 'ORD-20240511-0000094', '2024-05-11 11:54:24', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(9, 'ORD-20240511-0000096', '2024-05-11 11:54:24', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(10, 'ORD-20240511-0000098', '2024-05-11 11:55:12', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(11, 'ORD-20240511-0000100', '2024-05-11 11:55:12', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(12, 'ORD-20240511-0000102', '2024-05-11 11:57:40', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(13, 'ORD-20240511-0000104', '2024-05-11 11:57:40', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(14, 'ORD-20240511-0000106', '2024-05-11 12:00:54', 'user-00049', 100.00, 1, 329.00, 'GCash', ''),
(15, 'ORD-20240511-0000108', '2024-05-11 12:00:54', 'user-00049', 100.00, 1, 329.00, 'GCash', ''),
(16, 'ORD-20240511-0000110', '2024-05-11 12:01:41', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(17, 'ORD-20240511-0000112', '2024-05-11 12:01:41', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(18, 'ORD-20240511-0000114', '2024-05-11 12:04:50', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(19, 'ORD-20240511-0000116', '2024-05-11 12:08:07', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(20, 'ORD-20240511-0000118', '2024-05-11 12:08:07', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(21, 'ORD-20240511-0000120', '2024-05-11 12:08:07', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(22, 'ORD-20240511-0000122', '2024-05-11 12:09:26', 'user-00049', 100.00, 1, 329.00, 'GCash', ''),
(23, 'ORD-20240511-0000124', '2024-05-11 12:09:26', 'user-00049', 100.00, 1, 329.00, 'GCash', ''),
(24, 'ORD-20240511-0000126', '2024-05-11 12:23:06', 'user-00049', 100.00, 1, 329.00, 'GCash', ''),
(25, 'ORD-20240511-0000128', '2024-05-11 12:23:06', 'user-00049', 100.00, 1, 329.00, 'GCash', ''),
(26, 'ORD-20240511-0000130', '2024-05-11 12:24:38', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(27, 'ORD-20240511-0000132', '2024-05-11 12:24:38', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(28, 'ORD-20240511-0000134', '2024-05-11 12:25:53', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(29, 'ORD-20240511-0000136', '2024-05-11 12:25:53', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(30, 'ORD-20240511-0000138', '2024-05-11 12:26:42', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(31, 'ORD-20240511-0000140', '2024-05-11 12:26:42', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(32, 'ORD-20240511-0000142', '2024-05-11 12:27:39', 'user-00049', 100.00, 3, 787.00, 'GCash', ''),
(33, 'ORD-20240511-0000144', '2024-05-11 12:27:39', 'user-00049', 100.00, 3, 787.00, 'GCash', ''),
(34, 'ORD-20240511-0000146', '2024-05-11 12:28:50', 'user-00049', 100.00, 2, 558.00, 'Cash on Delivery', ''),
(35, 'ORD-20240511-0000148', '2024-05-11 12:31:00', 'user-00049', 100.00, 1, 329.00, 'GCash', ''),
(36, 'ORD-20240511-0000150', '2024-05-11 12:45:35', 'user-00049', 100.00, 2, 558.00, 'Cash on Delivery', ''),
(37, 'ORD-20240511-0000152', '2024-05-11 12:47:01', 'user-00049', 100.00, 3, 787.00, 'GCash', ''),
(38, 'ORD-20240511-0000154', '2024-05-11 12:49:32', 'user-00049', 100.00, 1, 329.00, 'GCash', ''),
(39, 'ORD-20240511-0000156', '2024-05-11 12:52:39', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(40, 'ORD-20240511-0000158', '2024-05-11 12:53:43', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(41, 'ORD-20240511-0000160', '2024-05-11 12:58:26', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(42, 'ORD-20240511-0000162', '2024-05-11 12:58:26', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(43, 'ORD-20240511-0000164', '2024-05-11 14:51:49', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(44, 'ORD-20240511-0000166', '2024-05-11 14:53:51', 'user-00049', 100.00, 2, 558.00, 'GCash', ''),
(47, 'ORD-20240511-0000170', '2024-05-11 15:50:55', 'user-00049', 100.00, 1, 229.00, 'GCash', 'Packed'),
(48, 'ORD-20240511-0000172', '2024-05-11 15:51:58', 'user-00049', 100.00, 2, 558.00, 'Cash on Delivery', ''),
(49, 'ORD-20240511-0000174', '2024-05-11 15:53:32', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', 'Packed'),
(50, 'ORD-20240512-0000176', '2024-05-11 16:05:32', 'user-00049', 100.00, 1, 329.00, 'GCash', 'Pending'),
(51, 'ORD-20240512-0000178', '2024-05-11 16:06:16', 'user-00049', 100.00, 6, 2161.00, 'Cash on Delivery', 'Shipped'),
(52, 'ORD-20240512-0000180', '2024-05-11 16:07:29', 'user-00049', 100.00, 3, 787.00, 'Cash on Delivery', ''),
(53, 'ORD-20240512-0000186', NULL, 'user-00049', 100.00, 3, 1245.00, 'GCash', ''),
(54, 'ORD-20240512-0000187', NULL, 'user-00049', 100.00, 0, 100.00, 'GCash', ''),
(55, 'ORD-20240512-0000188', NULL, 'user-00049', 100.00, 2, 558.00, 'Cash on Delivery', ''),
(56, 'ORD-20240512-0000189', NULL, 'user-00049', 100.00, 3, 787.00, 'GCash', ''),
(57, 'ORD-20240512-0000190', NULL, 'user-00049', 100.00, 1, 329.00, 'GCash', ''),
(58, 'ORD-20240512-0000191', NULL, 'user-00049', 100.00, 1, 329.00, 'GCash', ''),
(59, 'ORD-20240512-0000192', NULL, 'user-00049', 100.00, 3, 787.00, 'GCash', ''),
(60, 'ORD-20240512-0000193', NULL, 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(61, 'ORD-20240512-0000194', NULL, 'user-00049', 100.00, 3, 787.00, 'Cash on Delivery', 'Shipped'),
(62, 'ORD-20240512-0000195', NULL, 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(63, 'ORD-20240512-0000196', '2024-05-11 17:00:55', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(64, 'ORD-20240512-0000197', '2024-05-11 18:12:04', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(65, 'ORD-20240512-0000198', '2024-05-11 18:12:28', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(66, 'ORD-20240512-0000199', '2024-05-11 18:18:58', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(67, 'ORD-20240512-0000200', '2024-05-11 18:23:48', 'user-00049', 100.00, 3, 787.00, 'Cash on Delivery', ''),
(68, 'ORD-20240512-0000201', '2024-05-11 18:24:01', 'user-00049', 100.00, 3, 787.00, 'Cash on Delivery', ''),
(69, 'ORD-20240512-0000202', '2024-05-11 18:52:13', 'user-00049', 100.00, 1, 329.00, NULL, ''),
(70, 'ORD-20240512-0000203', '2024-05-11 18:53:29', 'user-00049', 100.00, 2, 897.00, 'Cash on Delivery', ''),
(71, 'ORD-20240513-0000213', '2024-05-12 17:55:48', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(72, 'ORD-20240513-0000214', '2024-05-12 17:55:48', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(73, 'ORD-20240513-0000215', '2024-05-12 17:56:36', 'user-00049', 100.00, 1, 329.00, 'Cash on Delivery', ''),
(74, 'ORD-20240514-0000278', '2024-05-14 15:20:46', NULL, 100.00, 1, 179.00, 'Cash on Delivery', '');

--
-- Triggers `transaction`
--
DELIMITER $$
CREATE TRIGGER `generate_order_number` BEFORE INSERT ON `transaction` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    DECLARE new_order_number VARCHAR(20);
    
    -- Get the next sequence value
    INSERT INTO sequence VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    
    -- Generate the alphanumeric ID
    SET new_order_number = CONCAT('ORD-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(next_id, 7, '0'));
    
    -- Set the new order_number value
    SET NEW.order_number = new_order_number, NEW.timestamp = NOW();
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
  `status` enum('active','inactive') DEFAULT 'active',
  `salt` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `username`, `email`, `password`, `first_name`, `last_name`, `phone_number`, `address`, `registration_date`, `status`, `salt`) VALUES
('tran-00041', 'dee', 'danielamarzan.cantillo@bicol-u.edu.ph', '25d55ad283aa400af464c76d713c07ad', 'Daniela', 'Cantillo', '09483340088', 'Zone 8 Labnig, Malinao, Albay', '2024-05-08 02:06:18', 'active', NULL),
('tran-00043', 'yes102', 'jessai@live.nl', 'e807f1fcf82d132f9bb018ca6738a19f', 'Jessai', 'Schonewille', '09483340088', 'BS Rollepaal, Dedemsvaart, Netherlands', '2024-05-08 02:06:18', 'inactive', NULL),
('user-00047', 'daniela', 'danielait@gmail.com', 'e807f1fcf82d132f9bb018ca6738a19f', 'Dee', 'Cantillo', '09483340088', 'Daraga, Albay', '2024-05-08 02:08:53', 'inactive', NULL),
('user-00049', 'MInzy', 'minzy19@gmail.com', 'e807f1fcf82d132f9bb018ca6738a19f', 'Minzy', 'Mendez', '09135902471', 'Zone 4 Bantayan, Tabaco City, Albay', '2024-05-08 02:59:40', 'inactive', NULL),
('user-00218', 'jkLover', 'jk@gmail.com', '65d671ec9787b32cfb7e33188be32ff7', 'Jeon', 'Jungkook', '09175883947', 'Seoul', '2024-05-14 00:39:43', 'inactive', NULL),
('user-00225', 'guest', 'bacodav896@syinxun.com', '3dbe00a167653a1aaee01d93e77e730e', 'Alex', 'aaaaa', '09175883947', 'Naga City', '2024-05-14 03:05:37', 'inactive', NULL),
('user-00228', 'vsefw', 'bacoda96@syinxun.com', 'e219b56989281a7846dd836161d7a2bd', 'Joseph', 'Jeon', '09175883947', 'Tabaco City', '2024-05-14 03:13:54', 'inactive', NULL),
('user-00231', 'guest3', 'fqwefe@fefe', '8ce87b8ec346ff4c80635f667d1592ae', 'Jeon', 'Jungkook', '09175883947', 'Seoul', '2024-05-14 03:15:44', 'active', NULL),
('user-00234', 'qwqr', 'jajedov542@syinxun.comqqw', '8ce87b8ec346ff4c80635f667d1592ae', 'Jeon', 'Jungkook', '09175883947', 'Seoul', '2024-05-14 03:22:06', 'active', NULL),
('user-00237', 'rwtw', 'jajedov542@syinxun.comqwqw', '8ce87b8ec346ff4c80635f667d1592ae', 'Alex', 'Jeon', '09175883947', 'Seoul', '2024-05-14 03:23:45', 'active', NULL),
('user-00240', 'jkLovereq', 'jajedov542@syinxun.com', '5313177b0a99d3daa526882318c05df6', 'Joseph', 'Jeon', '09175883947', 'Seoul', '2024-05-14 03:24:21', 'active', NULL),
('user-00243', 'guestrrw', 'jajedov542@syinxun.comqwqe', '8ce87b8ec346ff4c80635f667d1592ae', 'Alex', 'Jeon', '09175883947', 'Seoul', '2024-05-14 03:26:35', 'active', NULL),
('user-00246', 'guestqertth', 'josephbewq@3e', '7481678c27f3968c568fbfbd9f70ffa0', 'Alex', 'Jeon', '09175883947', 'Tabaco City', '2024-05-14 03:31:07', 'active', NULL),
('user-00249', 'wrrw', 'jajedov542@syinxun.comeqet3', '155c14766f5e35129b251aef1885a911', 'Joseph', 'Jeon', '09175883947', 'Seoul', '2024-05-14 03:32:34', 'active', NULL),
('user-00252', 'greagr', 'jajedov542@syinxun.com1tht', '8ce87b8ec346ff4c80635f667d1592ae', 'Alex', 'Jungkook', '09175883947', 'Seoul', '2024-05-14 03:37:58', 'active', NULL),
('user-00255', 'guestrw', 'bacodav896@syinxun.comqwrqwr', '04cac0540031555d7096726f9b3c0779', 'Alex', 'Jeon', '09175883947', 'Naga City', '2024-05-14 03:41:01', 'active', NULL),
('user-00258', 'guest42', 'fefe@fefe', '8ce87b8ec346ff4c80635f667d1592ae', 'Joseph', 'Jeon', '09175883947', 'Seoul', '2024-05-14 03:47:00', 'active', NULL),
('user-00261', '4141re', 'bacodav896@syinxun.com1441', '8ce87b8ec346ff4c80635f667d1592ae', 'Alex', 'Jeon', '09175883947', 'Seoul', '2024-05-14 03:52:22', 'active', NULL),
('user-00264', '2021-9576-3142727', 'josephrio@gregreg', '8ce87b8ec346ff4c80635f667d1592ae', 'Joseph', 'Jeon', '09175883947', 'Seoul', '2024-05-14 03:53:23', 'active', NULL),
('user-00267', 'guest243te', 'jajedov542@syinxun.com4114', '8ce87b8ec346ff4c80635f667d1592ae', 'Joseph', 'Jeon', '09175883947', 'Tabaco City', '2024-05-14 03:56:52', 'active', NULL),
('user-00270', '53refr', 'josephriosa12@gmail.com31', '8ce87b8ec346ff4c80635f667d1592ae', 'Jeon', 'Riosa', '09175883947', 'Tabaco City', '2024-05-14 04:28:38', 'active', NULL),
('user-00273', 'guestg34h5tenh', 'josephriosa12@gmail.com', '8ce87b8ec346ff4c80635f667d1592ae', 'Alex', 'Jeon', '09175883947', 'Naga City', '2024-05-14 04:43:13', 'active', NULL),
('user-00276', 'eqewvf', 'fefe@fefeqwq', '8ce87b8ec346ff4c80635f667d1592ae', 'Jeon', 'Riosa', '09175883947', 'Tabaco City', '2024-05-14 04:51:10', 'active', NULL),
('user-00280', '4q3reg', 'jajedov542@syinxun.com3r2', '054e3b308708370ea029dc2ebd1646c498d59d7203c9e1a44cf0484df98e581a', 'Joseph', 'Jeon', '09175883947', 'Tabaco City', '2024-05-15 13:58:00', 'active', NULL);

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
('tran-00042', 'tran-00041', '2024-05-07 18:06:18', 'signup'),
('tran-00044', 'tran-00043', '2024-05-07 18:06:18', 'signup'),
('tran-00048', 'user-00047', '2024-05-07 18:08:53', 'signup'),
('tran-00050', 'user-00049', '2024-05-07 18:59:40', 'signup'),
('tran-00054', 'user-00049', '2024-05-07 19:05:03', 'logout'),
('tran-00055', 'user-00049', '2024-05-07 19:06:09', 'login'),
('tran-00056', 'user-00049', '2024-05-07 19:06:11', 'logout'),
('tran-00057', 'user-00049', '2024-05-07 19:09:36', 'login'),
('tran-00058', 'user-00049', '2024-05-07 19:38:41', 'logout'),
('tran-00059', 'user-00049', '2024-05-07 19:40:59', 'login'),
('tran-00060', 'user-00049', '2024-05-07 19:46:08', 'logout'),
('tran-00061', 'user-00049', '2024-05-07 19:50:40', 'login'),
('tran-00062', 'user-00049', '2024-05-07 19:50:42', 'logout'),
('tran-00063', 'user-00049', '2024-05-07 19:52:44', 'login'),
('tran-00064', 'user-00049', '2024-05-07 20:28:45', 'logout'),
('tran-00065', 'user-00049', '2024-05-08 12:27:35', 'login'),
('tran-00066', 'user-00049', '2024-05-08 20:49:10', 'login'),
('tran-00067', 'user-00049', '2024-05-09 16:33:38', 'login'),
('tran-00069', 'user-00049', '2024-05-10 23:41:50', 'login'),
('tran-00072', 'user-00049', '2024-05-11 07:40:44', 'login'),
('tran-00074', 'user-00049', '2024-05-11 08:05:55', 'login'),
('tran-00075', 'user-00049', '2024-05-11 08:10:42', 'logout'),
('tran-00076', 'user-00049', '2024-05-11 08:10:49', 'login'),
('tran-00077', 'user-00049', '2024-05-11 10:01:31', 'logout'),
('tran-00078', 'user-00049', '2024-05-11 10:01:41', 'login'),
('tran-00204', 'user-00049', '2024-05-11 18:59:29', 'logout'),
('tran-00205', 'user-00049', '2024-05-12 06:03:25', 'login'),
('tran-00206', 'user-00049', '2024-05-12 06:03:32', 'logout'),
('tran-00207', 'user-00049', '2024-05-12 06:06:01', 'login'),
('tran-00219', 'user-00218', '2024-05-13 16:39:43', 'signup'),
('tran-00220', NULL, '2024-05-13 18:58:16', 'logout'),
('tran-00221', 'user-00218', '2024-05-13 18:58:31', 'login'),
('tran-00222', 'user-00218', '2024-05-13 18:59:10', 'logout'),
('tran-00223', 'user-00218', '2024-05-13 18:59:20', 'login'),
('tran-00224', 'user-00218', '2024-05-13 19:05:01', 'logout'),
('tran-00226', 'user-00225', '2024-05-13 19:05:37', 'signup'),
('tran-00227', NULL, '2024-05-13 19:12:54', 'logout'),
('tran-00229', 'user-00228', '2024-05-13 19:13:54', 'signup'),
('tran-00230', NULL, '2024-05-13 19:14:34', 'logout'),
('tran-00232', 'user-00231', '2024-05-13 19:15:44', 'signup'),
('tran-00233', NULL, '2024-05-13 19:21:24', 'logout'),
('tran-00235', 'user-00234', '2024-05-13 19:22:06', 'signup'),
('tran-00236', NULL, '2024-05-13 19:23:26', 'logout'),
('tran-00238', 'user-00237', '2024-05-13 19:23:45', 'signup'),
('tran-00239', NULL, '2024-05-13 19:24:03', 'logout'),
('tran-00241', 'user-00240', '2024-05-13 19:24:21', 'signup'),
('tran-00242', NULL, '2024-05-13 19:26:12', 'logout'),
('tran-00244', 'user-00243', '2024-05-13 19:26:35', 'signup'),
('tran-00245', NULL, '2024-05-13 19:30:29', 'logout'),
('tran-00247', 'user-00246', '2024-05-13 19:31:07', 'signup'),
('tran-00248', NULL, '2024-05-13 19:32:11', 'logout'),
('tran-00250', 'user-00249', '2024-05-13 19:32:34', 'signup'),
('tran-00251', NULL, '2024-05-13 19:37:31', 'logout'),
('tran-00253', 'user-00252', '2024-05-13 19:37:58', 'signup'),
('tran-00254', NULL, '2024-05-13 19:40:39', 'logout'),
('tran-00256', 'user-00255', '2024-05-13 19:41:01', 'signup'),
('tran-00257', NULL, '2024-05-13 19:46:27', 'logout'),
('tran-00259', 'user-00258', '2024-05-13 19:47:00', 'signup'),
('tran-00260', NULL, '2024-05-13 19:52:00', 'logout'),
('tran-00262', 'user-00261', '2024-05-13 19:52:22', 'signup'),
('tran-00263', NULL, '2024-05-13 19:52:58', 'logout'),
('tran-00265', 'user-00264', '2024-05-13 19:53:23', 'signup'),
('tran-00266', NULL, '2024-05-13 19:56:33', 'logout'),
('tran-00268', 'user-00267', '2024-05-13 19:56:52', 'signup'),
('tran-00269', NULL, '2024-05-13 20:28:02', 'logout'),
('tran-00271', 'user-00270', '2024-05-13 20:28:38', 'signup'),
('tran-00272', NULL, '2024-05-13 20:42:52', 'logout'),
('tran-00274', 'user-00273', '2024-05-13 20:43:13', 'signup'),
('tran-00275', NULL, '2024-05-13 20:50:53', 'logout'),
('tran-00277', 'user-00276', '2024-05-13 20:51:10', 'signup'),
('tran-00279', NULL, '2024-05-15 05:57:35', 'logout'),
('tran-00281', 'user-00280', '2024-05-15 05:58:00', 'signup');

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
    SET new_log_id = CONCAT('tran-', LPAD(next_id, 5, '0'));
    
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
  `height` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `bust_size` varchar(10) DEFAULT NULL,
  `hip_size` varchar(10) DEFAULT NULL,
  `shoe_size` varchar(5) DEFAULT NULL,
  `clothing_size` enum('XS','S','M','L','XL','XXL') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_preference`
--

INSERT INTO `user_preference` (`user_preference_id`, `user_id`, `height`, `weight`, `bust_size`, `hip_size`, `shoe_size`, `clothing_size`) VALUES
('pref-00212', 'user-00049', 233.00, 90.00, '23', '42', '18', 'XXL');

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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `style_box_details`  AS SELECT `s`.`style_id` AS `style_id`, `sb`.`style_box_id` AS `style_box_id`, `s`.`style` AS `style`, `s`.`style_description` AS `style_description`, `sb`.`style_box_description` AS `style_box_description`, `sb`.`price` AS `price`, `s`.`style_img_url` AS `style_img_url`, `sb`.`reviews` AS `reviews` FROM (`style` `s` join `style_box` `sb` on(`s`.`style_id` = `sb`.`style_id`)) ;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `security_questions`
--
ALTER TABLE `security_questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `sequence`
--
ALTER TABLE `sequence`
  MODIFY `sequence_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=300;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

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
