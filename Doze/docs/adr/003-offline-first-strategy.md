# ADR-003: Offline-First Strategy

* **Status:** Accepted
* **Date:** 2026-10-25
* **Author:** Gadiel Uicab

## 1. Context and Problem Statement
Formalize the technical decision to keep the application offline, with no internet dependency or user account requirement.

* **Note:** This document formalizes the decision made during the initial development phase in September 2026.

## 2. Considered Options
* **Option A:** Local-Only
* **Option B:** Offline-First

## 3. Decision Outcome
* **Decision:** Selected **Option B (Offline-First)**

## 4. Rationale
Sensitive data collected in iOS stays inside the local app sandbox, protecting it from third-party attacks. It avoids complex cloud privacy regulations since data lives exclusively on the user's device. It also eliminates backend infrastructure, server costs, and maintenance effort.

## 5. Consequences (Trade-offs)
* **Positive Consequences:**
  * Accelerated development pace.
  * Zero external dependencies and backend costs.
  * Maximum privacy and local security for sensitive data.
* **Negative Consequences (Accepted Risks):**
  * Irreversible data loss if the device is damaged or the app is deleted.
  * No multi-device sync without adding a local or iCloud sync layer.

## 6. Mitigation Strategies
* **OS-Level Backups:** Rely on native encrypted iOS system backups.
* **Manual Export:** Implement options to manually export and import history in simple formats like JSON or CSV.