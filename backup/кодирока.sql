-- Создание мастер-ключа для базы данных (потребуется пароль)
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AGGA';

-- Создание сертификата для симметричного ключа
CREATE CERTIFICATE MyCertificate
    WITH SUBJECT = 'Data Encryption Certificate';

	-- Создание симметричного ключа с алгоритмом AES
CREATE SYMMETRIC KEY DataEncryptionKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE MyCertificate;

	-- Открытие симметричного ключа для использования
OPEN SYMMETRIC KEY DataEncryptionKey
    DECRYPTION BY CERTIFICATE MyCertificate;

-- Вставка зашифрованных паролей в таблицу
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

-- Открытие симметричного ключа для использования
OPEN SYMMETRIC KEY DataEncryptionKey
    DECRYPTION BY CERTIFICATE MyCertificate;

-- Вставка зашифрованных паролей в таблицу Users в схеме dbo
INSERT INTO dbo.Users (Login, EncryptedPassword)
VALUES
    ('AdminUser', ENCRYPTBYKEY(KEY_GUID('DataEncryptionKey'), 'AdminPassword123')),
    ('ClientUser', ENCRYPTBYKEY(KEY_GUID('DataEncryptionKey'), 'ClientPassword123')),
    ('ManagerUser', ENCRYPTBYKEY(KEY_GUID('DataEncryptionKey'), 'ManagerPassword123'));

-- Закрытие симметричного ключа после использования
CLOSE SYMMETRIC KEY DataEncryptionKey;

SELECT Login, EncryptedPassword
FROM dbo.Users;
