//
//  CityChangeViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 28.04.2023.
//

import UIKit

class CityChangeViewController: GeoSelectionViewController {

    var callback: ()->() = {}

    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc private func nextButtonTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UserManager.shared.user.country = UserDefaults.standard.string(forKey: "COUNTRY")
            UserManager.shared.user.city = self.selectedGeoObject!.name
            UserManager.shared.user.isChanged = true
            self.callback()
            self.dismiss(animated: true)
        }
    }
}
