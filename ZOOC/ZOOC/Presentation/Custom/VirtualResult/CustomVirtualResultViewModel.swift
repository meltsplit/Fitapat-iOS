//
//  CustomVirtualResultViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 12/23/23.
//

import Foundation

import RxSwift
import RxRelay

final class CustomVirtualResultViewModel: ViewModelType {
    
    //MARK: - Dependency
    
    private var petRepository: PetRepository
    private var shopRepository: ShopRepository
    private var customRepository: CustomRepository
    
    //MARK: - Properties
    
    private let initData: MakeCharacterResult
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let productCellDidTap: Observable<PopularProductsDTO>
        let applyButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let productData = PublishRelay<[PopularProductsDTO]>()
        let virtualPetImageData = PublishRelay<String>()
        let pushToProductWebVC = PublishRelay<(String, MakeCharacterResult)>()
        let showToast = PublishRelay<String>()
    }
    
    //MARK: - Life Cycle
    
        init(
            petRepository: PetRepository,
            customRepository: CustomRepository,
            shopRepository: ShopRepository,
            initData: MakeCharacterResult
        ) {
            self.petRepository = petRepository
            self.customRepository = customRepository
            self.shopRepository = shopRepository
            self.initData = initData
        }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .flatMap(shopRepository.getPopularProducts)
            .bind(to: output.productData)
            .disposed(by: disposeBag)
        
        input.viewDidLoadEvent
            .map { self.initData.image }
            .bind(to: output.virtualPetImageData)
            .disposed(by: disposeBag)

        input.productCellDidTap
            .map { ("/product/custom/\($0.id)?prev=inApp", self.initData) }
            .bind(to: output.pushToProductWebVC)
            .disposed(by: disposeBag)
        
        input.applyButtonDidTap
            .map { _ in ("/custom", self.initData) }
            .bind(to: output.pushToProductWebVC)
            .disposed(by: disposeBag)
        
        return output
    }
}
