# OpenClockStandard
An open clock JSON "standard" for clock designs.  

Format is supported in the clock editing application [clockology for iOS & MacOS](https://clockologyapp.com/) to make the designs portable to other projects.  Other uses might be for [widgets](https://widgetyapp.com/), dashboards, etc. 

Hopefully it will be used on multiple software and [hardware](https://github.com/sqfmi/Watchy) [projects](https://github.com/wiz78/WeatherClock) and maybe someday [one of these](https://github.com/Open-Smartwatch/open-smartwatch.github.io).

## AI / LLMs / GPT

A basic prompt tested with GPT 4o to make a digital clock [prompts/gptDigitalClock.txt](prompts/gptDigitalClock.txt).  Some poeple have had success getting GPT to embed background images and layout labels in containers.  This is a WIP, and new prompts will be added soon.

To ensure the AI gets the correct shema with no errors, use this method:

1. "given the following json schema:". 
2. Attach or paste schema/schema.json](schema/schema.json)
3. "follow these rules to be a watch face designer:" 
4. Attach or paste [prompts/jsonClockDesigner.txt](prompts/jsonClockDesigner.txt)
5. Now add the prompt you want for the design.  
	*Example:* "make a simple digital clock with big green numbers and using a "fontFamily" of "Digital-7Mono"
	*More detailed Example:* "make a clockology style background image in the style of an 80s digital casio watch. Can you make me a preview of the backgroud image?"
	... tweak style and issues in image, then ...
	"looks good.  In the ocs json, embed the image as the first image layer ( base64), then add steps, time, and date labels in the top layers with a black fillColor Use the position of the labels to match the position of the appropriate spaces in the background image."

	It *should* read the schema from the rules in the jsonClockDesigner prompt [schema/schema.json](schema/schema.json), but attaching it first ensures it will strickly follow it with less errors.  The LLM may still make up new keys or values not in the schema, so sometimes you may have to fix mistakes after importing or edit by hand.  

To check if the json is valid, use [the json validator](https://www.jsonschemavalidator.net/) and paste the schema on the left and the ocs json on the right.

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

