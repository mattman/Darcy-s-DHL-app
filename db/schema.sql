DROP TABLE IF EXISTS `delivered_notices`;
DROP TABLE IF EXISTS `intransit_notices`;
DROP TABLE IF EXISTS `packages`;
DROP TABLE IF EXISTS `customers`;
DROP TABLE IF EXISTS `carriers`;
DROP TABLE IF EXISTS `administrators`;

CREATE TABLE `administrators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `carriers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `identifier` varchar(4) NOT NULL,
  `address` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(10) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `address` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `full_name` (`first_name`, `last_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `serial_number` varchar(255) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `carrier_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial_number` (`serial_number`),
  FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`carrier_id`)  REFERENCES `carriers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `intransit_notices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_id` int(11) NOT NULL,
  `tag_sequence` int(11) NOT NULL,
  `status` enum('T','D') NOT NULL,
  `recorded_at` datetime NOT NULL,
  `lat` decimal(15,10) NOT NULL,
  `lng` decimal(15,10) NOT NULL,
  `comment` varchar(100),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
 CREATE TABLE `delivered_notices` LIKE `intransit_notices`;

-- Stored Procedures.

DROP PROCEDURE IF EXISTS authenticate_as_admin;
DROP PROCEDURE IF EXISTS authenticate_as_carrier;
DROP PROCEDURE IF EXISTS carrier_id_from_serial_number;
DROP TRIGGER   IF EXISTS categorise_notices;

delimiter //

CREATE PROCEDURE authenticate_as_admin(current_username VARCHAR(100), current_password VARCHAR(100))
BEGIN
  SELECT * FROM administrators WHERE username = current_username AND password = current_password LIMIT 1;
END//

CREATE PROCEDURE authenticate_as_carrier(current_identifier VARCHAR(4), current_password VARCHAR(255))
BEGIN
  SELECT * FROM carriers WHERE identifier = current_identifier AND password = current_password LIMIT 1;
END//

CREATE PROCEDURE carrier_id_from_serial_number(serial_number VARCHAR(255))
BEGIN
  SELECT id FROM carriers WHERE serial_number LIKE CONCAT(identifier, "%") LIMIT 1;
END//

-- This trigger doesn't work...
#CREATE TRIGGER categorise_notices AFTER INSERT ON intransit_notices
#FOR EACH ROW BEGIN
#  IF NEW.status = 'D' OR (SELECT count(*) FROM delivered_notices WHERE package_id = NEW.package_id) > 0
#  THEN
#    INSERT INTO delivered_notices (id, package_id, tag_sequence, status, recorded_at, lat, lng, comment)
#    VALUES (NEW.id, NEW.package_id, NEW.tag_sequence, NEW.status, NEW.recorded_at, NEW.lat, NEW.lng, NEW.comment);
#    DELETE FROM intransit_notices WHERE id = NEW.id;
#  END IF;
#END//


delimiter ; 

INSERT INTO administrators (id, username, password) VALUES (NULL, 'admin', 'admin');
