//
//  MoreInformationViewController.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 15/03/2021.
//

import UIKit
//MARK: - More Information View Controller
final class MoreInformationViewController: UIViewController {
    
    //MARK: Properties
    var tableViewArray = SpoonacularParameters()
    var cuisines = [String]()
    var intolerances = [String]()
    var diets = [String]()
    
    var typeOfCuisineSelected = [String]()
    var typeOfDietSelected = [String]()
    var typeOfIntolerancesSelected = [String]()
    var typeOfMealSelected = [String]()
    
    weak var delegate: PassingDataDelegateProtocol?
    
    //MARK: Outlet
    @IBOutlet weak var typeOfCuisinesTableView: UITableView!
    @IBOutlet weak var intolerancesTableView: UITableView!
    @IBOutlet weak var typeOfDietTableView: UITableView!
    @IBOutlet weak var typeOfMealSegmentedControl: UISegmentedControl!
    
    //MARK: Methods Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeOfDietTableView.delegate = self
        typeOfDietTableView.dataSource = self
        
        intolerancesTableView.delegate = self
        intolerancesTableView.dataSource = self
        
        typeOfCuisinesTableView.delegate = self
        typeOfCuisinesTableView.dataSource = self
        
        translateCuisine()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        typeOfDietTableView.reloadData()
        typeOfCuisinesTableView.reloadData()
        intolerancesTableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.updateData(for: typeOfDietSelected, intoleranceArray: typeOfIntolerancesSelected, cuisineArray: typeOfCuisineSelected, mealArray: typeOfMealSelected)
    }
    
    //MARK: Actions
    @IBAction func mealTypeSegmentedControl(_ sender: Any) {
        if typeOfMealSegmentedControl.selectedSegmentIndex == 1 {
            typeOfMealSelected = tableViewArray.mealTypesEntree
        }
        if typeOfMealSegmentedControl.selectedSegmentIndex == 2 {
            typeOfMealSelected = tableViewArray.mealTypesMainDish
        }
        if typeOfMealSegmentedControl.selectedSegmentIndex == 3 {
            typeOfMealSelected = tableViewArray.mealTypesDessert
        }
    }
    
    //MARK: File Private Func
    ///method to translate element in cuisine array
    fileprivate func translateCuisine() {
        translate(from: "en", to: "fr", for: tableViewArray.cuisines.joined(separator: ",")) { (translatedText) in
            self.cuisines = translatedText.components(separatedBy: ",")
            self.typeOfCuisinesTableView.reloadData()
            self.translateIntolerance()
        }
    }
    
    ///method to translate element in diet array
    fileprivate func translateDiet() {
        translate(from: "en", to: "fr", for: tableViewArray.diets.joined(separator: ",")) { (translatedText) in
            self.diets = translatedText.components(separatedBy: ",")
            self.typeOfDietTableView.reloadData()
        }
    }
 
    ///method to translate element in intolerances array
    fileprivate func translateIntolerance() {
       translate(from: "en", to: "fr", for: tableViewArray.intolerances.joined(separator: ",")) { (translatedText) in
            self.intolerances = translatedText.components(separatedBy: ",")
            self.intolerancesTableView.reloadData()
            self.translateDiet()
        }
    }
  
    ///method to translate String
    fileprivate func translate(from detectedLang: String, to desiredLang: String, for text: String, completion: @escaping(String) -> Void) {
        TranslationService.shared.getTranslate(from: detectedLang, to: desiredLang, for: text) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(response.data.translations[0].translatedText)
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
}

