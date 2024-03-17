//
//  MySettingModel.swift
//  ZOOC
//
//  Created by 장석우 on 11/6/23.
//

import UIKit

struct MySettingModel {
    let title: String
    let icon: UIImage
}

extension MySettingModel {
    static var settingData: [MySettingModel] = [
        MySettingModel(
            title: "주문내역",
            icon: .zwImage(.ic_orderlist)
        ),
        MySettingModel(
            title: "알림설정",
            icon: .zwImage(.ic_settings)
        ),
        MySettingModel(
            title: "공지사항",
            icon: .zwImage(.ic_notice)
        ),
        MySettingModel(
            title: "문의하기",
            icon: .zwImage(.ic_inquiry)
        ),
        MySettingModel(
            title: "앱 정보",
            icon: .zwImage(.ic_info)
        ),
        MySettingModel(
            title: "로그아웃",
            icon: .zwImage(.ic_logout)
        )
    ]
}
