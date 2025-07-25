//
//  ClockStandard.swift
//  clockology
//
//  Created by Michael Hill on 2/6/21.
//  Copyright © 2021 Michael Hill. All rights reserved.
//

import Foundation

public struct ClockWrapper: Codable {
    public var clockStandard: ClockStandard
    public var assets: [ClockAsset]
    
    public init(clockStandard: ClockStandard, assets : [ClockAsset]) {
        self.clockStandard = clockStandard
        self.assets = assets
    }
}

public struct ClockAsset: Codable {
    
    public var imageData: String = ""
    public var filename: String = ""
    public var hasTransparency: Bool? = true //use PNG or JPG decoding
}

public struct ClockStandard: Codable {
    
    public var title: String = "Untitled"
    public var layers: [ClockLayer]
    
}

public enum ClockLayerTypes: String, Codable {
    case dateTime, text, icon, dataLabel, image, hand, dataBar, dataRing, batteryIndicator
}

public struct ClockLayer: Codable {

    public var type: ClockLayerTypes = .text

    public var zIndex: Int = 0 //0 is bottom higher is top. layering
    public var customName: String? = "" //each layer can have user generated names or empty
    public var filename: String? = "" // filenames for images used in the layer
    public var fillColor: String? = "" // fill color ( re used for public various types )
 
    public var alpha: Float? = 1.0 //transparency
    public var horizontalPosition: Float? = 0.0 //0 is center : negative left
    public var verticalPosition: Float? = 0.0 //0 is center : negative up
    public var scale: Float? = 1.0 // 1.0 is normal
    public var angleOffset: Float? = 0.0 // rotation of the overall layer
    public var isHidden: Bool? = false //hide this layer
    
    //importnt for setting the source for dynamic data
    public var dataSource: ClockLayerDataSources?
        
    //optional objects to hold properties for the layers
    public var textOptions: ClockLayerTextOptions?
    public var iconOptions: ClockLayerIconOptions?
    public var dataLabelOptions: ClockLayerDataLabelOptions?
    public var weatherOptions: ClockLayerWeatherOptions?
    public var handOptions: ClockLayerHandOptions?
    public var dataBarOptions: ClockLayerDataBarOptions?
    public var dataRingOptions: ClockLayerDataRingOptions?
}

public enum ClockLayerDataSources: String, Codable {
    case steps, stepcount, stepslong, stepsshort, stepssymbol, heartrate, energyburned, energyburnedgoal, exercisetime,
         exercisetimegoal, standtime, standtimegoal, distancewalkrun, distancewalkrununit, flightsclimbed,
         temperature, temperturemin, temperturemax, sunrise, sunset, feelslike, chanceofprecip, rainamount,
         weatherdescription, weatherdescriptioncaps, weathericon, battery, batterynum, batterylevel, unknown
    
    //allow to decode ignoring case
        public init(from decoder: Decoder) throws {
            // 1
            let container = try decoder.singleValueContainer()
            // 2
            let rawString = try container.decode(String.self)
            
            // 3
            if let dataSource = ClockLayerDataSources(rawValue: rawString.lowercased()) {
                self = dataSource
            } else {
                // 4
                self = .unknown
                //throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize UserType from invalid String value \(rawString)")
            }
        }
}

public struct ClockLayerDataRingOptions: Codable {
    
    public var format: ClockLayerDataRingFormats = .exerciseTime
    public var width: Float = 0.5 //radius of the circle
    public var colors: [String] = [] //array[ count 3] of hex colors for background, start, then end
}

public struct ClockLayerDataBarOptions: Codable {
    
    public var format: ClockLayerDataRingFormats = .energyBurned
    public var autoColor: Bool? = true //automatically set the color of the ring based on format: default false, can ignore for the most part
    public var cornerRadius: Float? = 0.0 //for rounding off the bars
    public var width: Float? = 0.2 // not necessarily same scale as the main canvas, but close
    public var height: Float? = 0.5 // not necessarily same scale as the main canvas, but close
    public var colors: [String]? = [] //array[ count 3] of hex colors for background, start, then end
}

public struct ClockLayerHandOptions: Codable {
    
    /*
        animationtypes: SecondHandMovementStep, SecondHandMovementStepOver, SecondHandMovementSmooth, SecondHandMovementOscillate,SecondHandMovementMechanical,SecondHandMovementStop2Go
 
         Step: one frame per second, rotating like a minute hand does
         Step Over: high fps - goes past the angle about 20 degrees then animates back to the correct angle
         Smooth: high fps - uses millesecond to calculate correct angle
         Oscillate: high fps - moves similar to smooth, but looks more like sin wave movement
         Mechanical: very high fps - uses milleseconds, but jumps to posision and skeps frames to look like a stopwatch style movement
         Stop2Go: very high fps - a combination of mechanical and oscillate
 */
    
    public var handType: ClockLayerHandTypes = .hour
    public var handStyle: String? = "plain"
    /* handStyle      
        "rounded",
        "classicOutline", 
        "classic",
        "swiss",
        "swissCircle", 
        "flatDial", 
        "thinDial", 
        "blocky", 
        "arrow", 
        "roman", 
        "pie", 
        "pieInverted" 
    */
    public var handStyleDescription: String? = "" // localized text description of the hand style
    public var animationType: String? = "" // will be specific to platforms, might want to ignore
    public var useImage: Bool? = false // use images instead of vectors
    public var animateClockwise: Bool? = true //used usually in combination with images that have numbers to animate in reverse to show numbers increasing for time
    public var imageAnchorX: Float? = 0.0 //when using images the anchor position ( bottom / centered of the image ) default: 0.5
    public var imageAnchorY: Float? = 0.0 //when using images the anchor position ( bottom / centered of the image ) default: 0.5
}

public struct ClockLayerWeatherOptions: Codable {
    
    /* format and other options for weather labels stored in dataLabelOptions */
    /* weather icon options stored in iconOption */
    public var timeSpan: ClockLayerWeatherTimeSpans = .current // time space for weather options
    public var timeSpanOffset : Int = 0 //offset ( in hours or days ) for the future timeSpans
    public var iconsPrefersFill: Bool = true // prefers the weather icons are filled or outline
}

public struct ClockLayerIconOptions: Codable {
    
    // https://developer.apple.com/sf-symbols/
    // TODO: map these to some good free or paid icon packs: https://www.flaticon.com/packs
    // SFNames added to enum SFIconNames
    // is name has "Custom" text in it, it is shipped as a "custom" SVG in clockologycase currently these are: runnerCustom, stepsCustom , stairsCustom
    public var sfSymbolName: String = "heart"
    public var thickness: Int = 3 // 1 - 5. 3 is default
}

public struct ClockLayerTextOptions: Codable {
    
