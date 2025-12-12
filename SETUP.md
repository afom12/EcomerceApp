# Setup Instructions

## Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

## Installation Steps

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
└── src/
    ├── config/
    │   └── routes.dart      # Route configuration
    ├── model/
    │   ├── product.dart     # Product model
    │   ├── category.dart    # Category model
    │   ├── cart_item.dart   # Cart item model
    │   └── data.dart        # Sample data
    ├── pages/
    │   ├── home_page.dart   # Home page with products
    │   ├── main_page.dart   # Main page with bottom nav
    │   ├── product_detail_page.dart  # Product details
    │   └── cart_page.dart   # Shopping cart
    ├── providers/
    │   └── cart_provider.dart  # Cart state management
    ├── theme/
    │   ├── app_colors.dart  # Color palette
    │   └── app_theme.dart   # Theme configuration
    └── widgets/
        ├── product_card.dart  # Product card widget
        ├── category_chip.dart  # Category selector
        └── custom_bottom_navigation_bar.dart  # Bottom nav bar
```

## Features

✅ Beautiful UI with women-friendly color scheme
✅ Product browsing with categories
✅ Product detail page with image carousel
✅ Shopping cart functionality
✅ Responsive design
✅ Smooth animations
✅ Modern Material Design 3

## Color Palette

- **Primary**: Soft Rose Pink (#FFB6C1)
- **Secondary**: Elegant Coral (#FF7F7F)
- **Accent**: Warm Peach (#FFDAB9)
- **Background**: Off White (#FFFBFB)

## Notes

- The app uses sample data from `lib/src/model/data.dart`
- Images are loaded from Unsplash URLs (you can replace with your own)
- Cart state is managed using Provider pattern
- All UI components follow Material Design 3 guidelines

