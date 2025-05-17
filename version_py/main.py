from src.config import *
from src.menu_form import *
import sqlite3

def main():
    """
    Функция main() запускается при старте
    """
    account_list = []

    with sqlite3.connect("/home/rick/python/InfinityApp/infinityApp.db") as conn:
        cursor = conn.cursor() # cursor нужен для выполнения запросов SQL
        cursor.execute("SELECT * FROM users")
        account_list = parse_users(cursor.fetchall())
        conn.commit()
    conn.close()


    # with open(path_bd, "r") as file:
    #     try:
    #         account_list = parse_users(file.read())
    #     except Exception as e:
    #         print(f"Ошибка в файле БД >>> {e}")


    try:
        with term.fullscreen(): # запускает буффер (Терминал поверх нынешнего)
            menu_form(account_list)
    except KeyboardInterrupt:
        gui_wrapper("Завершено пользователем", "♰")
        print(term.normal)


if __name__ == "__main__":
    main()