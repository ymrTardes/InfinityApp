from src.config import *
from src.chat_form import *




def login_form(account_list):
    print(term.clear + term.home)
    gui_wrapper("LOGIN", "*")
    while True:
        name_inp = get_inp("Введи имя заебал: (:q - выход) ")
        if name_inp == ":q":
            return True
        
        find_user = find_user_name(account_list, name_inp)
        if len(find_user) == 0:
            error_text("Пользователь не найден")
            continue

        chat_form(account_list, find_user[0])
        return False