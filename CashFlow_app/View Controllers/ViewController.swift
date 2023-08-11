//
//  ViewController.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 16/12/22.
//

import UIKit

enum FetchingError: Error {
    case couldNotFetchData
    case couldNotSaveNewData
}

// MARK: Properties: -


class MainViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models: [TableViewItem] = [TableViewItem]()

    private var textValueBuffer: String?
    private var dateValueBuffer: String?
    
    static var monthIsChanging  : Bool                 = false
    static var CategorySelection: ((String?)->(Void))? = nil
    static var TBWidth          : CGFloat              = 0
    static var totalBalance     : Int                  = 0
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text                                      = "Transactions"
        label.font                                      = UIFont(name: "Avenir-Medium", size: 40)
        label.textColor                                 = UIColor(red: 57/255, green: 62/255, blue: 70/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        let image  = UIImage(systemName: "plus.circle.fill")
        
        button.setBackgroundImage(image?.withTintColor(UIColor(red: 57/255, green: 62/255, blue: 70/255, alpha: 1.0), renderingMode: .alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let minusButton: UIButton = {
        let button = UIButton()
        let image  = UIImage(systemName: "minus.circle.fill")
        
        button.setBackgroundImage(image?.withTintColor(UIColor(red: 57/255, green: 62/255, blue: 70/255, alpha: 1.0), renderingMode: .alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let totalBalanceLabel: UILabel = {
        let label = UILabel()
        
        label.text                                      = "Total balance: 0"
        label.font                                      = UIFont(name: "Avenir-Medium", size: 20)
        label.textColor                                 = UIColor(red: 57/255, green: 62/255, blue: 70/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let incomeTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        tableView.layer.cornerRadius = 25
        tableView.backgroundColor    = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        
        return tableView
    }()
    
    let categoriesButton: UIButton = {
        let button = UIButton()
        
        button.setTitle     ("Modify categories", for: .normal)
        button.setTitleColor(.systemBlue,         for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let monthlyReportButton: UIButton = {
        let button = UIButton()
        
        button.setTitle     ("View Monthly Report", for: .normal)
        button.setTitleColor(.systemBlue,           for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}


// MARK: Functions: -


extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        traitCollectionDidChange(UITraitCollection(activeAppearance: .active))
        
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(minusButton)
        view.addSubview(totalBalanceLabel)
        view.addSubview(incomeTableView)
        view.addSubview(categoriesButton)
        view.addSubview(monthlyReportButton)
        
        buttonConfiguration()
        
        incomeTableView.delegate   = self
        incomeTableView.dataSource = self
        
        getAllItems()
        
        //let currentMonth = Date()
        //let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentMonth)! // Next date (1 day later)
        
        var TB: Int = 0
        for model in models {
            if(model.isIncome) {
                TB += Int(model.value ?? "") ?? 0
            }
            else {
                TB -= Int(model.value ?? "") ?? 0
            }
        }
        modifyTotalBalance(value: TB, isIncome: true)
        
        /*
        if(!models.isEmpty && isTransitioningToNewMonth(from: currentMonth, to: nextDate)) {
            for model in models {
                deleteItem(item: model)
            }
        }
         */
        
        if(models.isEmpty) {
            DispatchQueue.main.async {
                self.showFirstTimeAlert()
            }
        }
        
        applyConstraints()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if(traitCollection.userInterfaceStyle == .dark) {
            view.backgroundColor            = Colors.darkBackground
            incomeTableView.backgroundColor = Colors.darkTableView
            titleLabel.textColor            = Colors.darkTextLabel
            totalBalanceLabel.textColor     = Colors.darkTextLabel
            
            let image1 = UIImage(systemName: "minus.circle.fill")
            let image2 = UIImage(systemName: "plus.circle.fill")
            
            minusButton.setBackgroundImage(image1?.withTintColor(Colors.lightTableView, renderingMode: .alwaysOriginal), for: .normal)
            addButton  .setBackgroundImage(image2?.withTintColor(Colors.lightTableView, renderingMode: .alwaysOriginal), for: .normal)
        }
        else {
            view.backgroundColor            = Colors.lightBackground
            incomeTableView.backgroundColor = Colors.lightTableView
            titleLabel.textColor            = Colors.lightTextLabel
            totalBalanceLabel.textColor     = Colors.lightTextLabel
            
            let image1 = UIImage(systemName: "minus.circle.fill")
            let image2 = UIImage(systemName: "plus.circle.fill")
            
            minusButton.setBackgroundImage(image1?.withTintColor(Colors.darkBackground, renderingMode: .alwaysOriginal), for: .normal)
            addButton  .setBackgroundImage(image2?.withTintColor(Colors.darkBackground, renderingMode: .alwaysOriginal), for: .normal)
        }
        
        incomeTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        incomeTableView.frame = CGRect(x: Int(view.bounds.minX) + 20, y: Int(view.bounds.minY) + Int(totalBalanceLabel.frame.maxY) + 20, width: Int(view.bounds.width) - 40, height: Int(view.bounds.maxY - totalBalanceLabel.frame.maxY) - 100)
        
        MainViewController.TBWidth = incomeTableView.bounds.width
    }
    
    func isTransitioningToNewMonth(from fromDate: Date, to toDate: Date) -> Bool {
        let calendar = Calendar.current
        let fromComponents = calendar.dateComponents([.year, .month], from: fromDate)
        let toComponents = calendar.dateComponents([.year, .month], from: toDate)
        
        return fromComponents.month != toComponents.month
    }
    
    private func applyConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let addButtonConstraints = [
            addButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addButton.widthAnchor.constraint(equalToConstant: 125),
            addButton.heightAnchor.constraint(equalToConstant: 125)
        ]
        
        let minusButtonConstraints = [
            minusButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            minusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            minusButton.widthAnchor.constraint(equalToConstant: 125),
            minusButton.heightAnchor.constraint(equalToConstant: 125)
        ]
        
        let totalBalanceLabelConstraints = [
            totalBalanceLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            totalBalanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let categoriesButtonConstraints = [
            categoriesButton.topAnchor.constraint(equalTo: incomeTableView.bottomAnchor, constant: 20),
            categoriesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoriesButton.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        let monthlyReportButtonConstraints = [
            monthlyReportButton.topAnchor.constraint(equalTo: incomeTableView.bottomAnchor, constant: 20),
            monthlyReportButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            monthlyReportButton.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(addButtonConstraints)
        NSLayoutConstraint.activate(minusButtonConstraints)
        NSLayoutConstraint.activate(totalBalanceLabelConstraints)
        NSLayoutConstraint.activate(categoriesButtonConstraints)
        NSLayoutConstraint.activate(monthlyReportButtonConstraints)
    }
    
    private func buttonConfiguration() {
        addButton.addAction(UIAction(handler: { _ in
            let alert = UIAlertController(title: "Report income", message: nil, preferredStyle: .alert)
            
            alert.addTextField { field in
                field.placeholder  = "Value:"
                field.keyboardType = .numberPad
            }
            alert.addTextField { field in
                let datePicker = UIDatePicker()
                
                datePicker.datePickerMode           = .date
                datePicker.frame.size               = CGSize(width: 0, height: 300)
                datePicker.preferredDatePickerStyle = .wheels
                
                datePicker.addAction(UIAction(handler: { _ in
                    field.text = self.formatDate(date: datePicker.date)
                }), for: UIControl.Event.valueChanged)
                
                field.inputView = datePicker
                field.text      = self.formatDate(date: Date())
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
                guard let field     = alert.textFields?.first, let value = field.text,        !value.isEmpty    else { return }
                guard let dateField = alert.textFields?[1],    let dateText = dateField.text, !dateText.isEmpty else { return }
                
                let date = self?.deFormatDate(dateText: dateText)
                
                self?.modifyTotalBalance(value: Int(value) ?? 0, isIncome: true)
                self?.createItem(value: value, isIncome: true, date: date ?? Date(), transferType: "Income")
            }))
            
            self.present(alert, animated: true)
        }), for: .touchUpInside)
        
        minusButton.addAction(UIAction(handler: { _ in
            MainViewController.CategorySelection = { category in
                let alert = UIAlertController(title: "Report expenses", message: nil, preferredStyle: .alert)
                
                alert.addTextField { field in
                    field.placeholder  = "Value: "
                    field.keyboardType = .numberPad
                    field.text         = self.textValueBuffer ?? ""
                }
                alert.addTextField { field in
                    let datePicker = UIDatePicker()
                    
                    datePicker.datePickerMode           = .date
                    datePicker.frame.size               = CGSize(width: 0, height: 300)
                    datePicker.preferredDatePickerStyle = .wheels
                    
                    datePicker.addAction(UIAction(handler: { _ in
                        field.text = self.formatDate(date: datePicker.date)
                    }), for: UIControl.Event.valueChanged)
                    
                    field.inputView = datePicker
                    if(self.dateValueBuffer != nil) {
                        field.text = self.dateValueBuffer ?? ""
                    }
                    else {
                        field.text = self.formatDate(date: Date())
                    }
                }
                alert.addTextField { field in
                    let PVC = PopUpViewController()
                    PVC.modalPresentationStyle = .popover

                    field.addAction(UIAction(handler: { _ in
                        alert.dismiss(animated: true)
                        self.textValueBuffer = alert.textFields?[0].text
                        self.dateValueBuffer = alert.textFields?[1].text
                        self.present(PVC, animated: true)
                    }), for: .touchDown)
                    field.placeholder = "Category: Entertainment, Food, etc..."
                }
                
                alert.textFields![2].text = category ?? ""
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
                    guard let field     = alert.textFields?.first, let value    = field.text,     !value.isEmpty    else { return }
                    guard let dateField = alert.textFields?[1],    let dateText = dateField.text, !dateText.isEmpty else { return }
                    
                    let date = self?.deFormatDate(dateText: dateText)
                    
                    self?.modifyTotalBalance(value: Int(value) ?? 0, isIncome: false)
                    self?.createItem(value: value, isIncome: false, date: date ?? Date(), transferType: category ?? "")
                }))
                
                self.present(alert, animated: true)
            }
            
            guard let categorySelection = MainViewController.CategorySelection else { return }
            categorySelection(nil)
        }), for: .touchUpInside)
        
        categoriesButton.addAction(UIAction(handler: { _ in
            let CatVC   = CategoriesViewController()
            CatVC.title = "Categories"
            self.navigationController?.pushViewController(CatVC, animated: true)
        }), for: .touchUpInside)
        
        monthlyReportButton.addAction(UIAction(handler: { _ in
            let MonVC = MonthlyReportViewController()
            MonVC.title = "Monthly Report"
            self.navigationController?.pushViewController(MonVC, animated: true)
        }), for: .touchUpInside)
    }
    
    private func getMonthName(month: Date) -> String {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth          = dateFormatter.string(from: month)
        
        return nameOfMonth
    }
    
    private func showFirstTimeAlert() {
        let sheet = UIAlertController(title: "Initial balance", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Set initial balance", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Set an initial balance", message: nil, preferredStyle: .alert)
            
            alert.addTextField { field in
                field.placeholder  = "Value: "
                field.keyboardType = .numberPad
            }
            alert.addTextField { field in
                let datePicker = UIDatePicker()
                
                datePicker.datePickerMode           = .date
                datePicker.frame.size               = CGSize(width: 0, height: 300)
                datePicker.preferredDatePickerStyle = .wheels
                
                datePicker.addAction(UIAction(handler: { _ in
                    field.text = self.formatDate(date: datePicker.date)
                }), for: UIControl.Event.valueChanged)
                
                field.inputView   = datePicker
                field.text        = self.formatDate(date: Date())
            }
            
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
                guard let field     = alert.textFields?.first, let value    = field.text,     !value.isEmpty    else { return }
                guard let dateField = alert.textFields?[1],    let dateText = dateField.text, !dateText.isEmpty else { return }
                
                self.modifyTotalBalance(value: Int(value) ?? 0, isIncome: true)
                
                let formatter = DateFormatter()
                
                formatter.dateFormat = "dd/MM/yy"
                let date             = formatter.date(from: dateText)
                
                self.createItem(value: value, isIncome: true, date: date ?? Date(), transferType: "Initial Balance")
            }))
            
            self.present(alert, animated: true)
        }))
        
        present(sheet, animated: true)
    }
    
    private func formatDate(date: Date) -> String {
        let formatter        = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        
        return formatter.string(from: date)
    }
    
    private func deFormatDate(dateText: String) -> Date {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yy"
        return formatter.date(from: dateText) ?? Date()
    }
    
    private func modifyTotalBalance(value: Int, isIncome: Bool) {
        var formattedString = ""
        
        if(isIncome) {
            MainViewController.totalBalance += value
            formattedString = formatNumber(number: MainViewController.totalBalance)
            totalBalanceLabel.text = "Total balance: \(formattedString )"
        }
        else {
            MainViewController.totalBalance -= value
            formattedString = formatNumber(number: MainViewController.totalBalance)
            totalBalanceLabel.text = "Total balance: \(formattedString )"
        }
    }
    
    private func formatNumber(number: Int) -> String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle       = .currency
        formatter.currencySymbol    = "$"
        formatter.groupingSeparator = ","
        formatter.groupingSize      = 3
        
        return formatter.string(from: number as NSNumber) ?? ""
    }
    
