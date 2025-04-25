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
    if a > 17:
        return True
    else:
        return False
    
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
            splited = " ".join(splited[1::])
            print(splited[::-1])
        elif command(splited, ":c"):
            print(int(splited[1]) + int(splited[2]))
        elif command(splited, ":l"):
            if len(splited) == 1:
                num = 0
                for i in account_list:
                    num += 1
                    print(f"{num}. {i}")
            else:
                num = 0
                for i in account_list:
                    if i.casefold().startswith(splited[1].casefold()):
                        print(i)
                    else:
                        print("Не найдены такие челы")
                        break
        else:
            print(f"{name}: {msg_user}")

def command(msg, com):
    if com.casefold() in msg[0].casefold():
        return True
    else:
        return False
        
def run_help():
    print("""
            :q - выход
            :h - помощь
            :r <msg> - перевернутое сообщение 
            :c <a> <b> - a + b     
            :l - вывод всех полььзователей
            :l <Строка> - поиск пользователей по свопадению
            """)
    
main()
