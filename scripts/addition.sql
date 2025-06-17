use bookshop;

create user 'administrator'@'localhost' identified by 'password';
create role full_access;
grant all privileges on bookshop.* to full_access;
grant full_access to 'administrator'@'localhost';

create user 'junion_tester'@'localhost' identified by 'password';
create role revision;
grant select on bookshop.* to revision;
grant revision to 'junion_tester'@'localhost';

create user 'inserter'@'localhost' identified by 'password';
create role insert_acces;
grant insert on bookshop.* to insert_acces;
grant insert_acces to 'inserter'@'localhost';

create view used_books as (
	select b.name, b.category, o.number_of_customers
	from book b
	join (
		select count(order_id) as number_of_customers, book_id
		from orders_books o
		group by book_id
	) o on o.book_id = b.id
);
select * from used_books;

delimiter $$
create procedure add_book_for_customer (
	in book_id int, customer_id int
)
begin
	start transaction;
	insert basket(customer_id, book_id)
		values (customer_id, book_id);
	select c.first_name as customer_name, b.name as book_name
	from basket ba
	join book b
		on b.id = ba.book_id
	join customer c
		on c.id = ba.customer_id
	where ba.customer_id = customer_id;
	commit;
end;
delimiter ;
drop procedure add_book_for_customer;
call add_book_for_customer(1, 1);

create trigger books_reduce
after insert on basket
for each row
begin
	declare count_books int;

	select count(*) into count_books
	from basket b
	where b.customer_id = new.customer_id;
	
	if count_books > 5 then
		delete from customer where new.customer_id = id;
	end if;
end;

drop trigger books_reduce;
insert customer(id, first_name, last_name, birth_date, registration_date, email) values
(1, "Misha", "Makovka", '2006-11-20', '2025-06-12', 'myemail@gmail.com');
delete from customer where email = 'myemail@gmail.com';