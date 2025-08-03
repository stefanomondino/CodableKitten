# CodableKitten GitHub Events Demo

A SwiftUI demo app showing how to use the [`CodableKitten`](https://github.com/yourusername/CodableKitten) SPM package to decode and render events from the [GitHub Events API](https://docs.github.com/en/rest/activity/events). This project demonstrates polymorphic decoding and dynamic UI rendering using modern Swift and SwiftUI.

---

## What is CodableKitten?

**CodableKitten** is a Swift Package Manager (SPM) library that enables advanced, type-safe polymorphic decoding in Swift. It shines when working with APIs, like GitHub’s, where a single endpoint can return heterogeneous objects that share common structure but have different payloads.

- **Polymorphic decoding:** Decode API responses into distinct Swift types based on type fields in the JSON.
- **Swift Concurrency ready:** Works seamlessly with async/await and modern Swift features.
- **Flexible:** Works with any decodable protocol-based payloads.

---

## Demo App Overview

This demo app is a SwiftUI application that:

- Lets you enter a GitHub username and repository.
- Fetches the events for that repository using the GitHub REST API.
- Leverages `CodableKitten` to decode various event types—like `PushEvent`, `ReleaseEvent`, and `WatchEvent`—into the appropriate Swift types.
- Renders each event using a custom SwiftUI view, thanks to a simple `Renderable` protocol.

---

## Features

- **Dynamic Event Rendering:** Each event type (push, release, watch) gets its own SwiftUI view (`PushView`, `ReleaseView`, `WatchView`), mapped via protocol extensions.
- **Polymorphic Decoding:** The `GithubService` uses `CodableKitten` to decode events into their correct types at runtime.
- **Compositional UI:** Clean, modern SwiftUI UI with custom text fields, error handling, and loading states.
- **Swift Concurrency:** All network operations are performed with async/await.

---

## Getting Started

### Requirements

- Xcode 15+ (Swift 5.9+)
- macOS 13+, iOS 16+, or newer

### Installation

1. **Clone this repository:**

    ```bash
    git clone https://github.com/yourusername/CodableKittenDemo.git
    cd CodableKittenDemo
    ```
2. **Open the project in Xcode:**


