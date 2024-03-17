//
//  CustomCollectionViewLayout.swift
//  ZOOC
//
//  Created by 류희재 on 1/28/24.
//

import UIKit

enum CustomCollectionViewLayout {
    case concept
    case conceptItem
    case conceptDetail
    case album
    case albumItem
}

extension CustomCollectionViewLayout {
    var defaultEdgeInsets: NSDirectionalEdgeInsets {
        get {
            NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
    }
    
    var itemSize: NSCollectionLayoutSize {
        switch self {
        case .concept:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        case .conceptItem:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        case .album:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        case .albumItem:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        case .conceptDetail:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        }
    }
    
    var itemEdgeInsets: NSDirectionalEdgeInsets {
        switch self {
        case .concept:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0)
        case .conceptItem:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7)
        case .album:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 43, trailing: 0)
        case .albumItem:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        case .conceptDetail:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        }
    }
    
    var groupSize: NSCollectionLayoutSize {
        switch self {
        case .concept:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(382)
            )
        case .conceptItem:
            return NSCollectionLayoutSize(
                widthDimension: .estimated(163),
                heightDimension: .estimated(234)
            )
        case .album:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(511)
            )
        case .albumItem:
            return NSCollectionLayoutSize(
                widthDimension: .estimated(319),
                heightDimension: .fractionalHeight(1.0)
            )
        case .conceptDetail:
            return NSCollectionLayoutSize(
                widthDimension: .estimated(UIScreen.main.bounds.width),
                heightDimension: .estimated(86)
            )
        }
    }
    
    var groupEdgeInsets: NSDirectionalEdgeInsets {
        switch self {
        case .concept: return defaultEdgeInsets
        case .conceptItem: return defaultEdgeInsets
        case .album: return defaultEdgeInsets
        case .albumItem: return defaultEdgeInsets
        case .conceptDetail: return defaultEdgeInsets
        }
    }
    
    var headerSize: NSCollectionLayoutSize? { return nil }
    
    var header: NSCollectionLayoutBoundarySupplementaryItem? { return nil
    }
    
    var headerEdgeInsets: NSDirectionalEdgeInsets {
        return defaultEdgeInsets
    }
    
    var footerSize: NSCollectionLayoutSize? { return nil }
    
    var footer: NSCollectionLayoutBoundarySupplementaryItem? { return nil }
    
    var footerEdgeInsets: NSDirectionalEdgeInsets {
        return defaultEdgeInsets
    }
    
    var sectionBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior  {
        switch self {
        case .concept: return .none
        case .conceptItem: return .continuous
        case .album: return .none
        case .albumItem: return .continuous
        case .conceptDetail: return .none
        }
    }
    
    var sectionEdgeInsets: NSDirectionalEdgeInsets {
        switch self {
        case .concept:
            return NSDirectionalEdgeInsets(top: 0, leading: 28, bottom: 40, trailing: 0)
        case .conceptItem:
            return defaultEdgeInsets
        case .album:
            return NSDirectionalEdgeInsets(top: 0, leading: 28, bottom: 0, trailing: 0)
        case .albumItem:
            return defaultEdgeInsets
        case .conceptDetail:
            return NSDirectionalEdgeInsets(top: 0, leading: 28, bottom: 0, trailing: 0)
        }
    }
    
    var section: NSCollectionLayoutSection {
        switch self {
        case .concept: return self.createSection()
        case .conceptItem: return self.createSection()
        case .album: return self.createSection()
        case .albumItem: return self.createSection()
        case .conceptDetail: return self.createSection()
        }
    }
    
    func createSection() -> NSCollectionLayoutSection {
        var supplementaryItem: [NSCollectionLayoutBoundarySupplementaryItem] = []
        
        let item = NSCollectionLayoutItem(layoutSize: self.itemSize)
        item.contentInsets = self.itemEdgeInsets
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: self.groupSize, subitems: [item])
        group.contentInsets = self.groupEdgeInsets
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = sectionBehavior
        
        section.contentInsets = self.sectionEdgeInsets
        
        if let header = self.header {
            header.contentInsets = self.headerEdgeInsets
            supplementaryItem.append(header)
        }
        
        if let footer = self.footer {
            footer.contentInsets = self.footerEdgeInsets
            supplementaryItem.append(footer)
        }
        
        section.boundarySupplementaryItems = supplementaryItem
        return section
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(section: self.section)
        return layout
    }
}

