-- ------------------------------------------ --
-- ---------- PIZZA SIZE & PRICE ------------------- --
-- ------------------------------------------ --

select * from pizza_sp;

-- creamos un procedimiento para seleccionar la tabla --
DELIMITER $$
create procedure psp()
begin
	select * from pizza_sp;
end $$
DELIMITER ;

-- verificamos el procedimiento --
call psp();

-- renombramos la columna "pizza_id" --
alter table pizza_sp change column pizza_id pizza_size_id varchar(20) not null;

call psp();

-- verificamos duplicados --
select count(*) as cantidad_duplicados
from (
	select pizza_size_id
    from pizza_sp
    group by pizza_size_id
    having count(*) > 1
) as subquery;
-- duplicados = 0 --

-- vericamos espacios extras --
select pizza_size_id from pizza_sp where length(pizza_size_id) - length(trim(pizza_size_id)) > 0;
select pizza_type_id from pizza_sp where length(pizza_type_id) - length(trim(pizza_type_id)) > 0;
select size from pizza_sp where length(size) - length(trim(size)) > 0;

call psp();

-- revisemos los tipos de dato de la tabla --
describe pizza_sp;

-- cambiar tipo de dato de una columna mas asignacion de PK --
alter table pizza_sp modify pizza_size_id varchar (20) primary key;
alter table pizza_sp modify pizza_type_id varchar (50);
alter table pizza_sp add foreign key(pizza_type_id) references pizza_types (pizza_type_id);
alter table pizza_sp modify size varchar(4);



