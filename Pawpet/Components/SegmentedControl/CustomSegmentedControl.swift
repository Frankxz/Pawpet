//
//  CustomSegmentedControl.swift
//  Pawpet
//
//  Created by Robert Miller on 27.03.2023.
//

import UIKit

class CustomSegmentedControl: UIView {

    // MARK: - Private prorperties
    private var items = [String]()
    private var buttons = [UIButton]()
    private var selectorView = UIView()

    var selectedItem = ""

    // MARK: - Color logic
    private let selectedItemTextColor = UIColor.white
    private let unselectedItemTextColor = UIColor.subtitleColor
    private var selectedItemViewColor = UIColor.accentColor

    // MARK: - INITS
    init(frame: CGRect, items: [String]) {
        super.init(frame: frame)
        self.items = items
        setupView()
        updateView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Logic
extension CustomSegmentedControl {
    public func setupSelectorView(with color: UIColor) {
        selectedItemViewColor = color
        selectorView.backgroundColor = color
    }

    private func setupView() {
        backgroundColor = .backgroundColor
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }

    func updateView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview()}
        items.forEach { item in
            let button = UIButton(type: .system)

            button.setTitle(item, for: .normal)
            button.setTitleColor(unselectedItemTextColor, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)

            button.addTarget(self, action: #selector(changeSelectedItem(button:)), for: .touchUpInside)

            button.snp.makeConstraints{$0.width.equalTo(frame.width / CGFloat (items.count))}
            buttons.append(button)
        }

        updateSelectorView()

        buttons.first?.setTitleColor(selectedItemTextColor, for: .normal)
        selectedItem = buttons.first?.titleLabel?.text ?? ""


        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.bottom.top.trailing.leading.equalToSuperview()
        }
    }

    private func updateSelectorView() {
        let selectorWidth = frame.width / CGFloat(buttons.count)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        view.backgroundColor = selectedItemViewColor
        view.layer.cornerRadius = 6
        selectorView = view
        addSubview(selectorView)
    }
}

// MARK: - Changing selectedView
extension CustomSegmentedControl {
    @objc func changeSelectedItem(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(unselectedItemTextColor, for: .normal)

            if btn == button {
                selectedItem = btn.titleLabel?.text ?? ""
                let selectorStartPosition = frame.width /  CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorStartPosition
                    button.setTitleColor(self.selectedItemTextColor, for: .normal)
                }
            }
        }
    }

    public func changeSelectedViewPosition(itemName: String) {
        for (buttonIndex, button) in buttons.enumerated() {
            if button.titleLabel?.text == itemName {
                selectedItem = button.titleLabel?.text ?? ""
                let selectorStartPosition = frame.width /  CGFloat(buttons.count) * CGFloat(buttonIndex)

                self.selectorView.frame.origin.x = selectorStartPosition
                button.setTitleColor(self.selectedItemTextColor, for: .normal)
            }
        }
    }
}
