//
//  BZXIB3Cell.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/29.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit
let XibVC3CollectionCellId = "XibVC3CollectionCellId"
class BZXIB3Cell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setBase()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBase() {
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 13.5, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: XibVC3CollectionCellId)
    }
}

extension BZXIB3Cell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XibVC3CollectionCellId, for: indexPath)

        if indexPath.row%2 == 0 {
            cell.backgroundColor = .orange
        } else {
            cell.backgroundColor = .blue
        }
        return cell
    }
}

extension BZXIB3Cell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexpath row : \(indexPath.row)")
    }
}

extension BZXIB3Cell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 163, height: 124)
    }
}
