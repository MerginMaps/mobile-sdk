# Windows 

To build SDK:

- install Visual Studio (Community) 2015 (14)
- install Microsoft SDK 8.1
- install Microsoft Universal CRT SDK (not required on win 10)
- install dependency walker if you need to debug linkage
- install python 36 to path C:\Python36-x64
- open visual studio IDE and compile any example project (you need to additionally download some packages)
- make sure you have file Microsoft Visual Studio 14.0\VC\vcvarsall.bat present on the installation!
- install OSGeo4W 64 bit to C:\projects\input-sdk\x86_64\repo\OSGeo4W64
- install bison and flex and cmake and 7zip (through `choco`)
- get geodiff, qgis, input-sdk repos to C:\projects\input-sdk\x86_64\repo\
- remove leftovers from the previous installations, notably build and stage directories and resulting sdk.zip file
- `cd input-sdk\win`
- run `distibute.cmd`
- upload to dropbox "Lutra Consulting/_Support/input/input-sdks/win-sdk" & share
- tag the repo
- update input to use new SDK version

## Hints

- to find library on disk: `where -F -R \ xyz.Lib`