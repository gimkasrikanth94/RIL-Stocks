//
//  ENums.swift
//  RIL Stocks
//
//  Created by Srikanth Gimka on 19/08/22.
//

import Foundation
import SwiftUICharts

enum TimeFrame{
    case daily
    case weekly
    case monthly
}


enum OutputSize{
    case full
    case compact
}

enum Group {
    case low
    case open
    case close
    case high

    var data : GroupingData {
        switch self {
        case .low:
            return GroupingData(title: "Low" , colour: ColourStyle(colour: .red))
        case .open:
            return GroupingData(title: "Open", colour: ColourStyle(colour: .blue))
        case .close:
            return GroupingData(title: "High"   , colour: ColourStyle(colour: .green))
        case .high:
            return GroupingData(title: "Close"   , colour: ColourStyle(colour: .purple))
        }
    }
}
