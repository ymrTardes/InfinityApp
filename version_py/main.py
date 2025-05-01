import random as rnd
from blessed import Terminal
import os
from data.words import macan_list
term = Terminal()


path_bd = "data/users.txt"

class DataUser:
    def __init__(self, name, age): # Конструктор
        """
        self - ссылка на экземпляр класса
        """
        self.name = name # Свойство объекта или параметр
        self.age = age
        self.bio = "BIO undefinded"
    def set_bio(self, bio: str):
        self.bio = bio


def main():
    """
    Функция main() запускается при старте
    """
    print(f"{term.home}{term.clear}{term.move_y(int(term.height / 2.3))}")
    print(term.black_on_darkkhaki(wrap_title('press any key to continue')))

    with term.cbreak(), term.hidden_cursor():
        inp = term.inkey()
    
    title_app = wrap_title("INFINITY APP", "*")
    print(f"{term.home}{term.black_on_yellow3}{term.clear}{term.move_down(2)}{title_app}")
    # print(term.move_down(2) + 'You pressed ' + term.bold(repr(inp)))
    # wrap_title("WELCOME")


    # test = [DataUser("Yarik", 21), DataUser("dsa", 22)]
    account_list = []
    with open(path_bd, "r") as file:
        users_lines = file.read()
        users_lines = users_lines.split("\n")
        users_lines = list(map(lambda x: x.split(";"), users_lines))
        # ДРУГОЙ ВАРИАНТ
        # for i in users_lines:
        #     account_list.append(i.split(";"))
        try:
            for usr in users_lines:
                user_atrib = DataUser(usr[0].strip(), usr[1].strip())
                user_atrib.set_bio(usr[2].strip())
                account_list.append(user_atrib)
        except:
            print("Проверь БД на лишний Энтер)))))")

    while True:
        auth = input("Register/Login: R/L? ")
        if auth.upper() == "R": 
            run_registration(account_list)
            break
        elif auth.upper() == "L":
            run_login(account_list)
            break
        else:
            print("ты в ZaLoop, введите заново")


def wrap_title(s: str, sub_char="_"):
    """
    2 варианта, используя os встроенная библиотека или сторонняя blessed
    """
    # def get_term_size():
    #     try:
    #         size = os.get_terminal_size()
    #         return size.columns, size.lines
    #     except:
    #         return 80,25
    # columns, _ = get_term_size() 
    # # _ Значит что перменная не нужна
    # centred_text = s.center(columns)
    # print("_" * columns +"\n")
    # # print(centred_text)
    # print("_" * columns)
    
    width = term.width
    decotate_len = width - len(s)
    left_sub = decotate_len // 2
    right_sub = decotate_len - left_sub

    title = (sub_char * left_sub + s + sub_char * right_sub)
    # print(term.clear+term.move_y(int(term.height / 2.5)))
    # print(f"{term.home}{term.black_on_yellow3}{term.clear}")
    # print(term.gray10(title))
    # with term.cbreak(), term.hidden_cursor():
        # спрятать текст, спрятать курсор
    return term.center(title)



def check_age(a: int):
    """
    return вернет итак True или False, нет смысла в конструкции if else
    """
    return a > 17


def get_inp(query_msg):
    return input(query_msg).strip() # strip уберает лишние пробелы по умолчанию


def run_registration(account_list):
    # wrap_title("РЕГИСТРАЦИЯ", "?")
    name_inp = get_inp("Назовись: ")
    find_user = list(filter(lambda usr: usr.name == name_inp, account_list))
    if len(find_user) > 0:
        print("Уже есть такой педик")
    else:
        age_inp = int(get_inp("Скок по земле ходишь епта: "))
        if check_age(age_inp):
            print("Регистрация прошла заебок")
            with open(path_bd, "a") as file:
                file.write(f"\n{name_inp}; {age_inp};")
            run_app(account_list, DataUser(name_inp, age_inp))
        else:
            print("Маленький еще")


def run_login(account_list):
    # wrap_title("ВХОД", ".")
    name_inp = get_inp("Введи имя заебал: ")
    find_user = list(filter(lambda usr: usr.name == name_inp, account_list))
    if len(find_user) != 0:
        return run_app(account_list, find_user[0])
    else:
        print("Пользователь не найден")
    # for i in account_list:
    #     if i.name == name_inp:
    #         return run_app(account_list, i)
    # else:
    #     print("Пользователь не найден")


def run_app(account_list, user):
    # wrap_title("CHAT")
    print(f"Hello {user.name}")
    while True:
        msg_user = input("Введите сообщение: (:q for exit, :h for help) ")
        split_message = msg_user.split(" ")
        # сообщение юзера разбитое на список
        if command(split_message, ":q"):
            # wrap_title("GG WP tima rakov".upper())
            break
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

def command(split_message: list, com: str):
    """
        принимает сообщение разделенное на список, и команду вторым аргументом
        возвращает bool (T/F)
        есть ли команда в сообщении от пользователя
    """
    return com.casefold() in split_message[0].casefold()


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
        """
        переписал используя filter(под влиянием хаскеля)
        """
        # for i in account_list:
        #     if i.casefold().startswith(list[1].casefold()):
        #         res_search.append(i)
        if len(res_search) == 0:
            print("Никого не найдено")
        else:
            ord = 0
            for ob in res_search:
                ord += 1
                print(f"{ord}. {ob.name}, {ob.age}, {ob.bio}")


def replies():
    reply_msg = []
    for i in range(rnd.randint(1,12)):
        reply_msg.append(rnd.choice(macan_list))
    return " ".join(reply_msg)


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


def out_help():
    return "\n".join(help_text)


if __name__ == "__main__":
    main()
    # бля такой долбаеб писал код конечно