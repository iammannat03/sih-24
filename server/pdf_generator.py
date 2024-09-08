from reportlab.lib.pagesizes import LETTER
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.units import inch
from reportlab.lib.utils import ImageReader
from reportlab.platypus import Table, TableStyle  # Import Table and TableStyle
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import Paragraph
from reportlab.platypus import Image
from reportlab.lib.enums import TA_JUSTIFY
# name,username,password,

def convert_data_to_paragraph(data):
    styles = getSampleStyleSheet()
    styleN = styles['Normal']

    # Convert each cell of the data to a Paragraph
    data_with_paragraphs = [
        [Paragraph(str(cell), styleN) for cell in row] 
        for row in data
    ]

    return data_with_paragraphs


def create_pdf(image_path,name,email,username,password,device_data,account_info,login_info,location,AI_summary):
    c = canvas.Canvas("section.pdf", pagesize=LETTER)

    # Set background color (optional) for a section
    c.setFillColorRGB(1, 1, 1)
    c.rect(0, 0, 8.5 * inch, 11 * inch, fill=1)


    c.setFont("Helvetica-Bold", 14)
    c.setFillColorRGB(0, 0, 0)  # White text color
    heading_text = "Report"
    x_position = 3.5 * inch  # Centered horizontally on an 8.5-inch wide page
    y_position = 10 * inch  # Near the top margin of the page
    c.drawString(x_position, y_position, heading_text)

    # Draw the underline
    c.setStrokeColorRGB(0, 0, 0)  # Black color
    c.setLineWidth(1.5)  # Width of the underline
    text_width = c.stringWidth(heading_text, "Helvetica-Bold", 14)
    c.line(x_position, y_position - 2, x_position + text_width, y_position - 2)

    # Add a profile image placeholder (you can replace with an actual image)
    # Load the image
    img = ImageReader(image_path)

    # Get the dimensions of the image
    img_width, img_height = img.getSize()

    # Calculate the aspect ratio of the image
    aspect_ratio = img_width / img_height

    # Calculate the width and height of the image to fit into the placeholder
    placeholder_width = 2 * inch
    placeholder_height = 2 * inch

    if aspect_ratio > 1:
        # Landscape image
        img_width = placeholder_width
        img_height = img_width / aspect_ratio
    else:
        # Portrait image
        img_height = placeholder_height
        img_width = img_height * aspect_ratio

    # Calculate the position to center the image within the placeholder
    x = 0.75 * inch + (2 * inch - img_width) / 2
    y = 7.5 * inch + (2 * inch - img_height) / 2

    # Draw the image onto the canvas
    c.drawImage(img, x, y, img_width, img_height)

    # Border around image placeholder
    c.setStrokeColorRGB(0, 0, 0)  #black border
    c.setLineWidth(2)
    c.rect(0.75 * inch, 7.5 * inch, 2 * inch, 2 * inch)


    # Add placeholder labels and fields for name, etc.
    # Name field
  # Replace with the actual name from the parameters
    c.setStrokeColorRGB(0, 0, 0)
    c.setFillColorRGB(0, 0, 0)  # White text color
    c.setFont("Helvetica-Bold", 10)
    c.rect(5 * inch, 9.1 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)
    c.drawString(5.1 * inch, 9.2 * inch, f"{name}")



    # Name field
    c.setStrokeColorRGB(0, 0, 0)
    c.drawString(3.5 * inch, 9.2 * inch, "NAME:")
    c.rect(5 * inch, 9.1 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)

    # Account Checked field
    # Email Address field
    c.setStrokeColorRGB(0, 0, 0)
    c.drawString(3.5 * inch, 8.6 * inch, "Email Address:")
    c.rect(5 * inch, 8.5 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)
    c.setFillColorRGB(1, 1, 1)  # White text color
    c.setFont("Helvetica-Bold", 10)
    c.rect(5 * inch, 8.5 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(5.1 * inch, 8.6 * inch, f"{email}")

    # Handle ID field
    c.setStrokeColorRGB(0, 0, 0)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(3.5 * inch, 8.0 * inch, "HANDLE ID:")
    c.rect(5 * inch, 7.9 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)
    c.setFillColorRGB(1, 1, 1)  # White text color
    c.setFont("Helvetica-Bold", 10)
    c.rect(5 * inch, 7.9 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(5.1 * inch, 8.0 * inch, f"{username}")

    # Password field
    # Password field
    c.setFillColorRGB(0, 0, 0)
    c.drawString(3.5 * inch, 7.4 * inch, "PASSWORD:")
    c.setFillColorRGB(0, 0, 0)
    c.rect(5 * inch, 7.3 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)
    c.setStrokeColorRGB(0, 0, 0)  # White text color
    c.setFont("Helvetica-Bold", 10)
    c.rect(5 * inch, 7.3 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(5.1 * inch, 7.4 * inch, f"{password}")

    # Account Info Date
    c.setStrokeColorRGB(0, 0, 0)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(3.5 * inch, 6.8 * inch, "ACCOUNT INFO DATE:")
    c.rect(5 * inch, 6.7 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)

    # Date Range (From / Till)
    c.setStrokeColorRGB(0, 0, 0)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(3.5 * inch, 6.2 * inch, "FROM:")
    c.rect(5 * inch, 6.1 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)

    c.setStrokeColorRGB(0, 0, 0)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(3.5 * inch, 5.6 * inch, "TILL:")
    c.rect(5 * inch, 5.5 * inch, 2.5 * inch, 0.3 * inch, stroke=1, fill=0)

    c.setFont("Helvetica-Bold", 14)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(1 * inch, 5 * inch, "Device Information")  # Title
# Draw the underline
    c.setStrokeColorRGB(0, 0, 0)  # Black color
    c.setLineWidth(1.5)  # Width of the underline
    text_width = c.stringWidth("Device Information", "Helvetica-Bold", 14)
    c.line(1 * inch, 5 * inch - 2, 1 * inch + text_width, 5 * inch - 2)


    

    # Draw second line with vertical space

    # Create the table object
    table = Table(device_data, colWidths=[0.3 * inch, 1 * inch, 2.5 * inch, 2 * inch, 1 * inch])

    # Define table style
    table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.black),  # Header background color
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),  # Header text color
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),  # Bold font for headers
        ('FONTSIZE', (0, 0), (-1, 0), 10),  # Header font size
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),  # Padding for header
        ('BACKGROUND', (0, 1), (-1, -1), colors.grey),  # Background for data rows
        ('TEXTCOLOR', (0, 1), (-1, -1), colors.black),  # Text color for data rows
        ('GRID', (0, 0), (-1, -1), 0.5, colors.black),  # Grid lines
    ]))


    space_after_upper_section = 1.25 * inch # Space after the upper section

    # Table position on the page (move according to your layout)
    # Corrected Table placement
    table.wrapOn(c, 400, 300)  # Pass width and height as positional arguments
 # Set the wrapping (dynamic size)
    table.drawOn(c, 0.75 * inch, 5.25 * inch-space_after_upper_section)  # Position it on the canvas


    c.setFont("Helvetica-Bold", 14)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(1 * inch, 3.3 * inch, "AI SUMMARY:")  # Title
