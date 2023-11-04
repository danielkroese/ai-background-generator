//
//  Item.swift
//  Psycheros
//
//  Created by Daniël Kroese on 04/11/2023.
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
