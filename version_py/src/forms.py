import random as rnd
from data.words import macan_list
from src.User import DataUser
from src.config import *
from src.forms import *



def menu_form(account_list):
    gui_wrapper("INFINITY APP", "*")
    while True:
        auth = input("Register/Login/Quit: R/L/Q? ")
        if auth.upper() == "R":
            exit_bool = registration_form(account_list)
            if exit_bool:
                continue
            else:
                break
        elif auth.upper() == "L":
            exit_bool = login_form(account_list)
            if exit_bool:
                continue
            else:
                break
        elif auth.upper() == "Q":
            print(wrap_title("GG WP bOTi GOOD BYE EPTA", "*"))
            return None
        else:
            print("ты в ZaLoop, введите заново")


def registration_form(account_list):
    gui_wrapper("REGISTRATION", "*")
    while True:
        name_inp = get_inp("Назовись: (:q - выход) ")
        find_user = list(filter(lambda usr: usr.name == name_inp, account_list))
        if len(find_user) > 0:
            print("Уже есть такой педик")
            continue
        elif name_inp == ":q":
            return True
        else:
            try:
                age_inp = int(get_inp("Скок по земле ходишь епта: "))
                if check_age(age_inp):
                    print("Регистрация прошла заебок")
                    with open(path_bd, "a") as file:
                        file.write(f"\n{name_inp}; {age_inp};")
                    chat_form(account_list, DataUser(name_inp, age_inp))
                    return False
                else:
                    print("Маленький еще")
                    continue
            except Exception as e:
                print(f"Чилос вводи, мда...")
                continue


def login_form(account_list):
    gui_wrapper("LOGIN", "*")
    while True:
        name_inp = get_inp("Введи имя заебал: (:q - выход) ")
        if name_inp == ":q":
            return True
        find_user = list(filter(lambda usr: usr.name == name_inp, account_list))
        if len(find_user) != 0:
            chat_form(account_list, find_user[0])
            return True
        else:
            print("Пользователь не найден")
            continue


def chat_form(account_list, user):
    gui_wrapper("CHAT", "*")
    print(f"Hello {user.name}")
    while True:
        msg_user = input("Введите сообщение: (:q for exit, :h for help) ")
        split_message = msg_user.split(" ")
        # сообщение юзера разбитое на список
        if command(split_message, ":q"):
            return
        elif command(split_message, ":h"):
            # wrap_title("Tarkov Help".upper())
            print(out_help())
        elif command(split_message, ":r"):
            """
            инвертированное сообщение
            """
            split_message = " ".join(split_message[1::])
            print(split_message[::-1].strip())
        elif command(split_message, ":c"):
            print(int(split_message[1]) + int(split_message[2]))
        elif command(split_message, ":l"):
            run_list_users(split_message, account_list)
        elif command(split_message, ":i"):
            print(f"Me >>> {user.name}, {user.age}, {user.bio}")
        elif command(split_message, ":b"):
            run_edit_bio(split_message, user)
            print(f"Me >>> {user.name}, {user.age}, {user.bio}")
        else:
            print(f"{user.name} >>> {msg_user}")
            print(f"Нагибатор228 >>> {replies()}")


def run_edit_bio(split_message, user):
    pass


def run_list_users(split_message, account_list):
    """
    run_list_users(Список)
    Если передается :l - весь список пользователей
    Если :l <str> - ищутся пользователи, которые начинаются на <str>
    """
    if len(split_message) == 1:
            ord = 0
            for i in account_list:
                ord += 1
                print(f"{ord}. {i.name}, {i.age}, {i.bio}")
    else:
        start_sub = split_message[1].casefold()
        res_search = list(filter(lambda i: i.name.casefold().startswith(start_sub), account_list))

        if len(res_search) == 0:
            print("Никого не найдено")
        else:
            ord = 0
            for ob in res_search:
                ord += 1
                print(f"{ord}. {ob.name}, {ob.age}, {ob.bio}")


def replies():
    reply_msg = []
    for i in range(rnd.randint(1,3)):
        reply_msg.append(rnd.choice(macan_list))
    return " ".join(reply_msg)
