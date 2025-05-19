class DataUser:
    def __init__(self, id, name, age, bio="Undefinded"): # Конструктор
        """
        self - ссылка на экземпляр класса
        """
        self.id = id
        self.name = name # Свойство объекта или параметр
        self.age = age
        self.bio = bio
    def __str__(self): # строковое представление объекта
        return f"User >>> ID={self.id}, Name={self.name}, Age={self.age}, Bio={self.bio}"


    def set_bio(self, bio: str):
        self.bio = bio