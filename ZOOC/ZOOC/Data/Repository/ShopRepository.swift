//
//  ShopRepository.swift
//  ZOOC
//
//  Created by 장석우 on 11/18/23.
//

import Foundation

import RxSwift


//MARK: API 명세서 중 Route가 Shop인 데이터 대한 저장소 입니다.

protocol ShopRepository {
    func getPopularProducts() -> Observable<[PopularProductsDTO]>
}

struct DefaultShopRepository {
    
    //MARK: - Dependency

    private let shopService: ShopService
    
    //MARK: - Life Cycle

    init(
        shopService: ShopService
    ) {
        self.shopService = shopService
    }

}


extension DefaultShopRepository: ShopRepository {
    
    //MARK: - Shop Service
    
    func getPopularProducts() -> RxSwift.Observable<[PopularProductsDTO]> {
        shopService.getPopularProducts()
            .asObservable()
    }
    
}

