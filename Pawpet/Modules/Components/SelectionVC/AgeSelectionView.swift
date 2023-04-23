//
// AgeSelectionView.swift
// Pawpet
//
// Created by Robert Miller on 23.04.2023.
//

import UIKit

class AgeSelectionView: UIView {
// MARK: - PromptView
public var promptView = PromptView(with: "Select your pet's age",
and: "Please, if your pet is a puppy, set the year and month values to be zero.")

// MARK: - Button
public lazy var nextButton: AuthButton = {
let button = AuthButton()
button.setupTitle(for: "Continue")
return button
}()

// MARK: - AgePicker
let agePickerView = PetAgePickerView()

init() {
super.init(frame: .zero)
backgroundColor = .white
setupConstraints()
}

required init?(coder: NSCoder) {
fatalError("init(coder:) has not been implemented")
}
}

// MARK: - UI + Constraints
extension AgeSelectionView {
private func setupConstraints() {
addSubview(nextButton)
addSubview(promptView)
addSubview(agePickerView)

promptView.snp.makeConstraints { make in
make.leading.trailing.equalToSuperview().inset(20)
make.top.equalToSuperview().inset(60)
}

agePickerView.snp.makeConstraints { make in
make.left.right.equalToSuperview().inset(20)
make.top.equalTo(promptView.snp.bottom).offset(20)
make.height.equalTo(200)
}

nextButton.snp.makeConstraints { make in
make.leading.trailing.equalToSuperview().inset(20)
make.bottom.equalToSuperview().inset(60)
}
}
}
