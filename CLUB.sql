use club;

CREATE TABLE Clients (
    ID_Client INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(50) NOT NULL , 
    Date_of_Birthday DATE NOT NULL,
    Age_Category VARCHAR(20),
    Contact_Info VARCHAR(100),
    Availability_of_subscription BOOLEAN NOT NULL,
    Gender CHAR(1),
    Join_Date DATE
);

CREATE TABLE Coaches (
    ID_Coach INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Work_Schedule VARCHAR(255),
    Salary DECIMAL(10,2),
    Years_of_experience VARCHAR(25) NOT NULL
);

CREATE TABLE Services (
    ID_Service INT AUTO_INCREMENT PRIMARY KEY,
    Named VARCHAR(100) NOT NULL, -- TITLE
    Descriptions TEXT,
    Cost DECIMAL(10,2) NOT NULL,
    Group_Session BOOLEAN
);

CREATE TABLE Sessions (
    ID_Session INT AUTO_INCREMENT PRIMARY KEY,
    ID_Coach INT NOT NULL,
    ID_Service INT NOT NULL,
    ID_Client INT NOT NULL,
    Date_Time DATETIME NOT NULL,
    Session_Type VARCHAR(20) NOT NULL,
    Duration_Minutes INT,
    Room_Number INT,
    FOREIGN KEY (ID_Coach) REFERENCES Coaches(ID_Coach) ON DELETE CASCADE,
    FOREIGN KEY (ID_Service) REFERENCES Services(ID_Service) ON DELETE CASCADE,
    FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client) ON DELETE CASCADE
);

CREATE TABLE Subscriptions (
    ID_Subscription INT AUTO_INCREMENT PRIMARY KEY,
    ID_Client INT NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Cost DECIMAL(10,2) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    Max_Sessions INT,
    FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client) ON DELETE CASCADE
);

USE club;
INSERT INTO Clients (Full_Name, Date_of_Birthday, Age_Category, Contact_Info, Availability_of_subscription, Gender, Join_Date) VALUES
('МухАмедьяров Вячеслав Денисович', '1990-01-15', 'Взрослый', 'myxa@mail.ru', TRUE, 'M', '2023-01-01'),
('Олийнык Юрий Нетотчествович', '1985-05-20', 'Взрослый', 'mrfunny67@ya.ru', TRUE, 'F', '2023-01-02'),
('Матвеев Даниил Александрович', '2000-03-10', 'Молодежь', 'danymat@yaaaho.com', TRUE, 'M', '2023-01-03'),
('Федорова Елизавета Артёмовна', '1995-07-25', 'Взрослый', 'lizkakergyzka@gufun.com', TRUE, 'F', '2023-01-04'),
('Зайцев Константин Максимович', '1988-11-30', 'Взрослый', 'kostya228@fugun.com', false, 'M', '2023-01-05');

INSERT INTO Coaches (Full_Name, Specialization, Work_Schedule, Salary, Years_of_experience) VALUES
('Алексей Алексеев', 'Тренеры-по-пауэрлифтингу', 'Пн-Пт 9:00-18:00', 50000.00, '15 лет'),
('Ольга Васильева', 'Йога-инструктор', 'Вт-Вс 10:00-19:00', 45000.00, '3 года'),
('Андрей Андреянович', 'Персональный тренер', 'Пн-Сб 8:00-17:00', 60000.00, '7 лет'),
('Анастасия Павловна', 'Пилатес-инструктор', 'Пн-Чт 11:00-20:00', 48000.00, '5 лет'),
('Николай Владимирович', 'Тренер-по-битбоксу', 'Сб-Вс 10:00-15:00', 55000.00, '6 лет');

INSERT INTO Services (Named, Descriptions, Cost, Group_Session) VALUES
('Тренеровка по паэрлифтингу', 'Занятия в группе под руководством тренера', 1500.00, TRUE),
('Индивидуальная тренировка', 'Персональные занятия с тренером', 3000.00, FALSE),
('Йога для начинающих', 'Основы йоги для новичков', 1200.00, TRUE),
('Пилатес', 'Упражнения для укрепления мышц', 1300.00, TRUE),
('Битбокс', 'Занятие для горловых связок', 2000.00, TRUE);


