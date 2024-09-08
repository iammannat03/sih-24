import requests
import os
import json
from dotenv import load_dotenv
import os



def maps():
    path = os.path.join("data", "personal_information", "information_about_you")
    json_path = os.path.join(path, "account_based_in.json")

    with open(json_path, 'r') as f:
        json_data = json.load(f)
    location = json_data["inferred_data_primary_location"][0]["string_map_data"]["Town/city name"]["value"]

    # Load environment variables from .env file
    load_dotenv()

    # Access environment variables
    API_KEY1 = os.getenv('API_KEY1')
    API_KEY2 = os.getenv('API_KEY2')
    API_KEY1 = '66dccf04a1b52010117033orb17d030'
    query = location
    url = 'https://geocode.maps.co/search?q={}&api_key={}'.format(query.replace(' ', '+'), API_KEY)
    response = requests.get(url)
    json_data = response.json()
    API_KEY2 = 'd6b1110a7e104e9b8972237b54552f2b'
    lat = json_data[0]['lat']
    lon = json_data[0]['lon']
    display_name = json_data[0]['display_name']
    url = "https://maps.geoapify.com/v1/staticmap?style=osm-bright&width=600&height=400&center=lonlat:{},{}&zoom=14&apiKey={}".format(lon, lat, API_KEY)

    response = requests.get(url)
    with open('map_image.png', 'wb') as file:
        file.write(response.content)
    return display_name

