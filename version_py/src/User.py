class DataUser:
    def __init__(self, name, age): # Конструктор
        """
        self - ссылка на экземпляр класса
        """
        self.name = name # Свойство объекта или параметр
        self.age = age
        self.bio = "BIO undefinded"
    def __str__(self): # строковое представление объекта
        return f"User >>> Name={self.name}, Age={self.age}, Bio={self.bio}"


    def set_bio(self, bio: str):
        self.bio = bio