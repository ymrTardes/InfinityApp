import random as rnd
from words import *

account_list = ["Yarik","Angel", "dsa", "Yana"]

def main():
    """
    Функция main() запускается при старте
    """  
    print("Hello World")
    while True:
        auth = input("Register/Login: R/L? ")
        if auth.upper() == "R": 
            run_registration()
            break
        elif auth.upper() == "L":
            run_login()
            break
        else:
            print("ты в ZaLoop, введите заново")


def check_age(a):
    """
    return вернет итак True или False, нет смысла в конструкции if else
    """
    return a > 17


def run_registration():
    name_inp = input("Введи имя заебал: ")
    age_inp = int(input("Скок по земле ходишь епта: "))
    if check_age(age_inp):
        print("Регистрация прошла заебок")
        run_app(name_inp)
    else:
        print("Маленький еще")


def run_login():
    name_inp = input("Введи кличку заебал: ")
    if name_inp in account_list:
        run_app(name_inp)
    else:
        print("Зарегайся")


def run_app(name):
    print(f"Hello {name}")
    while True:
        msg_user = input("Введите сообщение: (:q for exit, :h for help) ")
        split_message = msg_user.split(" ")
        # сообщение юзера разбитое на список
        if command(split_message, ":q"):
            print(f"GG WP")
            break
        elif command(split_message, ":h"):
            run_help()
        elif command(split_message, ":r"):
            """
            инвертированное сообщение
            """
            split_message = " ".join(split_message[1::])
            print(split_message[::-1])
        elif command(split_message, ":c"):
            print(int(split_message[1]) + int(split_message[2]))
        elif command(split_message, ":l"):
            run_list_users(split_message)
        else:
            print(f"{name}: {msg_user}")
            print(f"Нагибатор228: {replies()}")


def command(split_message, com):
    return com.casefold() in split_message[0].casefold()


def run_list_users(split_message):
    """
    run_list_users(Список)
    Если передается :l - весь список пользователей
    Если :l <str> - ищутся пользователи, которые начинаются на <str>
    """
    if len(split_message) == 1:
            num = 0
            for i in account_list:
                num += 1
                print(f"{num}. {i}")
    else:
        res_search = list(filter(lambda i: i.casefold().startswith(split_message[1].casefold()), account_list))
        """
        переписал используя filter(под влиянием хаскеля)
        """
        # for i in account_list:
        #     if i.casefold().startswith(list[1].casefold()):
        #         res_search.append(i)
        if len(res_search) == 0:
            print("Никого не найдено")
        else:
            print(", ".join(res_search))


def replies():
    reply_msg = []
    for i in range(rnd.randint(1,12)):
        reply_msg.append(rnd.choice(macan_list))
    return " ".join(reply_msg)


def run_help():
    help_text = """
            :q - выход
            :h - помощь
            :r <msg> - перевернутое сообщение 
            :c <a> <b> - a + b     
            :l - вывод всех полььзователей
            :l <Строка> - поиск пользователей по свопадению
            """
    print(help_text)


if __name__ == "__main__":
    main()
    # бля такой долбаеб писал код конечно