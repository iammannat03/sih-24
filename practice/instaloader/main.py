import customtkinter as ctk
import instaloader
from tkinter import messagebox, StringVar, IntVar
from threading import Thread
from fpdf import FPDF
import os
from PIL import Image

# Function to update the progress indicator
def update_progress(value, total):
    progress.set(value)
    progress_label.set(f"Progress: {value}/{total} posts")

# Function to download Instagram posts
def download_instagram_posts():
    username = entry_username.get()
    password = entry_password.get()

    if not username or not password:
        messagebox.showerror("Error", "Please enter both username and password.")
        return

    try:
        # Initialize the Instaloader instance
        L = instaloader.Instaloader(download_pictures=True, download_videos=True)

        # Login with credentials
        L.login(username, password)

        # Download all posts from the logged-in user
        profile = instaloader.Profile.from_username(L.context, username)

        posts = list(profile.get_posts())
        total_posts = len(posts)
        update_progress(0, total_posts)

        # Create a folder to store images
        if not os.path.exists(profile.username):
            os.makedirs(profile.username)

        for index, post in enumerate(posts, start=1):
            L.download_post(post, target=profile.username)
            update_progress(index, total_posts)

        messagebox.showinfo("Success", f"All posts have been downloaded to the '{profile.username}' folder.")
        button_export_pdf.pack(pady=10)
        
    except Exception as e:
        messagebox.showerror("Error", str(e))

# Function to handle the download in a separate thread
def start_download():
    button_download.configure(state="disabled")
    progress_bar.pack(pady=10)
    Thread(target=download_instagram_posts).start()

# Function to remove non-latin-1 characters
def remove_non_latin1(text):
    return text.encode('latin-1', 'ignore').decode('latin-1')

# Function to export downloaded images and descriptions to PDF
def export_to_pdf():
    username = entry_username.get()
    content_dir = username

    pdf = FPDF()

    # Add a title page
    pdf.add_page()
    pdf.set_font("Arial", 'B', 24)
    pdf.cell(0, 10, 'Report', 0, 1, 'C')

    image_files = [f for f in os.listdir(content_dir) if f.endswith(('.jpg', '.jpeg', '.png'))]
    image_files.sort()

    for i, image_file in enumerate(image_files, start=1):
        image_path = os.path.join(content_dir, image_file)

        base_name = os.path.splitext(image_file)[0]
        description_file = os.path.join(content_dir, f"{base_name}.txt")
        description = ""
        if os.path.exists(description_file):
            with open(description_file, 'r', encoding='utf-8') as f:
                description = f.read()
                description = remove_non_latin1(description)

        with Image.open(image_path) as img:
            img = img.resize((200, 200))
            img_path_resized = os.path.join(content_dir, f"resized_{image_file}")
            img.save(img_path_resized)

        pdf.add_page()
        pdf.image(img_path_resized, x=10, y=30, w=60, h=60)

        pdf.set_xy(10, 90)
        pdf.set_font("Arial", 'B', 14)
        pdf.cell(0, 10, f"Image Caption - Post {i}", 0, 1)

        pdf.set_font("Arial", size=12)
        pdf.multi_cell(0, 10, description)

        os.remove(img_path_resized)

    output_pdf_path = os.path.join(content_dir, "instagram_posts_with_descriptions.pdf")
    pdf.output(output_pdf_path)

    messagebox.showinfo("Success", f"PDF has been created successfully and saved to {output_pdf_path}")

# Initialize the main window
app = ctk.CTk()
app.title("Instagram Downloader")
app.geometry("400x400")

# Username Label and Entry
label_username = ctk.CTkLabel(app, text="Username:")
label_username.pack(pady=10)

entry_username = ctk.CTkEntry(app, width=250)
entry_username.pack(pady=10)

# Password Label and Entry
label_password = ctk.CTkLabel(app, text="Password:")
label_password.pack(pady=10)

entry_password = ctk.CTkEntry(app, width=250, show="*")
entry_password.pack(pady=10)

# Download Button
button_download = ctk.CTkButton(app, text="Download Posts", command=start_download)
button_download.pack(pady=20)

# Progress Indicator
progress = IntVar()
progress_label = StringVar(value="Progress: 0/0 posts")
progress_bar = ctk.CTkProgressBar(app, variable=progress, orientation="horizontal", width=250)
progress_label_widget = ctk.CTkLabel(app, textvariable=progress_label)

progress_label_widget.pack(pady=5)

# Button to export as PDF (hidden initially)
button_export_pdf = ctk.CTkButton(app, text="Export as PDF", command=export_to_pdf)

# Run the application
app.mainloop()