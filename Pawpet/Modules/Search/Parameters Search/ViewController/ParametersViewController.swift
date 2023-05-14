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
        case animalType, region, breed, ageAndGender, price, button
    }

    private var isCrossbreed = false
    private var isPetTypeChosen = false
    var publication = Publication()
    var searchData: [String : Any] = [:]
    let alertView = ErrorAlertView()

    // MARK: PromptView
    public var promptView = PromptView(with: "Detailed search", and: "Please select the desired options")

    let regionTableVC = RegionTableViewController()
    var petInfoVC: PetInfoSearchSelectionViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        hideKeyboardWhenTappedAround()
    }
}

// MARK: - Configurating TableView
extension ParametersViewController {
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(EditableTableViewCell.self, forCellReuseIdentifier: "editableCell")
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
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionEnum = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        switch sectionEnum {
        case .animalType, .region, .breed, .ageAndGender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editableCell", for: indexPath) as! EditableTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .backgroundColor
            switch sectionEnum {
            case .animalType:
                cell.leftLabel.text = "Выберите тип животного"
                if isPetTypeChosen {
                    cell.rightLabel.text = publication.petInfo.petType.getNamePlural()
                }
            case .region:
                cell.leftLabel.text = "Выберите регион"
                if publication.city == "" {
                    cell.rightLabel.text = UserManager.shared.user.country
                } else  {
                    cell.rightLabel.text = (UserManager.shared.user.country!)  + ", " + publication.city + "..."
                }

            case .breed:
                if indexPath.row == 0 {
                    cell.leftLabel.text = "Является ли помесью"
                    let toggle = UISwitch()
                    toggle.addTarget(self, action: #selector(breedTogglerTapped(_:)), for: .touchUpInside)
                    cell.accessoryView = toggle
                    cell.accessoryType = .none
                    if publication.petInfo.isCrossbreed != nil {
                        cell.rightLabel.text = (publication.petInfo.isCrossbreed! ? "YES" : "NO")
                    }
                } else {
                    cell.leftLabel.text = "Выберите породу"
                    cell.rightLabel.text = publication.petInfo.breed
                    if publication.petInfo.secondBreed != nil {
                        cell.rightLabel.text! +=  " & " + (publication.petInfo.secondBreed!)
                    }
                }
            case .ageAndGender:
                if indexPath.row == 0 {
                    cell.leftLabel.text = "Выберите возраст"
                    if let ageFrom = searchData["ageFrom"] as? Int {
                        cell.rightLabel.text = "\(ageFrom) мес."
                        if let ageTo = searchData["ageTo"] as? Int {
                            cell.rightLabel.text = "от \(ageFrom) до \(ageTo) мес."
                        }
                    }

                } else {
                    cell.leftLabel.text = "Детальные параметры"
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
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
            cell.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
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
        if indexPath.section == 5 {
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
            selectPetType()
        }
        else if indexPath.section == 1 {
            selectRegion()
        }
        else if indexPath.section == 2 && indexPath.row == 1 {
            selectBreed()
        }
        else if indexPath.section == 3 && indexPath.row == 0 {
            selectAge()
        }
        else if indexPath.section == 3 && indexPath.row == 1 {
            selectDetails()
        }
    }

    // MARK: - Select Pet Type
    private func selectPetType() {
        let animalSelectionVC = AnimalSelectionBottomSheetViewController()
        animalSelectionVC.animalSelectionView.chapterCollectionView.petTypes = PetType.allCases.filter { $0 != .all }
        animalSelectionVC.animalSelectionView.chapterCollectionView.reloadData()
        animalSelectionVC.modalPresentationStyle = .overCurrentContext
        animalSelectionVC.callback = {
            self.publication.petInfo.petType = animalSelectionVC.animalSelectionView.chapterCollectionView.selectedType
            self.searchData["petType"] = self.publication.petInfo.petType
            self.isPetTypeChosen = true
            self.tableView.reloadData()

            self.petInfoVC = PetInfoSearchSelectionViewController(petType: self.publication.petInfo.petType, isForSearch: true)

        }
        self.present(animalSelectionVC, animated: false)
    }

    // MARK: - Select Region
    private func selectRegion() {
        regionTableVC.cities = GeoManager.shared.getCitiesOfCountry(countryName: UserManager.shared.user.country!, localize: .ru)
        regionTableVC.tableView.reloadData()
        regionTableVC.callBack = {
            let cities = self.regionTableVC.getCheckedCities()
            if !cities.isEmpty {
                self.publication.country = UserManager.shared.user.country!
                self.publication.city = cities.first!.name
                var citiesString: [String] = []
                for city in cities {
                    citiesString.append(city.name)
                }
                self.searchData["regions"] = citiesString
                self.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(regionTableVC, animated: true)
    }

    // MARK: - Select Breed
    private func selectBreed() {
        let firstBreedVC = BreedSearchViewController()
        firstBreedVC.paramsDelegate = self
        BreedManager.shared.loadData(for: publication.petInfo.petType, completion: { breeds in
            for breed in breeds {
                firstBreedVC.breeds.append(Breed(name: breed))
            }
            firstBreedVC.tableView.reloadData()
            let navigationVC = UINavigationController(rootViewController: firstBreedVC)
            firstBreedVC.isCrossbreed = self.isCrossbreed
            firstBreedVC.isFirstBreed = self.isCrossbreed
            navigationVC.modalPresentationStyle = .fullScreen
            self.present(navigationVC, animated: true)
        })
    }

    // MARK: - Select age
    private func selectAge() {
        let ageSelectionBottomSheetVC = AgeSelectionBottomSheetViewController()
        ageSelectionBottomSheetVC.isForSearch = true
        ageSelectionBottomSheetVC.paramsDelegate = self
        ageSelectionBottomSheetVC.modalPresentationStyle = .overCurrentContext
        self.present(ageSelectionBottomSheetVC, animated: false)
    }

    // MARK: - Select Details
    private func selectDetails() {
        if !isPetTypeChosen {
            alertView.showAlert(with: "Oops... Wait!", message: "First you need to select the type of pet, and based on it we will provide you with a list of detailed parameters.", on: self)
            return
        }

        guard let petInfoVC = petInfoVC else { return }

        var isMale: Bool = false
        var isFemale: Bool = false
        var isVaccinated: Bool?
        var withDocuments: Bool?
        var isSterilized: Bool?
        var isCupping: Bool?
        var colors: [String]?

        petInfoVC.callBack = {
            isMale = petInfoVC.petInfoView.isMaleChosen
            isFemale = petInfoVC.petInfoView.isFemaleChosen

            if !((!isMale && !isFemale) || (isMale && isFemale)) {
                if isMale {
                    self.searchData["isMale"] = true
                } else {
                    self.searchData["isMale"] = false
                }
            }

            if petInfoVC.petInfoView.togglers[0].isEnabled {
                isVaccinated = petInfoVC.petInfoView.isVacinated
                self.searchData["isVaccinated"] = isVaccinated
            } else {
                self.searchData["isVaccinated"] = ""
            }
            if petInfoVC.petInfoView.togglers[1].isEnabled {
                withDocuments = petInfoVC.petInfoView.isWithDocuments
                self.searchData["withDocuments"] = withDocuments
            } else {
                self.searchData["withDocuments"] = ""
            }

            if self.publication.petInfo.petType == .cat || self.publication.petInfo.petType == .dog {
                if petInfoVC.petInfoView.togglers[2].isEnabled {
                    isSterilized = petInfoVC.petInfoView.isSterilized
                    self.searchData["isSterilized"] = isSterilized
                } else {
                    self.searchData["isSterilized"] = ""
                }
            }

            if self.publication.petInfo.petType == .dog {
                if petInfoVC.petInfoView.togglers[3].isEnabled {
                    isCupping = petInfoVC.petInfoView.isCupping
                    self.searchData["isCupping"] = isCupping
                } else {
                    self.searchData["isCupping"] = ""
                }
            }

            if !petInfoVC.colorSelectVC.selectedColors.isEmpty {
                colors = []
                for color in petInfoVC.colorSelectVC.selectedColors {
                    colors?.append(color.rawValue)
                }
                self.searchData["colors"] = colors
            } else {
                self.searchData["colors"] = ""
            }

        }
        self.navigationController?.pushViewController(petInfoVC, animated: true)
    }

    @objc private func dismissAlertView() {
        alertView.dismissAlertView()
    }
}

// MARK: - Button logic
extension ParametersViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.selectPrice()
            print(self.searchData)

            let searchVC = SearchViewController(isFromDetail: true)
            PublicationManager.shared.fetchPublicationsWithFilter(searchData: self.searchData) { result in
                switch result {
                case .success(let fetchedPublications):
                    searchVC.cardCollectionView.publications = fetchedPublications
                    searchVC.cardCollectionView.reloadData()
                    searchVC.searchText = "Найдено \(fetchedPublications.count) публикаций "
                    self.navigationController?.pushViewController(searchVC, animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    @objc private func breedTogglerTapped(_ sender: UISwitch) {
        print("Toggler tapped")
        isCrossbreed.toggle()
        searchData["isCrossbreed"] = isCrossbreed
    }

    private func selectPrice() {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as! DoubleTFTableViewCell
        if cell.leftTextField.text != nil {
            if !cell.leftTextField.text!.isEmpty {
                if Int(cell.leftTextField.text!) != nil {
                    self.searchData["priceFrom"] = Int(cell.leftTextField.text!)! + 1
                }
            } else {
                self.searchData["priceFrom"] = ""
            }
        } else {
            self.searchData["priceFrom"] = ""
        }

        if cell.rightTextField.text != nil {
            if !cell.rightTextField.text!.isEmpty {
                if Int(cell.rightTextField.text!) != nil {
                    self.searchData["priceTo"] = Int(cell.rightTextField.text!)!
                }
            } else {
                self.searchData["priceTo"] = ""
            }
        } else {
            self.searchData["priceTo"] = ""
        }
    }
}

// MARK: Breed Search Delegate
extension ParametersViewController: BreedSearchDelegate {
    func didSelectBreed(firstBreed: String) {
        publication.petInfo.breed = firstBreed
        searchData["breed"] = firstBreed
        tableView.reloadData()
    }

    func didSelectBreed(secondBreed: String?) {
        publication.petInfo.secondBreed = secondBreed
        searchData["secondBreed"] = secondBreed
        tableView.reloadData()
    }
}

// MARK: Age select delegate
extension ParametersViewController: AgeSelectionForSearchDelegate {
    func didSelectFrom(age: Int) {
        searchData["ageFrom"] = age
        tableView.reloadData()
    }

    func didSelectTo(age: Int) {
        searchData["ageTo"] = age
        tableView.reloadData()
    }
}