// MARK: Core data functions: -
    
    
    func getAllItems() {
        do {
            models = try context.fetch(TableViewItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.incomeTableView.reloadData()
            }
        } catch {
            print(FetchingError.couldNotFetchData.localizedDescription)
        }
    }
    
    func createItem(value: String, isIncome: Bool, date: Date, transferType: String?) {
        let newItem = TableViewItem(context: context)
        
        newItem.value        = value
        newItem.date         = date
        newItem.isIncome     = isIncome
        newItem.transferType = transferType ?? "nil"
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            print(FetchingError.couldNotSaveNewData.localizedDescription)
        }
    }
    
    func deleteItem(item: TableViewItem) {
        if(item.isIncome) {
            modifyTotalBalance(value: Int(item.value ?? "") ?? 0, isIncome: false)
        }
        else {
            modifyTotalBalance(value: Int(item.value ?? "") ?? 0, isIncome: true)
        }
        
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            print(FetchingError.couldNotSaveNewData.localizedDescription)
        }
    }
    
    func updateItem(item: TableViewItem, newValue: String, newDate: Date, transferType: String?) {
        if(item.isIncome) {
            if(Int(item.value ?? "0") ?? 0 > Int(newValue) ?? 0) {
                modifyTotalBalance(value: ((Int(item.value ?? "0") ?? 0) - (Int(newValue) ?? 0)), isIncome: false)
            }
            else if(Int(item.value ?? "0") ?? 0 < Int(newValue) ?? 0) {
                modifyTotalBalance(value: ((Int(newValue) ?? 0) - (Int(item.value ?? "0") ?? 0)), isIncome: true)
            }
        }
        else {
            if(Int(item.value ?? "0") ?? 0 > Int(newValue) ?? 0) {
                modifyTotalBalance(value: ((Int(item.value ?? "0") ?? 0) - (Int(newValue) ?? 0)), isIncome: true)
            }
            else if(Float(item.value ?? "0") ?? 0 < Float(newValue) ?? 0) {
                modifyTotalBalance(value: ((Int(newValue) ?? 0) - (Int(item.value ?? "0") ?? 0)), isIncome: false)
            }
        }
        
        guard let newTransferType = transferType else { return }
        
        item.value        = newValue
        item.date         = newDate
        item.transferType = newTransferType
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            print(FetchingError.couldNotSaveNewData.localizedDescription)
        }
    }
}


