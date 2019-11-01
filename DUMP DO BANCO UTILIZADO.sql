-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 01-Nov-2019 às 23:53
-- Versão do servidor: 10.1.19-MariaDB
-- PHP Version: 7.0.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `editora`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `f_data_lancamento` (`dl` DATE, `n` INT) RETURNS DATE BEGIN
declare d date;
declare dt date;
declare i int;
declare r int;
select id into r from calendario where `data` = dl;
set i = r-n;
select `data` into dt from calendario where id = i;
RETURN dt;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `boneca`
--

CREATE TABLE `boneca` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `boneca`
--

INSERT INTO `boneca` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', 'Wednesday, 13 de November de 2019', '2019-11-13', 'Monday, 17 de February de 2020', '2020-02-17', b'1', 'Monday, 14 de October de 2019', '2019-10-14', 'ANTES DO PRAZO'),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', 'Tuesday, 25 de June de 2019', '2019-06-25', 'Wednesday, 25 de September de 2019', '2019-09-25', b'1', 'Monday, 14 de October de 2019', '2019-10-14', 'DEPOIS DO PRAZO'),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 03 de October de 2019', '2019-10-03', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 03 de October de 2019', '2019-10-03', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', 'Thursday, 04 de July de 2019', '2019-07-04', 'Friday, 04 de October de 2019', '2019-10-04', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', 'Wednesday, 31 de July de 2019', '2019-07-31', 'Wednesday, 02 de October de 2019', '2019-10-02', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', 'Wednesday, 10 de July de 2019', '2019-07-10', 'Thursday, 10 de October de 2019', '2019-10-10', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', 'Tuesday, 02 de July de 2019', '2019-07-02', 'Wednesday, 02 de October de 2019', '2019-10-02', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 03 de October de 2019', '2019-10-03', b'0', NULL, NULL, NULL);

--
-- Acionadores `boneca`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_boneca` BEFORE UPDATE ON `boneca` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_boneca` BEFORE INSERT ON `boneca` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `calendario`
--

