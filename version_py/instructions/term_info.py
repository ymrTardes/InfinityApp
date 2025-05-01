from blessed import Terminal
term = Terminal()

# ширина терминала
width = term.width


print(f"{term.home}{term.black_on_yellow3}{term.clear}")
# делает экран чистым
# term.colorText_on_bgColor

# home >>> Position cursor at (0, 0).


print(term.gray10("текст"))

with term.cbreak(), term.hidden_cursor():
# очистить экран
    pass