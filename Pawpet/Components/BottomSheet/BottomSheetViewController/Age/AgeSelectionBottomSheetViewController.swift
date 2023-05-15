//
//  AgeSelectionBottomSheetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit

protocol AgeSelectionForSearchDelegate {
    func didSelectFrom(age: Int)
    func didSelectTo(age: Int)
}

class AgeSelectionBottomSheetViewController: BottomSheetViewController {

    let ageSelectionView = AgeSelectionView()
    var callback: ()->() = {}
    var isForSearch = false
    var isSelectFrom = false
    var paramsDelegate: AgeSelectionForSearchDelegate?

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
        ageSelectionView.promptView.setupTitles(title: "Select pet's age from", subtitle: "Please, if you want to find puppy, set the year and month values to be zero.")
        ageSelectionView.nextButton.setupTitle(for: "Select")
        ageSelectionView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }

    private func setupConstraints() {
        containerView.addSubview(ageSelectionView)
        ageSelectionView.nextButton.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(400)
            make.height.equalTo(70)
        }
        ageSelectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Button logic
extension AgeSelectionBottomSheetViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        callback()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.nextButtonAction()
        }
    }

    private func nextButtonAction() {
        if !self.isForSearch {
            self.animateDismissView()
            return
        }

        if !isSelectFrom {
            let fromAge = ageSelectionView.agePickerView.getAgeInMonth()
            paramsDelegate?.didSelectFrom(age: fromAge)
           ageSelectionView.promptView.setupTitles(title: "Select pet's age to", subtitle: "Please, if you want to find puppy, set the year and month values to be zero.")
            isSelectFrom = true
        } else {
            let toAge = ageSelectionView.agePickerView.getAgeInMonth()
            paramsDelegate?.didSelectTo(age: toAge)
            self.animateDismissView()
        }
    }
}
