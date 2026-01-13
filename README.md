## 🎵 Flutter Media Player Functionality
```
A simple, clean, and fully Flutter-based media player that supports audio and video playback with playlist control.
Built using pure Flutter code with just_audio and video_player, no platform-specific UI required.
```
## ✨ Features
```
✅ Audio & Video playback
✅ Mixed playlist (audio + video)
✅ Play / Pause
✅ Next / Previous
✅ Fast forward & rewind (10 seconds)
✅ Seek bar for both audio and video
✅ Auto-play next media when current ends
✅ Clean & minimal UI
✅ In-app playback (no background audio)
✅ Safe slider handling (no assertion crashes)
✅ Ready for production & public library use
```
## 📸 Preview


https://github.com/user-attachments/assets/8f1a98a5-35eb-449e-8ce9-973f3726f331


## 📦 Installation
Add dependencies to your pubspec.yaml:
```
dependencies:
  flutter:
    sdk: flutter

  just_audio: ^0.9.36
  video_player: ^2.8.2
```
Run:
```
flutter pub get
```
## 🗂 Project Structure
```
lib/
 ├─ media_player.dart
 └─ src/
     ├─ media_item.dart
     ├─ media_player_controller.dart
     └─ media_player_widget.dart
```
## 🚀 Usage
1️⃣ Import the package
```
import 'package:your_package_name/media_player.dart';
```
2️⃣ Create a playlist
```
final playlist = [
  MediaItem(
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    type: MediaType.audio,
    title: 'Audio 1',
  ),
  MediaItem(
    url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    type: MediaType.video,
    title: 'Video 1',
  ),
];
```
3️⃣ Use MediaPlayerWidget
```
MediaPlayerWidget(
  playlist: playlist,
)
```
## 🔁 Auto Play Behavior
```
When audio finishes, the next item plays automatically

When video finishes, the next item plays automatically

Playlist ends gracefully without crashes
```
## 🎨 UI Behavior
```
Tap anywhere to show/hide controls

Controls auto-hide after a few seconds

Audio shows:

Music icon

Seek bar

Current time & duration

Video shows:

Video player

Scrubbable progress bar
```
## 🛠 Requirements
```
Flutter 3.x or later

Android / iOS

Internet connection for network media
```
## 📄 License
```
MIT License

Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```
