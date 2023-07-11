# 📌 Pinsplash
A Pinterest-inspired iOS app for exploring stunning photos from Unsplash

## 🚀 Getting Started

To get started with Pinsplash, clone the repository and open the `Pinsplash.xcworkspace` file in Xcode. 

### 📝 Prerequisites

Before you can run the app, you'll need to provide your own Unsplash API key.

### 🛠️ Installation

1. Sign up for a developer account on [Unsplash](https://unsplash.com/developers) and create a new application to get an API key.

2. Create a `Keys.plist` file in the root of the Pinsplash project directory.

3. Add the following content to the `Keys.plist` file and insert your Unsplash API Key:

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>UnsplashAPIKey</key>
        <string>Your API Key Here</string>
    </dict>
    </plist>
    ```
    
4. In Xcode, add the `Keys.plist` file to the project. Make sure to check the "Copy items if needed" checkbox.

5. Build and run the app in Xcode.

## 🌟 Features

- Browse popular photos from Unsplash with the familiar Pinterest layout
- Search for photos by keyword
- Responsive design
- Async image loading
- Custom Image Caching
- Custom `WaterfallCollectionViewLayout` 
- Autos sizing cells
- Pagination
- Infinite scrolling
- Modular and Extensible Code
- Network Requests and REST APIs using a Protocol-Oriented Approach
- Image sharing

### 👀 Upcoming
- Save collections locally using Core Data

## 👥 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


