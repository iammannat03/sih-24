import zipfile
import os
import glob

def extract_data():
    # Get the current directory where the script is located
    current_dir = os.path.dirname(os.path.abspath(__file__))

    # Define the uploads folder and find the .zip file
    uploads_folder = os.path.join(current_dir, 'uploads')
    zip_file = glob.glob(os.path.join(uploads_folder, '*.zip'))[0]  # Select the first .zip file found

    # Define the destination folder
    extract_folder = os.path.join(current_dir, 'data')

    # Extract the zip file
    with zipfile.ZipFile(zip_file, 'r') as zip_ref:
        zip_ref.extractall(extract_folder)

    print(f"Extracted {zip_file} to {extract_folder}")
