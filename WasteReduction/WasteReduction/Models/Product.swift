// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import Foundation

enum ProductState {
    case wasted, utilized, done, none
}

class Product: Equatable, Hashable {
    
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
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
        return Product(id: UUID().uuidString, name: "Keffir 2.0", price: 4.1, quantity: 2, iconUrl: "https://instamart.ru/spree/products/81441/product/86040.jpg?1538752678")
    }
    
    static var dummyWithRecomendation: Product {
        let product = Product(id: UUID().uuidString, name: "Kefir", price: 3.8, quantity: 3, iconUrl: "https://pp.userapi.com/c830408/v830408978/f3193/d0ciSh2whYw.jpg")
        product.recomendation = .dummy
        product.recomendationTitle = "You can reduce Carbon level buying similar product:"
        return product
    }
    
}
