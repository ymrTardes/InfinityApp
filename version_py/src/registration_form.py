from src.config import *
from src.User import DataUser
from src.chat_form import *




def registration_form(account_list: list):
    print(term.clear + term.home)
    gui_wrapper("REGISTRATION", "*")
    while True:
        name_inp = get_inp("Назовись: (:q - выход) ")
        if name_inp == ":q":
            return True
        
        find_user = find_user = find_user_name(account_list, name_inp)
        if len(find_user) > 0:
            error_text("Уже есть такой педик")
            continue
        elif not login_only_letters(name_inp):
            error_text("Логин должен быть без цифр")
        else:
            try:
                age_inp = int(get_inp("Скок по земле ходишь епта: "))
                if not check_age(age_inp):
                    error_text("Возраст должен быть от 18 до 80")
                    continue

                user = DataUser(0, name_inp, age_inp)
                # with open(path_bd, "a") as file:
                    # file.write(f"{name_inp}; {age_inp}; {user.bio}\n")

                with sqlite3.connect("/home/rick/python/InfinityApp/infinityApp.db") as conn:
                    cursor = conn.cursor()
                    cursor.execute(
                        "INSERT into users (name, age, bio) values (?,?,?)",
                        (name_inp, age_inp, user.bio)
                    )

                    conn.commit()
                conn.close()

                account_list.append(user)
                chat_form(account_list, user)
                return False

            except Exception as e:
                error_text("Чилос вводи, мда...")
                print(e)
                continue


def check_age(a: int):
    """
    return вернет итак True или False, нет смысла в конструкции if else
    """
    return a > 17 and a <= 80


def login_only_letters(name):
    res = name.isalpha()
    return res
