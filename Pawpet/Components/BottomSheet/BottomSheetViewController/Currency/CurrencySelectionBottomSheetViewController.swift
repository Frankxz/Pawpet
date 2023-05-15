//
//  CurrencySelectionBottomSheetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 03.05.2023.
//

import UIKit

protocol CurrencyChangeDelegate {
    func currencySelected(currency: String)
}

class CurrencySelectionBottomSheetViewController: BottomSheetViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let promptView = PromptView(with: "Chose the currency", and: "The changed currency will be selected by default on selecting price screen when you will publicate new post")

    private let currencies = [["🇺🇸 USD" : " - \("US's Dollar")"],
                              ["🇷🇺 RUB" : " - \("Russian Ruble")"],
                              [ "🇰🇿 KZT" : " - \("Tenge")"]]

    public var currencyDelegate: CurrencyChangeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        containerView.addSubview(promptView)
        containerView.addSubview(tableView)

        promptView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(promptView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 10
        tableView.sectionHeaderHeight = 0

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "currencyCell")
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
        let leftSide = currencies[indexPath.section].keys.first ?? ""
        let rightSide = currencies[indexPath.section].values.first ?? ""
        cell.textLabel?.setAttributedText(withString: leftSide, boldString: rightSide, font: .systemFont(ofSize: 18), stringWeight: .bold, boldStringWeight: .regular)

        cell.textLabel?.textColor = .accentColor
        cell.backgroundColor = .backgroundColor
        return cell
    }

    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCurrency = currencies[indexPath.section].keys.first ?? ""
        let filteredString = selectedCurrency.filter { $0.isUppercase }
        print(filteredString) 

        currencyDelegate?.currencySelected(currency: filteredString)
        self.animateDismissView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
}
