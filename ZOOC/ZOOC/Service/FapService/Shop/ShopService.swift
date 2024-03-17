//
//  ShopService.swift
//  ZOOC
//
//  Created by 장석우 on 11/22/23.
//

import Foundation

import Moya
import RxMoya
import RxSwift

protocol ShopService {
    func getPopularProducts() -> Single<[PopularProductsDTO]>
}

struct DefaultShopService {  //TODO: struct로 해도 되나? class 말고 struct로 했을 때 부작용 뭐가 있지
    private var provider = MoyaProvider<ShopTargetType>(session: Session(interceptor: FapInterceptor.shared),
                                                        plugins: [MoyaLoggingPlugin()])
}

extension DefaultShopService: ShopService {
    
    func getPopularProducts() -> RxSwift.Single<[PopularProductsDTO]> {
        provider.rx.request(.getPopularProducts)
            .filterSuccessfulStatusCodes()
            .map([PopularProductsDTO].self)
    }
   
}
