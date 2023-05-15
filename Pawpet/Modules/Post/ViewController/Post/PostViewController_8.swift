//
//  PostViewController_8.swift
//  Pawpet
//
//  Created by Robert Miller on 01.05.2023.
//

import UIKit
import Lottie

class PostViewController_8: UIViewController {

    let alertView = ErrorAlertView()

    private var priceSelectionView = PriceSelectionView()

    // MARK: - Animation view
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "Loading")
        view.loopMode = .autoReverse
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1.2
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationAppearence()
        hideKeyboardWhenTappedAround()
        setupConstraints()
        priceSelectionView.setupCurrencySymbol()
        priceSelectionView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - UI + Constraints
extension PostViewController_8 {
    private func setupConstraints() {
        view.addSubview(priceSelectionView)
        priceSelectionView.addSubview(animationView)
        
        priceSelectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.right.bottom.equalToSuperview()
        }

        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(priceSelectionView.priceTF.snp.bottom).offset(20)
            make.height.width.equalTo(260)
        }
    }
}

// MARK: - Button logic
extension PostViewController_8 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        animationView.play()

        // TODO: PublicationManager
        var price = Int(priceSelectionView.priceTF.text ?? "0") ?? 0
        if priceSelectionView.freeToggler.isOn { price = 0 }
        
        PublicationManager.shared.currentPublication.price = price
        PublicationManager.shared.currentPublication.currency = priceSelectionView.priceTF.currency
        PublicationManager.shared.savePublication { result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.navigationController?.pushViewController(PostViewController_Final(), animated: true)
                    self.animationView.stop()
                }
            case .failure(let error):
                self.alertView.showAlert(with: "Oops! Error...", message: error.localizedDescription, on: self)
                print(error.localizedDescription)
            }
        }
    }

    @objc private func dismissAlertView() {
        alertView.dismissAlertView()
    }
}

