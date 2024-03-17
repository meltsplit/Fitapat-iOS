//
//  CustomDetailUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2/5/24.
//
import Foundation

import RxSwift
import RxCocoa

protocol CustomDetailUseCase {
    var keywordData : PublishRelay<[(CustomKeywordType, PromptDTO?)]> { get }
    var detailCharacterData: BehaviorRelay<DetailCustomEntity?> { get }

    func getDetailCustomData(_ detailType: CustomType)
    func checkTicketState() -> Observable<TicketState>
}
