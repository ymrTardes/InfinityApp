from src.config import *
import random as rnd
from data.words import macan_list



# consts
help_text = [
          ":q - выход"
        , ":h - помощь"
        , ":r <msg> - перевернутое сообщение"
        , ":c <a> <b> - a + b"
        , ":l - вывод всех полььзователей"
        , ":l <text> - поиск пользователей по свопадению"
        , ":i - информация обо мне"
        , ":b <text> - изменить биографию (обо мне)"
        ]




def chat_form(account_list, user):
    print(term.clear + term.home)
    gui_wrapper("CHAT", "*")
    print(f"Hello {user.name}")
    while True:
        msg_user = input("Введите сообщение: (:q for exit, :h for help) ")
        split_message = msg_user.split(" ")
        # сообщение юзера разбитое на список
        match split_message[0].lower() if split_message else None:
            case ":q":
                try:
                    with open(path_bd, "w") as file:
                        for i in account_list:
                            file.write(f"{i.name}; {i.age}; {i.bio}\n")
                except Exception as e:
                    print(f"Не ломай файл >>> {e}")
                return True
            case ":h":
                print(out_help())
            case ":r":
                reverse_text(split_message)
            case ":c":
                try:
                    print(int(split_message[1]) + int(split_message[2]))
                except Exception as e:
                    error_text("Вводите числа в формате >>> :c <1> <2>")
            case ":l":
                run_list_users(split_message, account_list)
            case ":i":
                print(f"Me >>> {user.name}, {user.age}, {user.bio}")
            case ":b":
                run_edit_bio(split_message, user)
                print(user)
            case "\n":
                error_text("Сообщение пустое")
            case _: # Любой другой случай
                print(f"{user.name} >>> {msg_user}")
                print(term.pink_reverse(f"НАГИБАТОР_228 >>> {random_replies()}"))


def run_edit_bio(split_message, user):
    bio_str = " ".join(split_message[1:])
    user.set_bio(bio_str)


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
            error_text("Никого не найдено")
        else:
            ord = 0
            for ob in res_search:
                ord += 1
                print(f"{ord}. {ob.name}, {ob.age}, {ob.bio}")


def random_replies():
    reply_msg = []
    for i in range(rnd.randint(1,3)):
        reply_msg.append(rnd.choice(macan_list))
    return " ".join(reply_msg)


def out_help():
    return "\n".join(help_text)


def reverse_text(text):    
    """
    инвертированное сообщение
    """
    text = " ".join(text[1::])
    print(text[::-1].strip())