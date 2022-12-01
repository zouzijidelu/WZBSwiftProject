//
//  BZCollectionVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2022/1/11.
//  Copyright © 2022 iTalkBB. All rights reserved.
//

import UIKit

class BZCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}
