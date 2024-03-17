//
//  UIImage.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/12.
//

import UIKit

//MARK: - 해당 Enum은 asset에 저장된 이미지와 이름이 동일해야 합니다!

public enum ZwImageName: String {
    
    case btn_checkbox_fill
    case btn_checkbox
    case btn_minus
    case btn_picture
    case btn_plus
    case btn_productdelete
    case btn_x
    
    case default_image
    case default_profile
    
    case empty
    case featuredImage
    case gallery
    case graphics
    case graphics_notyet
    
    case ic_apple
    case ic_back
    case ic_cart
    case ic_dropdown
    case ic_exit
    case ic_explore_tint
    case ic_explore
    case ic_home_tint
    case ic_home
    case ic_info
    case ic_inquiry
    case ic_kakao
    case ic_logout
    case ic_my_tint
    case ic_my
    case ic_notice
    case ic_orderlist
    case ic_settings
    case ic_warning
    case ic_minicheck
    case ic_plus_mini
    case ic_lock
    
    case logo
    
    case mock_deprecated1
    case mock_deprecated2
    case mock_deprecated3
    case mock_hidi
    case mock_seokwoo
    case mockfeaturedImage
    
    case next
    case x_toast
    case xmark_white
    
    //MARK: Bank Logo
    case toss
    case kakaopay
    case kakaobank
    case kbstarbanking
    case banksalad
}

//MARK: - 사용할땐

extension UIImage {
    
    static func zwImage(_ imageName: ZwImageName) -> UIImage {
        return UIImage(named: imageName.rawValue)!
    }
    
}


