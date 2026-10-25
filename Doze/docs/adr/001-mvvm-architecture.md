# ADR-001: MVVM Architecture Justification

* **Status:** Accepted
* **Date:** 2026-10-03
* **Author:** Gadiel Uicab

## 1. Context and Problem Statement
Define and justify an architecture for Doze, an offline-first iOS application designed to grow as a standard medium-to-large project.

* **Note:** This document formalizes the decision made during the initial development phase in September 2026.

## 2. Considered Options
* **Option A:** Model-View (MV)
* **Option B:** Model-View-ViewModel (MVVM)
* **Option C:** The Composable Architecture (TCA)

## 3. Decision Outcome
* **Decision:** Selected **Option B (MVVM)**

## 4. Rationale
MVVM is the best fit for Doze because it gives a good balance between speed, code organization, and testing. It uses native Apple tools (`@Observable` / Combine) with no third-party dependencies, keeping views clean as the app grows.

## 5. Consequences (Trade-offs)
* **Positive Consequences:**
  * Clear separation between UI and business logic.
  * High testability for ViewModels and services.
  * Medium learning curve and easy to implement.
  * Zero external dependencies (uses native Swift tools).
  * Good integration with SwiftData and local storage.
* **Negative Consequences (Accepted Risks):**
  * Risk of boilerplate and "Massive ViewModel" if not managed well.
  * Does not offer absolute testability compared to TCA.

## 6. Mitigation Strategies
* Keep ViewModels small by delegating database and operations to dedicated Service objects.
* Avoid using ViewModels for simple or static views where MV is enough.