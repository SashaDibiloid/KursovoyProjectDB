-- �������� ������-����� ��� ���� ������ (����������� ������)
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AGGA';

-- �������� ����������� ��� ������������� �����
CREATE CERTIFICATE MyCertificate
    WITH SUBJECT = 'Data Encryption Certificate';

	-- �������� ������������� ����� � ���������� AES
CREATE SYMMETRIC KEY DataEncryptionKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE MyCertificate;

	-- �������� ������������� ����� ��� �������������
OPEN SYMMETRIC KEY DataEncryptionKey
    DECRYPTION BY CERTIFICATE MyCertificate;

-- ������� ������������� ������� � �������
INSERT INTO Users (Login, EncryptedPassword)
VALUES
    ('AdminUser', ENCRYPTBYKEY(KEY_GUID('DataEncryptionKey'), 'AdminPassword123')),
    ('ClientUser', ENCRYPTBYKEY(KEY_GUID('DataEncryptionKey'), 'ClientPassword123')),
    ('ManagerUser', ENCRYPTBYKEY(KEY_GUID('DataEncryptionKey'), 'ManagerPassword123'));

SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'Users';

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Login VARCHAR(50),
    EncryptedPassword VARBINARY(MAX)
);

-- �������� ������������� ����� ��� �������������
OPEN SYMMETRIC KEY DataEncryptionKey
    DECRYPTION BY CERTIFICATE MyCertificate;

-- ������� ������������� ������� � ������� Users � ����� dbo
INSERT INTO dbo.Users (Login, EncryptedPassword)
VALUES
    ('AdminUser', ENCRYPTBYKEY(KEY_GUID('DataEncryptionKey'), 'AdminPassword123')),
    ('ClientUser', ENCRYPTBYKEY(KEY_GUID('DataEncryptionKey'), 'ClientPassword123')),
    ('ManagerUser', ENCRYPTBYKEY(KEY_GUID('DataEncryptionKey'), 'ManagerPassword123'));

-- �������� ������������� ����� ����� �������������
CLOSE SYMMETRIC KEY DataEncryptionKey;

SELECT Login, EncryptedPassword
FROM dbo.Users;
