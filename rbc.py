import requests
from requests import ConnectionError, HTTPError, RequestException, Timeout
from bs4 import BeautifulSoup

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0"
}
url = "https://www.rbc.ru"

try:
    response = requests.get(url, headers=headers, timeout=5)
    response.raise_for_status()
except HTTPError as http_err:
    print(f"Статус-код HTTP: {http_err}")
except ConnectionError as conn_err:
    print(f"Ошибка соединения: {conn_err}")
except RequestException as req_err:
    print(f"Ошибка библиотеки requests: {req_err}")
except Exception as e:
    print(f"Другая ошибка: {e}")
else:
    soup = BeautifulSoup(response.text, 'lxml')

    file_arr = []
    links_main = soup.select('.styles_links-list__9Vlzb a')
    print(f"Количество ссылок в разделе главное: {len(links_main)}")
    file_arr.append(f"Раздел: Главное\n")

    for i, link in enumerate(links_main):
        href = link.get("href", "")
        text = link.text.strip()
        full_url = ""
        if href.find("https://") == 0:
            full_url = href  # print("     ", f"{i+1}. ", link.text.strip(), "->", href)
        else:
            full_url = "https://www.rbc.ru"+href  # print("     ", f"{i+1}. ", link.text.strip(), "->", str("https://www.rbc.ru"+href))
        output_text = f"    {i + 1}. {text} -> {full_url}"
        print(output_text)
        file_arr.append(output_text+"\n")

    links_main_center = soup.select('.MainNewsComponent_wrapper__Kybz5 a')
    file_arr.append(f"Раздел: Центральные новости\n")
    print(f"\nКоличество новостей в центре сайта: {len(links_main_center)}")

    for i, link in enumerate(links_main_center):
        href = link.get("href", "")
        text = link.get("data-metronome-text")
        full_url = ""
        if href.find("https://") == 0:
            full_url = href  # print("     ", f"{i+1}. ", link.get("data-metronome-text"), "->", href)
        else:
            full_url = "https://www.rbc.ru"+href  # print("     ", f"{i+1}. ", link.get("data-metronome-text"), "->", str("https://www.rbc.ru"+href))
        output_text = f"    {i + 1}. {text} -> {full_url}"
        print(output_text)
        file_arr.append(output_text+"\n")

    with open("file.txt", "w", newline="", encoding="utf-8") as f:
        f.writelines(file_arr)
    with open("file.txt", "r", encoding="utf-8") as f:
        print(f"\n{f.read()}")
