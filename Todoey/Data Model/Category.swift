//
//  Category.swift
//  Todoey
//
//  Created by Ivan Dimitrov on 16.02.18.
//  Copyright © 2018 Ivan Dosev Dimitrov. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
