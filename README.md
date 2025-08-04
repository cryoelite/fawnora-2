# Fawnora

Fawnora is a Flutter-based mobile application designed for ecological data collection and monitoring. It enables users to record observations of fauna, flora, and environmental disturbances in specific geographical regions. The app is designed to work offline and syncs with a Firebase backend when online.

## Key Features

- **Data Collection:** Record observations for various species of fauna and flora.
- **Disturbance Tracking:** Log environmental disturbances like sand mining, human activity, etc.
- **Offline First:** Data is stored locally using Hive and synced to the cloud when a connection is available.
- **Geolocation:** Tag observations with precise GPS coordinates.
- **Mapping:** Visualize data on Google Maps.
- **Secure:** User data is encrypted.
- **Multi-language support:** The app supports both English and Hindi.

## Tech Stack

- **Frontend:** Flutter
- **Backend:** Firebase (Firestore, Firebase Storage, Firebase Authentication)
- **State Management:** Riverpod
- **Local Storage:** Hive
- **Mapping:** Google Maps
- **Animation:** Rive

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- A Firebase project.

### Installation

1.  Clone the repo
    ```sh
    git clone https://github.com/your_username/fawnora.git
    ```
2.  Install packages
    ```sh
    flutter pub get
    ```
3.  Set up Firebase for your project. You will need to add your own `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files.
4.  Run the app
    ```sh
    flutter run
    ```

## Folder Structure

The `lib` folder is structured as follows:

-   `app`: Contains the main application logic, divided into features (e.g., `home`, `authentication`, `splash`).
-   `common_widgets`: Contains widgets that are used across multiple features.
-   `constants`: Contains application-wide constants like colors, routes, and asset paths.
-   `locale`: Contains localization files for different languages.
-   `models`: Contains the data models used in the application.
-   `routing`: Contains the application's routing logic.
-   `services`: Contains services that provide specific functionality (e.g., `AuthService`, `FirestoreService`).

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Acknowledgments

-   [Project GTF](https://www.ganges.org.in/wii-nmcg-project)
-   Wildlife Institute of India
-   National Mission for Clean Ganga
