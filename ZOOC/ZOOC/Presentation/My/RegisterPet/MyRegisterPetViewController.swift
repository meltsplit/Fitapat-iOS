//
//  MyRegisterPetViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/11/07.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class MyRegisterPetViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let petRepository: PetRepository
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = MyRegisterPetView()
    
    //MARK: - Life Cycle
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
        super.init(nibName: nil, bundle: nil)
        self.title = "반려동물 등록"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rootView.nameTextField.becomeFirstResponder()
        addNotification()
        dismissKeyboardWhenTappedAround(cancelsTouchesInView: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardNotifications()
    }
    
    //MARK: - Custom Method
    
    private func bindUI() {
        rootView.nameTextField.rx.text
            .orEmpty
            .map { $0.hasText }
            .subscribe(with: self, onNext: { owner, canRegister in
                owner.rootView.updateRegisterButtonUI(canRegister)
            }).disposed(by: disposeBag)
        
        rootView.nameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, name in
                owner.rootView.updateNameTextField(name)
            }).disposed(by: disposeBag)
        
        rootView.breedTextField.rx.text
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, breed in
                owner.rootView.updateBreedTextField(breed)
            }).disposed(by: disposeBag)
        
        rootView.registerPetButton.rx.tap
            .map { [weak self] _ in
                guard let name  = self?.rootView.nameTextField.text else { return false }
                return name.hasText
            }
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, canRegister in
                if canRegister { owner.pushToGenAIVC() } 
                else { owner.showToast("필수 정보를 입력해주세요") }
            }).disposed(by: disposeBag)
    }
}

extension MyRegisterPetViewController {
    func presentAlertViewController() {
        let fapAlertVC = FapAlertViewController(.leaveRegisterPage)
        fapAlertVC.delegate = self
        self.present(fapAlertVC, animated: false, completion: nil)
    }
    
    func pushToGenAIVC() {
        let genAIGuideVC = DIContainer.shared.makeGenAIGuideVC(
            name: self.rootView.nameTextField.text!,
            breed: self.rootView.breedTextField.text
        )
        self.navigationController?.pushViewController(genAIGuideVC, animated: true)
    }
}

extension MyRegisterPetViewController: FapAlertViewControllerDelegate {
    func leftButtonDidTap(_ alertType: FapAlertType) {
        self.dismiss(animated: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightButtonDidTap(_ alertType: FapAlertType) {
        return
    }
}






// 더보기...




// 더보기..





// 신성한 VC를 더렵혀서 죄송합니ㅏ 죄송합니다 죄송합니다ㅏ...
extension MyRegisterPetViewController {
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification ,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification){
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: duration){
            self.rootView.registerPetButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight - 20)
            }
            self.view.layoutIfNeeded()
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0,
                                         left: 0.0,
                                         bottom: 36,
                                         right: 0.0)
        
        rootView.scrollView.contentInset = contentInsets
    }
    
    
    @objc
    private func keyboardWillHide(notification: NSNotification){
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration){
            self.rootView.registerPetButton.snp.updateConstraints {
                $0.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
        
        rootView.scrollView.contentInset = .zero
    }
}
