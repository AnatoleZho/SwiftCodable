//
//  ViewController.swift
//  Codable
//
//  Created by EastElsoft on 2018/1/15.
//  Copyright © 2018年 AnatoleZho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad == bounds == ", view.bounds)
        print("viewDidLoad == frame == ", view.frame)
        
        // 1. 简单解码
        // Codable 是 Encodable 和 Decodable协议总和的别名,所以它既能编码也能解码
        // Decodable 解码协议 如：Model 中的 Swifter 结构体，只遵循了 Decodable 协议，所以只能解码，不能编码
        let switfterJSONStr = """
                              {
                                "fullName": "Federico Zanetello",
                                 "id": 123456,
                                 "twitter": "http://twitter.com/zntfdr"
                              }
                              """
        // 将 JSON 字符串转换成 Data 类型,指定编码集
        let swifterData = switfterJSONStr.data(using: .utf8)
        // Decoding data
        let swifterStruct = try? JSONDecoder().decode(Swifter.self, from: swifterData!)
        print(swifterStruct?.description ?? "")
        print("1 ❤️")
        
        // 2. 属性值为枚举类型解码
        // 如：Model 中的 Beer 结构体
        let beerJSONStr = """
                            {
                                "name": "Endeavor",
                                "abv": 8.9,
                                "brewery": "Saint Arnold",
                                "style": "ipa"
                            }
                            """
        let beerData = beerJSONStr.data(using: .utf8)
        let beerStruct = try? JSONDecoder().decode(Beer.self, from: beerData!)
        print(beerStruct?.description ?? "")
        print("2 ❤️❤️")

        // 3. 从数组中解析
        let groceryProductJSONStr = """
                                    [
                                        {
                                            "name": "Banana",
                                            "points": 200,
                                            "description": "A banana grown in Ecuador."
                                        },
                                        {
                                            "name": "Orange",
                                            "points": 100
                                        }
                                    ]
                                    """
        let groceryProductData = groceryProductJSONStr.data(using: .utf8)
        let products = try? JSONDecoder().decode([GroceryProduct].self, from: groceryProductData!)
        print("The following products are available:")
        // 快速遍历
