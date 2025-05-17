def wrap_title(title, sub_char=" "):
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
    decotate_len = width - len(title)
    left_sub = decotate_len // 2
    right_sub = decotate_len - left_sub

    title = (sub_char * left_sub + title + sub_char * right_sub)
    # print(term.clear+term.move_y(int(term.height / 2.5)))
    # print(f"{term.home}{term.black_on_yellow3}{term.clear}")
    # print(term.gray10(title))
    # with term.cbreak(), term.hidden_cursor():
        # спрятать текст, спрятать курсор
    return term.center(title)

# запуск программы хотел сделать
print(f"{term.home}{term.clear}{term.move_y(int(term.height / 2.3))}")
print(term.black_on_darkkhaki(wrap_title('press any key to continue')))

#             except Exception as e:
                # print(f"Чилос вводи, мда..... {type(e).__name__} >>> {e}")


#   сплит текста на список, по какому то знаку
account_list = []
with open(path_bd, "r") as file:
    users_lines = file.read()
    users_lines = users_lines.split("\n")
    users_lines = list(map(lambda x: x.split(";"), users_lines))
    # ДРУГОЙ ВАРИАНТ
    # for i in users_lines:
    #     account_list.append(i.split(";"))


# использование фильтра вместо for/in 
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


        # for i in account_list:
        #     if i.name == name_inp:
        #         return chat_form(account_list, i)
        # else:
        #     print("Пользователь не найден")


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


# разбиение на список со вложенным списком
account_list = []
with open(path_bd, "r") as file:
    users_lines = file.read() # читает файл
    users_lines = users_lines.split("\n") # разделяет на список построчно по переносу строки
    # users_lines --> ['Yarik;23;chert', 'Andrew;103; haskell']
    users_lines = list(map(lambda x: x.split(";"), users_lines)) # возвращает список, разделя по ;
    # users_lines --> [['Yarik', '23', 'chert'], ['Andrew', '103', ' haskell']]

# выбор команды через if/elif и через match case
def chat_form(account_list, user):
    gui_wrapper("CHAT", "*")
    print(f"Hello {user.name}")
    while True:
        msg_user = input("Введите сообщение: (:q for exit, :h for help) ")
        split_message = msg_user.split(" ")
        # сообщение юзера разбитое на список
        if command(split_message, ":q"):
            return True
        elif command(split_message, ":h"):
            print(out_help())
        elif command(split_message, ":r"):
           reverse_text(split_message)
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
            print(f"НАГИБАТОР_228 >>> {random_replies()}")

# match case
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
                print(int(split_message[1]) + int(split_message[2]))
            case ":l":
                run_list_users(split_message, account_list)
            case ":i":
                print(f"Me >>> {user.name}, {user.age}, {user.bio}")
            case ":b":
                run_edit_bio(split_message, user)
                print(f"Me >>> {user.name}, {user.age}, {user.bio}")
            case _: # Любой другой случай
                print(f"{user.name} >>> {msg_user}")
                print(f"НАГИБАТОР_228 >>> {random_replies()}")


# не нужна теперь
def command(split_message: list, command: str):
    """
        принимает сообщение разделенное на список, и команду вторым аргументом
        возвращает bool (T/F)
        есть ли команда в сообщении от пользователя
    """
    return command.casefold() in split_message[0].casefold()

# полезное
text = "Hello"
is_string = isinstance(text, str)  # True проверка на является ли перменная строкой
from collections.abc import Sequence # нужна библиотека для этого

text = "Hello"
is_sequence = isinstance(text, Sequence)  # True (строка — это последовательность символов)


# старое меню

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
            return None
        else:
            print("ты в ZaLoop, введите заново")

# версия для текстового файла
def parse_users(text: str):
    users_bd_list = text.split("\n")
    users_bd_list = list(map(lambda x: x.split(";"), users_bd_list))
    account_list = []

    for usr in users_bd_list:
        if len(usr[0]) != 0:
            user_atrib = DataUser(usr[0].strip(), usr[1].strip())
            user_atrib.set_bio(usr[2].strip())
            account_list.append(user_atrib)
    
    return account_list