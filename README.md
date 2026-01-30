# 💒 Daily Word App: A Spiritual Companion
The Daily Word App is a comprehensive spiritual companion designed to provide users with a daily dose of inspiration, guidance, and reflection. This app offers a wide range of features, including daily readings, Bible quotes, prayers, and more, all carefully crafted to help users deepen their faith and connect with their spiritual selves.

## 🚀 Features
- **Daily Readings**: Access to daily readings from the USCCB API, complete with scripture, reflections, and prayers.
- **Bible Quotes**: Random Bible quotes from the Bible.org API, providing inspiration and guidance.
- **Prayers**: A collection of prayers in multiple languages, including titles and texts.
- **Bible Screen**: A dedicated screen for exploring the Bible, with features like book, chapter, and verse navigation.
- **Prayers Screen**: A screen for accessing and reading prayers, with options for filtering and searching.
- **More Screen**: A screen providing additional features, such as settings, about, and contact information.
- **Localization**: Support for multiple languages, ensuring the app is accessible to a global audience.
- **State Management**: Utilizes the Provider package for efficient state management, making it easy to manage app-wide data and services.

## 🛠️ Tech Stack
- **Frontend**: Flutter, utilizing the Material Design framework for a consistent and intuitive user interface.
- **Backend**: USCCB API for daily readings, Bible.org API for Bible quotes.
- **State Management**: Provider package for managing app-wide state and services.
- **Localization**: AppLocalizations class for handling internationalization and localization.
- **Database**: SharedPreferences for storing user preferences and app data.
- **Packages**: http for making HTTP requests, dart:convert for JSON encoding and decoding, and html/parser for parsing HTML responses.

## 📦 Installation
To get started with the Daily Word App, follow these steps:
1. **Prerequisites**: Ensure you have Flutter installed on your machine, along with the necessary dependencies.
2. **Clone the Repository**: Clone the Daily Word App repository from GitHub.
3. **Install Dependencies**: Run `flutter pub get` to install the required dependencies.
4. **Run the App**: Run `flutter run` to launch the app on a connected device or emulator.

## 💻 Usage
1. **Launch the App**: Open the app on your device or emulator.
2. **Navigate**: Use the bottom navigation bar to switch between screens.
3. **Daily Readings**: Access daily readings, including scripture, reflections, and prayers.
4. **Bible Quotes**: View random Bible quotes for inspiration and guidance.
5. **Prayers**: Explore the collection of prayers, filtering and searching as needed.
6. **Settings**: Configure app settings, such as language and notification preferences.

## 📂 Project Structure
```markdown
daily_word_app/
|-- lib/
|    |-- main.dart
|    |-- data/
|    |    |-- prayers_data.dart
|    |-- services/
|    |    |-- app_provider.dart
|    |    |-- language_provider.dart
|    |    |-- bible_service.dart
|    |    |-- api_service.dart
|    |    |-- quote_service.dart
|    |-- models/
|    |    |-- prayer.dart
|    |    |-- bible_book.dart
|    |    |-- bible_quote.dart
|    |    |-- daily_reading.dart
|    |-- screens/
|    |    |-- home_screen.dart
|    |    |-- main_screen.dart
|    |-- l10n/
|    |    |-- app_localizations.dart
|-- pubspec.yaml
|-- README.md
```

## 📸 Screenshots

# Скриншоты приложения

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/3dbcb29f-8f60-4761-afb5-254583ec45ed" 
             alt="Экран 1" 
             width="180" 
             style="border-radius: 10px; border: 1px solid #eee;"/>
      </td>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/154f732a-f549-4ab0-8311-011780b9c0b6" 
             alt="Экран 2" 
             width="180"
             style="border-radius: 10px; border: 1px solid #eee;"/>
      </td>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/797c06ad-4464-4b4d-ba08-1d7f2ac94ba2" 
             alt="Экран 3" 
             width="180"
             style="border-radius: 10px; border: 1px solid #eee;"/>
      </td>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/5146355e-907c-448d-afbd-a94af9d42a20" 
             alt="Экран 4" 
             width="180"
             style="border-radius: 10px; border: 1px solid #eee;"/>
      </td>
    </tr>
  </table>
</div>


## 🤝 Contributing
To contribute to the Daily Word App, please follow these steps:
1. **Fork the Repository**: Create a fork of the Daily Word App repository.
2. **Create a Branch**: Create a new branch for your feature or bug fix.
3. **Make Changes**: Make the necessary changes, following the existing code style and structure.
4. **Commit and Push**: Commit your changes and push them to your fork.
5. **Create a Pull Request**: Create a pull request to merge your changes into the main repository.

## 📝 License
The Daily Word App is licensed under the MIT License.

## 📬 Contact
For questions, feedback, or support, please contact us at [glebanya.com@gmail.com](mailto:glebanya.com@gmail.com).
