//
//  Model.swift
//  Codable
//
//  Created by EastElsoft on 2018/1/22.
//  Copyright © 2018年 AnatoleZho. All rights reserved.
//

import Foundation

// 1. 简单解码
struct Swifter: Decodable {
    let fullName: String
    let id: Int
    let twitter: URL
    
    // 只要 Class 类继承自 NSObject，才会有 description 属性
    var description: String {
        return "Swifter: fullName: \(fullName), id: \(id), twitter: \(twitter)"
    }
}

// 2.属性值为枚举类型解码
struct Beer: Decodable {
    var name: String
    var brewery: String
    var style: BeerStyle
    
    // 枚举类型也要遵循 Decodable 协议
    enum BeerStyle: String, Decodable {
        case ipa, stout, kolsch
    }
    
    var description: String {
        return "Beer:  name: \(name), brewery: \(brewery), style: \(style.rawValue)"
    }
}

// 3. 从数组中解析
struct GroceryProduct: Decodable {
    var name: String
    var points: Int
    var description: String?
}

// 5. 解析复杂嵌套结构
// 根据 JSON 字符串结构创建的结构体
struct GroceryStoreService: Decodable {
    let name: String
    let aisles: [Aisle]
    
    struct Aisle: Decodable {
        let name: String
        let shelves: [Shelf]
        
        struct Shelf: Decodable {
            let name: String
            let product: GroceryStore.Product
            
        }
    }
}

// 数据处理中需要的 Model



struct GroceryStore {
    var name: String
    var products: [Product]
    
    struct Product: Codable {
        var name: String
        var points: Int
        var description: String?
    }
}

// 增加扩展处理已解析的原始数据
extension GroceryStore {
    init(from service: GroceryStoreService) {
        name = service.name
        products = []
        for aisle in service.aisles {
            for shelf in aisle.shelves {
                products.append(shelf.product)
            }
        }
    }
}

// 6. Change Key Name
struct GroceryProductT: Decodable {
    var name: String
    var points: Int
    var description: String?
    
    // 改变 key 名字需要遵循 CodingKey 协议
    // 即使 description key 没有改变也需要写上
    private enum CodingKeys: String, CodingKey {
        case name = "product_name"
        case points = "product_cost"
        case description
    }
}

 // 7. 自定义实现
struct CustomSwifter {
    let fullName: String
    let id: Int
    let twitter: URL
    
    // default struct initialize
    init(fullName: String, id: Int, twitter: URL) {
        self.fullName = fullName
        self.id = id
        self.twitter = twitter
    }
    var description: String {
        return "CustomSwifter: fullName: \(fullName), id: \(id), twitter: \(twitter)"
    }
}

extension CustomSwifter: Decodable {
    // declaring our keys
    enum StructKeys: String, CodingKey {
        case fullName = "fullName"
        case id = "id"
        case twitter = "twitter"
    }
    
    init(from decoder: Decoder) throws {
        // define our keyed container
        let container = try decoder.container(keyedBy: StructKeys.self)
        
        // extracting the data
        let fullName: String = try container.decode(String.self, forKey: .fullName)
        let id: Int = try container.decode(Int.self, forKey: .id)
        let twitter: URL = try container.decode(URL.self, forKey: .twitter)
        
        // initialize our struct
        self.init(fullName: fullName, id: id, twitter: twitter)
    }
}

// 8. 复杂解析（枚举）
enum SwifterOrBool {
    case swifter(Swifter)
    case bool(Bool)
}

extension SwifterOrBool: Decodable {
    enum CodingKeys: String, CodingKey {
        case swifter, bool
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let swifter = try container.decodeIfPresent(Swifter.self, forKey: .swifter) {
            self = .swifter(swifter)
        } else {
            self = .bool(try container.decode(Bool.self, forKey: .bool))
        }
        
    }
}

// 9. Merge Data from Different Depths 合并不同深度的数据
struct GroceryStoreMerge {
    struct Product {
        let name: String
        let points: Int
        let description: String?
    }
    var products: [Product]
    
    init(products: [Product] = []) {
        self.products = products
    }
}

extension GroceryStoreMerge: Decodable {
    struct ProductKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        init?(intValue: Int) {
            return nil
        }
        
        static let points = ProductKey.init(stringValue: "points")
        static let description = ProductKey.init(stringValue: "description")
    }
    
    init(from decoder: Decoder) throws {
        var productsTemp = [Product]()
        
        let container = try decoder.container(keyedBy: ProductKey.self)
        for key in container.allKeys {
            // Note how the `key` in the loop above is used immediately to access a nested container.
            let productContainer = try container.nestedContainer(keyedBy: ProductKey.self, forKey: key)
            // 如果是可选值，使用 decodeIfPresent 方法， 否则使用 decode 方法
            let points = try productContainer.decode(Int.self, forKey: ProductKey.points!)
            let description = try productContainer.decodeIfPresent(String.self, forKey: ProductKey.description!)
            // The key is used again here and completes the collapse of the nesting that existed in the JSON representation.
            let product = Product.init(name: key.stringValue, points: points, description: description)
            
            productsTemp.append(product)
        }
        self.init(products: productsTemp)
    }
}

// 10. 编码
extension GroceryStoreMerge: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ProductKey.self)
        for product in products {
            // Any product's 'name' can be used as a key name
            let nameKey = ProductKey.init(stringValue: product.name)
            var productContainer = container.nestedContainer(keyedBy: ProductKey.self, forKey: nameKey!)
            
            // The rest of keys use static names defined in 'ProductKey'.
            try productContainer.encode(product.points, forKey: GroceryStoreMerge.ProductKey.points!)
            try productContainer.encode(product.description, forKey: GroceryStoreMerge.ProductKey.description!)
        }
    }
}

// 11. 特殊数据类型处理
/*
 11.1 enum， 11.2 Bool 11.3 日期， 11.4 小数
 */

// **************** 此时必须定义原始值类型 String
// 否则报错 Type 'Geneder' does not conform to protocol 'Decodable'
enum Geneder: String, Decodable {
    case male
    case female
    case other
}

struct Foo: Codable {
    let date: Date
}

struct Numbers: Codable {
    let a: Float
    let b: Float
    let c: Float
}

// 12. 使用继承解析
class WineClass: Codable {
    var abv: Double?
    
}
class BeerClass: WineClass {
    var name: String?
    var brewery: String?
    var style: BeerStyle?
    
    enum BeerStyle: String, Codable {
        case ipa, stout, kolsch
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(brewery, forKey: .brewery)
        try container.encode(style, forKey: .style)
        // 调用父类的 encode
        try super.encode(to: encoder)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: BeerClass.CodingKeys.name)
        brewery = try container.decodeIfPresent(String.self, forKey: BeerClass.CodingKeys.brewery)
        style = try container.decodeIfPresent(BeerStyle.self, forKey: BeerClass.CodingKeys.style)
        // 调用 父类的 init 
        try super.init(from: decoder)
    }
}

extension BeerClass {
    enum CodingKeys: String, CodingKey {
        case abv, name, brewery, style
    }
}
