-- ------------------------------------------ --
-- ---------- PIZZA DATETIME ------------------- --
-- ------------------------------------------ --

-- renombramos tabla --
alter table orders rename to pizza_dt;

-- creamos un procedimiento -- 
delimiter $$
create procedure pdt()
begin
	select * from pizza_dt;
end $$
delimiter ;

call pdt();

-- revisamos duplicados --
select count(*) as cantidad_duplicados
from
	(select order_id
    from pizza_dt
    group by order_id
    having count(*) > 1
    ) as subquery;
-- duplicados = 0 --

call pdt();

-- cambiar a formato de fecha mysql --
-- ensayo
SELECT date, CASE
    WHEN date LIKE '%-%' THEN STR_TO_DATE(date, '%Y-%m-%d')
    ELSE NULL
END AS new_date
FROM pizza_dt;

-- actualizar cambios
update pizza_dt
set date = CASE
    WHEN date LIKE '%-%' THEN STR_TO_DATE(date, '%Y-%m-%d')
    else null
    end;
    
-- cambio tipo de dato --
alter table pizza_dt modify column date DATE;

describe pizza_dt;

call pdt();

-- cambiar a formato de tiempo mysql --
-- ensayo
SELECT time, CASE
    WHEN time LIKE '%:%' THEN STR_TO_DATE(time, '%H:%i:%s')
    ELSE NULL
END AS new_time
FROM pizza_dt;

-- cambio tipo de dato --
alter table pizza_dt modify column time TIME;

describe pizza_dt;

call pdt();

-- cambiar a not null la columna order_id y transformarla en PK --
alter table pizza_dt modify column order_id int not null primary key;

-- concatenar date y time -- (a modo de saber como se hace)
select order_id, str_to_date(concat(date,' ',time), '%Y-%m-%d %H:%i:%s') as date_time from pizza_dt;
