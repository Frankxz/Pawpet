//
//  DoubleTFTableViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 22.04.2023.
//

import UIKit
class DoubleTFTableViewCell: UITableViewCell {
    let leftTextField = UITextField()
    let rightTextField = UITextField()

    func configure(leftPlaceholder: String, rightPlaceholder: String) {
        addSubview(leftTextField)
        addSubview(rightTextField)

        leftTextField.placeholder = leftPlaceholder
        rightTextField.placeholder = rightPlaceholder

        leftTextField.borderStyle = .none
        rightTextField.borderStyle = .none

        leftTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(rightTextField)
        }

        rightTextField.snp.makeConstraints { make in
            make.leading.equalTo(leftTextField.snp.trailing).offset(40)
            make.trailing.equalToSuperview().offset(-20)
            make.top.bottom.equalToSuperview()
        }

        let leftBorder = UIView()
        let rightBorder = UIView()
        leftBorder.backgroundColor = .systemGray3
        rightBorder.backgroundColor = .systemGray3

        leftTextField.addSubview(leftBorder)
        rightTextField.addSubview(rightBorder)

        leftBorder.snp.makeConstraints { make in
            make.leading.trailing.equalTo(leftTextField)
            make.bottom.equalTo(leftTextField.snp.bottom).inset(5)
            make.height.equalTo(1)
        }

        rightBorder.snp.makeConstraints { make in
            make.leading.trailing.equalTo(rightTextField)
            make.bottom.equalTo(rightTextField.snp.bottom).inset(5)
            make.height.equalTo(1)
        }
    }
}
