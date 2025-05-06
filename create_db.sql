/*
  > sqlite3
  >> .read create_db.sql
  >> .save infinityApp.db
  >> .exit

  > sqlite3
  >> .open infinityApp.db
  >> .tables
  >> select * from users;
  >> insert into users (name, age, bio) values ('Yarik', 25, 'Admin');
  >> delete from users where id = 3
*/

create table users(
  id INTEGER  NOT NULL primary key,
  name TEXT,
  age INTEGER,
  bio TEXT
);

insert into `users` values (1, 'qwe', 18, 'Dev account'), (2, 'homaander', 25, 'Admin');
