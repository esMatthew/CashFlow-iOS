//
//  MonthlyReportViewController.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 8/07/23.
//

import UIKit

class MonthlyReportViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories: [CategoryTableViewItem]      = [CategoryTableViewItem]()
    var models    : [TableViewItem]              = [TableViewItem]()
    var cells     : [MonthlyReportTableViewItem] = [MonthlyReportTableViewItem]()
    
    var sections: [[MonthlyReportTableViewItem]] = [[MonthlyReportTableViewItem]()]
    
    var VPC: [Int]?
    var SPC: [String]?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MonthlyReportTableViewCell.self, forCellReuseIdentifier: MonthlyReportTableViewCell.identifier)
        tableView.backgroundColor = Colors.lightBackground
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.lightBackground
        
        getAllItems()
        
        getCategoryString()
        getAmountOfMoneySpentPerCategory()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func getAllItems() {
        do {
            models     = try context.fetch(TableViewItem.fetchRequest())
            categories = try context.fetch(CategoryTableViewItem.fetchRequest())
            cells      = try context.fetch(MonthlyReportTableViewItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print(FetchingError.couldNotFetchData.localizedDescription)
        }
    }
    
    private func getCategoryString() {
        SPC = [String](repeating: "0", count: categories.count)
        
        for i in 0...categories.count - 1 {
            SPC?[i] = categories[i].transferType ?? "Unkown"
        }
        
        SPC?.insert("Initial Balance", at: 0)
        SPC?.insert("Total balance", at: 1)
    }
    
    private func getAmountOfMoneySpentPerCategory() {
        VPC = [Int](repeating: 0, count: SPC?.count ?? 1)
        
        var buffer = 0
        var sum    = 0
        for i in 0...(SPC?.count ?? 0) - 1 {
            for j in 0...models.count - 1 {
                if(buffer != i) {
                    sum    = 0
                    buffer = i
                }
                
                if(models[j].transferType == SPC?[i]) {
                    sum += Int(models[j].value ?? "0") ?? 0
                }
            }
            VPC?[i] = sum
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
}

extension MonthlyReportViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Calendar.current.component(.month, from: Date())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SPC?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "January"
            case 1:
                return "February"
            case 2:
                return "March"
            case 3:
                return "April"
            case 4:
                return "May"
            case 5:
                return "June"
            case 6:
                return "July"
            case 7:
                return "August"
            case 8:
                return "September"
            case 9:
                return "October"
            case 10:
                return "November"
            case 11:
                return "December"
            default:
                return "Error"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First cell returns a comparison between the total initial amount of money in the month, and the end of it
        
        let category = SPC?[indexPath.row]
        let value    = VPC?[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthlyReportTableViewCell.identifier, for: indexPath) as? MonthlyReportTableViewCell else { return UITableViewCell() }
        
        if(indexPath.row == 0) {
            cell.categoryLabel.text   = SPC?[0]
            cell.valueLabel.text      = formatNumber(number: (Int(models[0].value ?? "0") ?? 0))
            cell.valueLabel.textColor = .systemGreen
            
            if(traitCollection.userInterfaceStyle == .dark) {
                cell.backgroundColor         = Colors.darkTableView
                cell.categoryLabel.textColor = Colors.darkTextLabel
            }
            else {
                cell.backgroundColor         = Colors.lightTableView
                cell.categoryLabel.textColor = Colors.lightTextLabel
            }
        }
        else if(indexPath.row == 1) {
            cell.categoryLabel.text   = "Final Balance"
            cell.valueLabel.text      = formatNumber(number: MainViewController.totalBalance)
            cell.valueLabel.textColor = .systemGreen
            
            if(traitCollection.userInterfaceStyle == .dark) {
                cell.backgroundColor         = Colors.darkTableView
                cell.categoryLabel.textColor = Colors.darkTextLabel
            }
            else {
                cell.backgroundColor         = Colors.lightTableView
                cell.categoryLabel.textColor = Colors.lightTextLabel
            }
        }
        else {
            cell.categoryLabel.text = category
            cell.valueLabel.text    = formatNumber(number: value ?? 0)
            
            if(traitCollection.userInterfaceStyle == .dark) {
                cell.backgroundColor         = Colors.darkTableView
                cell.categoryLabel.textColor = Colors.darkTextLabel
                cell.valueLabel.textColor    = .systemRed
            }
            else {
                cell.backgroundColor         = Colors.lightTableView
                cell.categoryLabel.textColor = Colors.lightTextLabel
                cell.valueLabel.textColor    = .systemRed
            }
        }
        
        return cell
    }
}
