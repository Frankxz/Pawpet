//
//  SignUpViewController6.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import UIKit
import SnapKit

class SignUpViewController6: GeoSelectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - Button logic
extension SignUpViewController6 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let cities = self.findCities(for: self.selectedGeoObject!.name)
            let signUpVC7 = SignUpViewController7(geoObjects: cities, geoVCType: .city)

            if cities.count != 0 {
                self.navigationController?.pushViewController(signUpVC7, animated: true)
                UserDefaults.standard.set(self.selectedGeoObject!.name, forKey: "COUNTRY")
            } else {
                UserDefaults.standard.set(self.selectedGeoObject!.name, forKey: "COUNTRY")
                UserDefaults.standard.set("", forKey: "CITY")
                FireStoreManager.shared.saveUserDataFromUD()
                self.navigationController?.pushViewController(SignUpViewController_final(), animated: true)
            }
        }
    }
}
