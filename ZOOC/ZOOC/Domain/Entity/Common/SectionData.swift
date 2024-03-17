//
//  SectionData.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/30.
//

import Foundation
import RxDataSources

struct SectionData<T> {
    var items: [T]
}

extension SectionData: SectionModelType {
    typealias Item = T
    
    init(original: SectionData, items: [T]) {
        self = original
        self.items = items
    }
}
