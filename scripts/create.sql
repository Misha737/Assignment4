use bookshop;

-- характеристика книги
create table book(
	id int primary key auto_increment, -- індентифікатор таблиці
	isbn bigint not null, -- унікальний індинтифікатор книги за стандартом
	name varchar(64), -- ім'я книги
	author varchar(64), -- автор книги
	publication_date date, -- дата вадання книги
	category varchar(16), -- категорія книги
	format varchar(16), -- формат файла (pdf, epub, mobi, ...)
	language varchar(8), -- код мови книги (uk, de, і так далі)
	description text, -- опис книги
	provider_id int, -- індентифікатор постачальника
	foreign key (provider_id) references provider(id)
		on delete cascade
		on update cascade
);

-- інформація про постачальника
create table provider(
	id int primary key auto_increment, -- індентифікатор таблиці
	site_url varchar(128), -- сайт постачальника
	providing_type varchar(16), -- тип постачальника (author, aggregator, publishing house)
	name varchar(64) -- Ім'я постачальника
);

-- інформація про клієнта
create table customer(
	id int primary key auto_increment, -- індентифікатор таблиці
	first_name varchar(64) not null, -- Ім'я клієнта
	last_name varchar(64), -- призвище клієнта
	birth_date date, -- дата народження
	registration_date date, -- дата реєстрації
	email varchar(128) unique, -- електронна пошта
	phone_number bigint -- телефон
);

-- інформація про замовлення клієнта 
create table custom_order(
	id int primary key auto_increment, -- індентифікатор таблиці
	purchasing_date date, -- дата замовлення
	purchasing_way varchar(16), -- спосіб оплати
	book_is_paid boolean, -- статус чи книга вже оплачена
	book_is_gotten boolean, -- статус чи книга вже отримана клієнту (в майбутньому для паперових книг)
	customer_id int, -- індентифікатор клієнта
	foreign key (customer_id) references customer(id)
		on update cascade
);

-- для встановлення зв'язку між книгами та 
create table orders_books(
	order_id int, -- індентифікатор замовлення
	foreign key (order_id) references custom_order(id)
		on update cascade
		on delete cascade,
	book_id int, -- індентифікатор книги
	foreign key (book_id) references book(id)
		on update cascade,
	quantity int, -- кількість замовлення
	cost int check (cost >= 0), -- ціна в момент покупки за одину книгу
	unique (order_id, book_id)
);

-- останні топ 5 переглянутих книг користувача
create table customer_last_books(
	customer_id int unique, -- індентифікатор користувача
	foreign key (customer_id) references customer(id)
		on delete cascade
		on update cascade,
	book1_id int, -- ідентифікатор на книгу
	foreign key (book1_id) references book(id)
		on delete cascade
		on update cascade,
	book2_id int, -- ідентифікатор на книгу
	foreign key (book2_id) references book(id)
		on delete cascade
		on update cascade,
	book3_id int, -- ідентифікатор на книгу
	foreign key (book3_id) references book(id)
		on delete cascade
		on update cascade,
	book4_id int, -- ідентифікатор на книгу
	foreign key (book4_id) references book(id)
		on delete cascade
		on update cascade,
	book5_id int, -- ідентифікатор на книгу
	foreign key (book5_id) references book(id)
		on delete cascade
		on update cascade
);

-- промокод для користувача
create table promocode(
	id int primary key auto_increment,
	code varchar(16), -- значеннч по якому можна додоати промокод
	share float -- відсоток знижки
);

-- встановлює зв'яозк many:many між користувачами та промокодами
create table customers_promocodes(
	customer_id int,
	foreign key (customer_id) references customer(id)
		on delete cascade
		on update cascade,
	promocode_id int,
	foreign key (promocode_id) references promocode(id)
		on delete cascade
		on update cascade
);

-- корзина для користувача
create table basket(
	customer_id int,
	foreign key (customer_id) references customer(id)
		on delete cascade
		on update cascade,
	book_id int,
	foreign key (book_id) references book(id)
		on delete cascade
		on update cascade
);

insert customer(first_name, last_name, birth_date, registration_date, email) values
("Misha", "Makovka", '2006-11-20', '2025-06-12', 'myemail@gmail.com'),
("Olena", "Shevchenko", '2001-05-14', '2024-11-10', 'olena.shev@gmail.com'),
("Ivan", "Koval", '1999-03-09', '2023-07-22', 'ivan.koval@yahoo.com'),
("Anna", "Tkachuk", '2003-12-01', '2025-01-15', 'anna.tkch@outlook.com'),
("Dmytro", "Hrytsenko", '2000-08-25', '2024-05-05', 'd.hrytsenko@mail.com'),
("Sofiia", "Melnyk", '1998-10-30', '2023-09-18', 'sofia.m@gmail.com'),
("Yurii", "Bondarenko", '2002-06-17', '2025-03-28', 'yurii.bond@gmail.com'),
("Natalia", "Krut", '2004-02-11', '2025-06-01', 'natalia.krut@gmail.com'),
("Artem", "Polishchuk", '2005-09-07', '2024-12-24', 'artem.pol@i.ua'),
("Kateryna", "Lysenko", '1997-04-05', '2023-08-30', 'katya.lysenko@ukr.net');

