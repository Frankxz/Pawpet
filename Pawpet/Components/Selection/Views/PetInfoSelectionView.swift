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

    var togglers: [UISwitch] = []
    var checkMarkButtons: [CheckmarkButton] = []

    // MARK: Button
    lazy var colorSelectButton: UIButton = {
        let customAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.systemBlue]
        let saveButtonTitle = NSAttributedString(string: "Select".localize(), attributes: customAttributes)
        let button = UIButton(type: .system)
        button.setAttributedTitle(saveButtonTitle, for: .normal)
        return button
    }()

    var isMaleChosen = false
    var isFemaleChosen = false

    var isVacinated = false
    var isWithDocuments = false

    var isCupping: Bool?
    var isSterilized: Bool?

    var isOnlyOneSelect = true
    var isForPost = false
    var isForSearch = false
    var isColorChosen = false

    init(isForPost: Bool = false, petType: PetType = .all, isForSearch: Bool = false) {
        super.init(frame: .zero)
        backgroundColor = .white
        self.isForSearch = isForSearch

        if isForPost {
            self.isForPost = isForPost
            nextButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            nextButton.isHidden = true
        }

        let type = petType == .all ? (PublicationManager.shared.currentPublication.petInfo.petType) : petType

        if type == .dog {
            for _ in 1...4 {
                togglers.append(UISwitch())
                checkMarkButtons.append(CheckmarkButton())
            }
        } else if type == .cat  {
            for _ in 1...3 {
                togglers.append(UISwitch())
                checkMarkButtons.append(CheckmarkButton())
            }
        } else {
            for _ in 1...2 {
                togglers.append(UISwitch())
                checkMarkButtons.append(CheckmarkButton())
            }
        }

        setupConstraints()

        print("TOGLERS COUNT: \(togglers.count)")
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
        let controlStackView = isForSearch ? getControlViewForSearch() : getControlView()
        let colorSelectionView = getColorSelectionView()

        addSubview(nextButton)
        addSubview(promptView)
        addSubview(colorSelectionView)
        addSubview(buttonStackView)
        addSubview(controlStackView)


        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
        }

        colorSelectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
        }

        controlStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(colorSelectionView.snp.bottom).offset(20)
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

    private func getControlView() -> UIView {
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
                label.text = "With documents".localize()
                control.addTarget(self, action: #selector(isWithDocumentsTapped), for: .valueChanged)
            case 2:
                label.text = "Sterilized".localize()
                control.addTarget(self, action: #selector(isSterilizedTapped), for: .valueChanged)
                isSterilized = false
            case 3:
                label.text = "Was cupping".localize()
                control.addTarget(self, action: #selector(isCuppingTapped), for: .valueChanged)
                isCupping = false

            default: continue
            }
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(control)
            mainStackView.addArrangedSubview(stackView)
        }

        let controlView = UIView()
        controlView.backgroundColor = .backgroundColor
        controlView.layer.cornerRadius = 12
        
        controlView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(10)
        }

        return controlView
    }

    private func getControlViewForSearch() -> UIView {
        let mainStackView = UIStackView()
        mainStackView.spacing = 10
        mainStackView.distribution = .fillEqually
        mainStackView.axis = .vertical

        for (index, control) in togglers.enumerated() {

            let buttonStackView = UIStackView()
            buttonStackView.distribution = .fill
            buttonStackView.spacing = 10
            buttonStackView.axis = .horizontal
            checkMarkButtons[index].mainLabel.text = "Все"
            buttonStackView.addArrangedSubview(control)
            buttonStackView.addArrangedSubview(checkMarkButtons[index])

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
                checkMarkButtons[index].button.addTarget(self, action: #selector(isAllVacinatedTapped), for: .touchUpInside)
            case 1:
                label.text = "With documents".localize()
                control.addTarget(self, action: #selector(isWithDocumentsTapped), for: .valueChanged)
                checkMarkButtons[index].button.addTarget(self, action: #selector(isAllDocumentTapped), for: .touchUpInside)
            case 2:
                label.text = "Sterilized".localize()
                control.addTarget(self, action: #selector(isSterilizedTapped), for: .valueChanged)
                checkMarkButtons[index].button.addTarget(self, action: #selector(isAllSterilizedTapped), for: .touchUpInside)
                isSterilized = false
            case 3:
                label.text = "Was cupping".localize()
                control.addTarget(self, action: #selector(isCuppingTapped), for: .valueChanged)
                checkMarkButtons[index].button.addTarget(self, action: #selector(isAllCuppingTapped), for: .touchUpInside)
                isCupping = false
            default: continue
            }

            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(buttonStackView)
            mainStackView.addArrangedSubview(stackView)
        }

        let controlView = UIView()
        controlView.backgroundColor = .backgroundColor
        controlView.layer.cornerRadius = 12

        controlView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(10)
        }

        return controlView
    }

    private func getColorSelectionView() -> UIView {
        let promtLabel = UILabel()
        promtLabel.textColor = .accentColor
        promtLabel.font = .systemFont(ofSize: 18, weight: .regular)
        promtLabel.text = "Pet's color".localize()

        let colorView = UIView()
        colorView.backgroundColor = .backgroundColor
        colorView.layer.cornerRadius = 12
        colorView.addSubview(promtLabel)
        colorView.addSubview(colorSelectButton)

        promtLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(10)
        }

        colorSelectButton.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(10)
        }

        return colorView
    }
}


// MARK: - Button logic
extension PetInfoSelectionView {
    @objc func isVaccinatedTapped() {
        isVacinated = togglers[0].isOn
    }

    @objc func isWithDocumentsTapped() {
        isWithDocuments = togglers[1].isOn
    }
    @objc func isSterilizedTapped() {
        isSterilized = togglers[2].isOn
    }

    @objc func isCuppingTapped() {
        isCupping = togglers[3].isOn
    }

    @objc func isAllVacinatedTapped() {
        togglers[0].isEnabled = !checkMarkButtons[0].button.isSelected
    }

    @objc func isAllDocumentTapped() {
        togglers[1].isEnabled = !checkMarkButtons[1].button.isSelected
    }

    @objc func isAllSterilizedTapped() {
        togglers[2].isEnabled = !checkMarkButtons[2].button.isSelected
    }

    @objc func isAllCuppingTapped() {
        togglers[3].isEnabled = !checkMarkButtons[3].button.isSelected
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
    func checkSelection() {
        if isForPost && !isForSearch {
            if !isMaleChosen && !isFemaleChosen {
                hideNextButton()
            } else {
                if isColorChosen {
                    showNextButton()
                }
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
