# SpyNetra

**SpyNetra** is an automated social media feed parsing tool designed to assist in the investigation of social media accounts. It parses personal information extracted from platforms like Facebook, Instagram, and WhatsApp using the **Meta Accounts Center**. Users can upload the exported zip file from Meta, and SpyNetra will automatically process the data, generating a detailed PDF report. The app is currently under development, and not all features are fully implemented yet.

## Screenshots

Below are some screenshots showcasing the current user interface of **SpyNetra**:

<p align="center">
  <img src="path/to/screenshot1.png" alt="Screenshot 1" width="45%" style="padding: 10px;">
  <img src="path/to/screenshot2.png" alt="Screenshot 2" width="45%" style="padding: 10px;">
</p>

## Features

- **Automated Parsing of Social Media Data**: Upload the zip file of personal data from Meta's Accounts Center, and SpyNetra will parse and process the content.
- **PDF Generation**: Automatically generates a structured PDF document containing the parsed social media data, including posts, messages, timelines, friend lists, followers, account info, and more.
- **AI-Powered Summary and Labeling**:
  - After generating the PDF, SpyNetra can create an AI summary of the document, providing key highlights and insights.
  - AI-generated labels for images from posts and screenshots help categorize content, including detecting NSFW (Not Safe For Work) and suspicious material.
- **Multi-Platform Support**: Available for both Android and Windows, supporting easy access across devices.
- **Cross-Platform Social Media Support**:
  - Facebook
  - Instagram
  - WhatsApp (under development)
  - Twitter (under development)
  - Telegram (under development)
  - Google Accounts (under development)

## Current Development Status

The app is under active development. Some key features are not fully implemented yet, including:

- Parsing data from Twitter, Telegram, and Google accounts.
- Full Android and Windows platform support.
- AI-powered PDF summary generation and AI-generated labels for images to categorize NSFW and suspicious content.
- User-friendly PDF export options and advanced filters.

## Use Cases

SpyNetra is designed for investigators and professionals in law enforcement, cybersecurity, and digital forensics. It automates the process of parsing personal information from social media platforms, eliminating manual efforts and errors.

## Installation and Running the App

1. Clone the repository:

   ```bash
   https://github.com/iammannat03/sih-24.git
   ```

2. Navigate to the project directory:

   ```bash
   cd sih-24
   ```

3. Install the required Flutter dependencies:

   ```bash
   flutter pub get
   ```

4. Install the required Python dependencies:

   ```bash
   pip install -r requirements.txt
   ```

5. Run the Flutter app:

   ```bash
   flutter run
   ```

   The server has already been deployed, and no additional configuration is required for the backend.

   This will run the open-source app, and you can begin using the tool.

## Usage

1. **Export Data**: Export the personal data zip file from the Meta Accounts Center for Facebook, Instagram, or WhatsApp.
2. **Upload**: Use the SpyNetra interface to upload the zip file.
3. **Parsing**: SpyNetra will parse the zip file, extracting key information such as posts, messages, friends, followers, and account details.
4. **PDF Generation**: Once the data is parsed, SpyNetra will generate a comprehensive PDF report.
5. Review and save or print the PDF as per requirements.

## Contributing

We welcome contributions to improve and expand SpyNetra! To contribute:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature-branch-name`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch-name`).
5. Create a pull request for review.

## License

SpyNetra is licensed under the [MIT License](LICENSE).