CREATE TABLE `calendario` (
  `id` int(11) NOT NULL,
  `data` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `calendario`
--

INSERT INTO `calendario` (`id`, `data`) VALUES
(1, '2019-01-02'),
(2, '2019-01-03'),
(3, '2019-01-04'),
(4, '2019-01-07'),
(5, '2019-01-08'),
(6, '2019-01-09'),
(7, '2019-01-10'),
(8, '2019-01-11'),
(9, '2019-01-14'),
(10, '2019-01-15'),
(11, '2019-01-16'),
(12, '2019-01-17'),
(13, '2019-01-18'),
(14, '2019-01-21'),
(15, '2019-01-22'),
(16, '2019-01-23'),
(17, '2019-01-24'),
(18, '2019-01-25'),
(19, '2019-01-28'),
(20, '2019-01-29'),
(21, '2019-01-30'),
(22, '2019-01-31'),
(23, '2019-02-01'),
(24, '2019-02-04'),
(25, '2019-02-05'),
(26, '2019-02-06'),
(27, '2019-02-07'),
(28, '2019-02-08'),
(29, '2019-02-11'),
(30, '2019-02-12'),
(31, '2019-02-13'),
(32, '2019-02-14'),
(33, '2019-02-15'),
(34, '2019-02-18'),
(35, '2019-02-19'),
(36, '2019-02-20'),
(37, '2019-02-21'),
(38, '2019-02-22'),
(39, '2019-02-26'),
(40, '2019-02-27'),
(41, '2019-02-28'),
(42, '2019-03-01'),
(43, '2019-03-04'),
(44, '2019-03-05'),
(45, '2019-03-07'),
(46, '2019-03-08'),
(47, '2019-03-11'),
(48, '2019-03-12'),
(49, '2019-03-13'),
(50, '2019-03-14'),
(51, '2019-03-15'),
(52, '2019-03-18'),
(53, '2019-03-19'),
(54, '2019-03-20'),
(55, '2019-03-21'),
(56, '2019-03-22'),
(57, '2019-03-25'),
(58, '2019-03-26'),
(59, '2019-03-27'),
(60, '2019-03-28'),
(61, '2019-03-29'),
(62, '2019-04-01'),
(63, '2019-04-02'),
(64, '2019-04-03'),
(65, '2019-04-04'),
(66, '2019-04-05'),
(67, '2019-04-08'),
(68, '2019-04-09'),
(69, '2019-04-11'),
(70, '2019-04-12'),
(71, '2019-04-15'),
(72, '2019-04-16'),
(73, '2019-04-17'),
(74, '2019-04-18'),
(75, '2019-04-19'),
(76, '2019-04-22'),
(77, '2019-04-23'),
(78, '2019-04-24'),
(79, '2019-04-25'),
(80, '2019-04-26'),
(81, '2019-04-29'),
(82, '2019-04-30'),
(83, '2019-05-02'),
(84, '2019-05-03'),
(85, '2019-05-06'),
(86, '2019-05-07'),
(87, '2019-05-08'),
(88, '2019-05-09'),
(89, '2019-05-10'),
(90, '2019-05-13'),
(91, '2019-05-14'),
(92, '2019-05-15'),
(93, '2019-05-16'),
(94, '2019-05-17'),
(95, '2019-05-20'),
(96, '2019-05-21'),
(97, '2019-05-22'),
(98, '2019-05-23'),
(99, '2019-05-24'),
(100, '2019-05-27'),
(101, '2019-05-28'),
(102, '2019-05-29'),
(103, '2019-05-30'),
(104, '2019-05-31'),
(105, '2019-06-03'),
(106, '2019-06-04'),
(107, '2019-06-05'),
(108, '2019-06-06'),
(109, '2019-06-07'),
(110, '2019-06-10'),
(111, '2019-06-12'),
(112, '2019-06-13'),
(113, '2019-06-14'),
(114, '2019-06-17'),
(115, '2019-06-18'),
(116, '2019-06-19'),
(117, '2019-06-20'),
(118, '2019-06-21'),
(119, '2019-06-24'),
(120, '2019-06-25'),
(121, '2019-06-26'),
(122, '2019-06-27'),
(123, '2019-06-28'),
(124, '2019-07-01'),
(125, '2019-07-02'),
(126, '2019-07-03'),
(127, '2019-07-04'),
(128, '2019-07-05'),
(129, '2019-07-08'),
(130, '2019-07-09'),
(131, '2019-07-10'),
(132, '2019-07-11'),
(133, '2019-07-12'),
(134, '2019-07-15'),
(135, '2019-07-16'),
(136, '2019-07-18'),
(137, '2019-07-19'),
(138, '2019-07-22'),
(139, '2019-07-23'),
(140, '2019-07-24'),
(141, '2019-07-25'),
(142, '2019-07-26'),
(143, '2019-07-29'),
(144, '2019-07-30'),
(145, '2019-07-31'),
(146, '2019-08-01'),
(147, '2019-08-02'),
(148, '2019-08-05'),
(149, '2019-08-06'),
(150, '2019-08-07'),
(151, '2019-08-08'),
(152, '2019-08-09'),
(153, '2019-08-12'),
(154, '2019-08-13'),
(155, '2019-08-14'),
(156, '2019-08-15'),
(157, '2019-08-16'),
(158, '2019-08-19'),
(159, '2019-08-20'),
(160, '2019-08-21'),
(161, '2019-08-22'),
(162, '2019-08-23'),
(163, '2019-08-26'),
(164, '2019-08-27'),
(165, '2019-08-28'),
(166, '2019-08-29'),
(167, '2019-08-30'),
(168, '2019-09-02'),
(169, '2019-09-03'),
(170, '2019-09-04'),
(171, '2019-09-05'),
(172, '2019-09-06'),
(173, '2019-09-09'),
(174, '2019-09-10'),
(175, '2019-09-11'),
(176, '2019-09-12'),
(177, '2019-09-13'),
(178, '2019-09-16'),
(179, '2019-09-17'),
(180, '2019-09-18'),
(181, '2019-09-19'),
(182, '2019-09-20'),
(183, '2019-09-23'),
(184, '2019-09-24'),
(185, '2019-09-25'),
(186, '2019-09-26'),
(187, '2019-09-27'),
(188, '2019-09-30'),
(189, '2019-10-01'),
(190, '2019-10-02'),
(191, '2019-10-03'),
(192, '2019-10-04'),
(193, '2019-10-07'),
(194, '2019-10-08'),
(195, '2019-10-09'),
(196, '2019-10-10'),
(197, '2019-10-11'),
(198, '2019-10-14'),
(199, '2019-10-15'),
(200, '2019-10-16'),
(201, '2019-10-17'),
(202, '2019-10-18'),
(203, '2019-10-21'),
(204, '2019-10-22'),
(205, '2019-10-23'),
(206, '2019-10-24'),
(207, '2019-10-25'),
(208, '2019-10-29'),
(209, '2019-10-30'),
(210, '2019-10-31'),
(211, '2019-11-01'),
(212, '2019-11-04'),
(213, '2019-11-05'),
(214, '2019-11-06'),
(215, '2019-11-07'),
(216, '2019-11-08'),
(217, '2019-11-11'),
(218, '2019-11-12'),
(219, '2019-11-13'),
(220, '2019-11-14'),
(221, '2019-11-18'),
(222, '2019-11-19'),
(223, '2019-11-20'),
(224, '2019-11-21'),
(225, '2019-11-22'),
(226, '2019-11-25'),
(227, '2019-11-26'),
(228, '2019-11-27'),
(229, '2019-11-28'),
(230, '2019-11-29'),
(231, '2019-12-02'),
(232, '2019-12-03'),
(233, '2019-12-04'),
(234, '2019-12-05'),
(235, '2019-12-06'),
(236, '2019-12-09'),
(237, '2019-12-10'),
(238, '2019-12-11'),
(239, '2019-12-12'),
(240, '2019-12-13'),
(241, '2019-12-16'),
(242, '2019-12-17'),
(243, '2019-12-18'),
(244, '2019-12-19'),
(245, '2019-12-20'),
(246, '2019-12-23'),
(247, '2019-12-24'),
(248, '2019-12-26'),
(249, '2019-12-27'),
(250, '2019-12-30'),
(251, '2019-12-31'),
(252, '2020-01-02'),
(253, '2020-01-03'),
(254, '2020-01-06'),
(255, '2020-01-07'),
(256, '2020-01-08'),
(257, '2020-01-09'),
(258, '2020-01-10'),
(259, '2020-01-13'),
(260, '2020-01-14'),
(261, '2020-01-15'),
(262, '2020-01-16'),
(263, '2020-01-17'),
(264, '2020-01-20'),
(265, '2020-01-21'),
(266, '2020-01-22'),
(267, '2020-01-23'),
(268, '2020-01-24'),
(269, '2020-01-27'),
(270, '2020-01-28'),
(271, '2020-01-29'),
(272, '2020-01-30'),
(273, '2020-01-31'),
(274, '2020-02-03'),
(275, '2020-02-04'),
(276, '2020-02-05'),
(277, '2020-02-06'),
(278, '2020-02-07'),
(279, '2020-02-10'),
(280, '2020-02-11'),
(281, '2020-02-12'),
(282, '2020-02-13'),
(283, '2020-02-14'),
(284, '2020-02-17'),
(285, '2020-02-18'),
(286, '2020-02-19'),
(287, '2020-02-20'),
(288, '2020-02-21'),
(289, '2020-02-26'),
(290, '2020-02-27'),
(291, '2020-02-28'),
(292, '2020-03-02'),
(293, '2020-03-03'),
(294, '2020-03-04'),
(295, '2020-03-05'),
(296, '2020-03-09'),
(297, '2020-03-10'),
(298, '2020-03-11'),
(299, '2020-03-12'),
(300, '2020-03-13'),
(301, '2020-03-16'),
(302, '2020-03-17'),
(303, '2020-03-18'),
(304, '2020-03-19'),
(305, '2020-03-20'),
(306, '2020-03-23'),
(307, '2020-03-24'),
(308, '2020-03-25'),
(309, '2020-03-26'),
(310, '2020-03-27'),
(311, '2020-03-30'),
(312, '2020-03-31'),
(313, '2020-04-01'),
(314, '2020-04-02'),
(315, '2020-04-03'),
(316, '2020-04-06'),
(317, '2020-04-07'),
(318, '2020-04-08'),
(319, '2020-04-09'),
(320, '2020-04-13'),
(321, '2020-04-14'),
(322, '2020-04-15'),
(323, '2020-04-16'),
(324, '2020-04-17'),
(325, '2020-04-20'),
(326, '2020-04-22'),
(327, '2020-04-23'),
(328, '2020-04-24'),
(329, '2020-04-27'),
(330, '2020-04-28'),
(331, '2020-04-29'),
(332, '2020-04-30'),
(333, '2020-05-04'),
(334, '2020-05-05'),
(335, '2020-05-06'),
(336, '2020-05-07'),
(337, '2020-05-08'),
(338, '2020-05-11'),
(339, '2020-05-12'),
(340, '2020-05-13'),
(341, '2020-05-14'),
(342, '2020-05-15'),
(343, '2020-05-18'),
(344, '2020-05-19'),
(345, '2020-05-20'),
(346, '2020-05-21'),
(347, '2020-05-22'),
(348, '2020-05-25'),
(349, '2020-05-26'),
(350, '2020-05-27'),
(351, '2020-05-28'),
(352, '2020-05-29'),
(353, '2020-06-01'),
(354, '2020-06-02'),
(355, '2020-06-03'),
(356, '2020-06-04'),
(357, '2020-06-05'),
(358, '2020-06-08'),
(359, '2020-06-09'),
(360, '2020-06-10'),
(361, '2020-06-12'),
(362, '2020-06-15'),
(363, '2020-06-16'),
(364, '2020-06-17'),
(365, '2020-06-18'),
(366, '2020-06-19'),
(367, '2020-06-22'),
(368, '2020-06-23'),
(369, '2020-06-24'),
(370, '2020-06-25'),
(371, '2020-06-26'),
(372, '2020-06-29'),
(373, '2020-06-30'),
(374, '2020-07-01'),
(375, '2020-07-02'),
(376, '2020-07-03'),
(377, '2020-07-06'),
(378, '2020-07-07'),
(379, '2020-07-08'),
(380, '2020-07-09'),
(381, '2020-07-10'),
(382, '2020-07-13'),
(383, '2020-07-14'),
(384, '2020-07-15'),
(385, '2020-07-16'),
(386, '2020-07-20'),
(387, '2020-07-21'),
(388, '2020-07-22'),
(389, '2020-07-23'),
(390, '2020-07-24'),
(391, '2020-07-27'),
(392, '2020-07-28'),
(393, '2020-07-29'),
(394, '2020-07-30'),
(395, '2020-07-31'),
(396, '2020-08-03'),
(397, '2020-08-04'),
(398, '2020-08-05'),
(399, '2020-08-06'),
(400, '2020-08-07'),
(401, '2020-08-10'),
(402, '2020-08-11'),
(403, '2020-08-12'),
(404, '2020-08-13'),
(405, '2020-08-14'),
(406, '2020-08-17'),
(407, '2020-08-18'),
(408, '2020-08-19'),
(409, '2020-08-20'),
(410, '2020-08-21'),
(411, '2020-08-24'),
(412, '2020-08-25'),
(413, '2020-08-26'),
(414, '2020-08-27'),
(415, '2020-08-28'),
(416, '2020-08-31'),
(417, '2020-09-01'),
(418, '2020-09-02'),
(419, '2020-09-03'),
(420, '2020-09-04'),
(421, '2020-09-08'),
(422, '2020-09-09'),
(423, '2020-09-10'),
(424, '2020-09-11'),
(425, '2020-09-14'),
(426, '2020-09-15'),
(427, '2020-09-16'),
(428, '2020-09-17'),
(429, '2020-09-18'),
(430, '2020-09-21'),
(431, '2020-09-22'),
(432, '2020-09-23'),
(433, '2020-09-24'),
(434, '2020-09-25'),
(435, '2020-09-28'),
(436, '2020-09-29'),
(437, '2020-09-30'),
(438, '2020-10-01'),
(439, '2020-10-02'),
(440, '2020-10-05'),
(441, '2020-10-06'),
(442, '2020-10-07'),
(443, '2020-10-08'),
(444, '2020-10-09'),
(445, '2020-10-13'),
(446, '2020-10-14'),
(447, '2020-10-15'),
(448, '2020-10-16'),
(449, '2020-10-19'),
(450, '2020-10-20'),
(451, '2020-10-21'),
(452, '2020-10-22'),
(453, '2020-10-23'),
(454, '2020-10-26'),
(455, '2020-10-27'),
(456, '2020-10-29'),
(457, '2020-10-30'),
(458, '2020-11-03'),
(459, '2020-11-04'),
(460, '2020-11-05'),
(461, '2020-11-06'),
(462, '2020-11-09'),
(463, '2020-11-10'),
(464, '2020-11-11'),
(465, '2020-11-12'),
(466, '2020-11-13'),
(467, '2020-11-16'),
(468, '2020-11-17'),
(469, '2020-11-18'),
(470, '2020-11-19'),
(471, '2020-11-20'),
(472, '2020-11-23'),
(473, '2020-11-24'),
(474, '2020-11-25'),
(475, '2020-11-26'),
(476, '2020-11-27'),
(477, '2020-11-30'),
(478, '2020-12-01'),
(479, '2020-12-02'),
(480, '2020-12-03'),
(481, '2020-12-04'),
(482, '2020-12-07'),
(483, '2020-12-09'),
(484, '2020-12-10'),
(485, '2020-12-11'),
(486, '2020-12-14'),
(487, '2020-12-15'),
(488, '2020-12-16'),
(489, '2020-12-17'),
(490, '2020-12-18'),
(491, '2020-12-21'),
(492, '2020-12-22'),
(493, '2020-12-23'),
(494, '2020-12-24'),
(495, '2020-12-28'),
(496, '2020-12-29'),
(497, '2020-12-30'),
(498, '2020-12-31');

-- --------------------------------------------------------

--
-- Estrutura da tabela `capa`
--

CREATE TABLE `capa` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `capa`
--

INSERT INTO `capa` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', 'Wednesday, 13 de November de 2019', '2019-11-13', 'Monday, 03 de February de 2020', '2020-02-03', b'0', NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', 'Tuesday, 25 de June de 2019', '2019-06-25', 'Wednesday, 11 de September de 2019', '2019-09-11', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 19 de September de 2019', '2019-09-19', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 19 de September de 2019', '2019-09-19', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', 'Thursday, 04 de July de 2019', '2019-07-04', 'Friday, 20 de September de 2019', '2019-09-20', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', 'Wednesday, 31 de July de 2019', '2019-07-31', 'Wednesday, 25 de September de 2019', '2019-09-25', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', 'Wednesday, 10 de July de 2019', '2019-07-10', 'Thursday, 26 de September de 2019', '2019-09-26', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', 'Tuesday, 02 de July de 2019', '2019-07-02', 'Wednesday, 18 de September de 2019', '2019-09-18', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 19 de September de 2019', '2019-09-19', b'0', NULL, NULL, NULL);

--
-- Acionadores `capa`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_capa` BEFORE UPDATE ON `capa` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_capa` BEFORE INSERT ON `capa` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `contrato`
--

CREATE TABLE `contrato` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `contrato`
--

INSERT INTO `contrato` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `caixa`, `termino_string`, `termino`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', b'0', NULL, NULL),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', b'0', NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', b'0', NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', b'0', NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', b'0', NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', b'0', NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', b'0', NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', b'0', NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', b'0', NULL, NULL);

--
-- Acionadores `contrato`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_contrato` BEFORE UPDATE ON `contrato` FOR EACH ROW begin
SET new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_contrato` BEFORE INSERT ON `contrato` FOR EACH ROW SET new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cotejo`
--

CREATE TABLE `cotejo` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `revisor` varchar(50) DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `cotejo`
--

INSERT INTO `cotejo` (`id`, `mes`, `livro`, `lancamento`, `lancamento_string`, `status`, `prazo_livro`, `revisor`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', '2020-02-25', 'Tuesday, 25 de February de 2020', 'FINALIZADO', 'JUSTO', NULL, 'Wednesday, 13 de November de 2019', '2019-11-13', 'Monday, 03 de February de 2020', '2020-02-03', b'0', NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', '2019-10-01', 'Tuesday, 01 de October de 2019', 'INICIAR', 'JUSTO', NULL, 'Tuesday, 25 de June de 2019', '2019-06-25', 'Wednesday, 11 de September de 2019', '2019-09-11', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', '2019-10-09', 'Wednesday, 09 de October de 2019', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 19 de September de 2019', '2019-09-19', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', '2019-10-09', 'Wednesday, 09 de October de 2019', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 19 de September de 2019', '2019-09-19', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', '2019-10-10', 'Thursday, 10 de October de 2019', 'INICIAR', 'JUSTO', NULL, 'Thursday, 04 de July de 2019', '2019-07-04', 'Friday, 20 de September de 2019', '2019-09-20', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', '2019-10-08', 'Tuesday, 08 de October de 2019', 'ATRASADO', 'CRITICO', NULL, 'Wednesday, 31 de July de 2019', '2019-07-31', 'Wednesday, 25 de September de 2019', '2019-09-25', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', '2019-10-16', 'Wednesday, 16 de October de 2019', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 10 de July de 2019', '2019-07-10', 'Thursday, 26 de September de 2019', '2019-09-26', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', '2019-10-08', 'Tuesday, 08 de October de 2019', 'INICIAR', 'JUSTO', NULL, 'Tuesday, 02 de July de 2019', '2019-07-02', 'Wednesday, 18 de September de 2019', '2019-09-18', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', '2019-10-09', 'Wednesday, 09 de October de 2019', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 19 de September de 2019', '2019-09-19', b'0', NULL, NULL, NULL);

--
-- Acionadores `cotejo`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_cotejo` BEFORE UPDATE ON `cotejo` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_cotejo` BEFORE INSERT ON `cotejo` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `crud_permissions`
--

CREATE TABLE `crud_permissions` (
  `id` int(6) UNSIGNED NOT NULL,
  `name` varchar(70) NOT NULL,
  `permissions` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `crud_permissions`
--

INSERT INTO `crud_permissions` (`id`, `name`, `permissions`) VALUES
(1, 'admin', '{"boneca":"111111","calendario":"111111","capa":"111111","contrato":"111111","cotejo":"111111","crud_permissions":"111111","crud_users":"111111","diagramacao":"111111","ebook":"111111","fechamento":"111111","ficha":"111111","grafica":"111111","imprensa":"111111","isbn":"111111","livros":"111111","marketing":"111111","preparacao":"111111","tratamento":"111111"}');

-- --------------------------------------------------------

--
-- Estrutura da tabela `crud_users`
--

CREATE TABLE `crud_users` (
  `id` int(6) UNSIGNED NOT NULL,
  `username` varchar(70) NOT NULL,
  `password` varchar(70) NOT NULL,
  `permissions` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `crud_users`
--

INSERT INTO `crud_users` (`id`, `username`, `password`, `permissions`) VALUES
(1, 'admin', '1234', '1');

-- --------------------------------------------------------

--
-- Estrutura da tabela `diagramacao`
--

CREATE TABLE `diagramacao` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `diagramador` varchar(50) DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `diagramacao`
--

INSERT INTO `diagramacao` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `diagramador`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', NULL, 'Wednesday, 13 de November de 2019', '2019-11-13', 'Monday, 03 de February de 2020', '2020-02-03', b'0', NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', NULL, 'Tuesday, 25 de June de 2019', '2019-06-25', 'Wednesday, 11 de September de 2019', '2019-09-11', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 19 de September de 2019', '2019-09-19', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 19 de September de 2019', '2019-09-19', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', NULL, 'Thursday, 04 de July de 2019', '2019-07-04', 'Friday, 20 de September de 2019', '2019-09-20', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', NULL, 'Wednesday, 31 de July de 2019', '2019-07-31', 'Wednesday, 25 de September de 2019', '2019-09-25', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 10 de July de 2019', '2019-07-10', 'Thursday, 26 de September de 2019', '2019-09-26', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', NULL, 'Tuesday, 02 de July de 2019', '2019-07-02', 'Wednesday, 18 de September de 2019', '2019-09-18', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 19 de September de 2019', '2019-09-19', b'0', NULL, NULL, NULL);

--
-- Acionadores `diagramacao`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_diagramacao` BEFORE UPDATE ON `diagramacao` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_diagramacao` BEFORE INSERT ON `diagramacao` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ebook`
--

CREATE TABLE `ebook` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `ebook`
--

INSERT INTO `ebook` (`id`, `mes`, `livro`, `lancamento`, `lancamento_string`, `status`, `prazo_livro`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', '2020-02-25', 'Tuesday, 25 de February de 2020', 'FINALIZADO', 'JUSTO', 'Wednesday, 05 de February de 2020', '2020-02-05', b'0', NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', '2019-10-01', 'Tuesday, 01 de October de 2019', 'INICIAR', 'JUSTO', 'Friday, 13 de September de 2019', '2019-09-13', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', '2019-10-09', 'Wednesday, 09 de October de 2019', 'INICIAR', 'JUSTO', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', '2019-10-09', 'Wednesday, 09 de October de 2019', 'INICIAR', 'JUSTO', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', '2019-10-10', 'Thursday, 10 de October de 2019', 'INICIAR', 'JUSTO', 'Tuesday, 24 de September de 2019', '2019-09-24', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', '2019-10-08', 'Tuesday, 08 de October de 2019', 'ATRASADO', 'CRITICO', 'Friday, 27 de September de 2019', '2019-09-27', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', '2019-10-16', 'Wednesday, 16 de October de 2019', 'INICIAR', 'JUSTO', 'Monday, 30 de September de 2019', '2019-09-30', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', '2019-10-08', 'Tuesday, 08 de October de 2019', 'INICIAR', 'JUSTO', 'Friday, 20 de September de 2019', '2019-09-20', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', '2019-10-09', 'Wednesday, 09 de October de 2019', 'INICIAR', 'JUSTO', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL);

--
-- Acionadores `ebook`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_ebook` BEFORE UPDATE ON `ebook` FOR EACH ROW begin
SET new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_ebook` BEFORE INSERT ON `ebook` FOR EACH ROW SET new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `fechamento`
--

CREATE TABLE `fechamento` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `finalizador` varchar(50) DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `fechamento`
--

INSERT INTO `fechamento` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `finalizador`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', NULL, 'Wednesday, 13 de November de 2019', '2019-11-13', 'Wednesday, 05 de February de 2020', '2020-02-05', b'0', NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', NULL, 'Tuesday, 25 de June de 2019', '2019-06-25', 'Friday, 13 de September de 2019', '2019-09-13', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', NULL, 'Thursday, 04 de July de 2019', '2019-07-04', 'Tuesday, 24 de September de 2019', '2019-09-24', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', NULL, 'Wednesday, 31 de July de 2019', '2019-07-31', 'Friday, 27 de September de 2019', '2019-09-27', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 10 de July de 2019', '2019-07-10', 'Monday, 30 de September de 2019', '2019-09-30', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', NULL, 'Tuesday, 02 de July de 2019', '2019-07-02', 'Friday, 20 de September de 2019', '2019-09-20', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL);

--
-- Acionadores `fechamento`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_fechamento` BEFORE UPDATE ON `fechamento` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_fechamento` BEFORE INSERT ON `fechamento` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ficha`
--

CREATE TABLE `ficha` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `ficha`
--

INSERT INTO `ficha` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', 'Wednesday, 13 de November de 2019', '2019-11-13', 'Monday, 17 de February de 2020', '2020-02-17', b'0', NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', 'Tuesday, 25 de June de 2019', '2019-06-25', 'Wednesday, 25 de September de 2019', '2019-09-25', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 03 de October de 2019', '2019-10-03', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 03 de October de 2019', '2019-10-03', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', 'Thursday, 04 de July de 2019', '2019-07-04', 'Friday, 04 de October de 2019', '2019-10-04', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', 'Wednesday, 31 de July de 2019', '2019-07-31', 'Wednesday, 02 de October de 2019', '2019-10-02', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', 'Wednesday, 10 de July de 2019', '2019-07-10', 'Thursday, 10 de October de 2019', '2019-10-10', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', 'Tuesday, 02 de July de 2019', '2019-07-02', 'Wednesday, 02 de October de 2019', '2019-10-02', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 03 de October de 2019', '2019-10-03', b'0', NULL, NULL, NULL);

--
-- Acionadores `ficha`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_ficha` BEFORE UPDATE ON `ficha` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_ficha` BEFORE INSERT ON `ficha` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `grafica`
--

CREATE TABLE `grafica` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `grafica`
--

INSERT INTO `grafica` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', 'Monday, 27 de January de 2020', '2020-01-27', 'Wednesday, 05 de February de 2020', '2020-02-05', b'0', NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', 'Wednesday, 04 de September de 2019', '2019-09-04', 'Friday, 13 de September de 2019', '2019-09-13', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Thursday, 12 de September de 2019', '2019-09-12', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Thursday, 12 de September de 2019', '2019-09-12', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', 'Friday, 13 de September de 2019', '2019-09-13', 'Tuesday, 24 de September de 2019', '2019-09-24', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', 'Wednesday, 18 de September de 2019', '2019-09-18', 'Friday, 27 de September de 2019', '2019-09-27', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', 'Thursday, 19 de September de 2019', '2019-09-19', 'Monday, 30 de September de 2019', '2019-09-30', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', 'Wednesday, 11 de September de 2019', '2019-09-11', 'Friday, 20 de September de 2019', '2019-09-20', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Thursday, 12 de September de 2019', '2019-09-12', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL);

--
-- Acionadores `grafica`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_grafica` BEFORE UPDATE ON `grafica` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_grafica` BEFORE INSERT ON `grafica` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `imprensa`
--

CREATE TABLE `imprensa` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `imprensa`
--

INSERT INTO `imprensa` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', 'Monday, 17 de February de 2020', '2020-02-17', 'Thursday, 20 de February de 2020', '2020-02-20', b'1', 'Monday, 14 de October de 2019', '2019-10-14', 'ANTES DO PRAZO'),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', 'Wednesday, 25 de September de 2019', '2019-09-25', 'Monday, 30 de September de 2019', '2019-09-30', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Thursday, 03 de October de 2019', '2019-10-03', 'Tuesday, 08 de October de 2019', '2019-10-08', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Thursday, 03 de October de 2019', '2019-10-03', 'Tuesday, 08 de October de 2019', '2019-10-08', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', 'Friday, 04 de October de 2019', '2019-10-04', 'Wednesday, 09 de October de 2019', '2019-10-09', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', 'Thursday, 03 de October de 2019', '2019-10-03', 'Monday, 07 de October de 2019', '2019-10-07', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', 'Thursday, 10 de October de 2019', '2019-10-10', 'Tuesday, 15 de October de 2019', '2019-10-15', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', 'Wednesday, 02 de October de 2019', '2019-10-02', 'Monday, 07 de October de 2019', '2019-10-07', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Thursday, 03 de October de 2019', '2019-10-03', 'Tuesday, 08 de October de 2019', '2019-10-08', b'0', NULL, NULL, NULL);

--
-- Acionadores `imprensa`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_imprensa` BEFORE UPDATE ON `imprensa` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_imprensa` BEFORE INSERT ON `imprensa` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `isbn`
--

CREATE TABLE `isbn` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `isbn`
--

INSERT INTO `isbn` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', 'Wednesday, 13 de November de 2019', '2019-11-13', 'Monday, 17 de February de 2020', '2020-02-17', b'0', NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', 'Tuesday, 25 de June de 2019', '2019-06-25', 'Wednesday, 25 de September de 2019', '2019-09-25', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 03 de October de 2019', '2019-10-03', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 03 de October de 2019', '2019-10-03', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', 'Thursday, 04 de July de 2019', '2019-07-04', 'Friday, 04 de October de 2019', '2019-10-04', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', 'Wednesday, 31 de July de 2019', '2019-07-31', 'Wednesday, 02 de October de 2019', '2019-10-02', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', 'Wednesday, 10 de July de 2019', '2019-07-10', 'Thursday, 10 de October de 2019', '2019-10-10', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', 'Tuesday, 02 de July de 2019', '2019-07-02', 'Wednesday, 02 de October de 2019', '2019-10-02', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 03 de October de 2019', '2019-10-03', b'0', NULL, NULL, NULL);

--
-- Acionadores `isbn`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_isbn` BEFORE UPDATE ON `isbn` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_isbn` BEFORE INSERT ON `isbn` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `livros`
--

CREATE TABLE `livros` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(100) DEFAULT NULL,
  `autor` varchar(50) DEFAULT NULL,
  `editor` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `observacao` varchar(50) DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `tiragem` varchar(5) DEFAULT NULL,
  `os` varchar(20) DEFAULT NULL,
  `entrada_string` varchar(50) DEFAULT NULL,
  `entrada` date DEFAULT NULL,
  `local_lancamento` varchar(100) DEFAULT NULL,
  `sinopse` varchar(500) DEFAULT NULL,
  `genero` varchar(50) DEFAULT NULL,
  `palavra_chave` varchar(100) DEFAULT NULL,
  `observacoes` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `livros`
--

INSERT INTO `livros` (`id`, `mes`, `livro`, `autor`, `editor`, `lancamento_string`, `lancamento`, `observacao`, `status`, `prazo_livro`, `tiragem`, `os`, `entrada_string`, `entrada`, `local_lancamento`, `sinopse`, `genero`, `palavra_chave`, `observacoes`) VALUES
(5, 'FEB', 'Casos Especiais', '1', NULL, 'Tuesday, 25 de February de 2020', '2020-02-25', NULL, 'FINALIZADO', 'JUSTO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', '1', '1', 'Tuesday, 01 de October de 2019', '2019-10-01', NULL, 'INICIAR', 'JUSTO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'tetste', NULL, 'Wednesday, 09 de October de 2019', '2019-10-09', NULL, 'INICIAR', 'JUSTO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'sadsadsad', 'sadsad', 'Wednesday, 09 de October de 2019', '2019-10-09', NULL, 'INICIAR', 'JUSTO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'dsads', 'adsad', 'Thursday, 10 de October de 2019', '2019-10-10', NULL, 'INICIAR', 'JUSTO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'sadsad', 'sadsad', 'Tuesday, 08 de October de 2019', '2019-10-08', NULL, 'ATRASADO', 'CRITICO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'adsfds', 'fafdsa', 'Wednesday, 16 de October de 2019', '2019-10-16', NULL, 'INICIAR', 'JUSTO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'sadsad', 'sadsa', 'Tuesday, 08 de October de 2019', '2019-10-08', NULL, 'INICIAR', 'JUSTO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'dsaf', 'dsfds', 'Wednesday, 09 de October de 2019', '2019-10-09', NULL, 'INICIAR', 'JUSTO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Acionadores `livros`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_livro` BEFORE UPDATE ON `livros` FOR EACH ROW SET new.mes = (upper(mid(MONTHNAME(new.lancamento),1,3))), new.lancamento_string = (date_format(new.lancamento, '%W, %d de %M de %Y')), new.entrada_string = (date_format(new.entrada, '%W, %d de %M de %Y'))
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_atualizar` AFTER UPDATE ON `livros` FOR EACH ROW begin

declare liv date;
declare lan date;
declare whi date;
declare pl varchar (20);
select new.lancamento into liv from livros where id = new.id;
select `data` into lan from calendario where `data` = liv;
select prazo_livro into pl from livros where id = new.id;

while lan is null do
set liv = subdate(liv, 1);
set lan = (select `data` from calendario where `data` = liv);
end while;
select `data` into whi from calendario where `data` = lan;

if pl = 'ideal' then
update preparacao x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, inicio = (select f_data_lancamento (whi, 89)), x.prazo = (select f_data_lancamento (whi, 29)) where y.id = new.id;

update imprensa x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, inicio = (select f_data_lancamento (whi, 6)), x.prazo = (select f_data_lancamento (whi, 1)) where y.id = new.id;

update grafica x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, inicio = (select f_data_lancamento (whi, 29)), x.prazo = (select f_data_lancamento (whi, 22)) where y.id = new.id;

update ebook x inner join grafica y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.prazo = y.prazo where y.id = new.id;

update diagramacao x inner join livros y on x.id = y.id inner join preparacao z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = z.inicio, x.prazo = (select f_data_lancamento (whi, 24)) where y.id = new.id;

update cotejo x inner join diagramacao y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = y.prazo where y.id = new.id;

update isbn x inner join livros y on x.id = y.id inner join cotejo z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = z.inicio, x.prazo = (select f_data_lancamento (whi, 4)) where y.id = new.id;

update ficha x inner join isbn y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = y.prazo where y.id = new.id;

update capa x inner join preparacao y on x.id = y.id inner join cotejo z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

update marketing x inner join livros y on x.id = y.id inner join capa z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = z.inicio, x.prazo = (select f_data_lancamento (whi, 7)) where y.id = new.id;

update boneca x inner join cotejo y on x.id = y.id inner join isbn z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

update contrato x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status` where y.id = new.id;

update fechamento x inner join ficha y on x.id = y.id inner join grafica z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

update tratamento x inner join preparacao y on x.id = y.id inner join fechamento z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

elseif pl = 'justo' then
update preparacao x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, inicio = (select f_data_lancamento (whi, 69)), x.prazo = (select f_data_lancamento (whi, 24)) where y.id = new.id;

update imprensa x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, inicio = (select f_data_lancamento (whi, 4)), x.prazo = (select f_data_lancamento (whi, 1)) where y.id = new.id;

update grafica x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, inicio = (select f_data_lancamento (whi, 19)), x.prazo = (select f_data_lancamento (whi, 12)) where y.id = new.id;

update ebook x inner join grafica y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.prazo = y.prazo where y.id = new.id;

update diagramacao x inner join livros y on x.id = y.id inner join preparacao z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = z.inicio, x.prazo = (select f_data_lancamento (whi, 14)) where y.id = new.id;

update cotejo x inner join diagramacao y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = y.prazo where y.id = new.id;

update isbn x inner join livros y on x.id = y.id inner join cotejo z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = z.inicio, x.prazo = (select f_data_lancamento (whi, 4)) where y.id = new.id;

update ficha x inner join isbn y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = y.prazo where y.id = new.id;

update capa x inner join preparacao y on x.id = y.id inner join cotejo z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

update marketing x inner join livros y on x.id = y.id inner join capa z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = z.inicio, x.prazo = (select f_data_lancamento (whi, 5)) where y.id = new.id;

update boneca x inner join cotejo y on x.id = y.id inner join isbn z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

update contrato x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status` where y.id = new.id;

update fechamento x inner join ficha y on x.id = y.id inner join grafica z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

update tratamento x inner join preparacao y on x.id = y.id inner join fechamento z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

elseif pl = 'critico' then
update preparacao x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, inicio = (select f_data_lancamento (whi, 49)), x.prazo = (select f_data_lancamento (whi, 19)) where y.id = new.id;

update imprensa x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, inicio = (select f_data_lancamento (whi, 3)), x.prazo = (select f_data_lancamento (whi, 1)) where y.id = new.id;

update grafica x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, inicio = (select f_data_lancamento (whi, 14)), x.prazo = (select f_data_lancamento (whi, 7)) where y.id = new.id;

update ebook x inner join grafica y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.prazo = y.prazo where y.id = new.id;

update diagramacao x inner join livros y on x.id = y.id inner join preparacao z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = z.inicio, x.prazo = (select f_data_lancamento (whi, 9)) where y.id = new.id;

update cotejo x inner join diagramacao y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = y.prazo where y.id = new.id;

update isbn x inner join livros y on x.id = y.id inner join cotejo z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = z.inicio, x.prazo = (select f_data_lancamento (whi, 4)) where y.id = new.id;

update ficha x inner join isbn y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = y.prazo where y.id = new.id;

update capa x inner join preparacao y on x.id = y.id inner join cotejo z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

update marketing x inner join livros y on x.id = y.id inner join capa z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = z.inicio, x.prazo = (select f_data_lancamento (whi, 2)) where y.id = new.id;

update boneca x inner join cotejo y on x.id = y.id inner join isbn z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

update contrato x inner join livros y on x.id = y.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status` where y.id = new.id;

update fechamento x inner join ficha y on x.id = y.id inner join grafica z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

update tratamento x inner join preparacao y on x.id = y.id inner join fechamento z on x.id = z.id set x.mes = y.mes, x.livro = y.livro, x.lancamento_string = y.lancamento_string, x.lancamento = y.lancamento, x.`status` = y.`status`, x.inicio = y.inicio, x.prazo = z.prazo where y.id = new.id;

end if;

end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_deletar` BEFORE DELETE ON `livros` FOR EACH ROW begin

delete from boneca where id in (select old.id from livros);

delete from capa where id in (select old.id from livros);

delete from contrato where id in (select old.id from livros);

delete from cotejo where id in (select old.id from livros);

delete from diagramacao where id in (select old.id from livros);

delete from ebook where id in (select old.id from livros);

delete from fechamento where id in (select old.id from livros);

delete from ficha where id in (select old.id from livros);

delete from grafica where id in (select old.id from livros);

delete from imprensa where id in (select old.id from livros);

delete from isbn where id in (select old.id from livros);

delete from marketing where id in (select old.id from livros);

delete from preparacao where id in (select old.id from livros);

delete from tratamento where id in (select old.id from livros);

end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_livro` BEFORE INSERT ON `livros` FOR EACH ROW SET new.mes = (upper(mid(MONTHNAME(new.lancamento),1,3))), new.lancamento_string = (date_format(new.lancamento, '%W, %d de %M de %Y')), new.entrada_string = (date_format(new.entrada, '%W, %d de %M de %Y'))
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_inserir` AFTER INSERT ON `livros` FOR EACH ROW begin

declare liv date;
declare lan date;
declare whi date;
declare pl varchar (20);
select new.lancamento into liv from livros where id = new.id;
select `data` into lan from calendario where `data` = liv;
select prazo_livro into pl from livros where id = new.id;

while lan is null do
set liv = subdate(liv, 1);
set lan = (select `data` from calendario where `data` = liv);
end while;
select `data` into whi from calendario where `data` = lan;

if pl = 'ideal' then
insert into preparacao (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, f_data_lancamento (whi, 89), f_data_lancamento (whi, 29) from livros where id = new.id;

insert into imprensa (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, f_data_lancamento (whi, 6), f_data_lancamento (whi, 1) from livros where id = new.id;

insert into grafica (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, f_data_lancamento (whi, 29), f_data_lancamento (whi, 22) from livros where id = new.id;

insert into ebook (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, prazo from grafica where id = new.id;

insert into diagramacao (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, f_data_lancamento (whi, 24) from preparacao where id = new.id;

insert into cotejo (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo from diagramacao where id = new.id;

insert into isbn (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, f_data_lancamento (whi, 4) from cotejo where id = new.id;

insert into ficha (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo from isbn where id = new.id;

insert into capa (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from preparacao x inner join cotejo y on x.id = y.id where x.id = new.id;

insert into marketing (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, f_data_lancamento (whi, 7) from capa where id = new.id;

insert into boneca (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from cotejo x inner join isbn y on x.id = y.id where x.id = new.id;

insert into contrato (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro from boneca where id = new.id;

insert into fechamento (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from ficha x inner join grafica y on x.id = y.id where x.id = new.id;

insert into tratamento (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from preparacao x inner join fechamento y on x.id = y.id where x.id = new.id;

elseif pl = 'justo' then
insert into preparacao (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, f_data_lancamento (whi, 69), f_data_lancamento (whi, 24) from livros where id = new.id;

insert into imprensa (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, f_data_lancamento (whi, 4), f_data_lancamento (whi, 1) from livros where id = new.id;

insert into grafica (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, f_data_lancamento (whi, 19), f_data_lancamento (whi, 12) from livros where id = new.id;

insert into ebook (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, prazo from grafica where id = new.id;

insert into diagramacao (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, f_data_lancamento (whi, 14) from preparacao where id = new.id;

insert into cotejo (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo from diagramacao where id = new.id;

insert into isbn (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, f_data_lancamento (whi, 4) from cotejo where id = new.id;

insert into ficha (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo from isbn where id = new.id;

insert into capa (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from preparacao x inner join cotejo y on x.id = y.id where x.id = new.id;

insert into marketing (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, f_data_lancamento (whi, 5) from capa where id = new.id;

insert into boneca (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from cotejo x inner join isbn y on x.id = y.id where x.id = new.id;

insert into contrato (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro from boneca where id = new.id;

insert into fechamento (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from ficha x inner join grafica y on x.id = y.id where x.id = new.id;

insert into tratamento (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from preparacao x inner join fechamento y on x.id = y.id where x.id = new.id;

elseif pl = 'critico' then
insert into preparacao (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, f_data_lancamento (whi, 49), f_data_lancamento (whi, 19) from livros where id = new.id;

insert into imprensa (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, f_data_lancamento (whi, 3), f_data_lancamento (whi, 1) from livros where id = new.id;

insert into grafica (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, f_data_lancamento (whi, 14), f_data_lancamento (whi, 7) from livros where id = new.id;

insert into ebook (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, prazo from grafica where id = new.id;

insert into diagramacao (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, f_data_lancamento (whi, 9) from preparacao where id = new.id;

insert into cotejo (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo from diagramacao where id = new.id;

insert into isbn (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, f_data_lancamento (whi, 4) from cotejo where id = new.id;

insert into ficha (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo from isbn where id = new.id;

insert into capa (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from preparacao x inner join cotejo y on x.id = y.id where x.id = new.id;

insert into marketing (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, f_data_lancamento (whi, 2) from capa where id = new.id;

insert into boneca (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from cotejo x inner join isbn y on x.id = y.id where x.id = new.id;

insert into contrato (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro) select id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro from boneca where id = new.id;

insert into fechamento (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from ficha x inner join grafica y on x.id = y.id where x.id = new.id;

insert into tratamento (id, mes, livro, lancamento_string, lancamento, `status`, prazo_livro, inicio, prazo) select x.id, x.mes, x.livro, x.lancamento_string, x.lancamento, x.`status`, x.prazo_livro, x.inicio, y.prazo from preparacao x inner join fechamento y on x.id = y.id where x.id = new.id;

end if;

end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `marketing`
--

CREATE TABLE `marketing` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `marketing`
--

INSERT INTO `marketing` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', 'Wednesday, 13 de November de 2019', '2019-11-13', 'Friday, 14 de February de 2020', '2020-02-14', b'0', NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', 'Tuesday, 25 de June de 2019', '2019-06-25', 'Tuesday, 24 de September de 2019', '2019-09-24', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Wednesday, 02 de October de 2019', '2019-10-02', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Wednesday, 02 de October de 2019', '2019-10-02', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', 'Thursday, 04 de July de 2019', '2019-07-04', 'Thursday, 03 de October de 2019', '2019-10-03', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', 'Wednesday, 31 de July de 2019', '2019-07-31', 'Friday, 04 de October de 2019', '2019-10-04', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', 'Wednesday, 10 de July de 2019', '2019-07-10', 'Wednesday, 09 de October de 2019', '2019-10-09', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', 'Tuesday, 02 de July de 2019', '2019-07-02', 'Tuesday, 01 de October de 2019', '2019-10-01', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', 'Wednesday, 03 de July de 2019', '2019-07-03', 'Wednesday, 02 de October de 2019', '2019-10-02', b'0', NULL, NULL, NULL);

--
-- Acionadores `marketing`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_marketing` BEFORE UPDATE ON `marketing` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_marketing` BEFORE INSERT ON `marketing` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `preparacao`
--

CREATE TABLE `preparacao` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `revisor` varchar(50) DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `preparacao`
--

INSERT INTO `preparacao` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `revisor`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', NULL, 'Wednesday, 13 de November de 2019', '2019-11-13', 'Monday, 20 de January de 2020', '2020-01-20', b'1', 'Friday, 25 de October de 2019', '2019-10-25', 'ANTES DO PRAZO'),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', NULL, 'Tuesday, 25 de June de 2019', '2019-06-25', 'Wednesday, 28 de August de 2019', '2019-08-28', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 05 de September de 2019', '2019-09-05', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 05 de September de 2019', '2019-09-05', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', NULL, 'Thursday, 04 de July de 2019', '2019-07-04', 'Friday, 06 de September de 2019', '2019-09-06', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', NULL, 'Wednesday, 31 de July de 2019', '2019-07-31', 'Wednesday, 11 de September de 2019', '2019-09-11', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 10 de July de 2019', '2019-07-10', 'Thursday, 12 de September de 2019', '2019-09-12', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', NULL, 'Tuesday, 02 de July de 2019', '2019-07-02', 'Wednesday, 04 de September de 2019', '2019-09-04', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Thursday, 05 de September de 2019', '2019-09-05', b'0', NULL, NULL, NULL);

--
-- Acionadores `preparacao`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_preparacao` BEFORE UPDATE ON `preparacao` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_preparacao` BEFORE INSERT ON `preparacao` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tratamento`
--

CREATE TABLE `tratamento` (
  `id` int(11) NOT NULL,
  `mes` varchar(3) DEFAULT NULL,
  `livro` varchar(50) DEFAULT NULL,
  `lancamento_string` varchar(50) DEFAULT NULL,
  `lancamento` date DEFAULT NULL,
  `status` enum('FINALIZADO','INICIAR','ATRASADO','ANDAMENTO') DEFAULT NULL,
  `prazo_livro` enum('IDEAL','JUSTO','CRITICO') DEFAULT NULL,
  `tratador` varchar(50) DEFAULT NULL,
  `ilustrador` varchar(50) DEFAULT NULL,
  `revisor` varchar(50) DEFAULT NULL,
  `inicio_string` varchar(50) DEFAULT NULL,
  `inicio` date DEFAULT NULL,
  `prazo_string` varchar(50) DEFAULT NULL,
  `prazo` date DEFAULT NULL,
  `caixa` bit(1) DEFAULT b'0',
  `termino_string` varchar(50) DEFAULT NULL,
  `termino` date DEFAULT NULL,
  `termino_status` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tratamento`
--

INSERT INTO `tratamento` (`id`, `mes`, `livro`, `lancamento_string`, `lancamento`, `status`, `prazo_livro`, `tratador`, `ilustrador`, `revisor`, `inicio_string`, `inicio`, `prazo_string`, `prazo`, `caixa`, `termino_string`, `termino`, `termino_status`) VALUES
(5, 'FEB', 'Casos Especiais', 'Tuesday, 25 de February de 2020', '2020-02-25', 'FINALIZADO', 'JUSTO', NULL, NULL, NULL, 'Wednesday, 13 de November de 2019', '2019-11-13', 'Wednesday, 05 de February de 2020', '2020-02-05', b'0', NULL, NULL, NULL),
(7, 'OCT', 'Livro mais 1', 'Tuesday, 01 de October de 2019', '2019-10-01', 'INICIAR', 'JUSTO', NULL, NULL, NULL, 'Tuesday, 25 de June de 2019', '2019-06-25', 'Friday, 13 de September de 2019', '2019-09-13', b'0', NULL, NULL, NULL),
(8, 'OCT', 'Testee', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, NULL, NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL),
(9, 'OCT', 'sdsad', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, NULL, NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL),
(10, 'OCT', 'sdadsa', 'Thursday, 10 de October de 2019', '2019-10-10', 'INICIAR', 'JUSTO', NULL, NULL, NULL, 'Thursday, 04 de July de 2019', '2019-07-04', 'Tuesday, 24 de September de 2019', '2019-09-24', b'0', NULL, NULL, NULL),
(11, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'ATRASADO', 'CRITICO', NULL, NULL, NULL, 'Wednesday, 31 de July de 2019', '2019-07-31', 'Friday, 27 de September de 2019', '2019-09-27', b'0', NULL, NULL, NULL),
(12, 'OCT', 'fdasf', 'Wednesday, 16 de October de 2019', '2019-10-16', 'INICIAR', 'JUSTO', NULL, NULL, NULL, 'Wednesday, 10 de July de 2019', '2019-07-10', 'Monday, 30 de September de 2019', '2019-09-30', b'0', NULL, NULL, NULL),
(13, 'OCT', 'dsad', 'Tuesday, 08 de October de 2019', '2019-10-08', 'INICIAR', 'JUSTO', NULL, NULL, NULL, 'Tuesday, 02 de July de 2019', '2019-07-02', 'Friday, 20 de September de 2019', '2019-09-20', b'0', NULL, NULL, NULL),
(14, 'OCT', 'fasdf', 'Wednesday, 09 de October de 2019', '2019-10-09', 'INICIAR', 'JUSTO', NULL, NULL, NULL, 'Wednesday, 03 de July de 2019', '2019-07-03', 'Monday, 23 de September de 2019', '2019-09-23', b'0', NULL, NULL, NULL);

--
-- Acionadores `tratamento`
--
DELIMITER $$
CREATE TRIGGER `tg_atualiza_tratamento` BEFORE UPDATE ON `tratamento` FOR EACH ROW begin
SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y'));
if new.caixa = 1 then
set new.termino = curdate(), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'));
elseif new.caixa = 0 then
set new.termino = null, new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y')), new.termino_status = null;
end if;
if new.termino < new. prazo then
set new.termino_status = 'ANTES DO PRAZO';
elseif new.termino = new. prazo then
set new.termino_status = 'NO PRAZO';
elseif new.termino > new. prazo then
set new.termino_status = 'DEPOIS DO PRAZO';
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_insere_tratamento` BEFORE INSERT ON `tratamento` FOR EACH ROW SET new.inicio_string = (date_format(new.inicio, '%W, %d de %M de %Y')), new.prazo_string = (date_format(new.prazo, '%W, %d de %M de %Y')), new.termino_string = (date_format(new.termino, '%W, %d de %M de %Y'))
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `boneca`
--
ALTER TABLE `boneca`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `calendario`
--
ALTER TABLE `calendario`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `capa`
--
ALTER TABLE `capa`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contrato`
--
ALTER TABLE `contrato`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cotejo`
--
ALTER TABLE `cotejo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crud_permissions`
--
ALTER TABLE `crud_permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crud_users`
--
ALTER TABLE `crud_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `diagramacao`
--
ALTER TABLE `diagramacao`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ebook`
--
ALTER TABLE `ebook`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fechamento`
--
ALTER TABLE `fechamento`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ficha`
--
ALTER TABLE `ficha`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `grafica`
--
ALTER TABLE `grafica`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `imprensa`
--
ALTER TABLE `imprensa`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `isbn`
--
ALTER TABLE `isbn`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `livros`
--
ALTER TABLE `livros`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `marketing`
--
ALTER TABLE `marketing`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `preparacao`
--
ALTER TABLE `preparacao`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tratamento`
--
ALTER TABLE `tratamento`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `calendario`
--
ALTER TABLE `calendario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=499;
--
-- AUTO_INCREMENT for table `crud_permissions`
--
ALTER TABLE `crud_permissions`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `crud_users`
--
ALTER TABLE `crud_users`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `livros`
--
ALTER TABLE `livros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
