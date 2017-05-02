//
//  Entity.swift
//  Fintegration
//
//  Created by Hrach on 10/28/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import Foundation
import UIKit

enum PredictionResult: String {
    case Level1 = "An offer you cannot refuse"
    case Level2 = "Well, this guys seem to be doing fine"
    case Level3 = "I would be cautious here"
    case Level4 = "This stock is not in good shape"
    
    var image: UIImage? {
        switch self {
        case .Level1:
            return UIImage(named: "level.1")
        case .Level2:
            return UIImage(named: "level.2")
        case .Level3:
            return UIImage(named: "level.3")
        case .Level4:
            return UIImage(named: "level.4")
        }
    }
    
    var color: UIColor {
        switch self {
        case .Level1:
            return UIColor.green
        case .Level2:
            return UIColor(red: 0.44, green: 0.93, blue: 0.48, alpha: 1.0)
        case .Level3:
            return UIColor.orange
        case .Level4:
            return UIColor.red
        }
    }
}

struct Article{
    let title: String
    let description: String
    let url: String
    let image: String
    
    init(title: String, description: String, url: String, image: String){
        self.title = title
        self.description = description
        self.url = url
        self.image = image
    }
}

struct Entity{
    let prediction: PredictionResult
    let articles: [Article]
    
    init(pred: PredictionResult, articles: [Article]){
        self.prediction = pred
        self.articles = articles
    }
}
