class DataUser:
    def __init__(self, name, age): # Конструктор
        """
        self - ссылка на экземпляр класса
        """
        self.name = name # Свойство объекта или параметр
        self.age = age
        self.bio = "BIO undefinded"
    def set_bio(self, bio: str):
        self.bio = bio