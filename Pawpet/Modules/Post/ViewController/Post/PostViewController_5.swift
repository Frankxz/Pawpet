//
//  PostViewController_5.swift
//  Pawpet
//
//  Created by Robert Miller on 12.04.2023.
//

import UIKit

class PostViewController_5: UIViewController {

    // MARK: - PromptView
    private var promptView = PromptView(with: "There is very little left !",
                                        and: "Please provide information so other users can get to know your pet better.", titleSize: 32)

    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()

    // MARK: - Option buttons
    private lazy var maleButton: OptionButton = {
        let button = OptionButton(withShadows: false)
        button.backgroundColor = .backgroundColor
        button.setupTitle(for: "♂", with: .systemFont(ofSize: 82), color: .subtitleColor)
        button.setupSubtitle(for: "Male", with: 20)
        button.addTarget(self, action: #selector(maleButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var femaleButton: OptionButton = {
        let button = OptionButton(withShadows: false)
        button.backgroundColor = .backgroundColor
        button.setupTitle(for: "♀", with: .systemFont(ofSize: 78), color: .subtitleColor)
        button.setupSubtitle(for: "Female", with: 20)
        button.addTarget(self, action: #selector(femaleButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Segmented control
    let segmentedControls: [CustomSegmentedControl] = {
        let frame = CGRect(x: 0, y: 0, width: 140, height: 60)
        let items = ["Yes", "No"]
        return [
            CustomSegmentedControl(frame: frame, items: items),
            CustomSegmentedControl(frame: frame, items: items),
            CustomSegmentedControl(frame: frame, items: items),
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.accentColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        nextButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        nextButton.isHidden = true
        setupConstraints()
    }
}

// MARK: - UI + Constraints
extension PostViewController_5 {
    private func setupConstraints() {
        let controlStackView = getControlStackView()
        let buttonStackView = getButtonsStackView()

        view.addSubview(controlStackView)
        view.addSubview(nextButton)
        view.addSubview(promptView)
        view.addSubview(buttonStackView)


        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }

        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(controlStackView.snp.bottom).offset(20)
        }

        controlStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }
    }

    private func getControlStackView() -> UIStackView {
        let mainStackView = UIStackView()
        mainStackView.spacing = 10
        mainStackView.distribution = .fillEqually
        mainStackView.axis = .vertical

        for (index, control) in segmentedControls.enumerated() {
            let stackView = UIStackView()
            stackView.distribution = .equalSpacing
            stackView.axis = .horizontal

            let label = UILabel()
            label.textColor = .accentColor
            label.font = .systemFont(ofSize: 24, weight: .regular)
            switch index {
            case 0:
               label.text = "Vaccine"
            case 1:
                label.text = "Cupping"
            default:
                label.text = "sterilization"
            }
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(control)
            mainStackView.addArrangedSubview(stackView)
        }
        return mainStackView
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
}

// MARK: - Button logic
extension PostViewController_5 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(PostViewController_6(), animated: true)
        }
    }
}

// MARK: - Button logic
extension PostViewController_5 {
    @objc private func maleButtonTapped(_ sender: UIButton) {
        print("Crossbreed chosen")
        UIView.animate(withDuration: 0.2) {
            self.femaleButton.setupSubtitle(for: "Female", with: 20, color: .subtitleColor)
            self.femaleButton.setupTitle(for: "♀", with: .systemFont(ofSize: 78), color: .subtitleColor)

            self.maleButton.setupSubtitle(for: "Male", with: 20, color: .accentColor)
            self.maleButton.setupTitle(for: "♂", with: .systemFont(ofSize: 82), color: .systemBlue)
            
            self.showNextButon()

        }
        // TODO: - StorageManager

    }

    @objc private func femaleButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.femaleButton.setupSubtitle(for: "Female", with: 20, color: .accentColor)
            self.femaleButton.setupTitle(for: "♀", with: .systemFont(ofSize: 78), color: .systemPink)

            self.maleButton.setupSubtitle(for: "Male", with: 20, color: .subtitleColor)
            self.maleButton.setupTitle(for: "♂", with: .systemFont(ofSize: 82), color: .subtitleColor)

            self.showNextButon()
        }
        // TODO: - StorageManager
    }

    private func showNextButon() {
        if nextButton.isHidden {
            showButtonWithAnimation()
        }
    }

    private func showButtonWithAnimation() {
        self.nextButton.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.nextButton.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        print("Button showed")
    }
}
