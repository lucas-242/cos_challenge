# COS Challenge Project

This project is a Flutter application developed as part of the COS Challenge. It demonstrates a mobile application with user authentication, VIN (Vehicle Identification Number) search functionality, and a clear architectural separation.

## Architecture

The project follows the MVVM architecture to ensure separation of concerns, maintainability, and testability:

-   **`presenter/`**: Contains the UI components and their corresponding `ValueNotifier`-based controllers. These controllers manage the state and logic related to the UI, interacting with the data layer.
-   **`data/`**: Contains the data models and repositories. Repositories abstract the data sources and provide a clean API for the presenter layer.
-   **`core/services/`**: Includes core services such as local storage (`flutter_secure_storage`).
-   **`shared/utils/`**: Contains utility classes, including the `CosChallenge` class which provides the `httpClient` for network operations and other challenge-specific constants.

## Testing Strategy

The project emphasizes unit and widget testing to ensure code quality and reliability. `mockito` is used extensively for mocking dependencies, enabling isolated testing of individual components.

-   **Unit Tests**: Located in `test/` under corresponding directory structures. These tests focus on verifying the logic of individual classes in isolation, mocking their dependencies.
-   **Widget Tests**: Used for testing UI components and their interactions. These tests simulate user interactions and verify the visual output and state changes of widgets.
-   **Dependency Injection**: Achieved primarily through constructor injection. This pattern makes classes independent of concrete implementations, allowing mock objects to be easily injected during testing.

To run the tests, use the following command:

```bash
flutter test
```

## How to Run the Project

To get the project up and running on your local machine, follow these steps:

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/cos_challenge.git
    cd cos_challenge
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Generate Mock Files (if needed):**
    If you add new mocks or modify existing ones, you'll need to run `build_runner`:
    ```bash
    dart run build_runner build -d
    ```

#### Download APK

You can download the latest APK from the [GitHub Releases page](https://github.com/lucas-242/cos_challenge/releases).

#### Running the Application

To run the application on a connected device or emulator:

```bash
flutter run
```