// MARK: Table view delegate and datasource: -


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier) as? CustomTableViewCell else { return UITableViewCell() }
        
        let model = models[indexPath.row]
        
        let date   = model.date ?? Date()
        let result = formatDate(date: date)
        
        let formattedString = formatNumber(number: Int(model.value ?? "0") ?? 0)
        
        cell.frame           = CGRect(x: tableView.bounds.minX, y: tableView.bounds.minY, width: tableView.bounds.width, height: tableView.bounds.height)
        cell.valueLabel.text = "\(formattedString)"
        cell.dateLabel.text  = "\(result)"
        
        if(traitCollection.userInterfaceStyle == .dark) {
            cell.backgroundColor     = Colors.darkTableView
            cell.typeLabel.textColor = Colors.darkTextLabel
            cell.dateLabel.textColor = Colors.darkTextLabel
        }
        else {
            cell.backgroundColor     = Colors.lightTableView
            cell.typeLabel.textColor = Colors.lightTextLabel
            cell.dateLabel.textColor = Colors.lightTextLabel
        }
        
        
        if(model.isIncome) {
            cell.valueLabel.textColor = .systemGreen
        }
        else {
            cell.valueLabel.textColor = .systemRed
        }
        
        cell.typeLabel.text       = model.transferType
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item  = self.models[indexPath.row]
        let sheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            MainViewController.CategorySelection = { category in
                let alert = UIAlertController(title: "Edit item", message: "Edit your item", preferredStyle: .alert)
                
                alert.addTextField { field in
                    field.placeholder  = "Value: "
                    field.keyboardType = .numberPad
                }
                alert.addTextField { field in
                    let datePicker = UIDatePicker()
                    
                    datePicker.datePickerMode           = .date
                    datePicker.frame.size               = CGSize(width: 0, height: 300)
                    datePicker.preferredDatePickerStyle = .wheels
                    
                    datePicker.addAction(UIAction(handler: { _ in
                        field.text = self.formatDate(date: datePicker.date)
                    }), for: UIControl.Event.valueChanged)
                    
                    field.inputView   = datePicker
                    field.placeholder = "Date: "
                }
                alert.addTextField { field in
                    let PVC = PopUpViewController()
                    PVC.modalPresentationStyle = .popover

                    field.addAction(UIAction(handler: { _ in
                        alert.dismiss(animated: true)
                        self.present(PVC, animated: true)
                    }), for: .touchDown)
                    field.placeholder = "Category: Entertainment, Food, etc..."
                }
                
                alert.textFields![0].text = item.value
                alert.textFields![1].text = self.formatDate(date: item.date ?? Date())
                if(category != nil) {
                    alert.textFields![2].text = category ?? ""
                }
                else {
                    alert.textFields![2].text = item.transferType
                }
                
                alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                    guard let field     = alert.textFields?.first, let value    = field.text,     !value.isEmpty    else { return }
                    guard let dateField = alert.textFields?[1],    let dateText = dateField.text, !dateText.isEmpty else { return }
                    guard let typeField = alert.textFields?[2],    let typeText = typeField.text, !typeText.isEmpty else { return }
                    
                    let date = self?.deFormatDate(dateText: dateText)
                    
                    self?.updateItem(item: item, newValue: value, newDate: date ?? Date(), transferType: typeText)
                }))
                self.present(alert, animated: true)
            }
            guard let categorySelection = MainViewController.CategorySelection else { return }
            categorySelection(nil)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteItem(item: item)
        }))
        
        self.present(sheet, animated: true)
    }
}
