-- Gets a list of available rooms based on set date range and specifications
SELECT DISTINCT roomID 
FROM room 
WHERE roomID NOT IN (
	SELECT roomreservation.roomID 
	FROM roomreservation
	INNER JOIN reservation
	ON reservation.reservationID = roomreservation.reservationID
	WHERE DATEDIFF('2013-11-09',dateFor) >= 0
	AND DATEDIFF('2013-11-05',checkOutDate) <= 0
)
AND isLakeview = 1
AND isSuite = 1
AND numBeds = 1
AND locked = 0;

-- Gets a list of unavailable rooms based on the date range
SELECT roomreservation.roomID, dateFor, checkOutDate 
	FROM roomreservation
	INNER JOIN reservation
	ON reservation.reservationID = roomreservation.reservationID
	WHERE DATEDIFF('2013-11-9',dateFor) >= 0
	AND DATEDIFF('2013-11-5',checkOutDate) <= 0;




UPDATE hotelsystem.room SET locked = 0 WHERE locked = 1;

select * from room where locked = 1;

select * from user;
select * from customer;
select * from reservation;
Select * from roomreservation;


-- Creates a user and a coresponding reservation
INSERT INTO user VALUES (NULL,'Nikko','Campbell','396 Ambrose St.','Thunder Bay', 'Ontario', 'Canada', '8076302555', 'c');
SELECT @last := LAST_INSERT_ID();
SELECT * FROM user;
INSERT INTO customer VALUES (NULL,@last);
SELECT @last := LAST_INSERT_ID();
SELECT * FROM customer;
INSERT INTO reservation VALUES (NULL, '2013-11-04','2013-11-06',@last,'r');
SELECT @last := LAST_INSERT_ID();
SELECT * FROM reservation;
INSERT INTO roomreservation VALUES (@last,'2013-11-10',702);
SELECT * FROM roomreservation;

-- Removes all entries from specified tables
set FOREIGN_KEY_CHECKS = 0;
truncate table customer;
truncate table user;
truncate table reservation;
truncate table roomreservation;
set FOREIGN_KEY_CHECKS = 1;