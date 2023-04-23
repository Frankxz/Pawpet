//
//  GenderSelectionBottomSheetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit

class GenderSelectionBottomSheetViewController: BottomSheetViewController {

    // MARK: - PromptView
    private var promptView = PromptView(with: "Gender selection",
                                        and: "Please select one or more options.", titleSize: 32)

    // MARK: - Labels
    private let factLabel: UILabel = {
        let label = UILabel()
        label.setAttributedText(withString: "🧐 Interesting fact: ", boldString: "It is believed that females are generally softer and calmer than their counterparts - at least when they are not in heat. On the other hand, males tend to be more assertive and aggressive. Dog owners often comment that males are more stubborn than females. This is largely due to their innate role in the pack.", font: .systemFont(ofSize: 14), stringWeight: .bold, boldStringWeight: .regular)
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Select")
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

    public var isMaleChosen = false
    public var isFemaleChosen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //changeHeight(defaultHeight: 400, maxHeight: 600)
        setupConstraints()
    }
}

// MARK: - UI + Constraints
extension GenderSelectionBottomSheetViewController {
    private func setupConstraints() {
        let buttonStackView = getButtonsStackView()

        containerView.addSubview(nextButton)
        containerView.addSubview(promptView)
        containerView.addSubview(buttonStackView)
        containerView.addSubview(factLabel)

        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }

        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
        }

        factLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(430)
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
}


// MARK: - Button logic
extension GenderSelectionBottomSheetViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animateDismissView()
        }
    }
}

// MARK: - Button logic
extension GenderSelectionBottomSheetViewController {
    @objc private func maleButtonTapped(_ sender: UIButton) {
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
        }
    }

    @objc private func femaleButtonTapped(_ sender: UIButton) {
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
        }
    }
}
