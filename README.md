# NueraTalk 🤖

NueraTalk is a smart Flutter chat application powered by Google's Gemini AI. It provides a seamless conversational experience with a modern UI, local chat history storage, and intelligent responses.

## ✨ Features

-   **AI-Powered Conversations**: Integrated with Google Gemini (`gemini-1.5-flash-latest`) for intelligent and context-aware responses.
-   **Modern Chat Interface**: Built with `dash_chat_2` for a polished and responsive messaging experience.
-   **Local History**: Saves chat sessions locally using `sqflite`, allowing users to revisit past conversations.
-   **Chat Management**:
    -   Auto-saves chat sessions.
    -   Organizes chats by date (Today, Yesterday, Last Week, etc.).
    -   Automatically deletes chats older than 30 days.
-   **User-Friendly Design**: Includes a drawer for easy navigation and access to chat history.

## 🛠️ Tech Stack

-   **Framework**: [Flutter](https://flutter.dev/)
-   **Language**: [Dart](https://dart.dev/)
-   **AI Model**: [Google Gemini](https://ai.google.dev/) (`google_generative_ai`)
-   **UI Library**: [Dash Chat 2](https://pub.dev/packages/dash_chat_2)
-   **Local Database**: [Sqflite](https://pub.dev/packages/sqflite)
-   **State Management**: `setState` (Native Flutter)

## 🚀 Getting Started

### Prerequisites

-   Flutter SDK installed (version `^3.5.3` recommended).
-   A Google Gemini API Key.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/HaiderAli228/NueraTalk.git](https://github.com/HaiderAli228/NueraTalk.git)
    cd NueraTalk
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure API Key:**
    -   Open `lib/view-model/app_links.dart`.
    -   Add your Gemini API key to the `chatbotPostApi` constant.
    ```dart
    class AppLinks {
      static const String chatbotPostApi = "YOUR_GEMINI_API_KEY";
    }
    ```

4.  **Run the app:**
    ```bash
    flutter run
    ```

## 📂 Project Structure
lib/
├── main.dart          # Application entry point and routing
├── models/            # Data models
├── routes/            # Route management
├── utils/             # Utility classes (Colors, Constants)
├── view/              # UI Screens (HomeView, etc.)
└── view-model/        # Logic and API handling


## 👨‍💻 Developer

**Haider Ali**
*Flutter Developer + Firease Developer*

-   📧 **Email**: [flutter2830@gmail.com](mailto:flutter2830@gmail.com)
-   🌐 **Portfolio**: [https://haiderali228.netlify.app/](https://haiderali228.netlify.app/)

---
*Built with ❤️ using Flutter and Gemini AI.*
