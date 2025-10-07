# Posts App

A Flutter mobile application that displays a list of posts from JSONPlaceholder API with local storage functionality and read status tracking.

## Features

- **Post List Screen**: Displays posts from the JSONPlaceholder API
- **Post Detail Screen**: Shows detailed information about a selected post
- **Read Status Tracking**: Posts change from light yellow to white when read
- **Post Filtering**: Filter posts by All, Read, and Unread status
- **Local Storage**: Data persistence and background synchronization
- **Modern UI**: Clean and responsive design with Material Design 3
- **State Management**: GetX for reactive state management
- **Error Handling**: Graceful error handling with retry functionality

## Technical Stack

- **Flutter**: Cross-platform mobile development
- **GetX**: State management and navigation
- **HTTP**: API communication
- **Hive**: Fast and lightweight NoSQL database for local storage
- **Material Design 3**: Modern UI components

## Project Structure

```
lib/
├── controller/
│   ├── post_controller.dart          # Manages post list state and API calls
│   └── post_detail_controller.dart   # Manages post detail state and API calls
├── models/
│   └── post.dart                     # Post data model
├── utils/
│   ├── colors.dart                   # App color scheme
│   └── responsive.dart               # Responsive utilities
├── views/
│   ├── post_screen.dart              # Post list screen
│   └── post_detail_screen.dart      # Post detail screen
└── main.dart                         # App entry point
```

## API Endpoints

- **Posts List**: `https://jsonplaceholder.typicode.com/posts`
- **Post Detail**: `https://jsonplaceholder.typicode.com/posts/{postId}`

## Getting Started

1. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## Key Features Implementation

### Read Status Tracking
- Posts start with light yellow background
- When tapped, posts are marked as read and background changes to white
- Read status is persisted in local storage

### Post Filtering
- **Filter Options**: All, Read, and Unread posts
- **Filter Bar**: Horizontal scrollable filter chips at the top
- **Filter Stats**: Real-time statistics showing total, read, and unread counts
- **Floating Action Button**: Quick access to filter options via bottom sheet
- **Empty States**: Contextual messages when no posts match the current filter
- **Real-time Updates**: Filter results update automatically when posts are marked as read

### Local Storage with Hive
- **Fast Performance**: Hive provides faster read/write operations compared to SharedPreferences
- **Type Safety**: Strongly typed data storage with generated adapters
- **Offline Access**: Posts are cached locally for offline access
- **Persistent State**: Read status is maintained across app sessions
- **Background Sync**: Background synchronization ensures data freshness
- **Memory Efficient**: Hive uses less memory and provides better performance

### Error Handling
- Network errors are handled gracefully
- Cached data is shown when API is unavailable
- Retry functionality for failed requests

## Dependencies

- `get: ^4.6.6` - State management and navigation
- `http: ^1.1.0` - HTTP requests
- `hive: ^2.2.3` - Fast NoSQL database
- `hive_flutter: ^1.1.0` - Hive Flutter integration
- `hive_generator: ^2.0.1` - Code generation for Hive adapters
- `build_runner: ^2.4.7` - Code generation runner