INSERT INTO Sessions (ID_Coach, ID_Service, ID_Client, Date_Time, Session_Type, Duration_Minutes, Room_Number) VALUES
('2023-01-10 10:00:00', 'Групповая', 60, 111),
( '2023-01-11 11:00:00', 'Индивидуальная', 45, 52),
('2023-01-12 12:00:00', 'Групповая', 60, 66),
('2023-01-13 13:00:00', 'Групповая', 60, 61),
('2023-01-14 14:00:00', 'Групповая', 60, 106);


INSERT INTO Subscriptions (ID_Client, Start_Date, End_Date, Cost, Type, Max_Sessions) VALUES
(1, '2023-01-01', '2023-06-01', 10000.00, 'Месячная', 10),
(2, '2023-01-02', '2023-07-01', 12000.00, 'Полугодовая', 20),
(3, '2023-01-03', '2023-08-01', 15000.00, 'Годовая', 30),
(4, '2023-01-04', '2023-09-01', 8000.00, 'Месячная', 10),
(5, '2023-01-05', '2023-10-01', 9000.00, 'Месячная', 10);


SELECT Named AS Название_услуги, Cost AS Стоимость
FROM Services;

SELECT Full_Name AS ФИО, Date_of_Birthday AS Дата_рождения, Age_Category AS Возрастная_категория, 
       Contact_Info AS Контактная_информация, Gender AS Пол, Join_Date AS Дата_присоединения
FROM Clients;

SELECT Age_Category AS Возрастная_категория, GROUP_CONCAT(Full_Name SEPARATOR ', ') AS Посетители
FROM Clients
GROUP BY Age_Category;

SELECT 
    c.Full_Name AS ФИО_посетителя,
    s.Named AS Название_услуги,
    sess.Date_Time AS Дата_и_время
FROM Sessions sess
JOIN Clients c ON sess.ID_Client = c.ID_Client
JOIN Services s ON sess.ID_Service = s.ID_Service
WHERE s.Group_Session = TRUE
ORDER BY sess.Date_Time;


SELECT Full_Name AS ФИО, Specialization AS Специализация, Salary AS Зарплата, 
       Years_of_experience AS Стаж, Work_Schedule AS График_работы
FROM Coaches;

SELECT Full_Name AS ФИО_тренера, Work_Schedule AS График_работы
FROM Coaches;

SELECT s.Named AS Групповые_занятия, GROUP_CONCAT(c.Full_Name SEPARATOR ', ') AS Участники
FROM Sessions sess
JOIN Services s ON sess.ID_Service = s.ID_Service
JOIN Clients c ON sess.ID_Client = c.ID_Client
WHERE s.Group_Session = TRUE
GROUP BY s.Named;

SELECT c.Full_Name AS ФИО, c.Contact_Info AS Контактная_информация, 
       c.Availability_of_subscription AS Наличие_абонемента, s.Type AS Тип_абонемента
FROM Clients c
JOIN Subscriptions s ON c.ID_Client = s.ID_Client
WHERE c.Availability_of_subscription = TRUE;


SELECT co.Full_Name AS ФИО_тренера, SUM(s.Cost) AS Общая_стоимость_услуг
FROM Sessions sess
JOIN Coaches co ON sess.ID_Coach = co.ID_Coach
JOIN Services s ON sess.ID_Service = s.ID_Service
GROUP BY co.Full_Name;

SELECT 
    c.Full_Name AS ФИО_посетителя,
    SUM(s.Cost) AS Общая_стоимость_услуг
FROM Sessions sess
JOIN Clients c ON sess.ID_Client = c.ID_Client
JOIN Services s ON sess.ID_Service = s.ID_Service
GROUP BY c.Full_Name
ORDER BY Общая_стоимость_услуг DESC;






