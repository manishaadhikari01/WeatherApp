# TODO: Redesign Detail Page with Glassmorphism

## Steps to Complete

1. **Update DetailPage Constructor**: Modify the DetailPage class to accept additional parameters for current weather data (location, currentDay, currentDate, currentTime, temperature, humidity, windSpeed, cloud).

2. **Update Homepage Navigation**: In homepage.dart, update the navigation to DetailPage to pass the current weather data along with dailyForecastWeather.

3. **Add Required Imports**: In detail_page.dart, add imports for dart:ui (for ImageFilter) and intl (for DateFormat).

4. **Implement Background**: Set the Scaffold body to a Container with DecorationImage using 'assests/dailyweatherbg.jpeg', fitted to cover, and apply a BackdropFilter with Gaussian blur (sigmaX: 25, sigmaY: 25).

5. **Create Glassmorphic Card Widget**: Define a helper widget or method for glassmorphic cards with translucent background, border, blur, and shadow.

6. **Design Current Weather Card**: Create the top card displaying place name, day/date/time, rain/wind/humidity with icons, and temperature on the right.

7. **Design Forecast Cards**: Create five slimmer cards below for the next five days, showing day/date, temperature, and optional condition.

8. **Apply Styling**: Ensure consistent spacing, padding, fonts (light/medium weights), and center alignment.

9. **Test and Verify**: Run the app to ensure the design matches the requirements and data is displayed correctly.
