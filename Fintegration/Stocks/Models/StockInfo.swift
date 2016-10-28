//
//  StockInfo.swift
//  Fintegration
//
//  Created by Hrach on 10/28/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import Foundation
import Gloss

struct StockInfo: Decodable {
    let symbol: String
    let name: String
    let exchange: String
    let assetType: String
    
    init?(json: JSON) {
        self.symbol = "symbol" <~~ json ?? ""
        self.name = "name" <~~ json ?? ""
        self.exchange = "exchDisp" <~~ json ?? ""
        self.assetType = "typeDisp" <~~ json ?? ""
    }
}