//        products?.forEach { print($0) } // decoded!!!!!

        if let pros = products {
            for product in pros {
                print("\t\(product.name) (\(product.points) points)")
                if let desc = product.description {
                    print("\t\t\(desc)")
                }
            }
        }
        print("3 ❤️❤️❤️")

        
        // 4. 从字典中解析
        let productDicJSONStr = """
                                {
                                  "one": {
                                            "name": "Banana",
                                            "points": 200,
                                            "description": "A banana grown in Ecuador."
                                        },
                                  "two": {
                                            "name": "Banana",
                                            "points": 200,
                                            "description": "A banana grown in Ecuador."
                                        },
                                  "three": {
                                            "name": "Banana",
                                            "points": 200,
                                            "description": "A banana grown in Ecuador."
                                        }
                                }
                                """
        let productDicData = productDicJSONStr.data(using: .utf8)
        let productDicDecoded = try? JSONDecoder().decode([String: GroceryProduct].self, from: productDicData!)
        
        productDicDecoded?.forEach { print("\($0.key): \($0.value)") }
        print("4 ❤️❤️❤️❤️")

        
        // 5. 解析复杂嵌套结构
        // 如 Model 中的 GroceryStoreService 结构体
        let groceryStoreServiceJSONStr = """
                            [
                                {
                                    "name": "Home Town Market",
                                    "aisles": [
                                        {
                                            "name": "Produce",
                                            "shelves": [
                                                {
                                                    "name": "Discount Produce",
                                                    "product": {
                                                        "name": "Banana",
                                                        "points": 200,
                                                        "description": "A banana that's perfectly ripe."
                                                    }
                                                }
                                            ]
                                        }
                                    ]
                                },
                                {
                                    "name": "Big City Market",
                                    "aisles": [
                                        {
                                            "name": "Sale Aisle",
                                            "shelves": [
                                                {
                                                    "name": "Seasonal Sale",
                                                    "product": {
                                                        "name": "Chestnuts",
                                                        "points": 700,
                                                        "description": "Chestnuts that were roasted over an open fire."
                                                    }
                                                },
                                                {
                                                    "name": "Last Season's Clearance",
                                                    "product": {
                                                        "name": "Pumpkin Seeds",
                                                        "points": 400,
                                                        "description": "Seeds harvested from a pumpkin."
                                                    }
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                            """
        let groceryStoreServiceData = groceryStoreServiceJSONStr.data(using: .utf8)
        let serviceStores = try? JSONDecoder().decode([GroceryStoreService].self, from: groceryStoreServiceData!)
        
        let stores = serviceStores?.map{ GroceryStore(from: $0) }
        for store in stores! {
            print("\(store.name) is selling:")
            for product in store.products {
                print("\t\(product.name) (\(product.points) points)")
                if let description = product.description {
                    print("\t\t\(description)")
                }
            }
        }
        print("5 ❤️❤️❤️❤️❤️")

        // 6. Change Key Name
        let changeKeyJSONStr = """
                                [
                                    {
                                        "product_name": "Bananas",
                                        "product_cost": 200,
                                        "description": "A banana grown in Ecuador."
                                    },
                                    {
                                        "product_name": "Oranges",
                                        "product_cost": 100,
                                        "description": "A juicy orange."
                                    }
                                ]
                                """
        let changeKeyJSONData = changeKeyJSONStr.data(using: .utf8)
        let groceryProductTs = try? JSONDecoder().decode([GroceryProductT].self, from: changeKeyJSONData!)
        print("The following products are available:")
        if let productTs = groceryProductTs {
            for product in productTs {
                print("\t\(product.name) (\(product.points) points)")
                if let description = product.description {
                    print("\t\t\(description)")
                }
            }
        }
        print("6 ❤️❤️❤️❤️❤️❤️")

        
        
        // 7. 自定义实现
        // Decoder负责处理JSON和Plist解析工作
        // 此时需要手动来实现 init(from: Decoder)。 之前没有实现该方法是因为编译器会默认帮我们实现一个
        let customSwifter = try? JSONDecoder().decode(CustomSwifter.self, from: swifterData!)
        print(customSwifter?.description ?? "")
        print("7 ❤️❤️❤️❤️❤️❤️❤️")

        // 8. 复杂解析（枚举）
        let swifterOrBoolStr = """
                                [{
                                "swifter": {
                                   "fullName": "Federico Zanetello",
                                   "id": 123456,
                                   "twitter": "http://twitter.com/zntfdr"
                                  }
                                },
                                { "bool": true },
                                { "bool": false },
                                {
                                "swifter": {
                                   "fullName": "Federico Zanetello",
                                   "id": 123456,
                                   "twitter": "http://twitter.com/zntfdr"
                                  }
                                }]
                                """
        let swifterOrBoolData = swifterOrBoolStr.data(using: .utf8)
    
        do {
            let swifterOrBoolArr = try JSONDecoder().decode([SwifterOrBool].self, from: swifterOrBoolData!)
            
            swifterOrBoolArr.forEach { print($0) }
        } catch {
            // 错误处理
            print(error)
        }
        print("8 ❤️❤️❤️❤️❤️❤️❤️❤️")

        // 9. Merge Data from Different Depths 合并不同深度的数据
        let groceryStoreMergeJSONStr = """
                                        {
                                            "Banana": {
                                                "points": 200,
                                                "description": "A banana grown in Ecuador."
                                            },
                                            "Orange": {
                                                "points": 100
                                            }
                                        }
                                        """
        let groceryStoreMergeData = groceryStoreMergeJSONStr.data(using: .utf8)
        
        do {
            let groceryStoreMerge =  try JSONDecoder().decode(GroceryStoreMerge.self, from: groceryStoreMergeData!)
            for product in groceryStoreMerge.products {
                print("\t\(product.name) (\(product.points) points)")
                if let description = product.description {
                    print("\t\t\(description)")
                }
            }
        } catch {
            print(error)
        }
        print("9 ❤️❤️❤️❤️❤️❤️❤️❤️❤️")

        // 10. 编码
        let storeMerge = GroceryStoreMerge.init(products: [
            .init(name: "Grapes", points: 230, description: "A mixture of red and green grapes."),
            .init(name: "Lemons", points: 2300, description: "An extra sour lemon.")
            ])
        print("The result of encoding a GroceryStoreMerge: ")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // 完美 JSON 格式化
        do {
            let encodedStoreMerge = try encoder.encode(storeMerge)
            // 输出 JSON 字符串
            print(String.init(data: encodedStoreMerge, encoding: .utf8)!)
            print()
        } catch {
           print(error)
        }
        print("10 ❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️")


        // 11. 特殊数据类型处理
        /*
         11.1 enum， 11.2 Bool 11.3 日期， 11.4 小数,  11.5 Data
         */
        let enumJSONStr = """
                          {
                              "gender": "male"
                          }
                          """
        let genderData = enumJSONStr.data(using: .utf8)
        do {
            let gender = try JSONDecoder().decode([String: Geneder].self, from: genderData!)
            gender.forEach({ print("\($0.key): \($0.value.rawValue)") })
        } catch  {
            print(error)
        }
        print("11.1 ❤️")
        
        let _ = """
                            {
                               "isYoungPioneer": true
                             }
                           """
        
        // 直接声明对应的属性就可以 var isYoungPioneer
        // Bool 类型默认只支持 true/false 形式的 Bool 值解析 如果后端 以 0/1 表示 Bool 类型，则要用 Int 类型然后再转换或是 自定义实现 Codable 协议
        print("11.2 ❤️❤️")
        // JSON 没有数据类型表示日期格式，因此需要客户端和服务端对序列化进行约定。通常情形下都会使用 ISO 8601 日期格式并序列化为字符串。
        
        // Date 类型的特殊性在于它有着各种各样的格式标准和表示方式，从数字到字符串可以说是五花八门
        /*
          Codable 给出的解决方案： 定义解析策略。
          JSONDecoder 和 JSONEncoder 声明了一个 DateDecodingStrategy 类型的属性，用来制定 Date 类型的策略
         /// The strategy to use for decoding `Date` values.
         public enum DateDecodingStrategy {
         
             /// Defer to `Date` for decoding. This is the default strategy.
             case deferredToDate
         
             /// Decode the `Date` as a UNIX timestamp from a JSON number.
             case secondsSince1970
         
             /// Decode the `Date` as UNIX millisecond timestamp from a JSON number.
             case millisecondsSince1970
         
             /// Decode the `Date` as an ISO-8601-formatted string (in RFC 3339 format).
             case iso8601
         
             /// Decode the `Date` as a string parsed by the given formatter.
             case formatted(DateFormatter)
         
             /// Decode the `Date` as a custom value decoded by the given closure.
             case custom((Decoder) throws -> Date)
         }
         
         */
        let foo = Foo.init(date: Date())
        let fooEncoder = JSONEncoder()
        fooEncoder.dateEncodingStrategy = .iso8601
        fooEncoder.outputFormatting = .prettyPrinted
        
        do {
           let data = try fooEncoder.encode(foo)
            print(String.init(data: data, encoding: .utf8) ?? "")
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let date =  try decoder.decode(Foo.self, from: data)
                print(date.date)
            } catch {
                print(error)
            }
        } catch  {
            print(error)
        }
    
        print("11.3 ❤️❤️❤️")
        
        /*
         浮点是 JSON 与 Swift 另一个存在不匹配情形的类型。如果服务器返回的事无效的 "NaN" 字符串会发生什么？无穷大或者无穷大？这些不会映射到 Swift 中的任何特定值。
         
         默认的实现是 .throw，这意味着如果上述数值出现的话就会引发错误，不过对此我们可以自定义映射。
         */
        let floatJsonStr = """
                            {
                               "a": "NaN",
                               "b": "+Infinity",
                               "c": "-Infinity"
                            }
                            """
        let floatData = floatJsonStr.data(using: .utf8)
        
        let floatDecoder = JSONDecoder()
        floatDecoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
        do {
           let numbers = try floatDecoder.decode(Numbers.self, from: floatData!)
            print(numbers)
            // 若使用  dump 则进入 error
//            dump(numbers)
            
            let floatEncoder = JSONEncoder()
            floatEncoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
            do {
               let data = try floatEncoder.encode(numbers)
                print(String.init(data: data, encoding: .utf8) ?? "")
            } catch {
                print(error)
            }
        } catch  {
            print(error)
        }
        
        print("11.4 ❤️❤️❤️❤️")
        
        /*
         有时候服务端 API 返回的数据是 base64 编码过的字符串。
         
         对此，我们可以在 JSONEncoder 使用以下策略：
         
         .base64
         .custom( (Data, Encoder) throws -> Void)
         反之，编码时可以使用：
         
         .base64
         .custom( (Decoder) throws -> Data)
         显然，.base64 时最常见的选项，但如果需要自定义的话可以采用 block 方式。
         */
        print("11.5 ❤️❤️❤️❤️❤️")

        // 12. 使用继承解析
        let inheritJsonDic = ["comments":"xxx","style":"ipa","brewery":"x","created_at":524716294.793119,"bottle_sizes":[2.3,3.6],"abv": 524716294.793119,"name":"name"] as [String : Any]

        let inheritJsonData = try? JSONSerialization.data(withJSONObject: inheritJsonDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let inheritDecoder = JSONDecoder()
        do {
           let beer = try inheritDecoder.decode(BeerClass.self, from: inheritJsonData!)
            print("解析成功： \(String(describing: beer.abv))")
        } catch {
            print("解析失败：",error)
        }
        
        
        print("11 ❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️")

        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear == bounds == ", view.bounds)
        print("viewWillAppear == frame == ", view.frame)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

