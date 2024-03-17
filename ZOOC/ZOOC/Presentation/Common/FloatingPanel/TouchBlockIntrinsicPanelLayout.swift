//
//  TouchBlockIntrinsicPanelLayout.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import Foundation
import FloatingPanel

final class TouchBlockIntrinsicPanelLayout: FloatingPanelBottomLayout {
    override var initialState: FloatingPanelState { .full }
    override var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelIntrinsicLayoutAnchor(fractionalOffset: 0, referenceGuide: .safeArea)
        ]
    }

    override func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        0.5
    }
}
