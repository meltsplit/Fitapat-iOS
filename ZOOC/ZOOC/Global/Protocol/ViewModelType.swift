//
//  ViewModelType.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/09.
//

import Foundation

import RxSwift

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    func transform(from input: Input, disposeBag: DisposeBag) -> Output
}

