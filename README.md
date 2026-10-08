# Ecommerce

Ecommerce is a Flutter e-commerce application built with a clean layered architecture using BLoC, GoRouter, dependency injection, and local persistence. The app lets users browse products, search and filter by category, add items to a wishlist or cart, and proceed through a checkout flow.
## Screen Shots
<img width="300" height="639" alt="7" src="https://github.com/user-attachments/assets/e3cd00ee-acb7-4c9e-89cc-935eb14e7abc" />
<img width="296" height="638" alt="6" src="https://github.com/user-attachments/assets/f83341cd-01a4-4cb3-a641-2381d9f84309" />
<img width="299" height="636" alt="5" src="https://github.com/user-attachments/assets/d116fcaf-6d8b-4e6f-a80a-eb3e0ef86c83" />
<img width="298" height="626" alt="4" src="https://github.com/user-attachments/assets/cdd1f4e8-03f3-4410-ad21-44653d7911a8" />
<img width="305" height="631" alt="3" src="https://github.com/user-attachments/assets/050abbc3-9be9-4b18-a78a-bdc9ff86d41f" />
<img width="299" height="627" alt="2" src="https://github.com/user-attachments/assets/9cfb7a4b-b4eb-4885-bb20-90ba63488ad0" />
<img width="299" height="640" alt="1" src="https://github.com/user-attachments/assets/250ec664-d285-4b12-83d3-79d732c79bc7" />

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
