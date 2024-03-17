//
//  MyEditPetProfileViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/06/22.
//

import UIKit
import RxSwift
import RxCocoa

final class MyEditPetProfileViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyEditPetProfileViewModel
    private let disposeBag = DisposeBag()
    
    private let deleteProfileImageSubject = PublishSubject<Void>()
    private let selectProfileImageSubject = PublishSubject<UIImage>()
    
    init(viewModel: MyEditPetProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIComponents
    
    private lazy var rootView = MyEditPetProfileView()
    private var galleryAlertController: GalleryAlertController {
        let galleryAlertController = GalleryAlertController()
        galleryAlertController.delegate = self
        return galleryAlertController
    }
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        bindViewModel()
    }
    
    //MARK: - Custom Method
    
    private func bindUI() {
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                let zoocAlertVC = ZoocAlertViewController(.leavePage)
                zoocAlertVC.delegate = owner
                owner.present(zoocAlertVC, animated: false)
            }).disposed(by: disposeBag)
        
        rootView.profileImageButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.present(owner.galleryAlertController,animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = MyEditPetProfileViewModel.Input(
            nameTextFieldDidChangeEvent: rootView.nameTextField.rx.controlEvent(.editingChanged).map { [weak self] _ in
                self?.rootView.nameTextField.text ?? "" }
                .asObservable(),
            editButtonTapEvent: self.rootView.completeButton.rx.tap.asObservable().map { [weak self] _ in
                self?.rootView.profileImageButton.currentImage ?? nil
            },
            deleteButtonTapEvent: deleteProfileImageSubject.asObservable(),
            selectImageEvent: selectProfileImageSubject.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.ableToEditProfile
            .asDriver()
            .drive(with: self, onNext: { owner, canEdit in
                owner.rootView.completeButton.isEnabled = canEdit
            }).disposed(by: disposeBag)
        
        output.textFieldState
            .asDriver()
            .drive(with: self, onNext: { owner, state in
                owner.rootView.nameTextField.textColor = state.textColor
            }).disposed(by: disposeBag)
        
        output.isEdited
            .asDriver(onErrorJustReturn: Bool())
            .drive(with: self, onNext: { owner, isEdited in
                if isEdited { owner.dismiss(animated: true) }
                else { owner.showToast("다시 시도해주세요", type: .bad)}
            }).disposed(by: disposeBag)
        
        output.petProfileData
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, profileData in
                guard let profileData else { return }
                owner.updateUI(profileData)
            }).disposed(by: disposeBag)
        
        output.isTextCountExceeded
            .subscribe(with: self, onNext: { owner, isTextCountExceeded in
                if isTextCountExceeded { owner.updateTextField(owner.rootView.nameTextField) }
            }).disposed(by: disposeBag)
    }
}

//MARK: - GalleryAlertControllerDelegate

extension MyEditPetProfileViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        present(imagePickerController, animated: true)
    }
    
    func deleteButtonDidTap() {
        deleteProfileImageSubject.onNext(())
    }
}

//MARK: - UIImagePickerControllerDelegate

extension MyEditPetProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        selectProfileImageSubject.onNext(image)
        dismiss(animated: true)
    }
}

//MARK: - ZoocAlertViewControllerDelegate

extension MyEditPetProfileViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}

extension MyEditPetProfileViewController {
    private func updateTextField(_ textField: ZoocEditTextField?) {
        guard let textField = textField else { return }
        let fixedText = textField.text?.substring(from: 0, to:textField.textFieldType.limit-1)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.rootView.nameTextField.text = fixedText
            guard let fixedText else { return }
            self.rootView.numberOfNameCharactersLabel.text = "\(String(describing: fixedText.count))/4"
        }
    }
    
    private func updateUI(_ editProfileData: EditPetProfileRequest) {
        rootView.nameTextField.text = editProfileData.nickName
        rootView.numberOfNameCharactersLabel.text = "\(editProfileData.nickName.count)/4"
        if editProfileData.file != nil {
            rootView.profileImageButton.setImage(editProfileData.file, for: .normal)
        } else {
            rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        }
    }
}
