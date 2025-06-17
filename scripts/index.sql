use bookshop;

create index name_index on book (name);

create index registration_date_index on customer(registration_date);

SELECT table_name, index_name, column_name, non_unique, index_type
FROM information_schema.STATISTICS
WHERE table_schema = 'bookshop';