# Draw the underline
    c.setStrokeColorRGB(0, 0, 0)  # Black color
    c.setLineWidth(1.5)  # Width of the underline
    text_width = c.stringWidth("AI SUMMARY:", "Helvetica-Bold", 14)
    c.line(1 * inch, 3.3 * inch - 2, 1 * inch + text_width, 3.3 * inch - 2)

    styles = getSampleStyleSheet()
    custom_style = ParagraphStyle('CustomStyle', parent=styles['Normal'],
                              fontSize=12,
                                fontName='Helvetica',
                                alignment=TA_JUSTIFY)

    # Create the paragraph with the custom style
    p = Paragraph(AI_summary, custom_style)

    # Wrap and draw the paragraph
    p.wrapOn(c, 6*inch, 12*inch)  # Adjust width and height as needed
    p.drawOn(c, 1*inch, 1.5*inch)

    c.showPage()

    
    c.setFont("Helvetica-Bold", 14)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(1 * inch, 10 * inch, "Account Information")  # Title
    # Draw the underline
    c.setStrokeColorRGB(0, 0, 0)  # Black color
    c.setLineWidth(1.5)  # Width of the underline
    text_width = c.stringWidth("Device Information", "Helvetica-Bold", 14)
    c.line(1 * inch, 10 * inch - 2, 1 * inch + text_width, 10 * inch - 2)


        # Data for the new table with 3 columns
    new_data = account_info

    # Create the new table with appropriate column widths
    new_table = Table(new_data, colWidths=[2 * inch, 1.5 * inch, 1.5 * inch])

    # Set the style for the new table
    new_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.black),  # Header background color
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),  # Header text color
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),  # Bold font for headers
        ('FONTSIZE', (0, 0), (-1, 0), 10),  # Header font size
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),  # Padding for header
        ('BACKGROUND', (0, 1), (-1, -1), colors.grey),  # Background for data rows
        ('TEXTCOLOR', (0, 1), (-1, -1), colors.black),  # Text color for data rows
        ('GRID', (0, 0), (-1, -1), 0.5, colors.black),  # Grid lines
    ]))

    # Position the new table below the previous content
    new_table.wrapOn(c, 400, 300)  # Use the appropriate width and height
    new_table.drawOn(c, 0.75 * inch, 7.5 * inch)  # Adjust y-position as needed

    # Continue with other elements if needed, save the PDF at the end

