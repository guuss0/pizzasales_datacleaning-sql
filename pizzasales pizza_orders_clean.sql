-- ------------------------------------------ --
-- ---------- PIZZA ORDERS ------------------- --
-- ------------------------------------------ --

-- cambiamos nombre de tabla --
alter table order_details rename to pizza_orders;

-- creamos un procedimiento que permita mostrar la tabla --
delimiter $$
create procedure po()
begin
	select * from pizza_orders;
end $$
delimiter ;

call po();

-- renombramos columna order_details_id --
alter table pizza_orders rename column order_details_id to order_trans_id;

-- verificamos duplicados --
select count(*) as duplicates
from (
	select order_trans_id
	from pizza_orders
	group by order_trans_id
	having count(*)>1
    ) as subquery;
-- duplicates = 0 --

call po();

-- espacios extras en pizza_id --
select pizza_id, trim(pizza_id)
from pizza_orders
where length(pizza_id)-length(pizza_id) > 0;
-- sin espacios vacios --

-- ver estado de tabla --
describe pizza_orders;

-- cambiar tipo de datos y asignacion de PK y FK --
alter table pizza_orders modify order_trans_id int primary key not null;
alter table pizza_orders change column pizza_id pizza_size_id varchar(50);
alter table pizza_orders add foreign key (pizza_size_id) references pizza_sp(pizza_size_id);
alter table pizza_orders add foreign key (order_id) references pizza_dt(order_id);

call po();