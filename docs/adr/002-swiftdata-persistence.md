# ADR-002: SwiftData Persistence

* **Status:** Accepted
* **Date:** 2026-10-24
* **Author:** Gadiel Uicab

## 1. Context and Problem Statement
Define and justify the choice of a local database engine over other options available within the Apple ecosystem.

* **Note:** This document formalizes the decision made during the initial development phase in September 2026.

## 2. Considered Options
* **Option A:** Core Data
* **Option B:** SwiftData
* **Option C:** JSON Files in FileSystem

## 3. Decision Outcome
* **Decision:** Selected **Option B (SwiftData)**

## 4. Rationale
Applying the `@Model` macro to a Swift class lets the compiler automatically generate the internal data persistence infrastructure. This removes the need for external mapping files. It integrates natively with `@Query` in views and uses `#Predicate` for filtering and sorting, making it very efficient for small-to-medium data volumes.

## 5. Consequences (Trade-offs)
* **Positive Consequences:**
  * Accelerated development pace.
  * Zero external dependencies.
  * Automatic database updates (migrations) make it easy to add new properties later without breaking the app.
  * Strong type safety catches database errors while writing code, preventing unexpected crashes for the user.
* **Negative Consequences (Accepted Risks):**
  * Shows performance degradation in queries handling over 100k simple objects.
  * Minimum deployment target requires iOS 17.0+.
  * Cannot be imported or backported (using techniques like `@backDeployed`) to iOS 16 or lower.

## 6. Mitigation Strategies
* Keep data models lightweight and delegate persistence operations to dedicated service/repository objects.
* Monitor dataset growth to optimize queries or evaluate fetch limits if object counts approach high volumes.