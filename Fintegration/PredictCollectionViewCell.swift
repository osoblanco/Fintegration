//
//  PredictCollectionViewCell.swift
//  Fintegration
//
//  Created by Hrach on 10/28/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import UIKit

class PredictCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var urlLabel: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var article: Article! {
        didSet{
            guard let article = article else {
                return
            }
            urlLabel.text = article.url
            descriptionLabel.text = article.description
            titleLabel.text = article.title
            icon.image = UIImage(named: article.image)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
