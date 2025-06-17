-- NIVEL 1
-- ejercicio 2
select distinct c.country from transaction t join company c on t.company_id = c.id where amount > 0 and declined = 0;

select count(distinct c.country) from transaction t join company c on t.company_id = c.id where amount > 0 and declined = 0;

-- ejercicio 3
select * from transaction where company_id in (select id from company where country = 'Germany');

select * from company where id in (select company_id from transaction where amount > (select avg(amount) from transaction where declined = 0));

delete from company where id not in (select company_id from transaction);



-- NIVEL 2
-- ejercicio 1
select date(timestamp) as fecha_en_dias, sum(amount) from transaction where amount >0 and declined = 0 group by fecha_en_dias limit 5;

-- ejercicio 2
select distinct c.country, avg(amount) as media_pais from transaction t join company c on t.company_id = c.id where t.declined = 0 and amount > 0 group by c.country order by media_pais desc;

-- ejercicio 3
select * from transaction t join company c on c.id = t.company_id where c.country = (select country from company where company_name = 'Non Institute');

select * from transaction where company_id in (select id from company where country = (select country from company where company_name = 'Non Institute'));


-- NIVEL 3
-- ejercicio 1
select c.company_name, c.phone, c.country, date(t.timestamp) as transaction_date, t.amount from company c join transaction t on c.id = t.company_id where t.amount between 350 and 400 and date(t.timestamp) in ('2015-04-29', '2018-07-20', '2024-03-13') and t.declined = 0 order by t.amount desc;

-- ejercicio 2
select count(c.id) as numero_transacciones, c.company_name, if(count(c.id) > 400, 'mas de 400', 'menos de 400') from transaction t left join company c on c.id = t.company_id group by c.id order by numero_transacciones desc;