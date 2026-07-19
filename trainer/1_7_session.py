import requests

with requests.Session() as session:
    session.headers.update({"User-Agent": "MySessionApp/1.0"})

    # Получаем куки
    response1 = session.get("https://httpbin.org/cookies/set/sessioncookie/12345")
    print(f"Куки после 1-ого запроса: {session.cookies.get('sessioncookie')}")

    # Куки автоматически отправляются
    response2 = session.get("https://httpbin.org/cookies")
    print(f"Куки, отправленные 2-ым запросом: {response2.json()['cookies']}")

    # Параметры по умолчанию (установка)
    session.params.update({"lang": "en"})
    response3 = session.get("https://httpbin.org/get")
    print(f"Параметры, отправленные 3-им запросом: {response3.json()['args']}")