//MARK: - TableView
extension MoreInformationViewController: UITableViewDataSource, UITableViewDelegate {
    ///method to determine number of Row in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if tableView == typeOfCuisinesTableView {
            count = tableViewArray.cuisines.count
        }
        if tableView == intolerancesTableView {
            count = tableViewArray.intolerances.count
        }
        if tableView == typeOfDietTableView {
            count = tableViewArray.diets.count
        }
        return count ?? 4
    }
   
    ///method to determine cell for Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == typeOfCuisinesTableView{
            var cell = tableView.dequeueReusableCell(withIdentifier: "typeOfCuisineCell", for: indexPath) as? FilterTableViewCell
            configureCell(&cell, tableView, indexPath, for: .cuisine, and: cuisines)
            return cell ?? UITableViewCell()
        }
        if tableView == intolerancesTableView{
            var cell = tableView.dequeueReusableCell(withIdentifier: "intoleranceCell", for: indexPath) as? FilterTableViewCell
            configureCell(&cell, tableView, indexPath, for: .intolerance, and: intolerances)
            return cell ?? UITableViewCell()
        }
        if tableView == typeOfDietTableView{
            var cell = tableView.dequeueReusableCell(withIdentifier: "typeOfDietCell", for: indexPath) as? FilterTableViewCell
            configureCell(&cell, tableView, indexPath, for: .diet, and: diets)
            return cell ?? UITableViewCell()
        }
      return UITableViewCell()
    }
   
    /// method to determine the behavior of a cell when she did select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if tableView == typeOfCuisinesTableView {
            cell?.setSelected(true, animated: true)
            typeOfCuisineSelected.append(tableViewArray.cuisines[indexPath.row])
        }
        if tableView == intolerancesTableView{
            cell?.setSelected(true, animated: true)
            typeOfIntolerancesSelected.append(tableViewArray.intolerances[indexPath.row])
        }
        if tableView == typeOfDietTableView{
            cell?.setSelected(true, animated: true)
            typeOfDietSelected.append(tableViewArray.diets[indexPath.row])
        }
    }

    /// method to determine the behavior of a cell when she didDeselect
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if tableView == typeOfCuisinesTableView {
            cell?.setSelected(false, animated: true)
            guard let index = typeOfCuisineSelected.firstIndex(of: tableViewArray.cuisines[indexPath.row]) else { return }
            typeOfCuisineSelected.remove(at: index)
        }
        if tableView == intolerancesTableView{
            cell?.setSelected(false, animated: true)
            guard let index = typeOfIntolerancesSelected.firstIndex(of: tableViewArray.intolerances[indexPath.row]) else { return }
            typeOfIntolerancesSelected.remove(at: index)
        }
        if tableView == typeOfDietTableView{
            cell?.setSelected(false, animated: true)
            guard let index = typeOfDietSelected.firstIndex(of: tableViewArray.diets[indexPath.row]) else { return }
            typeOfDietSelected.remove(at: index)
        }
    }
    
    //MARK: File private method
    ///method to configure cell
    fileprivate func configureCell(_ cell: inout FilterTableViewCell?, _ tableView: UITableView, _ indexPath: IndexPath, for filter: Filter, and array: [String] ) {
        cell?.titleIsHidden(for: filter )
        if array.count > 0 {
            let title = array[indexPath.row]
            cell?.configure(withTitle: title, for: filter)
        }
    }
   
    ///method to remove unselected element in array
    fileprivate func removeArray(_ array: [String], _ selection: String) {
        if let index = array.firstIndex(of: selection) {
            if array == typeOfCuisineSelected {
                typeOfCuisineSelected.remove(at: index)
            } else if array == typeOfDietSelected {
                typeOfDietSelected.remove(at: index)
            } else if array == typeOfIntolerancesSelected {
                typeOfIntolerancesSelected.remove(at: index)
            }
        }
    }
   
    ///method to append selected element in array
    fileprivate func appendToArray(_ array: [String], _ selection: String) {
        if array == typeOfCuisineSelected {
            typeOfCuisineSelected.append(selection)
        } else if array == typeOfDietSelected {
            typeOfDietSelected.append(selection)
        } else if array == typeOfIntolerancesSelected {
            typeOfIntolerancesSelected.append(selection)
        }
    }
}
