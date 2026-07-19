import requests

headers = {
    "Accept": "application/json",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0"
}
params = {
    "latitude": 55.75,
    "longitude": 37.61,
    "current": "temperature_2m,apparent_temperature"
}
url = "https://api.open-meteo.com/v1/forecast"

response = requests.get(url, headers=headers, params=params)
response.raise_for_status()
answer = response.json()
print(answer)
current = answer['current']
print(current['temperature_2m'])
print(current['apparent_temperature'])
