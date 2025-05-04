from src.User import DataUser
from src.config import *
from src.forms import *


def main():
    """
    Функция main() запускается при старте
    """

    account_list = []
    with open(path_bd, "r") as file:
        users_lines = file.read()
        users_lines = users_lines.split("\n")
        users_lines = list(map(lambda x: x.split(";"), users_lines))

        try:
            for usr in users_lines:
                user_atrib = DataUser(usr[0].strip(), usr[1].strip())
                user_atrib.set_bio(usr[2].strip())
                account_list.append(user_atrib)
        except:
            print("Ошибка в файле БД")
            
    try:
        menu_form(account_list)
        wrap_title("GG WP bOTi GOOD BYE EPTA", "*")
        print(term.normal)
    except KeyboardInterrupt:
        gui_wrapper("Завершено пользователем", "♰")
        print(term.normal)


if __name__ == "__main__":
    main()