# Ecommerce

Ecommerce is a Flutter e-commerce application built with a clean layered architecture using BLoC, GoRouter, dependency injection, and local persistence. The app lets users browse products, search and filter by category, add items to a wishlist or cart, and proceed through a checkout flow.

## Features

- Product listing with search and sorting
- Category-based filtering
- Infinite scrolling product loading
- Product details page
- Wishlist management
- Shopping cart with quantity updates and totals
- Checkout flow with order summary
- Local state persistence for cart and wishlist
- Clean architecture with data, domain, and presentation layers

## Tech Stack

- Flutter
- Dart
- BLoC for state management
- GoRouter for navigation
- GetIt for dependency injection
- Dio for HTTP requests
- SharedPreferences for local persistence
- CachedNetworkImage for image loading

## Project Structure

```text
lib/
├── app/
│   └── router/
├── core/
│   ├── di/
│   └── error/
├── features/
│   ├── cart/
│   ├── checkout/
│   ├── product/
│   └── wishlist/
├── app.dart
├── main.dart
└── test.dart
```

## Getting Started

### Prerequisites

- Flutter SDK 3.12.0 or newer
- Android Studio / VS Code with Flutter plugins
- An emulator or physical device

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd medhat
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Useful Commands

```bash
flutter analyze
flutter test
flutter run
```

## Notes

This project is structured to separate business logic from UI and external data sources, making it easier to extend with additional features, APIs, or tests.
