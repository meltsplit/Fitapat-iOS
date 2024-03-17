//
//  TouchPassIntrinsicPanelLayout.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import Foundation

import FloatingPanel

final class TouchPassIntrinsicPanelLayout: FloatingPanelBottomLayout {
    override var initialState: FloatingPanelState { .tip }
    override var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelIntrinsicLayoutAnchor(fractionalOffset: 0, referenceGuide: .safeArea)
        ]
    }
}