    public var casingType: ClockLayerTextCasing? = .none
    public var fontFamily: String? = "SFSystem" // https://developer.apple.com/fonts/
    public var fontFilename: String? = ""
    public var fontDescription: String? = ""
    public var dateTimeFormat: String? = ""
    /* enum options
         HHMMSS,
         HHMM,
         HHMMPM,
         HH,
         MM,
         SS,
         PM,
         DADD,
         DDMM,
         MMDD,
         MO,
         ML,
         MN,
         DA,
         DD,
         DDAuto,
         DL,
         DY,
         DW,
         WY,
         YY,
         YYYY,
         Colon,
         Slash,
         City,
         Country,
         HourWord,
         MinuteWord,
         SecondsWord,
         HourWordUnit,
         MinuteWordUnit,
         SecondsWordUnit
     
         */
    public var dateTimeFormatDescription: String? = ""
    /*
     case .Battery: description = "Battery %"
     case .BatteryNum: "Battery"
     case .DA: "Tue - Day Short"
     case .DL: "Tuesday - Day Full"
     case .DADD: "Tue 5 - Day Short & Num"
     case .DD: "05 - Day Num"
     case .DDAuto: "5 - Day Num"
     case .DDMM: "5 Nov - Day Num & Month"
     case .MMDD: "Nov 5 - Month & Day Num"
     case .MO: "Nov - Short Month"
     case .ML: "November - Full Month"
     case .MN: "11 - Month Num"
     case .HHMM: "10:30 - Hour:Min"
     case .HHMMPM: "10:30 pm - Hour:Min pm"
     case .HHMMSS: "10:30:55 - Hour:Min:Sec"
     case .HH: "10 - Hour"
     case .MM: "30 - Min"
     case .SS: "55 -sec"
     case .PM: "AM - am/pm"
     case .DY: "3 - Day of Year"
     case .DW: "1 - Day of Week"
     case .WY: "32 - Week of the Year"
     case .YY: "20 - year"
     case .YYYY: "2020 - year"
     case .City: "Chicago - time zone city"
     case .HourWord: "Twelve - hour as word"
     case .MinuteWord: "Thirty - minute as word"
     case .SecondsWord: "Fifty Nine - second as word"
     case .HourWordUnit: "Twelve Hours - hour as word + unit"
     case .MinuteWordUnit: "Thirty Minutes - minute as word + unit"
     case .SecondsWordUnit: "Fifty-Nine Seconds - second as word + unit"
     case .Colon: ": - colon"
     case .Slash: "/ - slash"
     */
    public var customText: String? = "" // designer entered text to show in label
    public var justification: ClockLayerTextJustification? = .centered
    public var effectType: String? = "" // will be specific to platforms, might want to ignore
    public var outlineWidth: Float? = 0.0 // pixels to show as outline on the text
    public var outlineColor: String? = "" // color for outline
    public var kerning: Float? = 0.0 // added as adv option, probably ignore
}

public struct ClockLayerDataLabelOptions: Codable {

    public var dataLabelFormatDescription: String? = ""
    public var unitDisplayLevel: ClockLayerUnitDisplayLevel? = .medium //preference for how much of the units to show along-side the data, IE: 32 degrees celcius v 32
}

public enum ClockLayerDataBarStyles: String, Codable {
    case rounded, flat, pill
}

public enum ClockLayerDataRingFormats: String, Codable {
    case energyBurned ,exerciseTime, standTime, batteryLevel
}

public enum ClockLayerHandTypes: String, Codable {
    case second, minute, hour
}

public enum ClockLayerWeatherTimeSpans: String, Codable {
    case current, hourly, daily
}

public enum ClockLayerUnitDisplayLevel: String, Codable {
    case short, medium, long
}


public enum ClockLayerTextJustification: String, Codable {
    case left, centered, right
}

public enum ClockLayerTextCasing: String, Codable {
    case none, lower, sentence, uppercased, word
}

