//
//  CountryChangeViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 28.04.2023.
//

import UIKit

class CountryChangeViewController: GeoSelectionViewController {

    // MARK: Button
    private lazy var cancelButton: UIBarButtonItem = {
        let customAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor.accentColor]
        let saveButtonTitle = NSAttributedString(string: "Cancel", attributes: customAttributes)
        let saveButton = UIButton(type: .system)
        saveButton.setAttributedTitle(saveButtonTitle, for: .normal)
        saveButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        return saveBarButton
    }()

    var callback: ()->() = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = cancelButton
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc private func nextButtonTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let country = self.selectedGeoObject as? Country else { return }
            let cities = country.cities

            let changeCityVC = CityChangeViewController(geoObjects: cities, geoVCType: .city)
            changeCityVC.callback = self.callback
            if cities.count != 0 {
                UserDefaults.standard.set(self.selectedGeoObject!.name, forKey: "COUNTRY")
                self.navigationController?.pushViewController(changeCityVC, animated: true)
            } else {
                UserDefaults.standard.set(self.selectedGeoObject!.name, forKey: "COUNTRY")
                UserDefaults.standard.set("", forKey: "CITY")
                self.navigationController?.popViewController(animated: true)
            }
        }

        
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
