WHERE IS THE ISS
================

Where is the ISS is an APP to detect the current location of the ISS (International Space Station).

## Supported iOS & SDK Versions

* Supported build target - iOS 8.0 (Xcode 6.1, Apple LLVM compiler 6.0)
* Earliest supported deployment target - iOS 8.0
* Earliest compatible deployment target - iOS 8.0

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


## Installation

- run `pod install` in the terminal.
- use .xcworkspace instead of .xcodeproj

## Information

- The ISS API used is available at [Open Notify](http://open-notify.org/Open-Notify-API/ISS-Location-Now/)
- The nearest location API used is available at [GeoNames](http://www.geonames.org/export/ws-overview.html)
- I used the 3rd party library KissXML to help parse the data from the Location API, making it easier to handle and parse the data instead of using Apple's NSXML. 

