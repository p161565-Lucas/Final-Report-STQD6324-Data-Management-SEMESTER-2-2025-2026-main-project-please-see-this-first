# Dashboard Results Analysis
## 1. Overall KPI Dashboard

![Insert Figure 1](screenshots/summary.png)

The KPI dashboard summarises the cleaned dataset of 103,024 bookings: 63,967 completed rides (62.1%) and 39,057 non-completed bookings (37.9%), generating total revenue of INR 35,080,467 at an average booking value of INR 548.42 and an average completed-ride distance of 22.85 km. Completed bookings make up the clear majority of transactions, but the nearly 38% non-completion rate is high enough that it deserves ongoing monitoring rather than being treated as background noise.

## 2. Booking Trend Analysis

![Insert Figure 2](screenshots/booking.png)

The booking trend covers a single continuous month, 1–31 July 2024, and is remarkably flat: daily volume ranges only from 3,072 to 3,432 bookings (mean 3,323, ~2% coefficient of variation), with no strong weekday/weekend pattern. This is unlike typical real-world ride-hailing demand, which usually shows pronounced peaks, so driver-scheduling decisions should not be based on an assumption of strong day-to-day demand swings in this dataset.

## 3. Revenue by Vehicle Type Analysis

![Insert Figure 3](screenshots/R_revenue_by_vehicle.png)

Revenue is spread almost evenly across all seven vehicle types (INR 4.88M–5.22M each, under a 7% spread), so no single category dominates total income. The one notable exception is Auto: it earns an average fare (INR 551) statistically identical to every other vehicle type despite covering less than half the distance (10.0 km vs. ~25 km for the rest) — a meaningfully higher fare per kilometre worth investigating before basing any pricing strategy on the assumption that fare scales with distance (the overall correlation between distance and booking value is only 0.002).

## 4. Pickup Location Analysis

![Insert Figure 4](screenshots/R_booings_by_pick_up_location.png)

The distribution of bookings across pickup locations is relatively balanced, with only slight variations in booking volume. Areas such as **Banashankari**, **Yeshwanthpur**, and **RT Nagar** record the highest number of pickups, while **Rajajinagar**, **Chamarajpet**, and **Jayanagar** have slightly lower totals. Overall, the chart indicates that ride demand is well distributed across different regions, suggesting broad service coverage without significant geographical concentration.

## 5. Customer Analysis

![Insert Figure 5](screenshots/R_cumtomer_by_booking_count.png)

The dataset contains 94,544 unique customer IDs across 103,024 bookings — an average of only 1.09 bookings per customer — and even the single most frequent customer (CID954071) made just 5 bookings, with the rest of the top 10 at 4 bookings each. In other words, there is no meaningful repeat-customer or "power user" segment in this data; nearly every booking comes from a different customer, so loyalty-program or repeat-usage strategies would need to be validated against real-world booking history rather than this dataset.

## 6. Payment Method Analysis

![Insert Figure 6](screenshots/payment.png)

Among completed rides, cash remains the leading payment method at 54.8%, followed by UPI at 40.5%; credit card (3.8%) and debit card (1.0%) are minor. Combined digital payment methods (UPI + cards) account for 45.2% of completed transactions, so the clearest opportunity for growing digital payments is converting cash users to UPI specifically, rather than promoting card payments.

## 7. Customer and Driver Rating Analysis

![Insert Figure 7](screenshots/rating.png)

Both driver ratings and customer ratings average 4.0 out of 5 (SD 0.58), with only about 2.5% of completed rides rated 3 or below. However, both fields take just three discrete values — 3, 4, and 5, with nothing lower — which is more consistent with a simulated rating field than with organically collected review data, so "high customer satisfaction" here should be read as a property of this dataset rather than a real-world service-quality claim.

## 8. Cancellation Reason Analysis

![Insert Figure 8](screenshots/cancellation.png)

Of all non-completed bookings, driver-initiated cancellations are the largest group (17.9% of all bookings), followed by "Driver Not Found" (9.8%) and customer-initiated cancellations (10.2%) — meaning driver- and supply-side issues (27.7% combined) are roughly three times more common than customer-side cancellations. The leading stated driver reasons are "Personal & Car related issue" and "Customer related issue," while the leading customer reason is "Driver is not moving towards pickup location," so improvement efforts should focus primarily on driver dispatch and availability rather than customer-facing cancellation prompts.

## 9. Logistic Regression Prediction Analysis

![Insert Figure 9](screenshots/Cancellation_risk_prediction1.png)

Re-evaluating this model surfaced a data-leakage issue: Ride_Distance is recorded as exactly 0 for every non-completed booking, so a model that includes it reports a misleadingly perfect 100% accuracy (AUC 1.00) by effectively reading the outcome off one of its own inputs rather than predicting it in advance. Once Ride_Distance is removed and the model is limited to information genuinely available before a trip (Booking_Value, Vehicle_Type), accuracy drops to 62.1% and AUC to 0.51 — no better than guessing the majority class — showing that, as currently specified, this model cannot actually flag at-risk bookings ahead of time; a real early-warning system would need new features such as historical cancellation rates by customer or pickup location.

## 10. Overall Business Insights

This dataset shows a platform with stable, low-variance daily demand, revenue spread evenly across vehicle types except for a distinctly higher fare-per-km on Auto rides, an almost entirely one-time customer base with no repeat-usage segment, and a 37.9% non-completion rate driven mainly by driver/supply-side issues rather than customers. Ratings are high but built on a discretised (3/4/5-only) scale, and the existing cancellation-risk model's apparent accuracy comes from a data leak rather than genuine predictive signal — once corrected, it offers no real lift over guessing. Together, these point to two priorities: (1) treat cancellation as primarily a dispatch/driver-availability problem, not a customer or vehicle-type problem, and (2) any future predictive-analytics work needs new, genuinely pre-trip features before it can deliver real operational value.
