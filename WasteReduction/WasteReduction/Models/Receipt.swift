// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import Foundation

class Receipt {
    
    var id: String
    let domesticStat: ConsumptionStat
    let wasteStat: ConsumptionStat
    let carbonStat: ConsumptionStat
    var products: [Product]
    var date: Date
    
    init(id: String, domesticStat: ConsumptionStat, wasteStat: ConsumptionStat, carbonStat: ConsumptionStat, products: [Product], date: Date) {
        self.id = id
        self.domesticStat = domesticStat
        self.wasteStat = wasteStat
        self.carbonStat = carbonStat
        self.products = products
        self.date = date
    }
}
