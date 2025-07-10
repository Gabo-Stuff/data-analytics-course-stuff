-- Nivel 1
-- preliminares
CREATE TABLE IF NOT EXISTS transaction (
	id VARCHAR(40) UNIQUE NOT NULL,
    card_id VARCHAR(20) NOT NULL,
    bussiness_id VARCHAR(10) NOT NULL,
    timestamp TIMESTAMP,
    amount DECIMAL(10,2),
    declined INT,
    product_ids VARCHAR(100) NOT NULL,
    user_id INT NOT NULL,
    lat FLOAT,
    longitude FLOAT,
    PRIMARY KEY(id),
    KEY(card_id),
    KEY(bussiness_id),
    KEY(product_ids),
    KEY(user_id),
    CONSTRAINT fk_transaction_card_id FOREIGN KEY(card_id) REFERENCES credit_card(id),
    CONSTRAINT fk_transaction_bussiness_id FOREIGN KEY (bussiness_id) REFERENCES company(company_id),
    CONSTRAINT fk_transaction_american_users_id FOREIGN KEY (user_id) REFERENCES american_user(id)
);

CREATE TABLE IF NOT EXISTS product (
	id VARCHAR(100) UNIQUE NOT NULL,
    product_name VARCHAR(30) NOT NULL,
    price VARCHAR(20) NOT NULL,
    colour VARCHAR(25),
    weight FLOAT,
    warehouse_id INT NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS company (
	company_id VARCHAR(20) UNIQUE NOT NULL,
    company_name VARCHAR(25) NOT NULL,
    phone INT,
    email VARCHAR(50),
    country VARCHAR(20) NOT NULL,
    website VARCHAR(50),
    PRIMARY KEY(company_id)
);

CREATE TABLE IF NOT EXISTS credit_card (
	id INT UNIQUE NOT NULL,
    user_id VARCHAR(10) NOT NULL,
    iban INT NOT NULL,
    pan INT,
    pin INT NOT NULL,
    cvv INT NOT NULL,
    track1 VARCHAR(50),
    track2 VARCHAR(50),
    expiring_date DATETIME,
    PRIMARY KEY(id),
    KEY(user_id),
    CONSTRAINT fk_credit_card_american_user_id FOREIGN KEY(user_id) REFERENCES american_user(id)
);

CREATE TABLE IF NOT EXISTS user (
	id INT UNIQUE NOT NULL,
    name VARCHAR(10) NOT NULL,
    surname VARCHAR(10) NOT NULL,
    phone VARCHAR(14),
    email VARCHAR(25),
    BIRTH_DATE DATETIME,
    country VARCHAR(25),
    city VARCHAR(20),
    postal_code INT,
    adress VARCHAR(25),
    PRIMARY KEY(id)
);

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/american_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/european_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE product
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bussiness.csv'
INTO TABLE company
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv'
INTO TABLE credit_card
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transaction
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- ejercicio 1
SELECT id, name FROM user
WHERE id IN (
	SELECT user_id FROM transaction
    GROUP BY user_id
    HAVING count(id) > 80
    )

-- ejercicio 2
SELECT 
  cc.iban, 
  AVG(t.amount) AS avg_amount
FROM 
  credit_card cc
  JOIN transaction t ON t.card_id = cc.id
  JOIN company c ON t.bussiness_id = c.company_id
WHERE 
  c.company_name = 'Donec Ltd'
GROUP BY 
  cc.iban;

-- Nivel 2
-- preliminares
CREATE TABLE IF NOT EXISTS estado_card (
 id VARCHAR(20) NOT NULL,
 estado  ENUM('activa', 'inactiva'),
 iban VARCHAR(50) NOT NULL,
 KEY(id),
 PRIMARY KEY (id)
);

INSERT INTO estado_card (
	id,
    estado,
    iban
    )
SELECT 
	cc.id,
    CASE
		WHEN 
		(SELECT COUNT(*)
            FROM transaction t
            WHERE t.card_id = cc.id
            AND t.declined = 1
            ORDER BY t.timestamp DESC
            LIMIT 3) = 3
		THEN 'inactiva' 
		ELSE 'activa'
	END AS estado,
	cc.iban
FROM credit_card cc;

-- ejercicio 1
SELECT COUNT(*) as numero_activas FROM estado_card
WHERE estado = 'activa';

-- Nivel 3
-- preliminares
CREATE TABLE IF NOT EXISTS transaction_product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(40) NOT NULL,
    product_id VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_transaction_product (transaction_id, product_id),
    CONSTRAINT fk_transaction_id FOREIGN KEY (transaction_id) REFERENCES transaction(id),
    CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES product(id)
);

-- ejercicio 1
SELECT COUNT(*) as numero_transacciones, tp.product_id FROM transaction_product tp
JOIN transaction t
ON t.id = tp.transaction_id
WHERE t.declined = 0
GROUP BY product_id
ORDER BY product_id DESC;