public enum SFIconNames: String, CaseIterable, Codable {
    case _0_circle
    case _00_circle
    case _0_circle_fill
    case _00_circle_fill
    case _0_square
    case _00_square
    case _0_square_fill
    case _00_square_fill
    case _1_circle
    case _01_circle
    case _1_circle_fill
    case _01_circle_fill
    case _1_magnifyingglass
    case _1_square
    case _01_square
    case _1_square_fill
    case _01_square_fill
    case _2_circle
    case _02_circle
    case _2_circle_fill
    case _02_circle_fill
    case _2_square
    case _02_square
    case _2_square_fill
    case _02_square_fill
    case _3_circle
    case _03_circle
    case _3_circle_fill
    case _03_circle_fill
    case _3_square
    case _03_square
    case _3_square_fill
    case _03_square_fill
    case _4_alt_circle
    case _4_alt_circle_fill
    case _4_alt_square
    case _4_alt_square_fill
    case _4_circle
    case _04_circle
    case _4_circle_fill
    case _04_circle_fill
    case _4_square
    case _04_square
    case _4_square_fill
    case _04_square_fill
    case _5_circle
    case _05_circle
    case _5_circle_fill
    case _05_circle_fill
    case _5_square
    case _05_square
    case _5_square_fill
    case _05_square_fill
    case _6_alt_circle
    case _6_alt_circle_fill
    case _6_alt_square
    case _6_alt_square_fill
    case _6_circle
    case _06_circle
    case _6_circle_fill
    case _06_circle_fill
    case _6_square
    case _06_square
    case _6_square_fill
    case _06_square_fill
    case _7_circle
    case _07_circle
    case _7_circle_fill
    case _07_circle_fill
    case _7_square
    case _07_square
    case _7_square_fill
    case _07_square_fill
    case _8_circle
    case _08_circle
    case _8_circle_fill
    case _08_circle_fill
    case _8_square
    case _08_square
    case _8_square_fill
    case _08_square_fill
    case _9_alt_circle
    case _9_alt_circle_fill
    case _9_alt_square
    case _9_alt_square_fill
    case _9_circle
    case _09_circle
    case _9_circle_fill
    case _09_circle_fill
    case _9_square
    case _09_square
    case _9_square_fill
    case _09_square_fill
    case _10_circle
    case _10_circle_fill
    case _10_square
    case _10_square_fill
    case _11_circle
    case _11_circle_fill
    case _11_square
    case _11_square_fill
    case _12_circle
    case _12_circle_fill
    case _12_square
    case _12_square_fill
    case _13_circle
    case _13_circle_fill
    case _13_square
    case _13_square_fill
    case _14_circle
    case _14_circle_fill
    case _14_square
    case _14_square_fill
    case _15_circle
    case _15_circle_fill
    case _15_square
    case _15_square_fill
    case _16_circle
    case _16_circle_fill
    case _16_square
    case _16_square_fill
    case _17_circle
    case _17_circle_fill
    case _17_square
    case _17_square_fill
    case _18_circle
    case _18_circle_fill
    case _18_square
    case _18_square_fill
    case _19_circle
    case _19_circle_fill
    case _19_square
    case _19_square_fill
    case _20_circle
    case _20_circle_fill
    case _20_square
    case _20_square_fill
    case _21_circle
    case _21_circle_fill
    case _21_square
    case _21_square_fill
    case _22_circle
    case _22_circle_fill
    case _22_square
    case _22_square_fill
    case _23_circle
    case _23_circle_fill
    case _23_square
    case _23_square_fill
    case _24_circle
    case _24_circle_fill
    case _24_square
    case _24_square_fill
    case _25_circle
    case _25_circle_fill
    case _25_square
    case _25_square_fill
    case _26_circle
    case _26_circle_fill
    case _26_square
    case _26_square_fill
    case _27_circle
    case _27_circle_fill
    case _27_square
    case _27_square_fill
    case _28_circle
    case _28_circle_fill
    case _28_square
    case _28_square_fill
    case _29_circle
    case _29_circle_fill
    case _29_square
    case _29_square_fill
    case _30_circle
    case _30_circle_fill
    case _30_square
    case _30_square_fill
    case _31_circle
    case _31_circle_fill
    case _31_square
    case _31_square_fill
    case _32_circle
    case _32_circle_fill
    case _32_square
    case _32_square_fill
    case _33_circle
    case _33_circle_fill
    case _33_square
    case _33_square_fill
    case _34_circle
    case _34_circle_fill
    case _34_square
    case _34_square_fill
    case _35_circle
    case _35_circle_fill
    case _35_square
    case _35_square_fill
    case _36_circle
    case _36_circle_fill
    case _36_square
    case _36_square_fill
    case _37_circle
    case _37_circle_fill
    case _37_square
    case _37_square_fill
    case _38_circle
    case _38_circle_fill
    case _38_square
    case _38_square_fill
    case _39_circle
    case _39_circle_fill
    case _39_square
    case _39_square_fill
    case _40_circle
    case _40_circle_fill
    case _40_square
    case _40_square_fill
    case _41_circle
    case _41_circle_fill
    case _41_square
    case _41_square_fill
    case _42_circle
    case _42_circle_fill
    case _42_square
    case _42_square_fill
    case _43_circle
    case _43_circle_fill
    case _43_square
    case _43_square_fill
    case _44_circle
    case _44_circle_fill
    case _44_square
    case _44_square_fill
    case _45_circle
    case _45_circle_fill
    case _45_square
    case _45_square_fill
    case _46_circle
    case _46_circle_fill
    case _46_square
    case _46_square_fill
    case _47_circle
    case _47_circle_fill
    case _47_square
    case _47_square_fill
    case _48_circle
    case _48_circle_fill
    case _48_square
    case _48_square_fill
    case _49_circle
    case _49_circle_fill
    case _49_square
    case _49_square_fill
    case _50_circle
    case _50_circle_fill
    case _50_square
    case _50_square_fill
    case a
    case a_circle
    case a_circle_fill
    case a_square
    case a_square_fill
    case airplane
    case airplayaudio
    case airplayvideo
    case alarm
    case alarm_fill
    case alt
    case ant
    case ant_circle
    case ant_circle_fill
    case ant_fill
    case antenna_radiowaves_left_and_right
    case app
    case app_badge
    case app_badge_fill
    case app_fill
    case app_gift
    case app_gift_fill
    case archivebox
    case archivebox_fill
    case arkit
    case arrow_2_circlepath
    case arrow_2_circlepath_circle
    case arrow_2_circlepath_circle_fill
    case arrow_2_squarepath
    case arrow_3_trianglepath
    case arrow_branch
    case arrow_clockwise
    case arrow_clockwise_circle
    case arrow_clockwise_circle_fill
    case arrow_clockwise_icloud
    case arrow_clockwise_icloud_fill
    case arrow_counterclockwise
    case arrow_counterclockwise_circle
    case arrow_counterclockwise_circle_fill
    case arrow_counterclockwise_icloud
    case arrow_counterclockwise_icloud_fill
    case arrow_down
    case arrow_down_circle
    case arrow_down_circle_fill
    case arrow_down_doc
    case arrow_down_doc_fill
    case arrow_down_left
    case arrow_down_left_circle
    case arrow_down_left_circle_fill
    case arrow_down_left_square
    case arrow_down_left_square_fill
    case arrow_down_left_video
    case arrow_down_left_video_fill
    case arrow_down_right
    case arrow_down_right_and_arrow_up_left
    case arrow_down_right_circle
    case arrow_down_right_circle_fill
    case arrow_down_right_square
    case arrow_down_right_square_fill
    case arrow_down_square
    case arrow_down_square_fill
    case arrow_down_to_line
    case arrow_down_to_line_alt
    case arrow_left
    case arrow_left_and_right
    case arrow_left_and_right_circle
    case arrow_left_and_right_circle_fill
    case arrow_left_and_right_square
    case arrow_left_and_right_square_fill
    case arrow_left_circle
    case arrow_left_circle_fill
    case arrow_left_square
    case arrow_left_square_fill
    case arrow_left_to_line
    case arrow_left_to_line_alt
    case arrow_merge
    case arrow_right
    case arrow_right_arrow_left
    case arrow_right_arrow_left_circle
    case arrow_right_arrow_left_circle_fill
    case arrow_right_arrow_left_square
    case arrow_right_arrow_left_square_fill
    case arrow_right_circle
    case arrow_right_circle_fill
    case arrow_right_square
    case arrow_right_square_fill
    case arrow_right_to_line
    case arrow_right_to_line_alt
    case arrow_swap
    case arrow_turn_down_left
    case arrow_turn_down_right
    case arrow_turn_left_down
    case arrow_turn_left_up
    case arrow_turn_right_down
    case arrow_turn_right_up
    case arrow_turn_up_left
    case arrow_turn_up_right
    case arrow_up
    case arrow_up_and_down
    case arrow_up_and_down_circle
    case arrow_up_and_down_circle_fill
    case arrow_up_and_down_square
    case arrow_up_and_down_square_fill
    case arrow_up_arrow_down
    case arrow_up_arrow_down_circle
    case arrow_up_arrow_down_circle_fill
    case arrow_up_arrow_down_square
    case arrow_up_arrow_down_square_fill
    case arrow_up_bin
    case arrow_up_bin_fill
    case arrow_up_circle
    case arrow_up_circle_fill
    case arrow_up_doc
    case arrow_up_doc_fill
    case arrow_up_left
    case arrow_up_left_and_arrow_down_right
    case arrow_up_left_circle
    case arrow_up_left_circle_fill
    case arrow_up_left_square
    case arrow_up_left_square_fill
    case arrow_up_right
    case arrow_up_right_circle
    case arrow_up_right_circle_fill
    case arrow_up_right_diamond
    case arrow_up_right_diamond_fill
    case arrow_up_right_square
    case arrow_up_right_square_fill
    case arrow_up_right_video
    case arrow_up_right_video_fill
    case arrow_up_square
    case arrow_up_square_fill
    case arrow_up_to_line
    case arrow_up_to_line_alt
    case arrow_uturn_down
    case arrow_uturn_down_circle
    case arrow_uturn_down_circle_fill
    case arrow_uturn_down_square
    case arrow_uturn_down_square_fill
    case arrow_uturn_left
    case arrow_uturn_left_circle
    case arrow_uturn_left_circle_badge_ellipsis
    case arrow_uturn_left_circle_fill
    case arrow_uturn_left_square
    case arrow_uturn_left_square_fill
    case arrow_uturn_right
    case arrow_uturn_right_circle
    case arrow_uturn_right_circle_fill
    case arrow_uturn_right_square
    case arrow_uturn_right_square_fill
    case arrow_uturn_up
    case arrow_uturn_up_circle
    case arrow_uturn_up_circle_fill
    case arrow_uturn_up_square
    case arrow_uturn_up_square_fill
    case arrowshape_turn_up_left
    case arrowshape_turn_up_left_2
    case arrowshape_turn_up_left_2_fill
    case arrowshape_turn_up_left_circle
    case arrowshape_turn_up_left_circle_fill
    case arrowshape_turn_up_left_fill
    case arrowshape_turn_up_right
    case arrowshape_turn_up_right_circle
    case arrowshape_turn_up_right_circle_fill
    case arrowshape_turn_up_right_fill
    case arrowtriangle_down
    case arrowtriangle_down_circle
    case arrowtriangle_down_circle_fill
    case arrowtriangle_down_fill
    case arrowtriangle_down_square
    case arrowtriangle_down_square_fill
    case arrowtriangle_left
    case arrowtriangle_left_circle
    case arrowtriangle_left_circle_fill
    case arrowtriangle_left_fill
    case arrowtriangle_left_square
    case arrowtriangle_left_square_fill
    case arrowtriangle_right
    case arrowtriangle_right_circle
    case arrowtriangle_right_circle_fill
    case arrowtriangle_right_fill
    case arrowtriangle_right_square
    case arrowtriangle_right_square_fill
    case arrowtriangle_up
    case arrowtriangle_up_circle
    case arrowtriangle_up_circle_fill
    case arrowtriangle_up_fill
    case arrowtriangle_up_square
    case arrowtriangle_up_square_fill
    case aspectratio
    case aspectratio_fill
    case asterisk_circle
    case asterisk_circle_fill
    case at
    case at_badge_minus
    case at_badge_plus
    case australsign_circle
    case australsign_circle_fill
    case australsign_square
    case australsign_square_fill
    case b_circle
    case b_circle_fill
    case b_square
    case b_square_fill
    case backward
    case backward_end
    case backward_end_alt
    case backward_end_alt_fill
    case backward_end_fill
    case backward_fill
    case badge_plus_radiowaves_right
    case bag
    case bag_badge_minus
    case bag_badge_plus
    case bag_fill
    case bag_fill_badge_minus
    case bag_fill_badge_plus
    case bahtsign_circle
    case bahtsign_circle_fill
    case bahtsign_square
    case bahtsign_square_fill
    case bandage
    case bandage_fill
    case barcode
    case barcode_viewfinder
    case battery_0
    case battery_25
    case battery_100
    case bed_double
    case bed_double_fill
    case bell
    case bell_circle
    case bell_circle_fill
    case bell_fill
    case bell_slash
    case bell_slash_fill
    case bin_xmark
    case bin_xmark_fill
    case bitcoinsign_circle
    case bitcoinsign_circle_fill
    case bitcoinsign_square
    case bitcoinsign_square_fill
    case bold
    case bold_italic_underline
    case bold_underline
    case bolt
    case bolt_badge_a
    case bolt_badge_a_fill
    case bolt_circle
    case bolt_circle_fill
    case bolt_fill
    case bolt_horizontal
    case bolt_horizontal_circle
    case bolt_horizontal_circle_fill
    case bolt_horizontal_fill
    case bolt_horizontal_icloud
    case bolt_horizontal_icloud_fill
    case bolt_slash
    case bolt_slash_fill
    case book
    case book_circle
    case book_circle_fill
    case book_fill
    case bookmark
    case bookmark_fill
    case briefcase
    case briefcase_fill
    case bubble_left
    case bubble_left_and_bubble_right
    case bubble_left_and_bubble_right_fill
    case bubble_left_fill
    case bubble_middle_bottom
    case bubble_middle_bottom_fill
    case bubble_middle_top
    case bubble_middle_top_fill
    case bubble_right
    case bubble_right_fill
    case burn
    case burst
    case burst_fill
    case c_circle
    case c_circle_fill
    case c_square
    case c_square_fill
    case calendar
    case calendar_badge_minus
    case calendar_badge_plus
    case calendar_circle
    case calendar_circle_fill
    case camera
    case camera_circle
    case camera_circle_fill
    case camera_fill
    case camera_on_rectangle
    case camera_on_rectangle_fill
    case camera_rotate
    case camera_rotate_fill
    case camera_viewfinder
    case capslock
    case capslock_fill
    case capsule
    case capsule_fill
    case captions_bubble
    case captions_bubble_fill
    case car
    case car_fill
    case cart
    case cart_badge_minus
    case cart_badge_plus
    case cart_fill
    case cart_fill_badge_minus
    case cart_fill_badge_plus
    case cedisign_circle
    case cedisign_circle_fill
    case cedisign_square
    case cedisign_square_fill
    case centsign_circle
    case centsign_circle_fill
    case centsign_square
    case centsign_square_fill
    case chart_bar
    case chart_bar_fill
    case chart_pie
    case chart_pie_fill
    case checkmark
    case checkmark_circle
    case checkmark_circle_fill
    case checkmark_rectangle
    case checkmark_rectangle_fill
    case checkmark_seal
    case checkmark_seal_fill
    case checkmark_shield
    case checkmark_shield_fill
    case checkmark_square
    case checkmark_square_fill
    case chevron_compact_down
    case chevron_compact_left
    case chevron_compact_right
    case chevron_compact_up
    case chevron_down
    case chevron_down_circle
    case chevron_down_circle_fill
    case chevron_down_square
    case chevron_down_square_fill
    case chevron_left
    case chevron_left_2
    case chevron_left_circle
    case chevron_left_circle_fill
    case chevron_left_slash_chevron_right
    case chevron_left_square
    case chevron_left_square_fill
    case chevron_right
    case chevron_right_2
    case chevron_right_circle
    case chevron_right_circle_fill
    case chevron_right_square
    case chevron_right_square_fill
    case chevron_up
    case chevron_up_chevron_down
    case chevron_up_circle
    case chevron_up_circle_fill
    case chevron_up_square
    case chevron_up_square_fill
    case circle
    case circle_bottomthird_split
    case circle_fill
    case circle_grid_2x2
    case circle_grid_2x2_fill
    case circle_grid_3x3
    case circle_grid_3x3_fill
    case circle_grid_hex
    case circle_grid_hex_fill
    case circle_lefthalf_fill
    case circle_righthalf_fill
    case clear
    case clear_fill
    case clock
    case clock_fill
    case cloud
    case cloud_bolt
    case cloud_bolt_fill
    case cloud_bolt_rain
    case cloud_bolt_rain_fill
    case cloud_drizzle
    case cloud_drizzle_fill
    case cloud_fill
    case cloud_fog
    case cloud_fog_fill
    case cloud_hail
    case cloud_hail_fill
    case cloud_heavyrain
    case cloud_heavyrain_fill
    case cloud_moon
    case cloud_moon_bolt
    case cloud_moon_bolt_fill
    case cloud_moon_fill
    case cloud_moon_rain
    case cloud_moon_rain_fill
    case cloud_rain
    case cloud_rain_fill
    case cloud_sleet
    case cloud_sleet_fill
    case cloud_snow
    case cloud_snow_fill
    case cloud_sun
    case cloud_sun_bolt
    case cloud_sun_bolt_fill
    case cloud_sun_fill
    case cloud_sun_rain
    case cloud_sun_rain_fill
    case coloncurrencysign_circle
    case coloncurrencysign_circle_fill
    case coloncurrencysign_square
    case coloncurrencysign_square_fill
    case command
    case control
    case creditcard
    case creditcard_fill
    case crop
    case crop_rotate
    case cruzeirosign_circle
    case cruzeirosign_circle_fill
    case cruzeirosign_square
    case cruzeirosign_square_fill
    case cube
    case cube_box
    case cube_box_fill
    case cube_fill
    case cursor_rays
    case d_circle
    case d_circle_fill
    case d_square
    case d_square_fill
    case decrease_indent
    case decrease_quotelevel
    case delete_left
    case delete_left_fill
    case delete_right
    case delete_right_fill
    case desktopcomputer
    case dial
    case dial_fill
    case divide
    case divide_circle
    case divide_circle_fill
    case divide_square
    case divide_square_fill
    case doc
    case doc_append
    case doc_circle
    case doc_circle_fill
    case doc_fill
    case doc_on_clipboard
    case doc_on_clipboard_fill
    case doc_on_doc
    case doc_on_doc_fill
    case doc_plaintext
    case doc_richtext
    case doc_text
    case doc_text_fill
    case doc_text_magnifyingglass
    case doc_text_viewfinder
    case dollarsign_circle
    case dollarsign_circle_fill
    case dollarsign_square
    case dollarsign_square_fill
    case dongsign_circle
    case dongsign_circle_fill
    case dongsign_square
    case dongsign_square_fill
    case dot_radiowaves_left_and_right
    case dot_radiowaves_right
    case dot_square
    case dot_square_fill
    case drop_triangle
    case drop_triangle_fill
    case e_circle
    case e_circle_fill
    case e_square
    case e_square_fill
    case ear
    case eject
    case eject_fill
    case ellipses_bubble
    case ellipses_bubble_fill
    case ellipsis
    case ellipsis_circle
    case ellipsis_circle_fill
    case envelope
    case envelope_badge
    case envelope_badge_fill
    case envelope_circle
    case envelope_circle_fill
    case envelope_fill
    case envelope_open
    case envelope_open_fill
    case equal
    case equal_circle
    case equal_circle_fill
    case equal_square
    case equal_square_fill
    case escape
    case eurosign_circle
    case eurosign_circle_fill
    case eurosign_square
    case eurosign_square_fill
    case exclamationmark
    case exclamationmark_bubble
    case exclamationmark_bubble_fill
    case exclamationmark_circle
    case exclamationmark_circle_fill
    case exclamationmark_icloud
    case exclamationmark_icloud_fill
    case exclamationmark_octagon
    case exclamationmark_octagon_fill
    case exclamationmark_shield
    case exclamationmark_shield_fill
    case exclamationmark_square
    case exclamationmark_square_fill
    case exclamationmark_triangle
    case exclamationmark_triangle_fill
    case eye
    case eye_fill
    case eye_slash
    case eye_slash_fill
    case eyedropper
    case eyedropper_full
    case eyedropper_halffull
    case eyeglasses
    case f_circle
    case f_circle_fill
    case f_cursive
    case f_cursive_circle
    case f_cursive_circle_fill
    case f_square
    case f_square_fill
    case faceid
    case film
    case film_fill
    case flag
    case flag_circle
    case flag_circle_fill
    case flag_fill
    case flag_slash
    case flag_slash_fill
    case flame
    case flame_fill
    case flashlight_off_fill
    case flashlight_on_fill
    case flip_horizontal
    case flip_horizontal_fill
    case florinsign_circle
    case florinsign_circle_fill
    case florinsign_square
    case florinsign_square_fill
    case flowchart
    case flowchart_fill
    case folder
    case folder_badge_minus
    case folder_badge_person_crop
    case folder_badge_plus
    case folder_circle
    case folder_circle_fill
    case folder_fill
    case folder_fill_badge_minus
    case folder_fill_badge_person_crop
    case folder_fill_badge_plus
    case forward
    case forward_end
    case forward_end_alt
    case forward_end_alt_fill
    case forward_end_fill
    case forward_fill
    case francsign_circle
    case francsign_circle_fill
    case francsign_square
    case francsign_square_fill
    case function
    case fx
    case g_circle
    case g_circle_fill
    case g_square
    case g_square_fill
    case gamecontroller
    case gamecontroller_fill
    case gauge
    case gauge_badge_minus
    case gauge_badge_plus
    case gear
    case gift
    case gift_fill
    case globe
    case gobackward
    case gobackward_10
    case gobackward_10_ar
    case gobackward_10_hi
    case gobackward_15
    case gobackward_15_ar
    case gobackward_15_hi
    case gobackward_30
    case gobackward_30_ar
    case gobackward_30_hi
    case gobackward_45
    case gobackward_45_ar
    case gobackward_45_hi
    case gobackward_60
    case gobackward_60_ar
    case gobackward_60_hi
    case gobackward_75
    case gobackward_75_ar
    case gobackward_75_hi
    case gobackward_90
    case gobackward_90_ar
    case gobackward_90_hi
    case gobackward_minus
    case goforward
    case goforward_10
    case goforward_10_ar
    case goforward_10_hi
    case goforward_15
    case goforward_15_ar
    case goforward_15_hi
    case goforward_30
    case goforward_30_ar
    case goforward_30_hi
    case goforward_45
    case goforward_45_ar
    case goforward_45_hi
    case goforward_60
    case goforward_60_ar
    case goforward_60_hi
    case goforward_75
    case goforward_75_ar
    case goforward_75_hi
    case goforward_90
    case goforward_90_ar
    case goforward_90_hi
    case goforward_plus
    case greaterthan
    case greaterthan_circle
    case greaterthan_circle_fill
    case greaterthan_square
    case greaterthan_square_fill
    case grid
    case grid_circle
    case grid_circle_fill
    case guaranisign_circle
    case guaranisign_circle_fill
    case guaranisign_square
    case guaranisign_square_fill
    case guitars
    case h_circle
    case h_circle_fill
    case h_square
    case h_square_fill
    case hammer
    case hammer_fill
    case hand_draw
    case hand_draw_fill
    case hand_point_left
    case hand_point_left_fill
    case hand_point_right
    case hand_point_right_fill
    case hand_raised
    case hand_raised_fill
    case hand_raised_slash
    case hand_raised_slash_fill
    case hand_thumbsdown
    case hand_thumbsdown_fill
    case hand_thumbsup
    case hand_thumbsup_fill
    case hare
    case hare_fill
    case headphones
    case heart
    case heart_circle
    case heart_circle_fill
    case heart_fill
    case heart_slash
    case heart_slash_circle
    case heart_slash_circle_fill
    case heart_slash_fill
    case helm
    case hexagon
    case hexagon_fill
    case hifispeaker
    case hifispeaker_fill
    case hourglass
    case hourglass_bottomhalf_fill
    case hourglass_tophalf_fill
    case house
    case house_fill
    case hryvniasign_circle
    case hryvniasign_circle_fill
    case hryvniasign_square
    case hryvniasign_square_fill
    case hurricane
    case i_circle
    case i_circle_fill
    case i_square
    case i_square_fill
    case icloud
    case icloud_and_arrow_down
    case icloud_and_arrow_down_fill
    case icloud_and_arrow_up
    case icloud_and_arrow_up_fill
    case icloud_circle
    case icloud_circle_fill
    case icloud_fill
    case icloud_slash
    case icloud_slash_fill
    case increase_indent
    case increase_quotelevel
    case indianrupeesign_circle
    case indianrupeesign_circle_fill
    case indianrupeesign_square
    case indianrupeesign_square_fill
    case info
    case info_circle
    case info_circle_fill
    case italic
    case j_circle
    case j_circle_fill
    case j_square
    case j_square_fill
    case k_circle
    case k_circle_fill
    case k_square
    case k_square_fill
    case keyboard
    case keyboard_chevron_compact_down
    case kipsign_circle
    case kipsign_circle_fill
    case kipsign_square
    case kipsign_square_fill
    case l_circle
    case l_circle_fill
    case l_square
    case l_square_fill
    case largecircle_fill_circle
    case larisign_circle
    case larisign_circle_fill
    case larisign_square
    case larisign_square_fill
    case lasso
    case leaf_arrow_circlepath
    case lessthan
    case lessthan_circle
    case lessthan_circle_fill
    case lessthan_square
    case lessthan_square_fill
    case light_max
    case light_min
    case lightbulb
    case lightbulb_fill
    case lightbulb_slash
    case lightbulb_slash_fill
    case line_horizontal_3
    case line_horizontal_3_decrease
    case line_horizontal_3_decrease_circle
    case line_horizontal_3_decrease_circle_fill
    case link
    case link_circle
    case link_circle_fill
    case link_icloud
    case link_icloud_fill
    case lirasign_circle
    case lirasign_circle_fill
    case lirasign_square
    case lirasign_square_fill
    case list_bullet
    case list_bullet_below_rectangle
    case list_bullet_indent
    case list_dash
    case list_number
    case livephoto
    case livephoto_play
    case livephoto_slash
    case location
    case location_circle
    case location_circle_fill
    case location_fill
    case location_north
    case location_north_fill
    case location_north_line
    case location_north_line_fill
    case location_slash
    case location_slash_fill
    case lock
    case lock_circle
    case lock_circle_fill
    case lock_fill
    case lock_icloud
    case lock_icloud_fill
    case lock_open
    case lock_open_fill
    case lock_rotation
    case lock_rotation_open
    case lock_shield
    case lock_shield_fill
    case lock_slash
    case lock_slash_fill
    case m_circle
    case m_circle_fill
    case m_square
    case m_square_fill
    case macwindow
    case magnifyingglass
    case magnifyingglass_circle
    case magnifyingglass_circle_fill
    case manatsign_circle
    case manatsign_circle_fill
    case manatsign_square
    case manatsign_square_fill
    case map
    case map_fill
    case mappin
    case mappin_and_ellipse
    case mappin_circle
    case mappin_circle_fill
    case mappin_slash
    case memories
    case memories_badge_minus
    case memories_badge_plus
    case message
    case message_circle
    case message_circle_fill
    case message_fill
    case metronome
    case mic
    case mic_circle
    case mic_circle_fill
    case mic_fill
    case mic_slash
    case mic_slash_fill
    case millsign_circle
    case millsign_circle_fill
    case millsign_square
    case millsign_square_fill
    case minus
    case minus_circle
    case minus_circle_fill
    case minus_magnifyingglass
    case minus_rectangle
    case minus_rectangle_fill
    case minus_slash_plus
    case minus_square
    case minus_square_fill
    case moon
    case moon_circle
    case moon_circle_fill
    case moon_fill
    case moon_stars
    case moon_stars_fill
    case moon_zzz
    case moon_zzz_fill
    case multiply
    case multiply_circle
    case multiply_circle_fill
    case multiply_square
    case multiply_square_fill
    case music_house
    case music_house_fill
    case music_mic
    case music_note
    case music_note_list
    case n_circle
    case n_circle_fill
    case n_square
    case n_square_fill
    case nairasign_circle
    case nairasign_circle_fill
    case nairasign_square
    case nairasign_square_fill
    case nosign
    case number
    case number_circle
    case number_circle_fill
    case number_square
    case number_square_fill
    case o_circle
    case o_circle_fill
    case o_square
    case o_square_fill
    case option
    case p_circle
    case p_circle_fill
    case p_square
    case p_square_fill
    case paintbrush
    case paintbrush_fill
    case pano
    case pano_fill
    case paperclip
    case paperclip_circle
    case paperclip_circle_fill
    case paperplane
    case paperplane_fill
    case paragraph
    case pause
    case pause_circle
    case pause_circle_fill
    case pause_fill
    case pause_rectangle
    case pause_rectangle_fill
    case pencil
    case pencil_and_ellipsis_rectangle
    case pencil_and_outline
    case pencil_circle
    case pencil_circle_fill
    case pencil_slash
    case pencil_tip
    case pencil_tip_crop_circle
    case pencil_tip_crop_circle_badge_minus
    case pencil_tip_crop_circle_badge_plus
    case percent
    case person
    case person_2
    case person_2_fill
    case person_2_square_stack
    case person_2_square_stack_fill
    case person_3
    case person_3_fill
    case person_badge_minus
    case person_badge_minus_fill
    case person_badge_plus
    case person_badge_plus_fill
    case person_circle
    case person_circle_fill
    case person_crop_circle
    case person_crop_circle_badge_checkmark
    case person_crop_circle_badge_exclam
    case person_crop_circle_badge_minus
    case person_crop_circle_badge_plus
    case person_crop_circle_badge_xmark
    case person_crop_circle_fill
    case person_crop_circle_fill_badge_checkmark
    case person_crop_circle_fill_badge_exclam
    case person_crop_circle_fill_badge_minus
    case person_crop_circle_fill_badge_plus
    case person_crop_circle_fill_badge_xmark
    case person_crop_rectangle
    case person_crop_rectangle_fill
    case person_crop_square
    case person_crop_square_fill
    case person_fill
    case person_icloud
    case person_icloud_fill
    case personalhotspot
    case perspective
    case pesetasign_circle
    case pesetasign_circle_fill
    case pesetasign_square
    case pesetasign_square_fill
    case pesosign_circle
    case pesosign_circle_fill
    case pesosign_square
    case pesosign_square_fill
    case phone
    case phone_arrow_down_left
    case phone_arrow_right
    case phone_arrow_up_right
    case phone_badge_plus
    case phone_circle
    case phone_circle_fill
    case phone_down
    case phone_down_circle
    case phone_down_circle_fill
    case phone_down_fill
    case phone_fill
    case phone_fill_arrow_down_left
    case phone_fill_arrow_right
    case phone_fill_arrow_up_right
    case phone_fill_badge_plus
    case photo
    case photo_fill
    case photo_fill_on_rectangle_fill
    case photo_on_rectangle
    case pin
    case pin_circle
    case pin_circle_fill
    case pin_fill
    case pin_slash
    case pin_slash_fill
    case play
    case play_circle
    case play_circle_fill
    case play_fill
    case play_rectangle
    case play_rectangle_fill
    case playpause
    case playpause_fill
    case plus
    case plus_app
    case plus_app_fill
    case plus_bubble
    case plus_bubble_fill
    case plus_circle
    case plus_circle_fill
    case plus_magnifyingglass
    case plus_rectangle
    case plus_rectangle_fill
    case plus_rectangle_fill_on_rectangle_fill
    case plus_rectangle_on_rectangle
    case plus_slash_minus
    case plus_square
    case plus_square_fill
    case plus_square_fill_on_square_fill
    case plus_square_on_square
    case plusminus
    case plusminus_circle
    case plusminus_circle_fill
    case power
    case printer
    case printer_fill
    case projective
    case purchased
    case purchased_circle
    case purchased_circle_fill
    case q_circle
    case q_circle_fill
    case q_square
    case q_square_fill
    case qrcode
    case qrcode_viewfinder
    case questionmark
    case questionmark_circle
    case questionmark_circle_fill
    case questionmark_diamond
    case questionmark_diamond_fill
    case questionmark_square
    case questionmark_square_fill
    case questionmark_video
    case questionmark_video_fill
    case quote_bubble
    case quote_bubble_fill
    case r_circle
    case r_circle_fill
    case r_square
    case r_square_fill
    case radiowaves_left
    case radiowaves_right
    case rays
    case recordingtape
    case rectangle
    case rectangle_3_offgrid
    case rectangle_3_offgrid_fill
    case rectangle_and_arrow_up_right_and_arrow_down_left
    case rectangle_and_arrow_up_right_and_arrow_down_left_slash
    case rectangle_and_paperclip
    case rectangle_badge_checkmark
    case rectangle_badge_xmark
    case rectangle_compress_vertical
    case rectangle_dock
    case rectangle_expand_vertical
    case rectangle_fill
    case rectangle_fill_badge_checkmark
    case rectangle_fill_badge_xmark
    case rectangle_fill_on_rectangle_angled_fill
    case rectangle_fill_on_rectangle_fill
    case rectangle_grid_1x2
    case rectangle_grid_1x2_fill
    case rectangle_grid_2x2
    case rectangle_grid_2x2_fill
    case rectangle_grid_3x2
    case rectangle_grid_3x2_fill
    case rectangle_on_rectangle
    case rectangle_on_rectangle_angled
    case rectangle_split_3x1
    case rectangle_split_3x1_fill
    case rectangle_split_3x3
    case rectangle_split_3x3_fill
    case rectangle_stack
    case rectangle_stack_badge_minus
    case rectangle_stack_badge_person_crop
    case rectangle_stack_badge_plus
    case rectangle_stack_fill
    case rectangle_stack_fill_badge_minus
    case rectangle_stack_fill_badge_person_crop
    case rectangle_stack_fill_badge_plus
    case rectangle_stack_person_crop
    case rectangle_stack_person_crop_fill
    case `repeat`
    case repeat_1
    case `return`
    case rhombus
    case rhombus_fill
    case rosette
    case rotate_left
    case rotate_left_fill
    case rotate_right
    case rotate_right_fill
    case rublesign_circle
    case rublesign_circle_fill
    case rublesign_square
    case rublesign_square_fill
    case rupeesign_circle
    case rupeesign_circle_fill
    case rupeesign_square
    case rupeesign_square_fill
    case s_circle
    case s_circle_fill
    case s_square
    case s_square_fill
    case safari
    case safari_fill
    case scissors
    case scissors_badge_ellipsis
    case scope
    case scribble
    case selection_pin_in_out
    case sheqelsign_circle
    case sheqelsign_circle_fill
    case sheqelsign_square
    case sheqelsign_square_fill
    case shield
    case shield_fill
    case shield_lefthalf_fill
    case shield_slash
    case shield_slash_fill
    case shift
    case shift_fill
    case shuffle
    case sidebar_left
    case sidebar_right
    case signature
    case skew
    case slash_circle
    case slash_circle_fill
    case slider_horizontal_3
    case slider_horizontal_below_rectangle
    case slowmo
    case smallcircle_circle
    case smallcircle_circle_fill
    case smallcircle_fill_circle
    case smallcircle_fill_circle_fill
    case smiley
    case smiley_fill
    case smoke
    case smoke_fill
    case snow
    case sparkles
    case speaker
    case speaker_1
    case speaker_1_fill
    case speaker_2
    case speaker_2_fill
    case speaker_3
    case speaker_3_fill
    case speaker_fill
    case speaker_slash
    case speaker_slash_fill
    case speaker_zzz
    case speaker_zzz_fill
    case speedometer
    case sportscourt
    case sportscourt_fill
    case square
    case square_and_arrow_down
    case square_and_arrow_down_fill
    case square_and_arrow_down_on_square
    case square_and_arrow_down_on_square_fill
    case square_and_arrow_up
    case square_and_arrow_up_fill
    case square_and_arrow_up_on_square
    case square_and_arrow_up_on_square_fill
    case square_and_line_vertical_and_square
    case square_and_line_vertical_and_square_fill
    case square_and_pencil
    case square_fill
    case square_fill_and_line_vertical_and_square
    case square_fill_and_line_vertical_square_fill
    case square_fill_on_circle_fill
    case square_fill_on_square_fill
    case square_grid_2x2
    case square_grid_2x2_fill
    case square_grid_3x2
    case square_grid_3x2_fill
    case square_grid_4x3_fill
    case square_lefthalf_fill
    case square_on_circle
    case square_on_square
    case square_righthalf_fill
    case square_split_1x2
    case square_split_1x2_fill
    case square_split_2x1
    case square_split_2x1_fill
    case square_split_2x2
    case square_split_2x2_fill
    case square_stack
    case square_stack_3d_down_dottedline
    case square_stack_3d_down_right
    case square_stack_3d_down_right_fill
    case square_stack_3d_up
    case square_stack_3d_up_fill
    case square_stack_3d_up_slash
    case square_stack_3d_up_slash_fill
    case square_stack_fill
    case squares_below_rectangle
    case star
    case star_circle
    case star_circle_fill
    case star_fill
    case star_lefthalf_fill
    case star_slash
    case star_slash_fill
    case staroflife
    case staroflife_fill
    case sterlingsign_circle
    case sterlingsign_circle_fill
    case sterlingsign_square
    case sterlingsign_square_fill
    case stop
    case stop_circle
    case stop_circle_fill
    case stop_fill
    case stopwatch
    case stopwatch_fill
    case strikethrough
    case studentdesk
    case suit_club
    case suit_club_fill
    case suit_diamond
    case suit_diamond_fill
    case suit_heart
    case suit_heart_fill
    case suit_spade
    case suit_spade_fill
    case sum
    case sun_dust
    case sun_dust_fill
    case sun_haze
    case sun_haze_fill
    case sun_max
    case sun_max_fill
    case sun_min
    case sun_min_fill
    case sunrise
    case sunrise_fill
    case sunset
    case sunset_fill
    case t_bubble
    case t_bubble_fill
    case t_circle
    case t_circle_fill
    case t_square
    case t_square_fill
    case table
    case table_badge_more
    case table_badge_more_fill
    case table_fill
    case tag
    case tag_circle
    case tag_circle_fill
    case tag_fill
    case teletype
    case teletype_answer
    case tengesign_circle
    case tengesign_circle_fill
    case tengesign_square
    case tengesign_square_fill
    case text_aligncenter
    case text_alignleft
    case text_alignright
    case text_append
    case text_badge_checkmark
    case text_badge_minus
    case text_badge_plus
    case text_badge_star
    case text_badge_xmark
    case text_bubble
    case text_bubble_fill
    case text_cursor
    case text_insert
    case text_justify
    case text_justifyleft
    case text_justifyright
    case text_quote
    case textbox
    case textformat
    case textformat_123
    case textformat_abc
    case textformat_abc_dottedunderline
    case textformat_alt
    case textformat_size
    case textformat_subscript
    case textformat_superscript
    case thermometer
    case thermometer_snowflake
    case thermometer_sun
    case timelapse
    case timer
    case tornado
    case tortoise
    case tortoise_fill
    case tram_fill
    case trash
    case trash_circle
    case trash_circle_fill
    case trash_fill
    case trash_slash
    case trash_slash_fill
    case tray
    case tray_2
    case tray_2_fill
    case tray_and_arrow_down
    case tray_and_arrow_down_fill
    case tray_and_arrow_up
    case tray_and_arrow_up_fill
    case tray_fill
    case tray_full
    case tray_full_fill
    case triangle
    case triangle_fill
    case triangle_lefthalf_fill
    case triangle_righthalf_fill
    case tropicalstorm
    case tugriksign_circle
    case tugriksign_circle_fill
    case tugriksign_square
    case tugriksign_square_fill
    case tuningfork
    case turkishlirasign_circle
    case turkishlirasign_circle_fill
    case turkishlirasign_square
    case turkishlirasign_square_fill
    case tv
    case tv_circle
    case tv_circle_fill
    case tv_fill
    case tv_music_note
    case tv_music_note_fill
    case u_circle
    case u_circle_fill
    case u_square
    case u_square_fill
    case uiwindow_split_2x1
    case umbrella
    case umbrella_fill
    case underline
    case v_circle
    case v_circle_fill
    case v_square
    case v_square_fill
    case video
    case video_badge_plus
    case video_badge_plus_fill
    case video_circle
    case video_circle_fill
    case video_fill
    case video_slash
    case video_slash_fill
    case view_2d
    case view_3d
    case viewfinder
    case viewfinder_circle
    case viewfinder_circle_fill
    case w_circle
    case w_circle_fill
    case w_square
    case w_square_fill
    case wand_and_rays
    case wand_and_rays_inverse
    case wand_and_stars
    case wand_and_stars_inverse
    case waveform
    case waveform_circle
    case waveform_circle_fill
    case waveform_path
    case waveform_path_badge_minus
    case waveform_path_badge_plus
    case waveform_path_ecg
    case wifi
    case wifi_exclamationmark
    case wifi_slash
    case wind
    case wind_snow
    case wonsign_circle
    case wonsign_circle_fill
    case wonsign_square
    case wonsign_square_fill
    case wrench
    case wrench_fill
    case x_circle
    case x_circle_fill
    case x_square
    case x_square_fill
    case x_squareroot
    case xmark
    case xmark_circle
    case xmark_circle_fill
    case xmark_icloud
    case xmark_icloud_fill
    case xmark_octagon
    case xmark_octagon_fill
    case xmark_rectangle
    case xmark_rectangle_fill
    case xmark_seal
    case xmark_seal_fill
    case xmark_shield
    case xmark_shield_fill
    case xmark_square
    case xmark_square_fill
    case y_circle
    case y_circle_fill
    case y_square
    case y_square_fill
    case yensign_circle
    case yensign_circle_fill
    case yensign_square
    case yensign_square_fill
    case z_circle
    case z_circle_fill
    case z_square
    case z_square_fill
    case zzz
    
    case runnerCustom
    case stepsCustom
    case stairsCustom
}

