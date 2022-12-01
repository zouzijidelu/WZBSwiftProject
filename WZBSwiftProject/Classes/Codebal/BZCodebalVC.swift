//
//  BZCodebalVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2022/4/22.
//  Copyright © 2022 iTalkBB. All rights reserved.
//

import UIKit
struct Location: Codable {
    var x: Double
    var y: Double
    var z: Double
    
    init(from decoder: Decoder) throws{
        var contaioner = try decoder.unkeyedContainer()
        
        self.x = try contaioner.decode(Double.self)
        self.y = try contaioner.decode(Double.self)
        self.z = try contaioner.decode(Double.self)
    }
}

struct RawSeverResponse: Codable{
    var location: Location
}


class BZCodebalVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let jsonString = """
        {
            "location": [20, 10,230]
        }
        """

        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        let result = try? decoder.decode(RawSeverResponse.self, from: jsonData!)
        print(result?.location.z)
    }


    
    @IBAction func convertToModel(_ sender: Any) {
        let jsonString = """
        [
            {
                "name": "Kody",
                "className": "Swift",
                "courceCycle": 12
            },{
                "name": "Cat",
                "className": "强化班",
                "courceCycle": 15
            },{
                "name": "Hank",
                "className": null,
                "courceCycle": 22
            },{
                "name": "Cooci",
                "className": "大师班",
                "courceCycle": 22
            }
        ]
        """
        let messageItem = """
                {"id":106,"data":{"target_type":"page","target":{"root_id":"","category_id":null,"series_id":"","episode_id":"","page_id":"","url":"","title":""}},"message":{"title":"VIP小助手","body":"您已成功开通1个月VIP会员，首次开通享0日免费试用！首次扣款日期为2022-04-18。","image_url":""},"status":0,"created_at":1650534289071}
                """
        
        let j = """
            {"list":[{"id":106,"data":{"target_type":"page","target":{"root_id":"","category_id":null,"series_id":"","episode_id":"","page_id":"","url":"","title":""}},"Message":{"title":"VIP小助手","body":"您已成功开通1个月VIP会员，首次开通享0日免费试用！首次扣款日期为2022-04-18。","image_url":""},"status":0,"created_at":1650534289071},{"id":15,"data":{"target_type":"page","target":{"root_id":"","category_id":null,"series_id":"","episode_id":"","page_id":"","url":"","title":""}},"Message":{"title":"VIP小助手","body":"您已成功开通1个月VIP会员，首次开通享0日免费试用！首次扣款日期为2022-04-18。","image_url":""},"status":0,"created_at":1650331977504},{"id":8,"data":{"target_type":"page","target":{"root_id":"","category_id":null,"series_id":"","episode_id":"","page_id":"","url":"","title":""}},"Message":{"title":"VIP小助手","body":"您已成功开通1个月VIP会员，首次开通享0日免费试用！首次扣款日期为2022-04-18。","image_url":""},"status":0,"created_at":1650331645581}],"page":1,"size":20,"sys_msg_unread_count":3,"total":3,"usr_msg_unread_count":3}
            """
        let messageMessage = """
                {"title":"VIP小助手","body":"您已成功开通1个月VIP会员，首次开通享0日免费试用！首次扣款日期为2022-04-18。","image_url":""}
"""
        let j3 = """
            {
                "name": "Cooci",
                "className": "大师班",
                "courceCycle": 22
            }
"""
        let messageData = """
                {"target_type":"page","target":{"root_id":"","category_id":null,"series_id":"","episode_id":"","page_id":"","url":"","title":""}}
"""
        let modelData = messageMessage.data(using:.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = modelData {
            let result = try? decoder.decode(HXMessageItem.self, from: data)
            print(result ?? "解析失败")
            print("end")
        }
    }
    
}
