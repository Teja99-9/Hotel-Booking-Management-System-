CREATE TABLE Hotels(
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_name VARCHAR(50),
    city VARCHAR(30),
    star_rating INT
);
INSERT INTO Hotels(hotel_name,city,star_rating)
VALUES
('Grand Palace','Chennai',5),
('Royal Inn','Bangalore',4),
('Blue Moon','Hyderabad',3);

CREATE TABLE Rooms(
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT,
    room_number VARCHAR(10),
    room_type VARCHAR(20),
    price DECIMAL(10,2),
    status VARCHAR(20),

    FOREIGN KEY(hotel_id)
    REFERENCES Hotels(hotel_id)
);
INSERT INTO Rooms(hotel_id,room_number,room_type,price,status)
VALUES
(1,'101','Standard',2500,'Available'),
(1,'102','Deluxe',4000,'Occupied'),
(1,'103','Suite',7000,'Occupied'),
(2,'201','Standard',2200,'Available'),
(2,'202','Deluxe',3800,'Occupied'),
(3,'301','Standard',1800,'Available'),
(3,'302','Suite',6000,'Occupied');

CREATE TABLE Guests(
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(50),
    phone VARCHAR(15),
    city VARCHAR(30)
);
INSERT INTO Guests(guest_name,phone,city)
VALUES
('Rahul','9876543210','Chennai'),
('Priya','9876543211','Bangalore'),
('Arun','9876543212','Hyderabad'),
('Sneha','9876543213','Coimbatore'),
('Karthik','9876543214','Mumbai');

CREATE TABLE Bookings(
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    booking_status VARCHAR(20),

    FOREIGN KEY(guest_id)
    REFERENCES Guests(guest_id),

    FOREIGN KEY(room_id)
    REFERENCES Rooms(room_id)
);
INSERT INTO Bookings(guest_id,room_id,check_in,check_out,booking_status)
VALUES
(1,2,'2026-07-25','2026-07-30','Completed'),
(2,3,'2026-07-28','2026-08-02','Active'),
(3,5,'2026-07-29','2026-08-01','Active'),
(4,7,'2026-07-20','2026-07-22','Completed'),
(1,1,'2026-08-05','2026-08-08','Booked'),
(5,4,'2026-07-31','2026-08-03','Cancelled');

CREATE TABLE Payments(
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20),

    FOREIGN KEY(booking_id)
    REFERENCES Bookings(booking_id)
);
INSERT INTO Payments(booking_id,amount,payment_status)
VALUES
(1,20000,'Paid'),
(2,35000,'Paid'),
(3,12000,'Pending'),
(4,15000,'Paid'),
(5,7500,'Pending'),
(6,0,'Refunded');

-- 1.Display Available Rooms
SELECT
room_number,
room_type,
price,
hotel_name
FROM Rooms
JOIN Hotels
ON Rooms.hotel_id=Hotels.hotel_id
WHERE status='Available';

-- 2.Find Guests Staying Today
SELECT
guest_name,
hotel_name,
room_number,
check_in,
check_out
FROM Guests
JOIN Bookings
ON Guests.guest_id=Bookings.guest_id
JOIN Rooms
ON Bookings.room_id=Rooms.room_id
JOIN Hotels
ON Rooms.hotel_id=Hotels.hotel_id
WHERE CURDATE()
BETWEEN check_in AND check_out
AND booking_status='Active';

-- 3.Calculate Total Revenue
SELECT
SUM(amount) AS Total_Revenue
FROM Payments
WHERE payment_status='Paid';

-- 4.Display Bookings Between Two Dates
SELECT
booking_id,
guest_name,
hotel_name,
check_in,
check_out
FROM Bookings
JOIN Guests
ON Bookings.guest_id=Guests.guest_id
JOIN Rooms
ON Bookings.room_id=Rooms.room_id
JOIN Hotels
ON Rooms.hotel_id=Hotels.hotel_id
WHERE check_in
BETWEEN '2026-07-25'
AND '2026-07-31';

-- 5.Find the Most Booked Room Type
SELECT
room_type,
COUNT(*) AS Total_Bookings
FROM Rooms
JOIN Bookings
ON Rooms.room_id=Bookings.room_id
GROUP BY room_type
ORDER BY Total_Bookings DESC
LIMIT 1;

-- 6.Calculate Occupancy Rate
SELECT
ROUND(
(
COUNT(CASE WHEN status='Occupied' THEN 1 END)
*100.0
/
COUNT(*)
),2)
AS Occupancy_Rate
FROM Rooms;

-- 7.Display Cancelled Bookings
SELECT
booking_id,
guest_name,
hotel_name,
room_number
FROM Bookings
JOIN Guests
ON Bookings.guest_id=Guests.guest_id
JOIN Rooms
ON Bookings.room_id=Rooms.room_id
JOIN Hotels
ON Rooms.hotel_id=Hotels.hotel_id
WHERE booking_status='Cancelled';

-- 8.Find Customers with Multiple Bookings
SELECT
guest_name,
COUNT(booking_id) AS Total_Bookings
FROM Guests
JOIN Bookings
ON Guests.guest_id=Bookings.guest_id
GROUP BY guest_name
HAVING COUNT(*)>1;

-- 9.Display Average Room Price
SELECT
AVG(price) AS Average_Room_Price
FROM Rooms;

-- 10.Find Hotels with More Than 100 Rooms
SELECT
hotel_name,
COUNT(room_id) AS Total_Rooms
FROM Hotels
JOIN Rooms
ON Hotels.hotel_id=Rooms.hotel_id
GROUP BY hotel_name
HAVING COUNT(room_id)>100;

-- 11.Find the highest-paying guest
SELECT
g.guest_name,
SUM(p.amount) AS Total_Spent
FROM Guests g
JOIN Bookings b
ON g.guest_id=b.guest_id
JOIN Payments p
ON b.booking_id=p.booking_id
GROUP BY g.guest_name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 12.Hotel-wise revenue
SELECT
h.hotel_name,
SUM(p.amount) AS Revenue
FROM Hotels h
JOIN Rooms r
ON h.hotel_id=r.hotel_id
JOIN Bookings b
ON r.room_id=b.room_id
JOIN Payments p
ON b.booking_id=p.booking_id
WHERE p.payment_status='Paid'
GROUP BY h.hotel_name;

-- 13.Most expensive room
SELECT
room_number,
room_type,
price
FROM Rooms
ORDER BY price DESC
LIMIT 1;

-- 14.Guests who have never made a booking
SELECT
g.guest_name
FROM Guests g
LEFT JOIN Bookings b
ON g.guest_id=b.guest_id
WHERE b.booking_id IS NULL;

-- 15.Rank hotels by revenue
SELECT
h.hotel_name,
SUM(p.amount) AS Revenue,
RANK() OVER (ORDER BY SUM(p.amount) DESC) AS Revenue_Rank
FROM Hotels h
JOIN Rooms r
ON h.hotel_id=r.hotel_id
JOIN Bookings b
ON r.room_id=b.room_id
JOIN Payments p
ON b.booking_id=p.booking_id
WHERE p.payment_status='Paid'
GROUP BY h.hotel_name;












