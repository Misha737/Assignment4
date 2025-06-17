use bookshop;

show tables;

explain analyze with
	one_year_customer as (
		select distinct e1.id as order_id
		from custom_order e1
		join customer e2
			on e1.customer_id = e2.id and
				curdate() - interval 1 year < e2.registration_date
	),
	sum_order_book as (
		select
			sum(e1.quantity) as quantity,
			e1.book_id
		from orders_books e1
		join one_year_customer e2
			on e1.order_id = e2.order_id
		group by e1.book_id
	)
select
	e1.name as book_name,
	e1.author,
	e1.category,
	e2.quantity
from book e1
left join sum_order_book e2
	on e2.book_id = e1.id
where e2.quantity is null;