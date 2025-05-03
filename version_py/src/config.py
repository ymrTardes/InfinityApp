from blessed import Terminal
term = Terminal()
import sys


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


path_bd = "version_py/data/users.txt"


# UI functions
def gui_wrapper(title, sub_char=" "):
    title_text = wrap_title(title, sub_char)
    print(f"{term.home}{term.on_darkseagreen}{term.cyan4}{term.clear}{term.move_down(1)}{title_text}", flush="True")


def wrap_title(title, sub_char=" "):
    width = term.width
    decotate_len = width - len(title)
    left_margin = decotate_len // 2
    right_margin = decotate_len - left_margin

    title = (sub_char * left_margin + title + sub_char * right_margin)
    return term.center(title)




# usualness functions
def out_help():
    return "\n".join(help_text)


def check_age(a: int):
    """
    return вернет итак True или False, нет смысла в конструкции if else
    """
    return a > 17 and a <= 80


def get_inp(query_msg):
    return input(query_msg).strip() # strip уберает лишние пробелы по умолчанию


def reverse_text(text):    
    """
    инвертированное сообщение
    """
    text = " ".join(text[1::])
    print(text[::-1].strip())