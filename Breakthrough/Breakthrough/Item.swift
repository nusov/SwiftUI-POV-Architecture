//
//  Item.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/22/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
