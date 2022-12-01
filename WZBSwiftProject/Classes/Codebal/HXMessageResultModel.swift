//
//  HXMessageResultModel.swift
//  huanxin3
//
//  Created by zhibin wang on 2020/8/5.
//  Copyright © 2020 italktv. All rights reserved.
//

import UIKit

class HXMessageBundle: HXBaseModel {
    var total: Int = 0
    var page: Int? = 1
    var size: Int? = 0
    var sysMsgUnreadCount: Int?
    var usrMsgUnreadCount: Int?
    var list: [HXMessageItem]?
}

class HXMessageItem: HXBaseModel {
    var id: Int?
    var status: Int?
    var message: HXMessageMessage?
    var data: HXMessageData?
    var isSelected: Bool?
    var isRead: Bool? = false {
        didSet {
            if (isRead ?? false) && status != 0 {
                status = 0
            }
        }
    }
}

extension HXMessageItem {
    private enum CokingKeys: String, CodingKey {
        case id
        case status
        case message
        case data
    }
}

class HXMessageMessage: HXBaseModel {
    var title: String?
    var body: String?
    var imageUrl: String?
}


class HXMessageData: HXBaseModel {
    var targetType: String?
    var target: HXTargetInfo?
}


class HXMessageCount: HXBaseModel {
    var usrMsg: Int?
    var sysMsg: Int?
}


class HXTargetInfo: HXBaseModel {
    
    var rootid: String?
    var categoryId: String?
    var template: String?
    var seriesId: String?
    var episodeId: String?
    var title: String?
    var url: String?
    //dvr是否自动播放
    var autoPlay: Bool?
    var pageId: String?
    //合集信息 targetType为 series或episde时使用
    var score: Int?
    var episodeTotal: Int?
    var episodeCount: Int?
    var latestEpisodeName: String?
    var latestEpisodeShortname: String?
    var releaseAt: Double?
}

class BZTestModel: HXBaseModel {
    
    var name: String?
    var className: String?
    var courceCycle: Int?
    var test: String?
}

extension BZTestModel {
}
