//
//  PetInfoSelectionView.swift
//  Pawpet
//
//  Created by Robert Miller on 05.05.2023.
//

import UIKit

class PetInfoSelectionView: UIView {

    // MARK: - PromptView
    var promptView = PromptView(with: "Please, provide more info",
                                        and: "Please provide up-to-date information about your pet.", titleSize: 32)

    // MARK: - Button
    lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Select")
        return button
    }()

    // MARK: - Option buttons
    private lazy var maleButton: OptionButton = {
        let button = OptionButton(withShadows: false)
        button.backgroundColor = .backgroundColor
        button.setupTitle(for: "♂", with: .systemFont(ofSize: 82), color: .subtitleColor)
        button.setupSubtitle(for: "Male", with: 20)
        button.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var femaleButton: OptionButton = {
        let button = OptionButton(withShadows: false)
        button.backgroundColor = .backgroundColor
        button.setupTitle(for: "♀", with: .systemFont(ofSize: 78), color: .subtitleColor)
        button.setupSubtitle(for: "Female", with: 20)
        button.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        return button
    }()

    let togglers: [UISwitch] = {
        var switches: [UISwitch] = []
        for _ in 0...3 { switches.append(UISwitch())}
        return switches
    }()

    var isMaleChosen = false
    var isFemaleChosen = false

    var isVacinated = false
    var isCupping = false
    var isSterilized = false
    var isWithDocuments = false

    var isOnlyOneSelect = true
    var isForPost = false

    init(isForPost: Bool = false) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupConstraints()

        if isForPost {
            nextButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            nextButton.isHidden = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension PetInfoSelectionView {
    func setupTogglers(isVaccinated: Bool, isCupping: Bool, isSterilized: Bool, isWithDocs: Bool) {
        togglers[0].isOn = isVaccinated
        togglers[1].isOn = isCupping
        togglers[2].isOn = isSterilized
        togglers[3].isOn = isWithDocs
    }

    private func setupConstraints() {
        let buttonStackView = getButtonsStackView()
        let controlStackView = getControlStackView()

        addSubview(nextButton)
        addSubview(promptView)
        addSubview(buttonStackView)
        addSubview(controlStackView)

        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
        }

        controlStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
        }

        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(controlStackView.snp.bottom).offset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(450)
        }
    }

    private func getButtonsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 20

        maleButton.snp.makeConstraints {$0.height.width.equalTo(160)}
        femaleButton.snp.makeConstraints {$0.height.width.equalTo(160)}

        stackView.addArrangedSubview(maleButton)
        stackView.addArrangedSubview(femaleButton)

        return stackView
    }

    private func getControlStackView() -> UIStackView {
        let mainStackView = UIStackView()
        mainStackView.spacing = 10
        mainStackView.distribution = .fillEqually
        mainStackView.axis = .vertical

        for (index, control) in togglers.enumerated() {
            let stackView = UIStackView()
            stackView.distribution = .equalSpacing
            stackView.axis = .horizontal

            let label = UILabel()
            label.textColor = .accentColor
            label.font = .systemFont(ofSize: 18, weight: .regular)
            switch index {
            case 0:
                label.text = "Vaccinated".localize()
                control.addTarget(self, action: #selector(isVaccinatedTapped), for: .valueChanged)
            case 1:
                label.text = "Was cupping".localize()
                control.addTarget(self, action: #selector(isCuppingTapped), for: .valueChanged)
            case 2:
                label.text = "Sterilized".localize()
                control.addTarget(self, action: #selector(isSterilizedTapped), for: .valueChanged)
            case 3:
                label.text = "With documents".localize()
                control.addTarget(self, action: #selector(isWithDocumentsTapped), for: .valueChanged)

            default: break
            }
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(control)
            mainStackView.addArrangedSubview(stackView)
        }
        return mainStackView
    }
}


// MARK: - Button logic
extension PetInfoSelectionView {
    @objc func isVaccinatedTapped() {
        isVacinated = togglers[0].isOn
    }

    @objc func isCuppingTapped() {
        isCupping = togglers[1].isOn
    }

    @objc func isSterilizedTapped() {
        isSterilized = togglers[2].isOn
    }

    @objc func isWithDocumentsTapped() {
        isWithDocuments = togglers[3].isOn
    }
}

// MARK: - Button logic
extension PetInfoSelectionView {
    @objc func maleButtonTapped() {
        UIView.animate(withDuration: 0.2) {
            if self.isMaleChosen {
                self.maleButton.setupSubtitle(for: "Male", with: 20, color: .subtitleColor)
                self.maleButton.setupTitle(for: "♂", with: .systemFont(ofSize: 82), color: .subtitleColor)
                self.isMaleChosen.toggle()
            } else {
                self.maleButton.setupSubtitle(for: "Male", with: 20, color: .accentColor)
                self.maleButton.setupTitle(for: "♂", with: .systemFont(ofSize: 82), color: .systemBlue)
                self.isMaleChosen.toggle()
            }

            if self.isOnlyOneSelect && self.isFemaleChosen {
                self.femaleButton.setupSubtitle(for: "Female", with: 20, color: .subtitleColor)
                self.femaleButton.setupTitle(for: "♀", with: .systemFont(ofSize: 78), color: .subtitleColor)
                self.isFemaleChosen.toggle()
            }
            self.checkSelection()
        }
    }

    @objc func femaleButtonTapped() {
        UIView.animate(withDuration: 0.2) {
            if self.isFemaleChosen {
                self.femaleButton.setupSubtitle(for: "Female", with: 20, color: .subtitleColor)
                self.femaleButton.setupTitle(for: "♀", with: .systemFont(ofSize: 78), color: .subtitleColor)
                self.isFemaleChosen.toggle()
            } else {
                self.femaleButton.setupSubtitle(for: "Female", with: 20, color: .accentColor)
                self.femaleButton.setupTitle(for: "♀", with: .systemFont(ofSize: 78), color: .systemPink)
                self.isFemaleChosen.toggle()
            }
            if self.isOnlyOneSelect && self.isMaleChosen {
                self.maleButton.setupSubtitle(for: "Male", with: 20, color: .subtitleColor)
                self.maleButton.setupTitle(for: "♂", with: .systemFont(ofSize: 82), color: .subtitleColor)
                self.isMaleChosen.toggle()
            }
            self.checkSelection()
        }
    }
}

// MARK: - For Post
extension PetInfoSelectionView {
    private func checkSelection() {
        if isForPost {
            if !isMaleChosen && !isFemaleChosen {
                hideNextButton()
            } else {
                showNextButton()
            }
        }
    }
    private func showNextButton() {
        if nextButton.isHidden {
            showButtonWithAnimation()
        }
    }

    private func hideNextButton() {
        if !nextButton.isHidden {
            hideNextButtonWithAnimation()
        }
    }

    private func showButtonWithAnimation() {
        nextButton.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.nextButton.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        print("Button showed")
    }

    private func hideNextButtonWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.nextButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            print("Button hided")
        }) { ended in
            if ended { self.nextButton.isHidden = true }
        }
    }
}


