//
//  MyUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol MyUseCase {
    var profileData: PublishRelay<PetResult> { get }
    var logoutSuccess: PublishRelay<Bool> { get }
    var deleteAccountSuccess: PublishRelay<Bool> { get }
    
    func requestMyPage()
    func logout()
    func deleteAccount()
}
