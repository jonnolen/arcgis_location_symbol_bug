arcgis_location_symbol_bug
==========================

Demonstrates bug with AGSMapView locationDisplay symbols after map view has been reset.

### pre-requisites/instructions
* Need to have ArcGIS iOS SDK 10.2.4 installed in the default location: ${HOME}/Library/SDKs/ArcGIS
* clone this repo.
* open and run ags_test.xcworkspace (NOT ags_test.xcproj)

### background
We have a map view on one of our views that we are releasing the memory for by 
removing layers and calling reset when the view controller is covered by the next
view controller in the navigation stack.  This is simulated in this application by 
providing buttons to release map and init map and a button to cycle through the three
states we use 
* locationDisplay.datasource off and autopan mode off
* datasource on and autopan mode default
* datasource on and autopan mode compassNavigation  

### bug replication
The first time a map view is configured
with a base layer, when you turn on location (call startDataSource and set autoPanMode to 
AGSLocationDisplayAutoPanModeDefault), the blue location icon shows up correctly.  When you
turn on compass mode (change autoPanMode to AGSLocationDisplayAutoPanModeCompassNavigation), 
the map rotates based on bearing and the blue icon changes to one with a cone indicating
current orientation. Turn off location (set autoPanMode back to AGSLocationDisplayAutoPanModeOff
and call stopDataSource), the blue icon disappears.

If you then release the map and then initialize it again (using the buttons on the screen), then
turn on location (call startDataSource and set autoPanMode to 
AGSLocationDisplayAutoPanModeDefault), the blue icon correctly shows up. However, when you turn 
on compass mode again the blue icon does not change to the compassnavigation symbol, but the map 
DOES rotate.

Variations of this are if the location services are in compas navigation mode when you release
and initialize the map then you will always get the compass navigation symbol instead of the 
normal location symbol, despite the map behaving correctly otherwise.

### expected vs actual
#### expected
I expect that every time the location data source is on and autoPanMode is default to see the blue circle location symbol.
I expect that every time the location data source is on and autoPanMode is compassNavigation to see the compass navigation location sybmol.
I expect this even if the map view has been reset, or had layers removed or added.
#### actual
After resetting a mapview that has been loaded once before the location symbols are not being correctly displayed.