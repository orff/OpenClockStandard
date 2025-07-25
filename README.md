# OpenClockStandard
An open clock JSON "standard" for clock designs.  

Format is supported in the clock editing application [clockology for iOS & MacOS](https://clockologyapp.com/) to make the designs portable to other projects.  Other uses might be for [widgets](https://widgetyapp.com/), dashboards, etc. 

Hopefully it will be used on multiple software and [hardware](https://github.com/sqfmi/Watchy) [projects](https://github.com/wiz78/WeatherClock) and maybe someday [one of these](https://github.com/Open-Smartwatch/open-smartwatch.github.io).

## JSON Schema

The schema used to define a clock face can be found in [schema/schema.json](schema/schema.json).

It follows JSON Schema Draft 2020-12 and is used to validate and generate compatible `.ocs` files for OpenClockStandard.

## Layout

0,0 is the center of the layout
positive Y ( vertical position ) is down

## Canvas

In the clockStandard node, there is a optoinal canvas node.  This decribes the width, height, and type of intended canvas, IE: watchface, widget, etc.  Setting the canvas width and height is important as layout is percentage-based, so setting an icon to a vertical position of 0.5 will be half way up from center ( 0.0 ) and all the way to the top, 1.0.

For clockology importing into a watch face, a canvas size of 242 height and 199 width is assumed.

## Layers

The layout is determined by a list of "layers" of items that make up the overall design.  

Current layer types supported are:
* Time: labels to show dates and times
* Icons: icons used to designate types of information on the face
* Hands: items that rotate automatically based on the time unit they are set to

## Examples

This layout is used for example JSON in the /examples folder.  It uses the supported layer types and has options added for each layer to store extra properties.

![Example Image](images/Examples.JPG)


## Implementations

* [Clockology](https://clockologyapp.com/) can import OCS files on iOS and sync them to watches
* [open-clock-web](https://github.com/mlc/open-clock-web/) can render clocks on the web

