//
//  ColorSelectionBottomSheetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 07.05.2023.
//

import UIKit

protocol ColorSelectionDelegate {
    func didSelectColor(colorType: PetColorType)
}

class ColorSelectionBottomSheetViewController: BottomSheetViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    let colors = PetColorType.allCases
    var colorDelegate: ColorSelectionDelegate?

    private let promptView = PromptView(with: "Select the color", and: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.addSubview(promptView)
        containerView.addSubview(tableView)

        promptView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(promptView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        tableView.register(ColorTableViewCell.self, forCellReuseIdentifier: "ColorCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorTableViewCell
        cell.configure(colorType: colors[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ColorTableViewCell
        let colorType = cell.colorType
        colorDelegate?.didSelectColor(colorType: colorType)
        self.animateDismissView()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

