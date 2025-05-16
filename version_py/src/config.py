from blessed import Terminal
term = Terminal()
import sqlite3


# sqlite
# connection = sqlite3.connect("version_py/data/my_db.db")
# cursor = conn.cursor()

with sqlite3.connect("version_py/data/my_db.db") as conn:
    cursor = conn.cursor() #  объект "курсор" для выполнения SQL-запросов и операций с базой данных


path_bd = "version_py/data/users.txt"




# UI functions
def gui_wrapper(title, sub_char=" "):
    title_text = wrap_title(title, sub_char)
    print(term.move_down(3) + title_text)


def error_text(text):
    print(term.red_reverse(text))


def wrap_title(title, sub_char=" "):
    width = term.width
    decotate_len = width - len(title)
    left_margin = decotate_len // 2
    right_margin = decotate_len - left_margin

    title = (sub_char * left_margin + title + sub_char * right_margin)
    return (term.deepskyblue2_reverse(term.center(title)))




# usualness functions
def get_inp(query_msg):
    return input(query_msg).strip() # strip уберает лишние пробелы по умолчанию


def find_user_name(account_list, name_inp):
    return list(filter(lambda usr: usr.name == name_inp, account_list))
