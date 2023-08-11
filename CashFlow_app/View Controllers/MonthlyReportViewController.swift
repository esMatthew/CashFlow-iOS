//
//  MonthlyReportViewController.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 8/07/23.
//

import UIKit

// TODO: Fill the sections BEFORE the current month by saving the monthly reports at the end of each month.

class MonthlyReportViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models: [TableViewItem] = [TableViewItem]()
    
    private var modelsPerMonth: [[TableViewItem]] = [[TableViewItem]]()
    
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
        sortByMonth()
        
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
            models = try context.fetch(TableViewItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print(FetchingError.couldNotFetchData.localizedDescription)
        }
    }
    
    private func sortByMonth() {
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        for _ in 0...currentMonth - 1 {
            modelsPerMonth.append([TableViewItem]())
        }
        
        for i in 0...modelsPerMonth.count - 1 {
            for j in 0...models.count - 1 {
                let modelDate = Calendar.current.component(.month, from: models[j].date ?? Date())
                
                if modelDate == i + 1 {
                    modelsPerMonth[i].append(models[j])
                }
            }
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  Calendar.current.monthSymbols[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First cell returns a comparison between the total initial amount of money in the month, and the end of it
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthlyReportTableViewCell.identifier) as? MonthlyReportTableViewCell else { return UITableViewCell() }
        
        cell.valueLabel.text = "Test"
        cell.categoryLabel.text = "Test"
        
        return cell
    }
}
