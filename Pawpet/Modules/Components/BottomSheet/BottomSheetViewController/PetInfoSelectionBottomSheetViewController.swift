//
//  GenderSelectionBottomSheetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit

class PetInfoSelectionBottomSheetViewController: BottomSheetViewController {
    let petInfoView = PetInfoSelectionView()
    var callBack: ()->() = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        changeHeight(defaultHeight: 580, maxHeight: 580)
        setupConstraints()
        petInfoView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        petInfoView.promptView.setupTitles(title: "Detail info selection",
                                           subtitle: "Please provide up-to-date information.")
    }
    
    private func setupConstraints() {
        containerView.addSubview(petInfoView)
        petInfoView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
}

// MARK: - Button logic
extension PetInfoSelectionBottomSheetViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        callBack()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animateDismissView()
        }
    }
}

