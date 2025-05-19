from blessed import Terminal
from src.User import DataUser
term = Terminal()
import sqlite3




conn = sqlite3.connect("./infinityApp.db")

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

# использовалась когда юзеры хранились в txt
# def parse_users(text: str):
#     users_bd_list = text.split("\n")
#     users_bd_list = list(map(lambda x: x.split(";"), users_bd_list))
#     account_list = []

#     for usr in users_bd_list:
#         if len(usr[0]) != 0:
#             user_atrib = DataUser(usr[0].strip(), usr[1].strip())
#             user_atrib.set_bio(usr[2].strip())
#             account_list.append(user_atrib)
    
#     return account_list


def parse_users(rows):
    account_list = []
    for row in rows:
        account_list.append(DataUser(row[0],row[1],row[2],row[3]))
    
    return account_list