//
//  CustomUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2/2/24.
//

import Foundation

import RxSwift
import RxCocoa

protocol CustomUseCase {
    
    //컨셉
    var conceptItemData: PublishRelay<[ConceptItemEntity]> { get }
    var sampleCharacterData: PublishRelay<[[CharacterResult]]> { get }
    var conceptData: [CustomConceptResult] { get }
    
    //앨범
    var characterData: PublishRelay<[[String : [CustomCharacterResult]]]> { get }
    
    
    func getCustomData()
    func getConceptData()
    func getAlbumData()
    
    func checkTicketState() -> Observable<TicketState>
}

