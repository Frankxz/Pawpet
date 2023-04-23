//
//  ParametersViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 22.04.2023.
//

import UIKit
import SnapKit

class ParametersViewController: UITableViewController {

    enum Section: Int, CaseIterable {
        case animalType, region, breed, ageAndGender, price, additionalInfo, button
    }

    private var isCrossbreed = false

    // MARK: PromptView
    public var promptView = PromptView(with: "Detailed search", and: "Please select the desired options")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
}

// MARK: - Configurating TableView
extension ParametersViewController {
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(DoubleTFTableViewCell.self, forCellReuseIdentifier: "DoubleTextFieldCell")
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "ButtonCell")

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        setupNavigationAppearence()

    }
}

// MARK: - UITableViewDataSource
extension ParametersViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionEnum = Section(rawValue: section) else { return 0 }

        switch sectionEnum {
        case .animalType, .button, .region, .price:
            return 1
        case .breed:
            return 2
        case .ageAndGender:
            return 2
        case .additionalInfo:
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionEnum = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        switch sectionEnum {
        case .animalType, .region, .breed, .ageAndGender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .backgroundColor
            switch sectionEnum {
            case .animalType:
                cell.textLabel?.text = "Выберите тип животного"
                cell.detailTextLabel?.text = "Кошка"
            case .region:
                cell.textLabel?.text = "Выберите регион"
                cell.detailTextLabel?.text = "Россия, Москва"
            case .breed:
                if indexPath.row == 0 {
                    cell.textLabel?.text = "Является ли помесью"
                    let toggle = UISwitch()
                    toggle.addTarget(self, action: #selector(breedTogglerTapped(_:)), for: .touchUpInside)
                    cell.accessoryView = toggle
                    cell.accessoryType = .none
                } else {
                    cell.textLabel?.text = "Выберите породу"
                    cell.detailTextLabel?.text = "Шпиц"
                }
            case .ageAndGender:
                if indexPath.row == 0 {
                    cell.textLabel?.text = "Выберите возраст"
                    cell.detailTextLabel?.text = "2 мес."
                } else {
                    cell.textLabel?.text = "Выберите пол"
                    cell.detailTextLabel?.text = "Мальчик"
                }
            default:
                break
            }

            return cell

        case .price:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleTextFieldCell", for: indexPath) as! DoubleTFTableViewCell

            cell.configure(leftPlaceholder: "Цена от", rightPlaceholder: "Цена до")
            cell.backgroundColor = .backgroundColor
            return cell

        case .additionalInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let toggle = UISwitch()
            cell.accessoryView = toggle
            cell.backgroundColor = .backgroundColor
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Купирован"
            case 1:
                cell.textLabel?.text = "Стерилизован"
            case 2:
                cell.textLabel?.text = "Вакцинирован"
            default:
                break
            }

            return cell
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
               return cell
        }
    }
}

// MARK: - HeaderView
extension ParametersViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        if section == 0 {
            view.addSubview(promptView)
            promptView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalToSuperview()
            }
        }
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 90 : 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 6 {
            return 100
        }
        return 44.0
    }
}

// MARK: - Row selection logic
extension ParametersViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section), row: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            let animalSelectionBottomSheetVC = AnimalSelectionBottomSheetViewController()
            animalSelectionBottomSheetVC.modalPresentationStyle = .overCurrentContext
            self.present(animalSelectionBottomSheetVC, animated: false)
        }
        else if indexPath.section == 1 {
            let regionTableVC = RegionTableViewController()
            navigationController?.pushViewController(regionTableVC, animated: true)
        }
        else if indexPath.section == 2 && indexPath.row == 1 {
            let firstBreedVC = BreedViewController()
            firstBreedVC.isCrossbreed = isCrossbreed
            firstBreedVC.isFirstBreed = isCrossbreed

            self.navigationController?.pushViewController(firstBreedVC, animated: true)
        }
        else if indexPath.section == 3 && indexPath.row == 0 {
            let ageSelectionBottomSheetVC = AgeSelectionBottomSheetViewController()
            ageSelectionBottomSheetVC.modalPresentationStyle = .overCurrentContext
            self.present(ageSelectionBottomSheetVC, animated: false)
        }
        else if indexPath.section == 3 && indexPath.row == 1 {
            let genderSelectionBottomSheetVC = GenderSelectionBottomSheetViewController()
            genderSelectionBottomSheetVC.modalPresentationStyle = .overCurrentContext
            self.present(genderSelectionBottomSheetVC, animated: false)
        }
    }
}

// MARK: - UITableViewDelegate
extension ParametersViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.additionalInfo.rawValue {
            return "Доп информация"
        }
        return nil
    }
}

// MARK: - Button logic
extension ParametersViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(PostViewController_2(), animated: true)
        }
    }

    @objc private func breedTogglerTapped(_ sender: UISwitch) {
        print("Toggler tapped")
        isCrossbreed.toggle()
    }
}
