//
//  UICollectionView+.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/06.
//

import UIKit

extension UICollectionView {
    func selectCell(row: Int,
                    section: Int = 0) {
        self.selectItem(at: IndexPath(row: row, section: section),
                        animated: true,
                        scrollPosition: .centeredVertically)
        
    }
    
    func deselectCell(row: Int,
                      section: Int = 0) {
        self.deselectItem(at: IndexPath(row: row, section: section),
                          animated: true)
      }
}
