//
//  EditableTableViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 29.04.2023.
//

import UIKit

class EditableTableViewCell: UITableViewCell {
    let leftLabel = UILabel()
    let rightLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundColor
        leftLabel.textColor = .accentColor
        rightLabel.textColor = .subtitleColor
        rightLabel.textAlignment = .right

        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)

        leftLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        rightLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.width.equalTo(contentView.bounds.width / 2 - 30)
            make.centerY.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        rightLabel.text = ""
        leftLabel.text = ""
        self.accessoryView = nil
        super.prepareForReuse()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

