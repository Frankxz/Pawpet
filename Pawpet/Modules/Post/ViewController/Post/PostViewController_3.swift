//
//  PostViewController_3.swift
//  Pawpet
//
//  Created by Robert Miller on 11.04.2023.
//

import UIKit
import SnapKit

class PostViewController_3: BreedSelectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - Button logic
extension PostViewController_3 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.isCrossbreed && self.isFirstBreed {
                let secondBreedVC = PostViewController_3()
                secondBreedVC.isCrossbreed = true
                secondBreedVC.isFirstBreed = false

                self.navigationController?.pushViewController(secondBreedVC, animated: true)
            } else {
                self.navigationController?.pushViewController(PostViewController_4(), animated: true)
            }
        }
        // TODO: - StorageManager
    }
}
