An iOS application built using the **MVVM-Coordinator Architecture**.

---

## 📂 Project Structure

The app is organized into the following key folders:

### 1. **Modules (MVVM)**
- **Model**: Defines the data structures and logic for handling app data.
- **View**: Manages the UI elements and user interaction.
- **ViewModel**: Acts as the intermediary between Model and View, containing logic to process and expose data for the View.

### 2. **Coordinator**
- Handles navigation and app flow between various screens.
- Centralizes routing logic, making the app more maintainable and decoupled.

### 3. **Helpers**
- Contains utility files and shared functionalities:
  - **NetworkManager**: Manages API requests and responses.
  - **URLConstructor**: Builds and validates API endpoints.
  - **ResponseValidator**: Validates API responses for errors or inconsistencies.
  - **LocalizedKey**: Centralizes app localization keys.
  - **APIService**: Contain based url for API requests and response.
  - **DataDecoder**: Decode data received from API into Any Models.
  - **NetworkError**: Centralized network error string.

---

## ✨ Features

- **Modular MVVM-Coordinator Architecture**: Ensures a clear separation of concerns and promotes code reusability.
- **Network Layer**: Centralized networking with request validation and error handling.
- **Scalable Design**: Built for easy extension and maintenance.
- **Pull-to-Refresh**: Supports refreshing of data on relevant screens.
- **Tag-Based Filtering**: Dynamically filter data using multiple tags.

---

## 🚀 Running the App

To run the app locally, follow these steps:

### **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```
### **Open the project in Xcode**:

    Double-click the .xcodeproj or .xcworkspace file to open the project.
### **Run the app**:

    Press Command + R or click the Run button in Xcode to build and run the app on the simulator or a connected device.

---
