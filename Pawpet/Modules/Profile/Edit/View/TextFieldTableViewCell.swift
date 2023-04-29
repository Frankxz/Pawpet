//
//  TextFieldTableViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 21.04.2023.
//

import UIKit
import SnapKit

class TextFieldTableViewCell: UITableViewCell {
    let textField: UITextField = {
        let tf = UITextField()
        return tf
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        contentView.backgroundColor = .backgroundColor
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
}
