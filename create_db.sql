/*
  > sqlite3
  >> .read create_db.sql    - Выполнить скрипт создания таблицы
  >> .save infinityApp.db   - Сохранить БД
  >> .exit

  > sqlite3
  >> .open infinityApp.db   - Открыть БД
  >> .tables                - Просмотреть список таблиц
  >> select * from users;
  >> insert into users (name, age, bio) values ('Yarik', 25, 'Admin');
  >> delete from users where id = 3
*/

create table users(
  id INTEGER NOT NULL primary key,
  name TEXT,
  age INTEGER,
  bio TEXT
);

insert into `users` values (1, 'qwe', 18, 'Dev account'), (2, 'homaander', 25, 'Admin');
