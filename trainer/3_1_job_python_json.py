import json

data = {
    "name": "Боби",
    "age": 25,
    "city": "Oslo",
    "hobbies": ["reading", "hiking"]
}

# Сериализация
json_string = json.dumps(data, indent=2, ensure_ascii=False)
print(f"JSON:\n")
print(json_string)

# Десериализация
parser_data = json.loads(json_string)
print(f"\nPython:\n")
print(parser_data)
print(f"Name: {parser_data['name']}")
print(f"First hobby: {parser_data['hobbies']}")
