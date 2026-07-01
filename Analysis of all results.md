# Results Analysis and Business Insights
## 1. Dataset Overview
After the data cleaning process, the ride booking dataset became suitable for business analysis and visualization. Invalid records, inconsistent values, and missing information were handled to improve data quality and ensure reliable analytical results. The cleaned dataset contains over 100,000 ride booking records, providing sufficient data for identifying operational patterns and customer behaviour.
The dataset includes important business attributes such as booking status, vehicle type, booking value, ride distance, payment method, customer and driver ratings, and cancellation reasons. These variables allow the dashboard to provide a comprehensive overview of ride booking operations and support data-driven decision making.
![Insert Figure 1](screenshots/summary.png)


## 2. Booking and Operational Analysis
The dashboard shows that the majority of bookings were completed successfully, while a considerable proportion were cancelled either by customers or drivers. Although successful bookings contribute most of the platform revenue, cancellations remain an important operational issue that directly affects customer satisfaction and business performance.
Different cancellation reasons were recorded for customers and drivers. Customer cancellations were mainly associated with changes in travel plans, incorrect pickup information, or service-related issues, while driver cancellations were often related to personal reasons, customer-related problems, or operational constraints. These findings indicate that reducing cancellation rates should remain one of the primary objectives for improving service quality.
Booking records also demonstrate that ride demand fluctuates throughout the day. Such information can assist the company in allocating drivers more efficiently during high-demand periods while reducing idle resources during quieter periods.
![Insert Figure 2](screenshots/booking.png)


## 3. Revenue and Customer Behaviour Analysis
The dashboard provides valuable insights into customer spending behaviour and service preferences. Different vehicle categories contribute differently to the overall business revenue. Premium vehicle services generally generate higher booking values, while economy vehicles contribute through a larger number of completed rides. Maintaining a balanced vehicle fleet therefore helps maximise both customer coverage and business profitability.
The payment method analysis indicates that customers increasingly prefer cashless transactions such as UPI, credit cards, and digital payments. Electronic payment methods improve transaction efficiency and reduce cash-handling risks, making them beneficial for both customers and service providers.
Customer and driver rating distributions also indicate that most completed rides receive relatively high ratings, suggesting that overall service quality is satisfactory. Nevertheless, a small number of lower-rated trips highlight opportunities for further improvement through driver training, customer support, and service monitoring.
![Insert Figure 3](screenshots/revenue.png)
![Insert Figure 4](screenshots/payment.png)
![Insert Figure 5](screenshots/rating.png)

## 4. Predictive Model Analysis
The Logistic Regression model was developed to predict the probability of booking cancellation based on operational variables contained in the dataset. Instead of only analysing historical records, the model provides a practical decision-support tool by identifying bookings that are more likely to be cancelled before the trip is completed.
Although the model does not eliminate cancellations, it enables platform operators to take preventive actions such as assigning alternative drivers, improving customer communication, or providing promotional incentives for high-risk bookings. This demonstrates how predictive analytics can support more proactive operational management rather than relying solely on historical reporting.
(Insert Figure 6: Logistic Regression Prediction Result)
![Insert Figure 6](screenshots/risk.png)


## 5. Overall Findings
Overall, the cleaned dataset provides meaningful business insights into ride booking operations. The dashboard successfully transforms raw booking records into understandable visual information, allowing managers to monitor booking performance, revenue generation, payment preferences, customer satisfaction, and cancellation behaviour.
The results indicate that while the platform performs well in terms of completed bookings and customer ratings, reducing booking cancellations remains an important opportunity for improvement. Furthermore, integrating predictive analytics with interactive dashboards enhances business decision-making by enabling management to identify operational risks earlier and respond more effectively.
The project demonstrates that combining data cleaning, Apache Hive, R Shiny, and predictive analytics creates a practical business intelligence solution capable of supporting both operational monitoring and strategic decision-making.
