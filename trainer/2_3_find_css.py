import requests
from bs4 import BeautifulSoup

url = "https://www.python.org"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'lxml')

# Находит все ссылки (тег a в блоке <div> с id="content")
links_in_content = soup.select('#content a')
print(f"Найдено внешних ссылок: {len(links_in_content)}")
for link in links_in_content[:3]:
    print(link.text.strip(), "->", link.get('href'))

# Находит ссылки (внутри тега p в блоке <div> с id="content" с тегом a)
links_in_content_new = soup.select('#content p a')
print(f"\nНайдено ссылок внутри тега p: {len(links_in_content_new)}")
for link in links_in_content_new[:5]:
    print(link.text.strip(), "->", link.get('href'))

# Находит ссылки внутри small_widget
links_in_content_widget = soup.select('#content .small-widget a')
print(f"\nНайдено ссылок внутри class_=small_widget: {len(links_in_content_widget)}")
for link in links_in_content_widget[:4]:
    print(link.text.strip(), "->", link.get('href'))

# Находит ссылки внутри класса small_widget get-started-widget
links_in_content_widget_st = soup.select('#content .small-widget.get-started-widget a')
print(f"\nНайдено ссылок внутри class_=small_widget get-started-widget: {len(links_in_content_widget_st)}")
for link in links_in_content_widget_st:
    print(link.text.strip(), "->", link.get('href'))

# Находит первый элемент с классом "main-navigation" и внутри него 1-й элемент
first_nav_item = soup.select_one('.main-navigation li')
if first_nav_item:
    print(f"\n1-ый элемент навигации: {next(first_nav_item.stripped_strings)}")  # next() = берёт 1-ую строку, stripped_string = берёт строки поочерёдно.
