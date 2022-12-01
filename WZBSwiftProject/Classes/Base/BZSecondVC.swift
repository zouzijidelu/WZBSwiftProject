//
//  BZSecondVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/12/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZSecondVC: UIViewController  {

    @IBOutlet weak var img: UIImageView!    
    var tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var wheelView: BZWheelView = BZWheelView()
    var data:[String] = ["12","13","14","15","16","17","18","19","12","13","14","15","16","17","18","19"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        //initUI()
        addButtonWithAnimation()
    }
    func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.rowHeight = 100
        self.view.addSubview(tableView)
        wheelView = BZWheelView(frame: CGRect(x: 0, y: 100, width: 40, height: 40))
        wheelView.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        wheelView.borderWidth = 1
        wheelView.backgroundColor = UIColor.blue
        
        wheelView.contents = data
        wheelView.isUserInteractionEnabled = false
        self.view.addSubview(wheelView)
        //let view = UIView(frame: <#T##CGRect#>)
        setViewAtTabbarView()
    }
    
    func setViewAtTabbarView() {
        var parentController = self.parent
        while !(parentController is UITabBarController) {
            if parentController?.parent == nil { return }
            parentController = parentController?.parent
        }
        let tabbarControlelr = parentController as! UITabBarController
        var controllerIndex = -1
        findControllerIndexLoop: for (i, child) in tabbarControlelr.children.enumerated() {
            var stack = [child]
            while stack.count > 0 {
                let count = stack.count
                for j in stride(from: 0, to: count, by: 1) {
                    if stack[j] is Self {
                        controllerIndex = i
                        break findControllerIndexLoop
                    }
                    for vc in stack[j].children {
                        stack.append(vc)
                    }
                }
                for _ in 1...count {
                    stack.remove(at: 0)
                }
            }
        }
        if controllerIndex == -1 { return }
        let tabBarButtons = tabbarControlelr.tabBar.subviews.filter({
            type(of: $0).description().isEqual("UITabBarButton")
        })
        guard !tabBarButtons.isEmpty else { return }
        let tabBarButton = tabBarButtons[controllerIndex]
        let swappableImageViews = tabBarButton.subviews.filter({
            type(of: $0).description().isEqual("UITabBarSwappableImageView")
        })
        guard !swappableImageViews.isEmpty else { return }
        let swappableImageView = swappableImageViews.first!
        tabBarButton.addSubview(wheelView)
        swappableImageView.isHidden = true
        NSLayoutConstraint.activate([
            wheelView.widthAnchor.constraint(equalToConstant: 25),
            wheelView.heightAnchor.constraint(equalToConstant: 25),
            wheelView.centerXAnchor.constraint(equalTo: swappableImageView.centerXAnchor),
            wheelView.centerYAnchor.constraint(equalTo: swappableImageView.centerYAnchor)
        ])
    }
    
    func addButtonWithAnimation() {
        let image = UIImage.animatedImageNamed("test", duration: 2.0)
        
        let btn1 = UIButton(type: .custom)
        btn1.frame = CGRect(x:20, y:100, width:320, height:36)
        btn1.setImage(image, for: .normal)
        btn1.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        self.view.addSubview(btn1)
    }
    
    @objc func click() {
        
    }
    
    // 利用拖线的方式生成 button 的方法
        @IBAction func dazhao()
        {
            // 调用自定义的方法
            imageAnimation(imageV: &img, imageName: "热点_000", imageNumber: 55)
        }
        
        @IBAction func xiaoZhao() {
            imageAnimation(imageV: &img, imageName: "热点_000", imageNumber: 55)
        }
        
    
    // 定义的动画方法
    func imageAnimation(imageV: inout UIImageView, imageName: String, imageNumber: Int)
    {
        
        // 声明一个空的 image 数组
        var imgArray:[UIImage]! = []
        for i in 0..<imageNumber
        {
            var tempName = imageName
            // 拼接名称
            if i<10 { tempName += "0" }
            let name: String? = tempName + "\(i)"
            // 获取app中的图片 参数是:可选值Optionals
            
            // 根据路径获得图片
            let image: UIImage? = UIImage(named: name!)
            // 往数组中添加图片
            imgArray.append(image!)
        }
        // 给动画数组赋值
        imageV.animationImages = imgArray
        // 设置重复次数, 学过的都知道...0 代表无限循环,其他数字是循环次数,负数效果和0一样...
        imageV.animationRepeatCount = 1
        // 动画完成所需时间
        imageV.animationDuration = 1.2
        // 开始动画
        imageV.startAnimating()

    }
    
}


// MARK: UITableViewDelegate
extension BZSecondVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")
//        if let hotwordCell = cell as? DFSearchHotwordCell {
//            hotwordCell.index = indexPath.row + 1
//            if (0..<(hotwords?.count ?? 0)) ~= indexPath.row {
//                hotwordCell.titleLabel.text = hotwords![indexPath.row].title
//                hotwordCell.trend = hotwords![indexPath.row].trend ?? 0
//            }
//
//        }
        cell?.textLabel?.text = data[indexPath.row]
        cell?.textLabel?.textColor = .black
        return cell ?? UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //`progress`怎么计算取决于你需求，这里的是为了把`tableview`当前可见区域最底部的2个数字给显示出来。
        let progress = Float((scrollView.contentOffset.y + tableView.bounds.height - tableView.rowHeight) / scrollView.contentSize.height)
        wheelView.progress = progress
    }
    
    
}
