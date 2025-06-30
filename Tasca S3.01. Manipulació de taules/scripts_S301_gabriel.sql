-- Nivel 1
-- ejercicio 1
CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(15) PRIMARY KEY,
    iban VARCHAR(34) NOT NULL UNIQUE,
    pan VARCHAR(19) NOT NULL UNIQUE,
    pin VARCHAR(4) NOT NULL,
    cvv VARCHAR(4) NOT NULL,
    expiring_date VARCHAR(10) NOT NULL
);

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

-- ejercicio 2
UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT * FROM credit_card
WHERE iban = 'TR323456312213576817699999';

-- ejercicio 3
INSERT INTO transaction (
    id,
    credit_card_id,
    company_id,
    user_id,
    lat,
    longitude,
    timestamp,
    amount,
    declined
) VALUES (
    '108B1D1D-5B23-A76C-55EF-C568E49A99DD',
    'CcU-9999',
    'b-9999',
    9999,
    829.999,
    -117.999,
    NOW(),
    111.11,
    FALSE 
);

ALTER TABLE credit_card
DROP COLUMN pan;


-- Nivel 2
-- ejercicio 1

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

-- ejercicio 2
CREATE VIEW VistaMarketing AS
SELECT c.company_name, c.phone, c.country, AVG(t.amount) AS media_compras
FROM company c JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0
AND t.amount > 0
GROUP BY c.company_name, c.phone, c.country;

SELECT * FROM VistaMarketing
ORDER BY media_compras DESC;

-- ejercicio 3
SELECT * FROM VistaMarketing
WHERE country = 'Germany'
ORDER BY media_compras DESC;

-- Nivel 3
-- ejercicio 1
-- tabla company
ALTER TABLE company
DROP COLUMN website;

-- tabla transaction
ALTER TABLE transaction
MODIFY credit_card_id VARCHAR(25);

-- tabla credit_card
ALTER TABLE credit_card
MODIFY iban VARCHAR(50);

ALTER TABLE credit_card
MODIFY expiring_date VARCHAR(20);

ALTER TABLE transaction
DROP FOREIGN KEY fk_transaction_credit_card;

ALTER TABLE credit_card
MODIFY id VARCHAR(20);

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

ALTER TABLE credit_card
MODIFY cvv INT;

ALTER TABLE credit_card
MODIFY expiring_date VARCHAR(20);

ALTER TABLE credit_card
MODIFY fecha_actual DATE;

ALTER TABLE user
MODIFY id INT;

ALTER TABLE user
CHANGE email personal_email VARCHAR(150);

-- ejercicio 2
-- opcion basica
CREATE VIEW InformeTecnico AS
SELECT 
	t.id as transaction_id,
	u.name as user_name,
    u.surname as user_surname,
    cc.iban as user_credit_card_iban,
    c.company_name
FROM transaction t
INNER JOIN user as u ON t.user_id = u.id
INNER JOIN credit_card as cc ON t.credit_card_id = cc.id
INNER JOIN company as c ON t.company_id = c.id
WHERE t.declined = 0
AND amount > 0

SELECT * FROM InformeTecnico
ORDER BY transaction_id;

-- opcion mas desarrollada
CREATE VIEW InformeTecnico AS
SELECT 
	t.id as transaction_id,
	u.name as user_name,
    u.surname as user_surname,
    u.phone as user_phone,
    t.amount as transaction_amount,
    cc.iban as user_credit_card_iban,
    c.company_name,
    c.phone as company_phone,
    c.country company_country,
    t.timestamp
FROM transaction t
INNER JOIN user as u ON t.user_id = u.id
INNER JOIN credit_card as cc ON t.credit_card_id = cc.id
INNER JOIN company as c ON t.company_id = c.id
WHERE t.declined = 0
AND amount > 0

SELECT * FROM InformeTecnico
ORDER BY transaction_id;