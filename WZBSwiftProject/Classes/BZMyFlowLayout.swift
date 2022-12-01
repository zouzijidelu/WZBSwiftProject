//
//  BZMyFlowLayout.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2022/1/11.
//  Copyright © 2022 iTalkBB. All rights reserved.
//

import UIKit

class BZMyFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func commonInit () {
        sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 10, right: 20)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 20
    }
    
    override func prepare() {
        let itemWidth = (UIScreen.main.bounds.width - 40 - 8*4)/5
        let itemHeight = itemWidth*155/105 + 10
        //DFOriginalRecommendLayout.itemHeight = CGFloat(itemHeight)
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
}
