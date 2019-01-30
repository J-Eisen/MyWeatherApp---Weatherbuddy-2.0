# MyWeatherApp---Weatherbuddy-2.0
A second attempt at building [WeatherBuddy] in a better way. 
As an alternative to write the entire project at once, this version is being done piece by piece.

WeatherBuddy is a weather app that won't tell you the weather. 
Instead, it takes weather data and turns it into advice on what to wear with simple algoritms that you use every time you check a weather app!
Eventually, you will be able to choose to use your zipcode, GPS (both in the background and only during app use), and calendar.
The calendar option finds the gaps between events, figuring out where you'll be traveling. 
To keep your information safe, the location and time information will be completely decoupled from any events.
Any event and calendar information is deleted as soon as possible.

## Current Features
- loading and parsing JSON from wunderground api
- settings view to adjust the weatherbuddy algorithms to user specifications
- turning JSON data into useful information to users

## Next Feature
- add ability to see raw weather information
## Future Features
- improving location capabilities
  - GPS capabilities
  - allowing users to choose between zipcode and GPS
  - calendar capabilities
  - allowing users to choose between zipcode, GPS, and calendar
  - allowing users to choose which calendars they use for their location
- raw weather information
  - add ability to see current weather information
  - add ability to see *why* certain articles of clothing are suggested
- improve user interface
  - clean up settings screens
  - change the text-based clothing information to image based
  - add multiple "buddies"
  - allow users to choose between these "buddies"

[WeatherBuddy]: https://github.com/J-Eisen/WeatherBuddy-iOS
