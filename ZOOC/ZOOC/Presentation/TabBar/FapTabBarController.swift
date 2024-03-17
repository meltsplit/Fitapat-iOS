//
//  ZoocTabBarController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/25.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

class FapTabBarController: UITabBarController {
    
    private let disposeBag = DisposeBag()
    private let petRepository = DefaultPetRepository.shared
    
    //MARK: - Properties
    
    let uploadingToastController = DIContainer.shared.makeUploadingToastController()
    
    //MARK: - ViewControllers
    
    let shopViewController = DIContainer.shared.makeFapWebVC(path: "")
    let customViewController = DIContainer.shared.makeCustomVC()
    let myViewController = DIContainer.shared.makeMyVC()
    
    
    lazy var shopNavigationContrller = UINavigationController(rootViewController: shopViewController)
    lazy var customNavigationController = UINavigationController(rootViewController: customViewController)
    lazy var myNavigationController = UINavigationController(rootViewController: myViewController)
    
    
    //MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        object_setClass(self.tabBar, FapTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setTabBar()
        setTabBarItems()
        setViewControllers()
        selectedIndex = 1
    }
    
    //MARK: - Custom Method
    
    private func setTabBar(){
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        tabBar.backgroundColor = .zw_tabbar_backgound
        tabBar.tintColor = .zw_black
        tabBar.itemPositioning = .centered
        
        tabBar.makeShadow(color: .black.withAlphaComponent(0.05),
                          offset: .zero,
                          radius: 30,
                          opacity: 1)
    }
    
    private func setTabBarItems() {
        shopNavigationContrller.tabBarItem = UITabBarItem(title: nil,
                                                          image: .icHome,
                                                          selectedImage: .icHomeTint)
        
        customNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                             image: .icExplore,
                                                             selectedImage: .icExploreTint)
        
        myNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                         image: .icMy,
                                                         selectedImage: .icMyTint)
        
        shopNavigationContrller.tabBarItem.imageInsets = .init(top: 8, left: 25, bottom: -8, right: -25)
        customNavigationController.tabBarItem.imageInsets = .init(top: 10, left: 0, bottom: -10, right: 0)
        myNavigationController.tabBarItem.imageInsets = .init(top: 8, left: -25, bottom: -8, right: 25)
        
    }
    
    private func setViewControllers(){
        
        viewControllers = [shopNavigationContrller,
                           customNavigationController,
                           myNavigationController]
    }
    
}


extension FapTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let impactService = Haptic.impact(.light)
        impactService.run()
    }
}



final class FapTabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        var sizeThatFits = super.sizeThatFits(size)
        
        sizeThatFits.height = 110
        
        return sizeThatFits
        
    }
    
}
