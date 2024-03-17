//
//  ChooseConceptViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 1/29/24.
//

import Foundation

import RxSwift
import RxRelay

final class ChooseConceptViewModel: ViewModelType {
    
    //MARK: - Dependency
    
    private let customRepository: CustomRepository
    private let userRepository: UserRepository
    
    //MARK: - Properties
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewWillAppear: Observable<Void>
        let conceptCellDidTap: Observable<CustomConceptResult>
    }
    
    struct Output {
        let conceptData = PublishRelay<[SectionData<CustomConceptResult>]>()
        let ticketData = PublishRelay<Int>()
        let pushToMakePromptVC = PublishRelay<CustomConceptResult>()
    }
    
    //MARK: - Life Cycle
    
        init(
            customRepository: CustomRepository,
            userRepository: UserRepository
        ) {
            self.customRepository = customRepository
            self.userRepository = userRepository
        }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .flatMap(customRepository.getConcept)
            .map {
                var data = $0
                
                if data.count % 2 != 0 {
                    data.append(.commingSoon())
                }
                
                return data
            }
            .map { [SectionData(items: $0)] }
            .bind(to: output.conceptData)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .flatMap(userRepository.getTicket)
            .bind(to: output.ticketData)
            .disposed(by: disposeBag)
        
        input.conceptCellDidTap
            .filter { $0 != .commingSoon() }
            .bind(to: output.pushToMakePromptVC)
            .disposed(by: disposeBag)
        
        return output
    }
}
