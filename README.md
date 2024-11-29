# Firebase Extensions Example

A simple Flutter app demonstrating the usage of Firebase Extensions, specifically the [Transcribe Speech to Text](https://extensions.dev/extensions/googlecloud/speech-to-text) by Google Cloud. The app supports Android and iOS.

It was build using Flutter 3.22.3.

Users can take or import photos from their devices and record a voice note. These are saved to Firebase Storage, and the Speech-to-Text extension transcribes the voice recordings and saves the transcriptions to Firestore. The app displays the transcriptions next to the corresponding images.

## Getting Started

To run this app locally, follow these steps:

### Prerequisites

1. **Flutter SDK**: Ensure you have Flutter installed on your machine. You can follow the installation guide [here](https://flutter.dev/docs/get-started/install).
2. **Firebase CLI**: Required to interact with Firebase services from the command line.

### Steps

1. **Create a Firebase Project**
    - Go to the [Firebase Console](https://console.firebase.google.com/).
    - Click on "Add Project" and follow the setup steps.

2. **Authenticate Firebase on Your Machine**
    - Open a terminal and run:
      ```bash
      curl -sL https://firebase.tools | bash
      firebase login
      ```

3. **Activate Flutterfire CLI**
    - Run the following command to activate the Flutterfire CLI:
      ```bash
      dart pub global activate flutterfire_cli
      ```

4. **Configure Flutter App to Use Firebase**
    - Navigate to your Flutter project directory.
    - Run the Flutterfire CLI to configure your app:
      ```bash
      flutterfire configure
      ```
    - Follow the prompts to select the Firebase project you created and enable the platforms you are targeting (Android, iOS, and web).

5. **Enable Necessary Firebase Products**
    - In the Firebase Console, go to the **Authentication** section:
        - Enable Anonymous Authentication.
    - In the **Firestore Database** section:
        - Create a Firestore database and set the security rules according to your needs. Here's an example of basic rules:
          ```
          service cloud.firestore {
            match /databases/{database}/documents {
              match /{document=**} {
                allow read, write: if request.auth != null;
              }
            }
          }
          ```
    - Change your project's billing plan to Blaze.
    - In the **Storage** section:
        - Set up Firebase Storage and configure its security rules. Example:
          ```
          service firebase.storage {
            match /b/{bucket}/o {
              match /{allPaths=**} {
                allow read, write: if request.auth != null;
              }
            }
          }
          ```

6. **Install Firebase Extensions**
    - In the Firebase Console, navigate to the **Extensions** section.
    - Find and install the **Transcribe Speech to Text** extension by Google Cloud.
    - Follow the configuration steps, ensuring the extension is set to transcribe audio files uploaded to your specified Firebase Storage bucket and save the transcriptions to Firestore.

### Running the App

1. Clone the repository.
2. Get the dependencies:

    ```bash
    flutter pub get
    ```
3. Setup Firebase as mentioned in previous section.
4. Run the app:

   ```bash
   flutter run
   ```

## Firebase Products Used

-   **Firebase Authentication**: For user authentication (Anonymous Authentication).
-   **Cloud Firestore**: To store the transcriptions and keep track of content added by users.
-   **Firebase Storage**: To store the uploaded photos and voice recordings.
-   **Firebase Extensions**: Transcribe Speech to Text by Google Cloud to transcribe voice recordings.