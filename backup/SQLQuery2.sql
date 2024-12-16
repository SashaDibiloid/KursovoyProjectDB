USE CLUB;
GO

-- Вставка данных в таблицы
INSERT INTO Clients (Full_Name, Date_of_Birthday, Age_Category, Contact_Info, Availability_of_subscription, Gender, Join_Date) VALUES
(N'МухАмедьяров Вячеслав Денисович', '1990-01-15', N'Взрослый', 'myxa@mail.ru', 1, 'M', '2023-01-01'),
(N'Олийнык Юрий Нетотчествович', '1985-05-20', N'Взрослый', 'mrfunny67@ya.ru', 1, 'F', '2023-01-02'),
(N'Матвеев Даниил Александрович', '2000-03-10', N'Молодежь', 'danymat@yaaaho.com', 1, 'M', '2023-01-03'),
(N'Федорова Елизавета Артёмовна', '1995-07-25', N'Взрослый', 'lizkakergyzka@gufun.com', 1, 'F', '2023-01-04'),
(N'Зайцев Константин Максимович', '1988-11-30', N'Взрослый', 'kostya228@fugun.com', 0, 'M', '2023-01-05');

INSERT INTO Coahces (Full_Name, Specialization, Work_Schedule, Salary, Years_of_experience) VALUES
(N'Алексей Алексеев', N'Тренеры-по-пауэрлифтингу', N'Пн-Пт 9:00-18:00', 50000.00, N'15 лет'),
(N'Ольга Васильева', N'Йога-инструктор', N'Вт-Вс 10:00-19:00', 45000.00, N'3 года'),
(N'Андрей Андреянович', N'Персональный тренер', N'Пн-Сб 8:00-17:00', 60000.00, N'7 лет'),
(N'Анастасия Павловна', N'Пилатес-инструктор', N'Пн-Чт 11:00-20:00', 48000.00, N'5 лет'),
(N'Николай Владимирович', N'Тренер-по-битбоксу', N'Сб-Вс 10:00-15:00', 55000.00, N'6 лет');

INSERT INTO Services (Named,Description, Cost, Group_Session) VALUES
(N'Тренеровка по паэрлифтингу', N'Занятия в группе под руководством тренера', 1500.00, 1),
(N'Индивидуальная тренировка', N'Персональные занятия с тренером', 3000.00, 0),
(N'Йога для начинающих', N'Основы йоги для новичков', 1200.00, 1),
(N'Пилатес', N'Упражнения для укрепления мышц', 1300.00, 1),
(N'Битбокс', N'Занятие для горловых связок', 2000.00, 1);


SELECT Age_Category AS Возрастная_категория, STRING_AGG(Full_Name, ', ') AS Посетители
FROM Clients
GROUP BY Age_Category;

SELECT Full_Name AS ФИО, Date_of_Birthday AS Дата_рождения, Age_Category AS Возрастная_категория, 
       Contact_Info AS Контактная_информация, Gender AS Пол, Join_Date AS Дата_присоединения
FROM Clients;

SELECT Age_Category AS Возрастная_категория, STRING_AGG(Full_Name, ', ') AS Посетители
FROM Clients
GROUP BY Age_Category;


SELECT 
    c.Full_Name AS ФИО_посетителя,
    s.Named AS Название_услуги,
    sess.Date_Time AS Дата_и_время
FROM Sessions sess
JOIN Clients c ON sess.ID_Clients = c.ID_Clients
JOIN Services s ON sess.ID_Services = s.ID_Services
WHERE s.Group_Session = 1
ORDER BY sess.Date_Time;


SELECT Full_Name AS ФИО, Specialization AS Специализация, Salary AS Зарплата, 
       Years_of_experience AS Стаж, Work_Schedule AS График_работы
FROM Coahces;

SELECT Full_Name AS ФИО_тренера, Work_Schedule AS График_работы
FROM Coahces;

SELECT 
    s.Named AS Групповые_занятия, 
    STUFF(
        (
            SELECT ', ' + c2.Full_Name
            FROM Sessions sess_inner
            JOIN Clients c2 ON sess_inner.ID_Clients = c2.ID_Clients
            WHERE sess_inner.ID_Services = sess.ID_Services
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 
        1, 2, ''
    ) AS Участники
FROM Sessions sess
JOIN Services s ON sess.ID_Services = s.ID_Services
WHERE s.Group_Session = 1 
GROUP BY s.Named, sess.ID_Services;


SELECT c.Full_Name AS ФИО, c.Contact_Info AS Контактная_информация, 
       c.Availability_of_subscription AS Наличие_абонемента, s.Type AS Тип_абонемента
FROM Clients c
JOIN Subscriptions s ON c.ID_Clients = s.ID_Clients
WHERE c.Availability_of_subscription = 1;


SELECT co.Full_Name AS ФИО_тренера, SUM(s.Cost) AS Общая_стоимость_услуг
FROM Sessions sess
JOIN Coahces co ON sess.ID_Coaches = co.ID_Coaches
JOIN Services s ON sess.ID_Services = s.ID_Services
GROUP BY co.Full_Name;

SELECT 
    c.Full_Name AS ФИО_посетителя,
    SUM(s.Cost) AS Общая_стоимость_услуг
FROM Sessions sess
JOIN Clients c ON sess.ID_Clients = c.ID_Clients
JOIN Services s ON sess.ID_Services = s.ID_Services
GROUP BY c.Full_Name
ORDER BY Общая_стоимость_услуг DESC;
