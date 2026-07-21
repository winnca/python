import requests
from requests import ConnectionError, HTTPError, RequestException, Timeout
from bs4 import BeautifulSoup

headers = {
    "Accept": "application/json",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0"
}

url = "https://raw.githubusercontent.com/winnca/SQL/main/README.md"

try:
    response_winnca = requests.get(url, headers=headers, timeout=5)
    response_winnca.raise_for_status()
    soup = BeautifulSoup(response_winnca.text, 'lxml')
except HTTPError as http_err:
    print(f"Статус-код HTTP: {http_err}")
except ConnectionError as conn_err:
    print(f"Ошибка соединения: {conn_err}")
except Timeout as t_err:
    print(f"Таймаут истёк: {t_err}")
except RequestException as req_err:
    print(f"Ошибка библиотеки requests: {req_err}")
except Exception as e:
    print(f"Другая ошибка: {e}")
else:
    print(soup.text)
    soup = soup.text.split("\n")
    file_arr = []
    for row in soup:
        cl_row = row.strip()
        if not cl_row:  # Для пустых строк
            continue
        if cl_row[0].isnumeric():  # Лучше использовать cl_row[:1].isdigit() = первый элемент, проверка на число.
            file_arr.append("\n" + "-- " + row + "\n" + "\n")
            continue
        if cl_row[0:3] == "```" or cl_row == "table" or cl_row[0] == ">" or cl_row == "ERD" or cl_row[0] == "#":
            continue
        file_arr.append(row+"\n")
    with open('query.sql', 'w', newline="", encoding='utf-8') as f:
        f.writelines(file_arr)
