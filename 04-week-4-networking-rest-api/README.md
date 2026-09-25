# LAB 2 : PROVIDER AND ERROR HANDLING

## Test three error scenarios

1. Run the app with normal internet, observe loading, then the list of 100 posts.

<img src="screenshots/load.png" alt="flutter analyze" width="400">
<img src="screenshots/normal1.png" alt="flutter analyze" width="400">
<img src="screenshots/normal2.png" alt="flutter analyze" width="400">

2. Turn off the internet (airplane mode), press refresh, observe the friendly message + Retry button. Turn the internet back on, press Retry.

No Internet Connection

<img src="screenshots/noInternet.png" alt="flutter analyze" width="400">

After Connect to the internet and press Retry 
<img src="screenshots/normal1.png" alt="flutter analyze" width="400">

3. Temporarily change baseUrl to a wrong URL, observe the connection error message. Restore it after the test.

Change baseURL to wrong URL
<img src="screenshots/wrongURL.png" alt="flutter analyze" width="400">
<img src="screenshots/Timeout.png" alt="flutter analyze" width="400">

# Lab 3: Basic Pagination

Observe:

Page 1 appears with ten lists also include loading indicator

<img src="screenshots/Paged.png" alt="flutter analyze" width="400">

Data grows without a full reload

<img src="screenshots/grows.png" alt="flutter analyze" width="400">


# Reflection

1. Why is the UI forbidden from calling Dio directly? What breaks if this rule is violated?

- The UI is forbidden from calling Dio directly to keep the architecture clean (separation of concerns) and make interface components easy to test without depending on the API. If violated, code flow becomes messy, difficult to maintain, and unit testing UI components becomes extremely hard to execute.

2. When is client-side pagination enough, and when must you rely on server pagination (_page/_limit)?

- Client-side pagination is sufficient when the total data is small and can be safely loaded all at once initially. Conversely, server pagination (_page/_limit) is required when handling large or continuously growing datasets to save network bandwidth and device memory.

3. How do repository exceptions become AsyncError without try/catch in every widget? When is explicit try/catch still needed?

- Exceptions from the repository are automatically caught by Riverpod's AsyncNotifier and converted into AsyncError when called inside the build() method. Explicit try/catch blocks are still needed in user action methods (event handlers) like refresh buttons or form submissions to manage UI state manually.

4. Which part of the AI output did you fix, and why?

- The fixed portion was the scroll trigger logic, changing it from a fixed pixel threshold (maxScrollExtent - 200) to a position-percentage approach (NotificationListener). This was done because a fixed pixel threshold often fails to detect scrolling on high-resolution emulators when the item count is low.
