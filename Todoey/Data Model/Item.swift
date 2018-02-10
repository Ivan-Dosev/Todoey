//
//  Item.swift
//  Todoey
//
//  Created by Ivan Dimitrov on 9.02.18.
//  Copyright © 2018 Ivan Dosev Dimitrov. All rights reserved.
//

import Foundation
class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
