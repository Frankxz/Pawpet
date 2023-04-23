//
//  AgeSelectionBottomSheetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit

class AgeSelectionBottomSheetViewController: BottomSheetViewController {

    private let ageSelectionView = AgeSelectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupNavigationAppearence()
    }
}

// MARK: - UI + Cosntraints
extension AgeSelectionBottomSheetViewController {
    private func setupView() {
        ageSelectionView.promptView.setupTitles(title: "Select pet's age", subtitle: "Please, if you want to find puppy, set the year and month values to be zero.")
        ageSelectionView.nextButton.setupTitle(for: "Select")
        ageSelectionView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }

    private func setupConstraints() {
        containerView.addSubview(ageSelectionView)
        ageSelectionView.nextButton.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(430)
            make.height.equalTo(70)
        }
        ageSelectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - Button logic
extension AgeSelectionBottomSheetViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animateDismissView()
        }
    }
}
