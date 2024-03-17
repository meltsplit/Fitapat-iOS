//
//  Toast.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/07.
//

import UIKit

import SnapKit


final class Toast: UIView {
    
    func show(
        message: String,
        view: UIView,
        bottomInset: CGFloat)
    {
        let safeAreaBottomInset = UIApplication.shared.firstWindow?.safeAreaInsets.bottom ?? 0
        let toastLabel = UILabel()
        
        self.backgroundColor = .zw_black
        self.alpha = 1
        self.setBorder(width: 1, color: .zw_black)
        self.isUserInteractionEnabled = false
        
        
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = .zw_Subhead4
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.sizeToFit()
    
        
        view.addSubview(self)
        self.addSubviews(toastLabel)
        
        
        self.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(safeAreaBottomInset + bottomInset)
        }
        
        toastLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1, delay: 1.8, options: .curveEaseOut, animations: {
                self.alpha = 0.0
            }, completion: {_ in
                self.removeFromSuperview()
            })
        })
    }
    
    func show(message: String,
              view: UIView,
              topInset: CGFloat) {
        let safeAreaBottomInset = UIApplication.shared.firstWindow?.safeAreaInsets.bottom ?? 0
        let toastLabel = UILabel()
        
        self.backgroundColor = .zw_black
        self.alpha = 1
        self.setBorder(width: 1, color: .zw_black)
        self.isUserInteractionEnabled = false
        
        
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = .zw_Subhead4
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.sizeToFit()
    
        
        view.addSubview(self)
        self.addSubviews(toastLabel)
    
        
        self.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(safeAreaBottomInset + topInset)
        }
        
        toastLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
        
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1, delay: 1.8, options: .curveEaseOut, animations: {
                self.alpha = 0.0
            }, completion: {_ in
                self.removeFromSuperview()
            })
        })
    }
    


}
