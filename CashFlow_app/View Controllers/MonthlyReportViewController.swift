//
//  MonthlyReportViewController.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 5/02/23.
//

// TODO: - Report each month the amount of money spent on each category
// TODO: - Report each month the amount of money earned/received


 //The system should create a new section on the tableview whenever each month is over. If the user starts using the app from February, then the first section should be February. Each month has to be stored and then reset every year. While the month is not over, it will display the actualized information from the transaction activity, but when it's over it will freeze.

import UIKit

class MonthlyReportViewController: UIViewController {
    static var TBWidth: CGFloat = 0
    
    var monthLastDays: Int = 31
    let monthNames   : [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let transferTypes: [String] = []
    
    let context                   = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var transferTypeModel = [CategoryTableViewItem]()
    private var valuesModel       = [TableViewItem]()
    
    let reportTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MonthlyReportTableViewCell.self, forCellReuseIdentifier: MonthlyReportTableViewCell.identifier)
        tableView.backgroundColor = Colors.lightBackground
        
        return tableView;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.lightBackground
        
        view.addSubview(reportTableView)
        
        switch (getCurrentMonth().number) {
            case 1:
                monthLastDays = 31
                break
            case 2:
                monthLastDays = 28
                break
            case 3:
                monthLastDays = 31
                break
            case 4:
                monthLastDays = 30
                break
            case 5:
                monthLastDays = 31
                break
            case 6:
                monthLastDays = 30
                break
            case 7:
                monthLastDays = 31
                break
            case 8:
                monthLastDays = 31
                break
            case 9:
                monthLastDays = 30
                break
            case 10:
                monthLastDays = 31
                break
            case 11:
                monthLastDays = 30
                break
            case 12:
                monthLastDays = 31
                break
            default:
                break
        }
        
        reportTableView.delegate   = self
        reportTableView.dataSource = self
        
        getAllItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reportTableView.frame               = view.bounds
        MonthlyReportViewController.TBWidth = view.bounds.width
    }
    
    func getCurrentMonth() -> (name: String, number: Int) {
        let date      = Date()
        let formatter = DateFormatter()
        let calendar  = Calendar.current
        
        let components = calendar.dateComponents([.month], from: date)
        formatter.dateFormat = "LLLL"
        
        return (formatter.string(from: date), components.month ?? 0)
    }
    
    func getCurrentDay() -> Int {
        let date     = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: date)
        
        return components.day ?? 0
    }
    
    func getAllItems() {
        do {
            transferTypeModel = try context.fetch(CategoryTableViewItem.fetchRequest())
            valuesModel       = try context.fetch(TableViewItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.reportTableView.reloadData()
            }
        }
        catch {
            print("Error fetching data")
        }
    }
    
    func getValuePerTT(transferType: String) -> String {
        var valuePerTransferType = 0
        
        for i in 0...valuesModel.count - 1{
            if valuesModel[i].transferType == transferType {
                if valuesModel[i].isIncome {
                    valuePerTransferType += Int(valuesModel[i].value ?? "") ?? 0
                }
                else {
                    valuePerTransferType -= Int(valuesModel[i].value ?? "") ?? 0
                }
            }
        }
        
        return String(valuePerTransferType)
    }
}

extension MonthlyReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let month: Int = getCurrentMonth().number
        return month
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return monthNames[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transferTypeModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthlyReportTableViewCell.identifier, for: indexPath) as? MonthlyReportTableViewCell else { return UITableViewCell() }
        
        let transferType         = transferTypeModel[indexPath.row].transferType
        let valuePerTransferType = getValuePerTT(transferType: transferTypeModel[indexPath.row].transferType ?? "")
        
        cell.typeLabel.text  = transferType
        cell.valueLabel.text = valuePerTransferType
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
