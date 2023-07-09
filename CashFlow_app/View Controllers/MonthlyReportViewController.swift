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
    
    let monthNames: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "Dicember"]
    
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
}

extension MonthlyReportViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return monthNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First cell returns a comparison between the total initial amount of money in the month, and the end of it
        // Next cells return the amount of money spent in a certain category
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthlyReportTableViewCell.identifier) as? MonthlyReportTableViewCell else { return UITableViewCell() }
        
        cell.categoryLabel.text = "Category"
        cell.valueLabel.text = "Value"
        
        if(traitCollection.userInterfaceStyle == .dark) {
            cell.backgroundColor         = Colors.darkTableView
            cell.categoryLabel.textColor = Colors.darkTextLabel
            cell.valueLabel.textColor    = Colors.darkTextLabel
        }
        else {
            cell.backgroundColor         = Colors.lightTableView
            cell.categoryLabel.textColor = Colors.lightTextLabel
            cell.valueLabel.textColor    = Colors.lightTextLabel
        }
        
        return cell
    }
}
