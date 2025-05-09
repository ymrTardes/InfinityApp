import random as rnd
from data.words import macan_list
from src.User import DataUser
from src.config import *




def menu_form(account_list):
    print(term.clear)
    draw_menu() # отрисовка меню с choice_menu = 0, т.е выбран первый пункт меню
    global choice_menu
    key_i = ""
    result_forms = True


    while key_i.lower() != "q":
        with term.cbreak(), term.hidden_cursor(): # блокировка ввода пользователя, чтобы все происходило по отслеживанию нажатой кнопки
            key_i = term.inkey(timeout=10) # timeout задает переменной None через N секунд
        if not key_i:
            print(term.lavenderblush4_reverse("Ожидание ввода..."))
        elif key_i.name == "KEY_DOWN":
            if choice_menu != 2:
                choice_menu += 1
            draw_menu()
        elif key_i.name == "KEY_UP":
            if choice_menu != 0:
                choice_menu -= 1
            draw_menu()
        elif key_i.name == "KEY_ENTER":
            match choice_menu:
                case 0:
                    result_forms = registration_form(account_list)
                case 1:
                    result_forms = login_form(account_list)
                case 2:
                    result_forms = False
        # пользователь выбрал форму через нажатие R/L
        elif key_i.lower() == "r":
            result_forms = registration_form(account_list)
        elif key_i.lower() == "l":
            result_forms = login_form(account_list)
        
        if result_forms:
            print(term.clear + term.home)
            draw_menu()
            continue
        else:
            break


def draw_menu():
    """
    отрисовка меню
    выделаяет цветом тот элемент, индекс которого совпадает с choice_menu
    """
    print(term.home) # Возвращает курсор в 0 позицию, из за этого меню перезаписывается
    gui_wrapper("INFINITY APP", "*")
    for i in range(0,len(menu_form_elements)):
        if i == choice_menu:
            print(term.deepskyblue2_reverse(menu_form_elements[i]))
        else:
            print(menu_form_elements[i])


def registration_form(account_list):
    print(term.clear + term.home)
    gui_wrapper("REGISTRATION", "*")
    while True:
        name_inp = get_inp("Назовись: (:q - выход) ")
        if name_inp == ":q":
            return True
        
        find_user = list(filter(lambda usr: usr.name == name_inp, account_list))
        if len(find_user) > 0:
            error_text("Уже есть такой педик")
            continue
        elif not login_only_letters(name_inp):
            error_text("Логин должен быть без цифр")
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
                    error_text("Возраст должен быть от 18 до 80")
                    continue
            except Exception as e:
                error_text("Чилос вводи, мда...")
                continue


def login_form(account_list):
    print(term.clear + term.home)
    gui_wrapper("LOGIN", "*")
    while True:
        name_inp = get_inp("Введи имя заебал: (:q - выход) ")
        if name_inp == ":q":
            return True
        
        find_user = list(filter(lambda usr: usr.name == name_inp, account_list))
        if len(find_user) != 0:
            chat_form(account_list, find_user[0])
            return False
        else:
            error_text("Пользователь не найден")
            continue


def chat_form(account_list, user):
    gui_wrapper("CHAT", "*")
    print(f"Hello {user.name}")
    while True:
        msg_user = input("Введите сообщение: (:q for exit, :h for help) ")
        split_message = msg_user.split(" ")
        # сообщение юзера разбитое на список
        match split_message[0].lower() if split_message else None:
            case ":q":
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
                print(f"Me >>> {user.name}, {user.age}, {user.bio}")
            case "\n":
                error_text("Сообщение пустое")
            case _: # Любой другой случай
                print(f"{user.name} >>> {msg_user}")
                print(term.pink_reverse(f"НАГИБАТОР_228 >>> {random_replies()}"))


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
