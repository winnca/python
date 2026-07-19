import requests
from bs4 import BeautifulSoup

url = "https://www.python.org"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'lxml')

# Находим элемент навигации
nav_item = soup.select_one('.main-navigation li a[href="/about/"]')

if nav_item:
    print(f"Element: {nav_item.text.strip()}")
    print(f"Parent: {nav_item.parent.name}")

    # Следующий соседний элемент
    next_li = nav_item.parent.find_next_sibling('li')
    if next_li:
        print(f"Next element: {next_li.text.strip()}")

    # Все дочерние элементы li
    for child in nav_item.parent.children:
        if child.name:
            print(f"<{child.name}>")

# Теги <a> и <ul> в самом низу — это не содержимое класса tier-2 super-navigation.
# Это результат работы вашего цикла for child in next_li.children:, который вывел прямых детей самого верхнего тега next_li
# (то есть всего блока <li id="downloads">).
