CREATE USER 'auth_user'@'localhost' IDENTIFIED BY '123456';

CREATE DATABASE auth;

GRANT ALL PRIVILEGES ON auth.* to 'auth_user'@'localhost';

USE auth;

CREATE TABLE user (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

INSERT INTO user(email, password) VALUES ('admin@gmail.com', '123456');
