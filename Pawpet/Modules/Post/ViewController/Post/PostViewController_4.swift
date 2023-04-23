//
//  PostViewController_4.swift
//  Pawpet
//
//  Created by Robert Miller on 12.04.2023.
//

import UIKit

class PostViewController_4: UIViewController {
    
    private let ageSelectionView = AgeSelectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupNavigationAppearence()
        ageSelectionView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - UI + Cosntraints
extension PostViewController_4 {
    private func setupConstraints() {
        view.addSubview(ageSelectionView)
        ageSelectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - Button logic
extension PostViewController_4 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(PostViewController_5(), animated: true)
        }
    }
}
