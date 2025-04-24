account_list = ["Yarik","Angel", "dsa"]

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
        if splited[0] == ":q":
            print("GG WP")
            break
        elif splited[0] == ":h":
            run_help()
        elif ":r" in splited[0]:
            splited = " ".join(splited[1::])
            print(splited[::-1])
        elif splited[0] == ":c":
            print(int(splited[1]) + int(splited[2]))
        else:
            print(f"{name}: {msg_user}")

def run_help():
    print("""
            :q - выход
            :h - помощь
            :r <msg> - перевернутое сообщение 
            :c <a> <b> to a + b     
            """)
    
main()
