//
//  XIBVC2.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit
let XibVC2CollectionCellId = "XibVC2CollectionCellId"
class XIBVC2: BZBaseVC {
    lazy var xibView:XIBView? = {
        let xv = Bundle.main.loadNibNamed("XIBView", owner: nil, options: nil)?.first as? XIBView
        xv?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
        return xv
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "XIBVC2"
        setBase()
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: XibVC2CollectionCellId)
        collectionView.setContentOffset(CGPoint(x: 100,y: 0), animated: false)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        print(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)//44
//        print(self.view.safeAreaInsets)//(top: 88.0, left: 0.0, bottom: 34.0, right: 0.0)
//        print(self.view.safeAreaInsets.top)
//        print(self.view.frame)
    }
    
    func testView() {
        print(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)//44
        print(self.view.safeAreaInsets)//(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        print(self.view.frame)
        //self.navigationController?.navigationBar.isHidden = true
        if let tempXibView = self.xibView {
            view.addSubview(tempXibView)
        }
    }
    @IBAction func click(_ sender: Any) {
        collectionView.setContentOffset(CGPoint(x: 100,y: 0), animated: false)
    }
}

extension XIBVC2: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XibVC2CollectionCellId, for: indexPath)

        if indexPath.row%2 == 0 {
            cell.backgroundColor = .orange
        } else {
            cell.backgroundColor = .blue
        }
        return cell
    }
}

extension XIBVC2: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension XIBVC2: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 163, height: 124)
    }
}