insert provider(site_url, providing_type, name) values
('https://authorzone.com', 'author', 'AuthorZone'),
('https://readnow.org', 'aggregator', 'ReadNow Aggregator'),
('https://pubhouse.ua', 'publishing house', 'Ukrainian Publishing House'),
('https://litmaster.io', 'author', 'LitMaster'),
('https://allbooks.net', 'aggregator', 'AllBooks Network'),
('https://novadruzhba.com', 'publishing house', 'Nova Druzhba Press'),
('https://storycraft.pro', 'author', 'StoryCraft'),
('https://libhub.com', 'aggregator', 'LibHub Central'),
('https://drukarka.in.ua', 'publishing house', 'Drukarka Group'),
('https://inkspire.io', 'author', 'Inkspire Writers');


insert book(isbn, name, author, publication_date, category, format, language, description, provider_id) values
(9780143127550, 'Sapiens', 'Yuval Noah Harari', '2014-09-04', 'history', 'pdf', 'en', 'A brief history of humankind.', 1),
(9780262033848, 'Introduction to Algorithms', 'Thomas H. Cormen', '2009-07-31', 'education', 'epub', 'en', 'Algorithms explained with clarity.', 2),
(9780439554930, 'Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', '1997-06-26', 'fantasy', 'mobi', 'en', 'First book in the Harry Potter series.', 3),
(9781982137458, 'The Institute', 'Stephen King', '2019-09-10', 'thriller', 'azw3', 'en', 'A novel about kidnapped gifted children.', 4),
(9780590353427, 'Harry Potter and the Chamber of Secrets', 'J.K. Rowling', '1998-07-02', 'fantasy', 'fb2', 'en', 'Second book in the Harry Potter series.', 6),
(9780321125217, 'Domain-Driven Design', 'Eric Evans', '2003-08-30', 'technology', 'pdf', 'en', 'Tackling complexity in software.', 2),
(9780062316110, 'The Alchemist', 'Paulo Coelho', '1988-04-15', 'fiction', 'epub', 'en', 'A journey of self-discovery.', 5),
(9780140283334, '1984', 'George Orwell', '1949-06-08', 'dystopia', 'mobi', 'en', 'A classic dystopian novel.', 7),
(9780307278449, 'The Road', 'Cormac McCarthy', '2006-09-26', 'post-apoc', 'azw3', 'en', 'A bleak journey of father and son.', 8),
(9780374533557, 'Thinking, Fast and Slow', 'Daniel Kahneman', '2011-10-25', 'psychology', 'pdf', 'en', 'Explores the dual systems of thought.', 10);

insert custom_order (purchasing_date, purchasing_way, book_is_paid, book_is_gotten, customer_id) values
('2025-06-01', 'Visa', true, true, 1),
('2025-06-02', 'Mastercard', false, false, 2),
('2025-06-03', 'PayPal', true, false, 3),
('2025-06-04', 'ApplePay', true, true, 4),
('2025-06-05', 'GooglePay', false, false, 5),
('2025-06-06', 'Visa', true, true, 1),
('2025-06-07', 'Mastercard', false, false, 2),
('2025-06-08', 'PayPal', true, true, 3),
('2025-06-09', 'ApplePay', true, false, 4),
('2025-06-10', 'GooglePay', true, true, 5);

insert orders_books(order_id, book_id, quantity, cost) values
(1, 3, 2, 250),
(1, 4, 3, 310),
(2, 5, 1, 100),
(2, 10, 5, 120),
(3, 1, 1, 440),
(4, 2, 1, 234),
(5, 3, 2, 250),
(6, 8, 4, 310),
(6, 1, 2, 234),
(7, 2, 1, 235),
(7, 9, 10, 99),
(8, 5, 1, 100),
(9, 3, 2, 250),
(10, 4, 3, 310),
(10, 5, 1, 100);

insert into customer_last_books (customer_id, book1_id, book2_id, book3_id, book4_id, book5_id) values
(1, 101, 102, 103, 104, 105),
(2, 106, 107, 108, 109, 110),
(3, 111, 112, 113, 114, 115),
(4, 116, 117, 118, 119, 120),
(5, 101, 103, 105, 107, 109);

insert into promocode (code, share) values
('SUMMER20', 0.20),
('WELCOME10', 0.10),
('FREESHIP', 0.00),
('BOOKLOVER15', 0.15),
('VIP25', 0.25);

insert into customers_promocodes (customer_id, promocode_id) values
(1, 1),
(1, 2),
(2, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 1),
(5, 3);

insert into basket (customer_id, book_id) values
(1, 106),
(1, 107),
(2, 103),
(2, 110),
(3, 115),
(4, 118),
(5, 120),
(5, 101);
