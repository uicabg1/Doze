    # Doze

A native iOS application designed to calculate optimal sleep cycles (90 minutes) and record basic daily rest metrics completely offline.

## Minimum Viable Product (Version 1.0)

To ensure an agile development cycle of less than a month, the initial version is strictly limited to the following features:

**Core Features (Must Have):**
* **Wake-up Time Calculation:** "If I go to sleep right now, at what time should I wake up to complete n cycles?"
* **Bedtime Reverse Calculation:** "If I want to wake up at 7:00 AM, at what time should I go to sleep?"
* **Wake-up Notification Trigger:** Local iOS notifications scheduled at target wake-up times ("Did you wake up?") to launch the app and automatically log exact wake times.
* **Energy Level Metric:** 1-to-5 battery-style rating upon waking up to track rest quality and add optional notes.
* **Sleep Metrics & Historical Logs:** Summary screen showing 7-day average sleep duration, average energy ratings, weekly trend bar charts, and daily detailed logs.
* **Manual Adjustment:** Edit or log past sleep entries manually.
* **100% Offline & Private:** SwiftData local storage with no user account creation or external server requirements.

**Out of Scope:**
* Apple Health or external hardware (Apple Watch) integration.
* Native system alarm override/interruption (uses local alert notifications instead).
* External server sync or social features.
* Complex statistical charts (to be implemented in future versions).

## Tech Stack

* **Language:** Swift 6
* **User Interface:** SwiftUI (following Apple Human Interface Guidelines)
* **Data Persistence:** SwiftData (Local SQLite engine)
* **Frameworks:** `UserNotifications` (Local alerts)
* **Target Platform:** iOS 17+ / iPhone

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** pattern with clear separation of concerns between data entities, business logic, and UI components:

* **Model:**
  * `SleepRecord`: Primary `@Model` entity tracking `bedTime`, `wakeTime`, `energyLevel`, `note`, and `createdAt`.
* **Services / Logic Engine:**
  * `SleepCalculator`: Pure mathematical utility for adding/subtracting 90-minute cycle blocks and computing completed cycles.
  * `SleepMetrics`: Data aggregator for computing average sleep duration, average energy scores, and fetching daily logs.
  * `NotificationManager`: Service for requesting permissions and scheduling/canceling local wake-up reminder triggers.
* **ViewModel:** Handles UI state binding, coordinates service execution, and manages SwiftData context operations.
* **View:** Purely declarative SwiftUI screens with custom iOS dark theme palette (`#1E1E1E` background, `#E9B71A` accent).

## Development Roadmap

- [x] Week 1: Core architecture, data model design (`SleepRecord`), and mathematical cycle logic (`SleepCalculator`).
- [ ] Week 2: SwiftUI screen layout implementation (Wake-up, Bedtime, Energy, Manual Log, Metrics).
- [x] Week 3: Integration of SwiftData local storage and `NotificationManager` flow.
- [ ] Week 4: Physical device testing, QA, and visual HIG refinement.

## Project Structure

```text
Doze/
├── Doze/                     # App Source Code
│   ├── App/                  # Main App Entry Point (DozeApp.swift)
│   ├── Models/               # SwiftData Persistence Entities (@Model)
│   │   └── SleepRecord.swift
│   ├── ViewModels/           # MVVM State Manager (@Observable)
│   │   └── SleepViewModel.swift
│   ├── Services/             # Business Logic & Utility Engines
│   │   ├── SleepCalculator.swift
│   │   ├── SleepMetrics.swift
│   │   └── NotificationManager.swift
│   ├── Views/                # SwiftUI Declarative Interface
│   │   ├── WakeUpView.swift
│   │   ├── BedtimeView.swift
│   │   ├── EnergyView.swift
│   │   ├── ManualAdjustmentView.swift
│   │   ├── MetricsView.swift
│   │   └── Components/       # Reusable UI elements (Buttons, Cards)
│   └── Resources/            # Assets, Color Palette (#1E1E1E, #E9B71A)
│       └── Assets.xcassets
├── docs/                     # Planning & Architecture Assets
│   ├── Roadmap.md
│   └── UML/                  # Class diagrams & wireframes
└── README.md
