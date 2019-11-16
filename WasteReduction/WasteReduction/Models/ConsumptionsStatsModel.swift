// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import DynamicButton

enum ConsumptionsStatsDirection {
    case up, down

    var dynamicButtonStyle: DynamicButton.Style {
        switch self {
        case .up:                       return .caretUp
        case .down:                     return .caretDown
        }
    }
}

struct ConsumptionsStats {
    
    let domestic: ConsumptionStat
    let waste: ConsumptionStat
    let carbon: ConsumptionStat
    
    init(domesticDetails: String, wasteDetails: String, carbonDetails: String) {
        self.domestic = ConsumptionStat(type: .domestic, details: domesticDetails, direction: .up)
        self.waste = ConsumptionStat(type: .waste, details: wasteDetails, direction: .down)
        self.carbon = ConsumptionStat(type: .carbon, details: carbonDetails, direction: .up)
    }
}

struct ConsumptionStat {
    
    let type: ConsumptionType
    let details: String
    let direction: ConsumptionsStatsDirection
}

enum ConsumptionType {
    case domestic, waste, carbon
    
    var title: String {
        switch self {
        case .domestic:                 return "Domestic"
        case .waste:                    return "Waste"
        case .carbon:                   return "Carbon"
        }
    }
    
    var shortTitle: String {
        switch self {
        case .domestic:                 return "D:"
        case .waste:                    return "W:"
        case .carbon:                   return "C:"
        }
    }
    
    var color: UIColor {
        switch self {
        case .domestic:                 return Constants.Colors.lightYellow
        case .waste:                    return Constants.Colors.darkBlue
        case .carbon:                   return Constants.Colors.pinkRed
        }
    }
}
