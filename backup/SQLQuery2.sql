USE CLUB;
GO

-- ������� ������ � �������
INSERT INTO Clients (Full_Name, Date_of_Birthday, Age_Category, Contact_Info, Availability_of_subscription, Gender, Join_Date) VALUES
(N'������������ �������� ���������', '1990-01-15', N'��������', 'myxa@mail.ru', 1, 'M', '2023-01-01'),
(N'������� ���� ��������������', '1985-05-20', N'��������', 'mrfunny67@ya.ru', 1, 'F', '2023-01-02'),
(N'������� ������ �������������', '2000-03-10', N'��������', 'danymat@yaaaho.com', 1, 'M', '2023-01-03'),
(N'�������� ��������� ��������', '1995-07-25', N'��������', 'lizkakergyzka@gufun.com', 1, 'F', '2023-01-04'),
(N'������ ���������� ����������', '1988-11-30', N'��������', 'kostya228@fugun.com', 0, 'M', '2023-01-05');

INSERT INTO Coahces (Full_Name, Specialization, Work_Schedule, Salary, Years_of_experience) VALUES
(N'������� ��������', N'�������-��-�������������', N'��-�� 9:00-18:00', 50000.00, N'15 ���'),
(N'����� ���������', N'����-����������', N'��-�� 10:00-19:00', 45000.00, N'3 ����'),
(N'������ �����������', N'������������ ������', N'��-�� 8:00-17:00', 60000.00, N'7 ���'),
(N'��������� ��������', N'�������-����������', N'��-�� 11:00-20:00', 48000.00, N'5 ���'),
(N'������� ������������', N'������-��-��������', N'��-�� 10:00-15:00', 55000.00, N'6 ���');

INSERT INTO Services (Named,Description, Cost, Group_Session) VALUES
(N'���������� �� ������������', N'������� � ������ ��� ������������ �������', 1500.00, 1),
(N'�������������� ����������', N'������������ ������� � ��������', 3000.00, 0),
(N'���� ��� ����������', N'������ ���� ��� ��������', 1200.00, 1),
(N'�������', N'���������� ��� ���������� ����', 1300.00, 1),
(N'�������', N'������� ��� �������� ������', 2000.00, 1);


SELECT Age_Category AS ����������_���������, STRING_AGG(Full_Name, ', ') AS ����������
FROM Clients
GROUP BY Age_Category;

SELECT Full_Name AS ���, Date_of_Birthday AS ����_��������, Age_Category AS ����������_���������, 
       Contact_Info AS ����������_����������, Gender AS ���, Join_Date AS ����_�������������
FROM Clients;

SELECT Age_Category AS ����������_���������, STRING_AGG(Full_Name, ', ') AS ����������
FROM Clients
GROUP BY Age_Category;


SELECT 
    c.Full_Name AS ���_����������,
    s.Named AS ��������_������,
    sess.Date_Time AS ����_�_�����
FROM Sessions sess
JOIN Clients c ON sess.ID_Clients = c.ID_Clients
JOIN Services s ON sess.ID_Services = s.ID_Services
WHERE s.Group_Session = 1
ORDER BY sess.Date_Time;


SELECT Full_Name AS ���, Specialization AS �������������, Salary AS ��������, 
       Years_of_experience AS ����, Work_Schedule AS ������_������
FROM Coahces;

SELECT Full_Name AS ���_�������, Work_Schedule AS ������_������
FROM Coahces;

SELECT 
    s.Named AS ���������_�������, 
    STUFF(
        (
            SELECT ', ' + c2.Full_Name
            FROM Sessions sess_inner
            JOIN Clients c2 ON sess_inner.ID_Clients = c2.ID_Clients
            WHERE sess_inner.ID_Services = sess.ID_Services
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 
        1, 2, ''
    ) AS ���������
FROM Sessions sess
JOIN Services s ON sess.ID_Services = s.ID_Services
WHERE s.Group_Session = 1 
GROUP BY s.Named, sess.ID_Services;


SELECT c.Full_Name AS ���, c.Contact_Info AS ����������_����������, 
       c.Availability_of_subscription AS �������_����������, s.Type AS ���_����������
FROM Clients c
JOIN Subscriptions s ON c.ID_Clients = s.ID_Clients
WHERE c.Availability_of_subscription = 1;


SELECT co.Full_Name AS ���_�������, SUM(s.Cost) AS �����_���������_�����
FROM Sessions sess
JOIN Coahces co ON sess.ID_Coaches = co.ID_Coaches
JOIN Services s ON sess.ID_Services = s.ID_Services
GROUP BY co.Full_Name;

SELECT 
    c.Full_Name AS ���_����������,
    SUM(s.Cost) AS �����_���������_�����
FROM Sessions sess
JOIN Clients c ON sess.ID_Clients = c.ID_Clients
JOIN Services s ON sess.ID_Services = s.ID_Services
GROUP BY c.Full_Name
ORDER BY �����_���������_����� DESC;
