//
//  UIViewController+.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/21.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func showButtonToast(_ message: String, 
                         with buttonMessage: String,
                         delegate: ButtonToastDelegate?) {
        
        DispatchQueue.main.async {    
            guard let window = UIApplication.shared.firstWindow else { return }
            
            let toast = ButtonToast(message, with: buttonMessage)
            toast.isUserInteractionEnabled = true
            toast.delegate = delegate
            
            window.addSubview(toast)
            window.bringSubviewToFront(toast)
            
            toast.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(window.safeAreaInsets.bottom + 86)
            }
            
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
                toast.alpha = 1.0
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
                    toast.alpha = 0.0
                }, completion: {_ in
                    toast.removeFromSuperview()
                })
            }
        }
    }
    
    func showToast(_ message: String,
                   view: UIView? = UIApplication.shared.firstWindow,
                   bottomInset: CGFloat = 86
    ) {
        guard let view else { return }
        Toast().show(message: message,
                     view: view,
                     bottomInset: bottomInset
        )
    }
    
    func presentToast(_ message: String) {
        guard let view = UIApplication.shared.firstWindow else { return }
        Toast().show(message: message,
                     view: view,
                     bottomInset: 86
        )
    }
    
    func presentToastAtTop(_ message: String) {
        guard let view = UIApplication.shared.firstWindow else { return }
        Toast().show(message: message,
                     view: view,
                     topInset: 65)
    }
    
    
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification ,
                                               object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func addKeyboardNotifications(view: UIView){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification ,
                                               object: view)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: view)
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification ,
                                                  object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    func dismissKeyboardWhenTappedAround(cancelsTouchesInView: Bool = false) {
        print(#function)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = cancelsTouchesInView
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK: - Action Method
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        // 키보드의 높이만큼 화면을 올려준다.
        print("키보드 올라감")
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        if let view = notification.object as? UIView{
            view.frame.origin.y -= keyboardHeight
        }
        guard view.frame.origin.y == 0 else { return }
        self.view.frame.origin.y -= keyboardHeight
        Device.keyBoardHeight = keyboardHeight
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc private func keyboardWillHide(_ notification: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        print("키보드 내려감")
        
        if let view = notification.object as? UIView{
            view.frame.origin.y += Device.keyBoardHeight

        } else {
            guard view.frame.origin.y < 0 else { return }
            self.view.frame.origin.y += Device.keyBoardHeight
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          dismissKeyboard()
    }
    
    
  
    func presentSafariViewController(_ url: String) {
        guard let url = URL(string: url) else {
            self.showToast("잘못된 URL 입니다.")
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .fullScreen
        self.present(safariViewController, animated: true)
    }
}
