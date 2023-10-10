-- ------------------------------------------ --
-- ---------- PIZZA TYPES ------------------- --
-- ------------------------------------------ --

-- crear base de datos para mis tablas -
create database if not exists pizzasales;

-- seleccionar base de datos --
use pizzasales;

-- ver 10 registros --
select * from pizza_types limit 10;

-- crear store procedure para llamar tabla --
DELIMITER $$
create procedure pt()
begin
	select * from pizza_types;
end $$
DELIMITER ;

-- llamar store procedure para ver tabla completa--
call pt();

-- 1 Verificar si existen registros duplicados --
select count(*) as duplicates
from (
select pizza_type_id
from pizza_types
group by pizza_type_id
having count(*) > 1
) as subquery;
-- duplicates = 0 --

-- 2 modificar columna ingredients --

-- ingredientes por pizza_type_id --
select pizza_type_id, (length(ingredients)-length(replace(ingredients,',',''))) + 1 as number_ingredients
from pizza_types
order by number_ingredients desc;

-- agregar columna number_ingredients a tabla original --
alter table pizza_types
add column number_ingredients varchar(100);

update pizza_types
set number_ingredients = (length(ingredients)-length(replace(ingredients,',',''))) + 1;

call pt();

-- splitar columna de ingredientes --
-- prueba --
select pizza_type_id, ingredients,
if (number_ingredients >0, substring_index(ingredients,',',1),null) as ingredient01,
if (number_ingredients >1, substring_index(substring_index(ingredients,',',2),',',-1),null) as ingredient02,
if (number_ingredients >2, substring_index(substring_index(ingredients,',',3),',',-1),null) as ingredient03,
if (number_ingredients >3, substring_index(substring_index(ingredients,',',4),',',-1),null) as ingredient04,
if (number_ingredients >4, substring_index(substring_index(ingredients,',',-4),',',1),null) as ingredient05,
if (number_ingredients >5, substring_index(substring_index(ingredients,',',-3),',',1),null) as ingredient06,
if (number_ingredients >6, substring_index(substring_index(ingredients,',',-2),',',1),null) as ingredient07,
if (number_ingredients >7, substring_index(ingredients,',',-1),null) as ingredient08
from pizza_types
order by number_ingredients desc;

-- agrego columnas para cada ingrediente --
alter table pizza_types
add column ingredient01 varchar(100),
add column ingredient02 varchar(100),
add column ingredient03 varchar(100),
add column ingredient04 varchar(100),
add column ingredient05 varchar(100),
add column ingredient06 varchar(100),
add column ingredient07 varchar(100),
add column ingredient08 varchar(100);

update pizza_types
set ingredient01 = if (number_ingredients >0, substring_index(ingredients,',',1),null);
update pizza_types
set ingredient02 = if (number_ingredients >1, substring_index(substring_index(ingredients,',',2),',',-1),null);
update pizza_types
set ingredient03 = if (number_ingredients >2, substring_index(substring_index(ingredients,',',3),',',-1),null);
update pizza_types
set ingredient04 = if (number_ingredients >3, substring_index(substring_index(ingredients,',',4),',',-1),null);
update pizza_types
set ingredient05 = if (number_ingredients >5, substring_index(substring_index(ingredients,',',-3),',',1),null);
update pizza_types
set ingredient06 = if (number_ingredients >5, substring_index(substring_index(ingredients,',',-3),',',1),null);
update pizza_types
set ingredient07 = if (number_ingredients >6, substring_index(substring_index(ingredients,',',-2),',',1),null);
update pizza_types
set ingredient08 = if (number_ingredients >7, substring_index(ingredients,',',-1),null);

-- verificamos espacios extras en las columnas de ingredients --
select ingredient01 from pizza_types where length(ingredient01) - length(trim(ingredient01)) >0; -- no hay espacios
select ingredient02 from pizza_types where length(ingredient02) - length(trim(ingredient02)) >0;  -- si hay espacios
select ingredient03 from pizza_types where length(ingredient03) - length(trim(ingredient03)) >0;  -- si hay espacios
select ingredient04 from pizza_types where length(ingredient04) - length(trim(ingredient04)) >0;  -- si hay espacios
select ingredient05 from pizza_types where length(ingredient05) - length(trim(ingredient05)) >0;  -- si hay espacios
select ingredient06 from pizza_types where length(ingredient06) - length(trim(ingredient06)) >0;  -- si hay espacios
select ingredient07 from pizza_types where length(ingredient07) - length(trim(ingredient07)) >0;  -- si hay espacios
select ingredient08 from pizza_types where length(ingredient08) - length(trim(ingredient08)) >0;  -- si hay espacios

-- eliminamos los espacios extras desde la columna ingredients02 hasta 08 --
update pizza_types
set ingredient02 = trim(ingredient02)
where length(ingredient02) - length(trim(ingredient02)) >0;

update pizza_types
set ingredient03 = trim(ingredient03)
where length(ingredient03) - length(trim(ingredient03)) >0;

update pizza_types
set ingredient04 = trim(ingredient04)
where length(ingredient04) - length(trim(ingredient04)) >0;

update pizza_types
set ingredient05= trim(ingredient05)
where length(ingredient05) - length(trim(ingredient05)) >0;

update pizza_types
set ingredient06 = trim(ingredient06)
where length(ingredient06) - length(trim(ingredient06)) >0;

update pizza_types
set ingredient07 = trim(ingredient07)
where length(ingredient07) - length(trim(ingredient07)) >0;

update pizza_types
set ingredient08 = trim(ingredient08)
where length(ingredient08) - length(trim(ingredient08)) >0;

select length(ingredient08), length(trim(ingredient08)) from pizza_types; -- hay espacios

call pt();

-- eliminamos la columna ingredients --
alter table pizza_types drop column ingredients;

-- eliminar las palabras repitidas "The" y "Pizza" al inicio/final de cada nombre --
-- prueba --
select name, replace(name,'The ','') from pizza_types;

update pizza_types
set name = replace(name,' Pizza','');

update pizza_types
set name = replace(name,'The ','');

call pt();

-- cambiar tipo de dato de una columna mas asignacion de PK --
alter table pizza_types modify pizza_type_id varchar(50) primary key not null;
alter table pizza_types modify name varchar(50);
alter table pizza_types modify category varchar(50);
alter table pizza_types modify number_ingredients int;

-- tabla final after cleaning --
call pt();
