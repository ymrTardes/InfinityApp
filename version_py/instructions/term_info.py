from blessed import Terminal
term = Terminal()

# ширина терминала
width = term.width


print(f"{term.home}{term.black_on_yellow3}{term.clear}")
# делает экран чистым и задает стиль
# term.colorText_on_bgColor

# home >>> Position cursor at (0, 0).


print(term.gray10("текст"))

with term.cbreak(), term.hidden_cursor():
# очистить экран
    pass

term.bright_cyan_reverse # будто выделителем

term.black_on_yellow # текс + фон

print(f"{term.on_wheat3}{term.hotpink3_reverse}")

# print(f"{term.home}{term.on_darkseagreen}{term.cyan4}{term.clear}{term.move_down(1)}{title_text}")
print(term.home + term.on_darkseagreen + term.cyan4 + term.clear + term.move_down(1) + title_text)