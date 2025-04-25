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
        splited = msg_user.split(" ")
        if command(splited, ":q"):
            print(f"GG WP")
            break
        elif command(splited, ":h"):
            run_help()
        elif command(splited, ":r"):
            """
            инвертированное сообщение
            """
            splited = " ".join(splited[1::])
            print(splited[::-1])
        elif command(splited, ":c"):
            print(int(splited[1]) + int(splited[2]))
        elif command(splited, ":l"):
            run_list_users(splited)
        else:
            print(f"{name}: {msg_user}")
            replies(macan_list)
            print(f"Нагибатор228: {result_msg}")

def command(msg, com):
    return com.casefold() in msg[0].casefold()

def run_list_users(list):
    """
    run_list_users(Список)
    Если передается :l - весь список пользователей
    Если :l <str> - ищутся пользователи, которые начинаются на <str>
    """
    if len(list) == 1:
            num = 0
            for i in account_list:
                num += 1
                print(f"{num}. {i}")
    else:
        res_search = []
        for i in account_list:
            if i.casefold().startswith(list[1].casefold()):
                res_search.append(i)
        if len(res_search) == 0:
            print("Никого не найдено")
        else:
            print(", ".join(res_search))

def replies(list):
    len_sentense = rnd.randint(1,12)   
    reply_msg = []
    for i in range(len_sentense):
        reply_msg.append(rnd.choice(list))
    global result_msg 
    result_msg = " ".join(reply_msg)
    return result_msg

def run_help():
    print("""
            :q - выход
            :h - помощь
            :r <msg> - перевернутое сообщение 
            :c <a> <b> - a + b     
            :l - вывод всех полььзователей
            :l <Строка> - поиск пользователей по свопадению
            """)

if __name__ == "__main__":
    main()