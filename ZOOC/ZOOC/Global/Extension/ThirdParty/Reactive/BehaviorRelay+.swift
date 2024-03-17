//
//  BehaviorRelay+.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/29.
//

import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection {

    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
    
    func remove(index: Element.Index) {
        var array = self.value
        array.remove(at: index)
        self.accept(array)
    }
}
