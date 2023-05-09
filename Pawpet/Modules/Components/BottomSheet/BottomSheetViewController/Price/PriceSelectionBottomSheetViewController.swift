//
//  PriceSelectionBottomSheetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 03.05.2023.
//

import UIKit

class PriceSelectionBottomSheetViewController: BottomSheetViewController {

    let priceSelectionView = PriceSelectionView()
    var callback: ()->() = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeHeight(defaultHeight: 700, maxHeight: 700)
        setupConstraints()
        hideKeyboardWhenTappedAround()
        priceSelectionView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)

    }

    private func setupConstraints() {
        containerView.addSubview(priceSelectionView)
        priceSelectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.bottom.equalToSuperview()
        }

        priceSelectionView.nextButton.snp.removeConstraints()
        priceSelectionView.nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(70)
            make.top.equalToSuperview().inset(700 - 70 - 60)
        }
    }

    @objc private func nextButtonTapped(_ sender: UIButton) {
        callback()
        animateDismissView()
    }
}

