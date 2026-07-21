import requests
from requests import HTTPError, RequestException, ConnectionError, Timeout

headers = {
    "Accept": "application/json",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0"
}

with requests.Session() as session:
    session.headers.update(headers)
    url = "https://api.github.com/users/winnca/repos"
    try:
        response_winnca = session.get(url, timeout=5)
        response_winnca.raise_for_status()
        repos_winnca = response_winnca.json()
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
        print(f"Репозитории {repos_winnca[0]['owner']['login']}")
        for rep in repos_winnca:
            if rep['name'] == 'cisco':
                rep['language'] = 'cisco'
            elif rep['name'] == 'git':
                rep['language'] = 'git'
            elif rep['name'] == 'SQL':
                rep['language'] = 'SQL'
            print(f"название: {rep['name']}; URL: {rep['html_url']}, описание = [{rep['description']}], язык программирования: {rep['language']}")

    url = "https://api.github.com/users/octocat/repos"
    try:
        response_octocat = session.get(url, timeout=5)
        response_octocat.raise_for_status()
        repos_octocat = response_octocat.json()
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
        print(f"\nРепозитории {repos_octocat[0]['owner']['login']}")
        for rep in repos_octocat[:5]:
            print(f"название: {rep['name']}; URL: {rep['html_url']}, описание = [{rep['description']}], количество звезд = {rep['stargazers_count']}, яп: {rep['language']}")

        repos_octocat_order_asc = sorted(repos_octocat, key=lambda r: r['stargazers_count'] or 0)  # or 0 на случай, если GitHub вернет None вместо числа звезд
        print("\nТоп 3")
        for rep in repos_octocat_order_asc[::-1][:3]:
            print(f"название = {rep['name']}, кол-во звёзд = {rep['stargazers_count']}")
