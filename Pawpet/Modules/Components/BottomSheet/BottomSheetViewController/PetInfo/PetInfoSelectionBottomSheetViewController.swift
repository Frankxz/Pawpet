//
//  PetInfoSearchSelectionViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit

class PetInfoSearchSelectionViewController: UIViewController {
    let petInfoView: PetInfoSelectionView
    let colorSelectVC = ColorSelectionBottomSheetViewController(isForSearch: true)
    
    var callBack: ()->() = {}

    init(petType: PetType, isForSearch: Bool = false) {
        self.petInfoView = PetInfoSelectionView(petType: petType, isForSearch: isForSearch)
        self.petInfoView.isOnlyOneSelect = !isForSearch
        super.init(nibName: nil, bundle: nil)
    }

    init() {
        self.petInfoView = PetInfoSelectionView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        petInfoView.colorSelectButton.addTarget(self, action: #selector(selectColorButtonTapped), for: .touchUpInside)
        petInfoView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        petInfoView.promptView.setupTitles(title: "Detail info selection",
                                           subtitle: "Please select the desired search parameters")
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        view.addSubview(petInfoView)
        petInfoView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(100)
        }

        petInfoView.nextButton.snp.removeConstraints()
        petInfoView.nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(70)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}

// MARK: - Button logic
extension PetInfoSearchSelectionViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        callBack()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Color Selection
extension PetInfoSearchSelectionViewController: ColorSelectionDelegate {
    func didSelectColor(colorType: PetColorType) {
        if !colorSelectVC.selectedColors.isEmpty {
            updateButtonTitle(colorType: colorType)
            petInfoView.isColorChosen = true
            petInfoView.checkSelection()
        }
    }

    @objc private func selectColorButtonTapped() {
        colorSelectVC.isForSearch = true
        colorSelectVC.colorDelegate = self
        colorSelectVC.modalPresentationStyle = .overCurrentContext
        present(colorSelectVC, animated: false)
    }

    func updateButtonTitle(colorType: PetColorType) {
        let customAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.systemBlue]

        if colorSelectVC.selectedColors.count == 1 {
            let saveButtonTitle = NSAttributedString(string: colorType.rawValue.localize(), attributes: customAttributes)
            petInfoView.colorSelectButton.setAttributedTitle(saveButtonTitle, for: .normal)
        } else {
            var colorString = "\(colorSelectVC.selectedColors.count) выбрано"
            let saveButtonTitle = NSAttributedString(string: colorString, attributes: customAttributes)
            petInfoView.colorSelectButton.setAttributedTitle(saveButtonTitle, for: .normal)
        }
    }
}

