from src.config import *
from src.login_form import *
from src.registration_form import *


# consts
menu_form_elements = ["REGISTRATION (R)", "LOGIN (L)", "Press 'q' to Quit."]
# choice_menu = 0 # нужна для отрисовки какой пункт меню выбран в >>> draw_menu()


def menu_form(account_list, choice_menu=0):
    print(term.clear)
    draw_menu(choice_menu) # отрисовка меню с choice_menu = 0, т.е выбран первый пункт меню
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
            draw_menu(choice_menu)
        elif key_i.name == "KEY_UP":
            if choice_menu != 0:
                choice_menu -= 1
            draw_menu(choice_menu)
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
            draw_menu(choice_menu)
            continue
        else:
            break


def draw_menu(choice_menu):
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







