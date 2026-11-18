# Journali - Journaling App
Journali is a personal journaling app for iPhone, built with SwiftUI. Write, edit, bookmark, search, and sort your journal entries. Your thoughts, your story.

## Features

- Add a new journal entry with a title and body
- Edit an existing entry (the original date is kept)
- Delete an entry by swiping the card, with a confirmation alert
- Bookmark your favorite entries
- Sort by bookmark or by entry date
- Search entries by title or content
- Discard-changes confirmation when closing the editor with unsaved edits
- Dark mode design with the Liquid Glass effect
- Entries are saved on the device and stay after closing the app

## Screenshots

<p float="left">
<img width="220" height="450" alt="photo_6044200849262711357_y" src="https://github.com/user-attachments/assets/c039ac7c-fa50-47d2-bb19-773addb39992" />
<img width="220" height="450" alt="photo_6044200849262711358_y" src="https://github.com/user-attachments/assets/668d016d-122d-42ec-967f-1f14b0099290" />
<img width="220" height="450" alt="photo_6044200849262711359_y" src="https://github.com/user-attachments/assets/69270d9a-87bd-46e6-8448-19963e446b4c" />
<img width="220" height="450" alt="photo_6044200849262711360_y" src="https://github.com/user-attachments/assets/be49b077-e203-4bf9-9210-e5621830f564" />

</p>

## Technologies

- Swift
- SwiftUI
- SwiftData (local persistence)
- MVVM architecture
- SF Symbols
- Icon Composer (app icon)
- Xcode

## Architecture (MVVM)

```
journali
├── Models
│   └── JournalEntry.swift        # @Model class: title, date, body, isBookmarked
├── ViewModels
│   └── JournalViewModel.swift    # fetch, add, update, delete, toggleBookmark
├── Views
│   ├── MainPage.swift            # list, search, sort, empty state
│   ├── JournalCard.swift         # a single entry card
│   ├── SwipeableCard.swift       # swipe-to-delete wrapper
│   ├── JournalEditorView.swift   # add / edit screen
│   └── SplashView.swift          # launch screen
├── Assets
└── MyApp.swift                   # app entry point
```

## Requirements

- Xcode 26 or later
- iOS 26 or later (uses `.glassEffect` and `.buttonStyle(.glass)`)

## How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR-USERNAME/journali.git
   ```
2. Open `journali.xcodeproj` in Xcode.
3. Choose a simulator or a connected iPhone.
4. Press `Cmd + R`.

To run on a real device, select your Apple ID team under Signing & Capabilities and change the Bundle Identifier to a unique one.

## Author

<p align="center">
  <a href="https://github.com/batool182">
    <img src="https://github.com/batool182.png" width="100" style="border-radius:50%" alt="Batool Alkhudaydi" />
  </a>
  <br />
  <b>Batool Alkhudaydi</b>
  <br />
  <a href="https://github.com/batool182">@batool182</a>
</p>
