//
//  ClockStandard.swift
//  clockology
//
//  Created by Michael Hill on 2/6/21.
//  Copyright © 2021 Michael Hill. All rights reserved.
//

import Foundation

struct ClockStandard: Codable {
    var version = "1.0" //version of the models
    var title: String
    
    var layers: [ClockLayer]
}

struct ClockLayer: Codable {
    var type: ClockLayerTypes = .text

    var zIndex: Int = 0
    var customName: String = ""
    var imageFilename: String = ""
    var fillColor: String = ""

    var alpha: String = "1.0"
    var horizontalPosition: String = "0.0"
    var verticalPosition: String = "0.0"
    var scale: String = "1.0"
    var angleOffset: String = "0.0"
    var isHidden: Bool = false
        
    var textOptions: ClockLayerTextOptions?
    var iconOptions: ClockLayerIconOptions?
    var dataLabelOptions: ClockLayerDataLabelOptions?
    var weatherOptions: ClockLayerWeatherOptions?
}

struct ClockLayerWeatherOptions: Codable {
    var timeSpan: ClockLayerWeatherTimeSpans = .current
    var timeSpanOffset : Int = 0
    var iconsPrefersFill: Bool = true
}

struct ClockLayerIconOptions: Codable {
    var sfSymbolName: String = "heart"
    var thickness: Int = 3 // 1 - 5
}

struct ClockLayerTextOptions: Codable {
    
    var casingType: ClockLayerTextCasing = .none
    var fontFamily: String = "SFSystem"
    var fontFilename: String = ""
    var fontDescription: String = ""
    var dateTimeFormat: String = ""
    var dateTimeFormatDescription: String = ""
    var customText: String = ""
    var justification: ClockLayerTextJustification = .centered
    var effectType: String = "" //Note: convert to specific type ?
    var outlineWidth: String = "0.0"
    var outlineColor: String = ""
    var kerning: String = "0.0"
    
}

struct ClockLayerDataLabelOptions: Codable {
    var dataLabelFormat: String = ""
    var dataLabelFormatDescription: String = ""
    var unitDisplayLevel: ClockLayerUnitDisplayLevel = .medium
}

enum ClockLayerWeatherTimeSpans: String, Codable {
    case current, hourly, daily
}

enum ClockLayerUnitDisplayLevel: String, Codable {
    case short, medium, long
}


enum ClockLayerTextJustification: String, Codable {
    case left, centered, right
}

enum ClockLayerTextCasing: String, Codable {
    case none, lower, sentence, uppercased, word
}

enum ClockLayerTypes: String, Codable {
    case dateTime, text, icon, dataLabel
}

