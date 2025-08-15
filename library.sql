-- 1️⃣ Create Database
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- 2️⃣ Create Tables
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(8,2),
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Issued'))
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    issue_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- 3️⃣ Insert Sample Data
INSERT INTO Books (title, author, category, price) VALUES
('The Alchemist', 'Paulo Coelho', 'Fiction', 300.00),
('Clean Code', 'Robert C. Martin', 'Programming', 550.00),
('Rich Dad Poor Dad', 'Robert Kiyosaki', 'Finance', 400.00);

INSERT INTO Members (name, email, phone) VALUES
('Alice Johnson', 'alice@example.com', '9876543210'),
('Bob Smith', 'bob@example.com', '9876543211');

INSERT INTO Transactions (book_id, member_id, issue_date, return_date) VALUES
(1, 1, '2025-08-01', '2025-08-10'),
(2, 2, '2025-08-05', NULL);

-- 4️⃣ Sample Queries

-- 📌 View All Books
SELECT * FROM Books;

-- 📌 View Members
SELECT * FROM Members;

-- 📌 Issue a Book (update status)
UPDATE Books SET status = 'Issued' WHERE book_id = 1;

-- 📌 View Currently Issued Books
SELECT b.title, m.name, t.issue_date
FROM Transactions t
JOIN Books b ON t.book_id = b.book_id
JOIN Members m ON t.member_id = m.member_id
WHERE b.status = 'Issued';

-- 📌 Late Return Report (Books not returned in 7 days)
SELECT b.title, m.name, t.issue_date, DATEDIFF(CURDATE(), t.issue_date) AS days_issued
FROM Transactions t
JOIN Books b ON t.book_id = b.book_id
JOIN Members m ON t.member_id = m.member_id
WHERE t.return_date IS NULL AND DATEDIFF(CURDATE(), t.issue_date) > 7;

-- 📌 Return a Book
UPDATE Books SET status = 'Available' WHERE book_id = 1;
UPDATE Transactions SET return_date = CURDATE() WHERE transaction_id = 1;
