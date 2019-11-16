// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import Foundation

enum ProductState {
    case wasted, utilized, done, none
}

class Product: Equatable {
    
    var id: String
    var name: String
    var price: Double
    var quantity: Double
    var carbonLevel: Double
    var isDomestic: Bool
    var iconUrl: String
    var shouldBeAnimated: Bool = true
    
    var recomendationTitle: String?
    var recomendation: Product?
    
    var state: ProductState = .none
    
    init(id: String, name: String, price: Double, quantity: Double, carbonLevel: Double = 10, isDomestic: Bool = true, iconUrl: String) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.carbonLevel = carbonLevel
        self.isDomestic = isDomestic
        self.iconUrl = iconUrl
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
}

extension Product {
    
    var toViewModel: ProductViewModelProtocol & ViewModel {
        if let recomendation = recomendation, let recomendationTitle = recomendationTitle {
            return ProductWithRecommendaitonViewModel(id: id,
                                                      name: name,
                                                      price: price,
                                                      quantity: quantity,
                                                      carbonLevel: "\(carbonLevel)",
                                                      isDomestic: isDomestic,
                                                      productIcon: iconUrl,
                                                      recommendedTitle: recomendationTitle,
                                                      recommendedProductName: recomendation.name,
                                                      recommendedProductIcon: recomendation.iconUrl)
        } else {
            return ProductViewModel(id: id,
                                    name: name,
                                    price: price,
                                    quantity: quantity,
                                    carbonLevel: "\(carbonLevel)",
                isDomestic: isDomestic, productIcon: iconUrl)
        }
    }
    
    static var dummy: Product {
        return Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1, iconUrl: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492")
    }
    
    static var dummyWithRecomendation: Product {
        let product = Product(id: UUID().uuidString, name: "Kefir", price: 1.5, quantity: 3, iconUrl: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492")
        product.recomendation = .dummy
        product.recomendationTitle = "You can reduce Carbon level buying similar product:"
        return product
    }
    
}
