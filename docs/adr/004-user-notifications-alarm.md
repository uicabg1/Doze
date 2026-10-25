# ADR-004: User Notifications Alarm

* **Status:** Accepted
* **Date:** 2026-10-25
* **Author:** Gadiel Uicab

## 1. Context and Problem Statement
Formalize the technical decision to delegate user wake-up alarms to the system notification framework instead of building a custom native infinite alarm mechanism.

* **Note:** This document formalizes the decision made during the initial development phase in September 2026.

## 2. Considered Options
* **Option A:** Critical Alerts
* **Option B:** UNUserNotificationCenter

## 3. Decision Outcome
* **Decision:** Selected **Option B (UNUserNotificationCenter)**

## 4. Rationale
Except for rare cases, iOS suspends background processes to save battery. Apps given background execution access get a maximum window of ~30 seconds before being suspended. Using system notifications avoids background task issues and complies with App Store Guidelines (Rule 2.5.4).

## 5. Consequences (Trade-offs)
* **Positive Consequences:**
  * Native functionality with no network requirements or special entitlements needed.
  * Delivery is handled directly by the iOS system daemon.
  * Guarantees timely delivery with 0% CPU and battery consumption from the app.
* **Negative Consequences (Accepted Risks):**
  * Cannot play continuous infinite sound loops like a traditional clock app.
  * Alarm delivery depends on user granting notification permissions.

## 6. Mitigation Strategies
* Request notification permissions clearly during user onboarding.
* Schedule recurring local notifications with maximum allowed alert sound duration.