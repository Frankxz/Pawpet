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
    var isForSearch: Bool = false
    var selectedColors: [PetColorType] = []

    private let promptView = PromptView(with: "Select the color", and: "")

    var nextButton = AuthButton()

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

        if isForSearch {
            containerView.addSubview(nextButton)
            nextButton.setupTitle(for: "Select")
            nextButton.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.top.equalToSuperview().inset(470)
            }
        }

        tableView.register(ColorTableViewCell.self, forCellReuseIdentifier: "ColorCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    init(isForSearch: Bool = false) {
        self.isForSearch = isForSearch
        super.init(nibName: nil, bundle: nil)
        if  isForSearch {
            nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func nextButtonTapped() {
        guard let selectedColor = selectedColors.first else {
            animateDismissView()
            return
        }
        colorDelegate?.didSelectColor(colorType: selectedColor)
        animateDismissView()
    }
}

// MARK: - TableView
extension ColorSelectionBottomSheetViewController {
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
        if !isForSearch {
            print("Not for search")
            colorDelegate?.didSelectColor(colorType: colorType)
            self.animateDismissView()
            tableView.deselectRow(at: indexPath, animated: true)
        }  else {
            if cell.isColorSelected {
                print("For search | was selected")
                cell.colorCircle.layer.borderColor = UIColor.subtitleColor.cgColor
                cell.colorCircle.layer.borderWidth = 0.4
                cell.colorLabel.textColor = .accentColor
                selectedColors.removeAll { $0 == colorType}
                tableView.deselectRow(at: indexPath, animated: true)
                cell.isColorSelected = false
            } else {
                print("For search | was not selected, selecting")
                cell.colorCircle.layer.borderColor = UIColor.systemBlue.cgColor
                cell.colorCircle.layer.borderWidth = 2
                cell.colorLabel.textColor = .systemBlue
                selectedColors.append(colorType)
                cell.isColorSelected = true
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

