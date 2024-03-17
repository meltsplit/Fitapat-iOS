//
//  ProductOptionBottomSheet.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import UIKit

import SnapKit
import FloatingPanel

protocol ScrollableViewController where Self: UIViewController {
    var scrollView: UIScrollView { get }
}

final class BottomSheetViewController: FloatingPanelController {
    private let isTouchPassable: Bool
    
    init(isTouchPassable: Bool, contentViewController: ScrollableViewController) {
        self.isTouchPassable = isTouchPassable
        
        super.init(delegate: nil)
        setUpView(contentViewController: contentViewController)
        
//        if let bs = contentViewController as? ProductBottomSheet {
//            bs.updateHeightHandler = { [weak self] in
//                self?.view.layoutIfNeeded()
//                
//                UIView.animate(withDuration: 0.4) { [weak self] in
//                    self?.invalidateLayout()
//                }
//                
//            }
//        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setUpView(contentViewController: ScrollableViewController) {
        // Contents
        set(contentViewController: contentViewController)
        track(scrollView: contentViewController.scrollView)
        contentMode = .fitToBounds
        // Appearance
        let appearance = SurfaceAppearance().then {
            $0.cornerRadius = 6.0
            $0.backgroundColor = .white
            $0.borderColor = .clear
            $0.borderWidth = 0
        }
        
        // Surface
        surfaceView.grabberHandle.isHidden = false
        surfaceView.grabberHandle.backgroundColor = .zw_brightgray
        surfaceView.grabberHandleSize = .init(width: 40, height: 4)
        surfaceView.appearance = appearance
        
        // Backdrop
        backdropView.dismissalTapGestureRecognizer.isEnabled = isTouchPassable ? false : true
        let backdropColor = isTouchPassable ? UIColor.clear : .black
        backdropView.backgroundColor = backdropColor // alpha 설정은 FloatingPanelBottomLayout 델리게이트에서 설정
        
        // Layout
        let layout = isTouchPassable ? TouchPassIntrinsicPanelLayout() : TouchBlockIntrinsicPanelLayout()
        self.layout = layout
        
        // delegate
        delegate = self
    }
}

extension BottomSheetViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        let loc = fpc.surfaceLocation
        let minY = fpc.surfaceLocation(for: .full).y
        let maxY = fpc.surfaceLocation(for: .tip).y
        let y = isTouchPassable ? max(min(loc.y, minY), maxY) : min(max(loc.y, minY), maxY)
        fpc.surfaceLocation = CGPoint(x: loc.x, y: y)
        
        
    }
    
    // 특정 속도로 아래로 당겼을때 dismiss 되도록 처리
    public func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        guard velocity.y > 200 else { return }
        dismiss(animated: true)
    }
}
