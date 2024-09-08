import os
import json
import datetime
import re
import pdf_generator
import maps

def get_image():
    # Define the base path
    base_path = os.path.join("data", "media", "profile")

    # Get the first folder (random number folder)
    folders = sorted(os.listdir(base_path))  # sort to ensure consistent order
    first_folder = folders[-1]  # grab the first/ last[-1] folder

    # Define the path for the first folder
    folder_path = os.path.join(base_path, first_folder)

    # Get the image inside the first folder
    image_files = [f for f in os.listdir(folder_path) if os.path.isfile(os.path.join(folder_path, f))]
    first_image = image_files[0]  # assuming there is one image file

    # Full path to the image
    image_path = os.path.join(folder_path, first_image)

    return image_path


def timestamp_to_datetime(timestamp):
    # Convert the timestamp to a datetime object
    dt_object = datetime.datetime.fromtimestamp(timestamp)
    return dt_object


def account_information():
    # Define the base path and JSON file path
    base_path = os.path.join("data", "personal_information", "personal_information")
    json_file_path = os.path.join(base_path, "account_information.json")

    # Load the JSON data from the file
    with open(json_file_path, 'r') as f:
        json_data = json.load(f)    

    col = json_data.get('profile_account_insights')[0].get('string_map_data')
    main_keys = list(col.keys())
    values = [col[key]['value'] for key in main_keys]
    timestamps = [timestamp_to_datetime(col[key]['timestamp']) for key in main_keys]
    clubbed_data = [[key, value, str(timestamp)] for key, value, timestamp in zip(main_keys, values, timestamps)]
    clubbed_data.insert(0, ["Field", "Value", "Timestamp"])
    return clubbed_data


def last_login_info():
    base_path = os.path.join("data", "your_instagram_activity", "messages")
    json_file_path = os.path.join(base_path, "secret_conversations.json")

    # Load the JSON data from the file
    with open(json_file_path, 'r') as f:
        json_data = json.load(f) 

    # Initialize the result list with the header
    result = [["device_type", "device_manufacturer", "device_model", "device_os_version", "last_connected_ip", "last_active_time"]]
    
    # Extract the armadillo_devices list
    devices = json_data.get("ig_secret_conversations", {}).get("armadillo_devices", [])
    
    # Iterate through each device and append its info to the result
    for device in devices:
        device_info = [
            device.get("device_type", ""),
            device.get("device_manufacturer", ""),
            device.get("device_model", ""),
            device.get("device_os_version", ""),
            device.get("last_connected_ip", ""),
            device.get("last_active_time", "")
        ]
        result.append(device_info)
    
    return result




def personal_information():
    # Define the base path and JSON file path
    base_path = os.path.join("data", "personal_information", "personal_information")
    json_file_path = os.path.join(base_path, "personal_information.json")

    # Load the JSON data from the file
    with open(json_file_path, 'r') as f:
        json_data = json.load(f)

    # Extract the required information
    email = json_data.get('profile_user')[0].get('string_map_data').get('Email address').get('value')
    phone = json_data.get('profile_user')[0].get('string_map_data').get('Phone number confirmed').get('value')
    username = json_data.get('profile_user')[0].get('string_map_data').get('Username').get('value')
    name = json_data.get('profile_user')[0].get('string_map_data').get('Name').get('value')
    bio = json_data.get('profile_user')[0].get('string_map_data').get('Bio').get('value')
    gender = json_data.get('profile_user')[0].get('string_map_data').get('Name').get('value')  # Same as name, change if required
    dob = json_data.get('profile_user')[0].get('string_map_data').get('Date of birth').get('value')
    return [name,email,username,"****",bio,dob]



path = os.path.join("data", "personal_information", "device_information")
json_path = os.path.join(path, "devices.json")

# Load the JSON data from the file
with open(json_path, 'r') as f:
    json_data = json.load(f)

def device_information(json_data,i):

    timestamp = json_data.get('devices_devices')[i].get('string_map_data').get('Last login').get('timestamp') 
    time = timestamp_to_datetime(timestamp=timestamp)
    time = time.strftime("%Y-%m-%d %H:%M")
    # print(timestamp)


    device = json_data.get('devices_devices')[i].get('string_map_data').get('User agent').get('value') 
    # print(device)
    # Regex patterns
    user_agent_pattern = r"(Instagram [\d\.]+ Android)"
    resolution_pattern = r"(\d+x\d+)"
    brand_model_pattern = r"; ([A-Za-z]+); ([A-Za-z0-9 ]+)"

    # Extract using regex
    user_agent = re.search(user_agent_pattern, device).group(1)
    resolution = re.search(resolution_pattern, device).group(1)
    brand_model = re.search(brand_model_pattern, device)

    brand = brand_model.group(1)
    model = brand_model.group(2)
    return [i+1,time,user_agent, brand +" "+ model,resolution]

devices_result =[["No.", "Last Login", "User Agent", "Device Model", "Resolution"]];
i=0
for login in json_data.get('devices_devices'):
    devices_result.append(device_information(json_data=json_data,i=i))
    i+=1


def get_info():
    image_path = get_image()
    name = personal_information()[0]
    email = personal_information()[1]
    username = personal_information()[2]
    password = personal_information()[3]
    account_info = account_information()
    login_info = last_login_info()
    display_name = maps.maps()
    pdf_generator.create_pdf(image_path=image_path,name=name,email=email,username=username,password=password,device_data=devices_result,account_info=account_info,login_info=login_info,location=display_name)



# print(device_information(json_data=json_data))
# Print results
# print(f"User Agent: {user_agent}")
# print(f"Resolution: {resolution}")
# print(f"Brand: {brand}")
# print(f"Model: {model}")
# Print or use the extracted information
# print(f"Email: {email}")
# print(f"Phone: {phone}")
# print(f"Username: {username}")
# print(f"Name: {name}")
# print(f"Bio: {bio}")
# print(f"Gender: {gender}")
# print(f"Date of Birth: {dob}")

