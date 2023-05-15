//
//  DynamicTextView.swift
//  Pawpet
//
//  Created by Robert Miller on 12.04.2023.
//

import UIKit
import SnapKit

class DynamicTextView: UITextView {

    private let placeholderLabel = UILabel()

    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        backgroundColor = .backgroundColor
        layer.cornerRadius = 6
        
        // Установка отступов
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        // Установка свойств текстового поля
        font = UIFont.systemFont(ofSize: 16)
        textColor = .black

        // Добавление placeholder
        placeholderLabel.text = ""
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = .lightGray
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.left.equalToSuperview().inset(16)
        }

        // Ограничения для автоматического изменения размера
        isScrollEnabled = false
        sizeToFit()
        isScrollEnabled = true

        // Ограничения с помощью SnapKit
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Обновление отображения placeholder
        placeholderLabel.isHidden = !text.isEmpty
    }
}
