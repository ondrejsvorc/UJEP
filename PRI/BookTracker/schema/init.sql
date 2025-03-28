SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `Book`;
DROP TABLE IF EXISTS `Author`;
DROP TABLE IF EXISTS `Genre`;

CREATE TABLE `Author` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `Genre` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `Book` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author_id` int unsigned NOT NULL,
  `genre_id` int unsigned,
  `year` year,
  `status` enum('want to read', 'currently reading', 'read') NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`author_id`) REFERENCES `Author` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`genre_id`) REFERENCES `Genre` (`id`) ON DELETE SET NULL
);

INSERT INTO `Author` (`id`, `name`) VALUES
(1, 'George Orwell'),
(2, 'Frank Herbert'),
(3, 'J.R.R. Tolkien');

INSERT INTO `Genre` (`id`, `name`) VALUES
(1, 'Dystopian'),
(2, 'Science Fiction'),
(3, 'Fantasy');

INSERT INTO `Book` (`id`, `title`, `author_id`, `genre_id`, `year`, `status`) VALUES
(1, '1984', 1, 1, 1949, 'read'),
(2, 'Dune', 2, 2, 1965, 'want to read'),
(3, 'The Hobbit', 3, 3, 1937, 'currently reading');