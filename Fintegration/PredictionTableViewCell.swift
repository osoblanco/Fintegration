//
//  PredictionTableViewCell.swift
//  Fintegration
//
//  Created by Hrach on 10/28/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class PredictionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    var entity: Entity! {
        didSet {
            guard let entity = entity else {
                return
            }
            descriptionLabel.text = entity.prediction.rawValue
            icon.image = entity.prediction.image
            descriptionLabel.textColor = entity.prediction.color
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib.init(nibName: "PredictCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PredCollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        self.backgroundColor = UIColor.lightGray
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entity.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PredCollectionCell", for: indexPath)
        let predCell = cell as! PredictCollectionViewCell
        predCell.article = entity.articles[indexPath.row]
        return cell
    }
    
            //1
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: 150, height: collectionView.frame.size.height)
        }
}
