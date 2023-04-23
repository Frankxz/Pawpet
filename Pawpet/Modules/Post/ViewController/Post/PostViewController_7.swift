//
//  PostViewController_7.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import UIKit
import PhotosUI
class PostViewController_7: UIViewController {
    
    // MARK: - PromptView
    private var promptView = PromptView(with: "Select photos of your pet",
                                        and: "Please select a photo of the published pet, it will help other users to be fascinated by it", titleSize: 32)
    
    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()
    
    // MARK: - CollectionView
    private lazy var photosCollectionView = PhotoCollectionView()
    private var selectedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationAppearence()
        photosCollectionView.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        setupConstraints()
        photosCollectionView.images = selectedImages
    }
}

// MARK: - UI + Constraints
extension PostViewController_7 {
    private func setupConstraints() {
        view.addSubview(nextButton)
        view.addSubview(promptView)
        view.addSubview(photosCollectionView)
        
        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }
        
        photosCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.bottom.equalTo(nextButton.snp.top).offset(-40)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}

// MARK: - Photos selection
extension PostViewController_7: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let error = error {
                        print("Failed to load image: \(error.localizedDescription)")
                        return
                    }
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.selectedImages.append(image)
                            self?.photosCollectionView.images = self!.selectedImages
                            self?.photosCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func pickerDidCancel(_ picker: PHPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Button logic
extension PostViewController_7 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(PostViewController_8(), animated: true)
        }
    }
    
    @objc private func addButtonTapped(_ sender: UIButton) {
        showPhotoPicker()
    }
    
    func showPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
}
