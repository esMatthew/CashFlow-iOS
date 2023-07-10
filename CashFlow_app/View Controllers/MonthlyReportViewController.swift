//
//  MonthlyReportViewController.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 8/07/23.
//

import UIKit

class MonthlyReportViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories: [CategoryTableViewItem] = [CategoryTableViewItem]()
    var models    : [TableViewItem]         = [TableViewItem]()
    
    var VPC: [Int]?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MonthlyReportTableViewCell.self, forCellReuseIdentifier: MonthlyReportTableViewCell.identifier)
        tableView.backgroundColor = Colors.lightBackground
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.lightBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        getAllItems()
        
        getAmountOfMoneySpentPerCategory()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func getAllItems() {
        do {
            models     = try context.fetch(TableViewItem.fetchRequest())
            categories = try context.fetch(CategoryTableViewItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print(FetchingError.couldNotFetchData.localizedDescription)
        }
    }
    
    private func getAmountOfMoneySpentPerCategory() {
        VPC = [Int](repeating: 0, count: categories.count)
        
        var buffer = 0
        var sum    = 0
        for i in 0...categories.count - 1 {
            for j in 0...models.count - 1 {
                if(buffer != i) {
                    sum = 0
                    buffer = i
                }
                
                if(models[j].transferType == categories[i].transferType) {
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        
        return nameOfMonth
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First cell returns a comparison between the total initial amount of money in the month, and the end of it
        let category = categories[indexPath.row]
        let value    = VPC?[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthlyReportTableViewCell.identifier, for: indexPath) as? MonthlyReportTableViewCell else { return UITableViewCell() }
        
        cell.categoryLabel.text = category.transferType
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
        
        return cell
    }
}