# Heading for the new table
    c.setFont("Helvetica-Bold", 14)
    c.drawString(1 * inch, 6 * inch, "LAST TWO LOGGED IN DEVICES:")
    text_width = c.stringWidth("LAST TWO LOGGED IN DEVICES:", "Helvetica-Bold", 14)
    c.line(1 * inch, 6 * inch - 2, 1 * inch + text_width, 6 * inch - 2)

    # Use a sample style sheet for paragraph styling
    styles = getSampleStyleSheet()
    styleN = styles['Normal']

    # Data for the new table with word wrapping for columns
    data = convert_data_to_paragraph(login_info)

    # Create the table with specific column widths
    table = Table(data, colWidths=[1 * inch, 1 * inch, 1 * inch, 1 * inch, 1.5 * inch, 1.5 * inch])

    # Apply styling to the table (optional)
    table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.grey),  # Header row background color
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),  # Header row text color
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),  # Center alignment
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),  # Bold header row
        ('FONTSIZE', (0, 0), (-1, -1), 10),  # Font size for all cells
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),  # Padding for header row
        ('BACKGROUND', (0, 1), (-1, -1), colors.beige),  # Background color for other rows
        ('GRID', (0, 0), (-1, -1), 1, colors.black),  # Grid lines
    ]))

    # Position the table 2 inches below the previous one
    table.wrapOn(c, 400, 300)
    table.drawOn(c, 1 * inch, 4 * inch)  # Adjust y-position to 4 inches for space between tables


    # Add new page
    c.showPage()

    # Set font and add heading
    c.setFont("Helvetica-Bold", 14)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(1 * inch, 10 * inch, "Primary Location")

    # Underline the heading
    text_width = c.stringWidth("Primary Location", "Helvetica-Bold", 14)
    c.setLineWidth(1)
    c.line(1 * inch, 10 * inch - 2, 1 * inch + text_width, 10 * inch - 2)

    c.setFont("Helvetica", 12)
    c.setFillColorRGB(0, 0, 0)
    c.drawString(1 * inch, 9.5 * inch, location)

    # Load and display the image
    image_path = "map_image.png"
    map_image = Image(image_path)
    map_image.drawHeight = 5 * inch  # Adjust image height
    map_image.drawWidth = 5 * inch  # Adjust image width

    # Draw image under the heading (position the image properly below)
    map_image.drawOn(c, 1 * inch, 4 * inch)

    # Save the PDF
    c.save()

# image_path = "data/media/profile/202407/452633093_508431004972191_5499171854651456110_n_17862252078190127.jpg"

# name = "Prakhar Mishra"

# email = "prakharmishra.531@gmail.com"

# username = "MozartX"

# password = "123456"

# data = [
#     ["No.", "Last Login Timestamp", "User Agent", "Device Model", "Resolution"],  # Table header
#     ["1", "1689226512", "Barcelona 291.0.0.31.111 Android", "Samsung SM-A145F", "1080x2209"],
#     ["2", "1688632646", "Barcelona 289.0.0.77.109 Android", "Realme RMX2193", "720x1448"],
#     ["3", "1670168302", "Instagram 261.0.0.21.111 Android", "Vivo V2153", "1080x2208"],
#     ["4", "1662734520", "Instagram 251.1.0.11.106 Android", "Vivo V2029", "720x1470"],
#     ["5", "1689226512", "Barcelona 291.0.0.31.111 Android", "Samsung SM-A145F", "1080x2209"],
#     ["6", "1689226512", "Barcelona 291.0.0.31.111 Android", "Samsung SM-A145F", "1080x2209"],
#     ["7", "1689226512", "Barcelona 291.0.0.31.111 Android", "Samsung SM-A145F", "1080x2209"],
#     ["8", "1689226512", "Barcelona 291.0.0.31.111 Android", "Samsung SM-A145F", "1080x2209"],
#     ["9", "1689226512", "Barcelona 291.0.0.31.111 Android", "Samsung SM-A145F", "1080x2209"],
# ]
# # Generate the PDF section
# create_pdf(image_path=image_path,name=name,email=email,username=username,password=password,device_data=data)
