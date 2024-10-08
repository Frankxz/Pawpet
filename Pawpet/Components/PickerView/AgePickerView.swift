//
//  AgePickerView.swift
//  Pawpet
//
//  Created by Robert Miller on 12.04.2023.
//

import UIKit

class PetAgePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    // Data source arrays
    private let yearsArray = Array(0...25) // 0-25 years
    private let monthsArray = Array(0...11) // 0-11 months

    // Selected values
    private var selectedYears: Int = 0
    private var selectedMonths: Int = 0

    // Fonts
    private let pickerFont = UIFont(name: "Helvetica", size: 18.0)!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .backgroundColor
        layer.cornerRadius = 8
        self.delegate = self
        self.dataSource = self

        // Set default selected values
        self.selectRow(2, inComponent: 0, animated: false) // 2 years
        self.selectRow(6, inComponent: 1, animated: false) // 6 months
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? yearsArray.count : monthsArray.count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = component == 0 ? "\(yearsArray[row]) \("years".localize())" : "\(monthsArray[row]) \("months".localize())"
        return title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedYears = yearsArray[row]
        } else {
            selectedMonths = monthsArray[row]
        }
    }

    func getAgeInMonth() -> Int {
        selectedMonths + (selectedYears * 12)
    }

    func setupAge(age: Int) {
        // Найти количество лет и оставшиеся месяцы
        let years = age / 12
        let months = age % 12

        // Убедится, что значения в пределах допустимого диапазона
        if years >= 0 && years < yearsArray.count && months >= 0 && months < monthsArray.count {
            // Установить года и месяцы в пикере
            selectRow(years, inComponent: 0, animated: false)
            selectRow(months, inComponent: 1, animated: false)

            // Обновить значения selectedYears и selectedMonths
            selectedYears = years
            selectedMonths = months
        }
    }

}
