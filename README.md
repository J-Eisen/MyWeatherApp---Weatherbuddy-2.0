# MyWeatherApp---Weatherbuddy-2.0 ![weatherbuddyicon][weatherbuddyiconlink]
A second attempt at building [WeatherBuddy] in a better way. 
As an alternative to write the entire project at once, this version is being done piece by piece.

WeatherBuddy is a weather app that won't tell you the weather. 
Instead, it takes weather data and turns it into advice on what to wear with simple algoritms that you use every time you check a weather app!
Eventually, you will be able to choose to use your zipcode, GPS (both in the background and only during app use), and calendar.
The calendar option finds the gaps between events, figuring out where you'll be traveling. 
To keep your information safe, the location and time information will be completely decoupled from any events.
Any event and calendar information is deleted as soon as possible.

## Current Features
- Data Features
  - JSON parsing via weatherunderground
  - settings view to adjust the weatherbuddy algorithms to user specifications
  - Current weather information display
  - Data is interpreted into generic clothing options, displayed by your WeatherBuddy
- Graphical Features
  - One buddy (CircleBuddy) ![CircleBuddy][circlebuddylink] that will tell you what weather to expect
  - One background for CircleBuddy
  - Custom icons for selecting different buddies (not enabled) and settings
- Location Features
  - GPS and zipcode functionality
  - GPS preferred when both are enabled

## Next Feature
- *uninteresting* more unit tests to prep for wider testing
- mildly interesting bug fixes

## Future Features
- improving location capabilities
  - calendar capabilities
  - allowing users to choose between zipcode, GPS, and calendar
  - allowing users to choose which calendars they use for their location
- raw weather information
  - add ability to see *why* certain articles of clothing are suggested
- improve user interface
  - add animation to the Buddies
  - add multiple Buddies
  - allow users to choose between these Buddies
  
## Known Bugs
- Wrong weather information being used for current weather
- Background dimensions are off
- Reloading has been disabled

[weatherbuddyiconlink]: https://www.dropbox.com/s/2jx2iddtyx6th66/IconforWeb.png?raw=true
[WeatherBuddy]: https://github.com/J-Eisen/WeatherBuddy-iOS
[circlebuddylink]: https://www.dropbox.com/s/zroecov9wxwj0bc/CircleBuddyDefault_256px_1x.png?raw=true
