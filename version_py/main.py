from src.config import *
from src.menu_form import *


def main():
    """
    Функция main() запускается при старте
    """

    account_list = []
    with open(path_bd, "r") as file:
        try:
            account_list = parse_users(file.read())
        except Exception as e:
            print(f"Ошибка в файле БД >>> {e}")
            
    try:
        with term.fullscreen(): # запускает буффер (Терминал поверх нынешнего)
            menu_form(account_list)
    except KeyboardInterrupt:
        gui_wrapper("Завершено пользователем", "♰")
        print(term.normal)


if __name__ == "__main__":
    main()