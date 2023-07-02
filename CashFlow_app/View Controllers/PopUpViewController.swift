//
//  PopUpViewController.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 26/12/22.
//

import UIKit

class PopUpViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [CategoryTableViewItem]()
    
    let categoryTableview: UITableView = {
        let tableView = UITableView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        tableView.backgroundColor = Colors.lightBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let alertLabel: UILabel = {
        let label = UILabel()
        
        label.text          = "Go to \"Modify Categories\" to add or remove categories"
        label.font          = UIFont(name: "Avenir-Medium", size: 15)
        label.textColor     = Colors.lightTextLabel
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.lightBackground
        
        view.addSubview(alertLabel)
        view.addSubview(categoryTableview)
        
        applyConstraints()
        
        categoryTableview.delegate   = self
        categoryTableview.dataSource = self
        
        getAllItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryTableview.frame = CGRect(x: 0, y: 30, width: Int(view.bounds.width), height: Int(view.bounds.height))
    }
    
    func applyConstraints() {
        let alertLabelConstraints = [
            alertLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            alertLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
        ]
        
        NSLayoutConstraint.activate(alertLabelConstraints)
    }
    
    // MARK: Core data functions -
    
    
    func getAllItems() {
        do {
            models = try context.fetch(CategoryTableViewItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.categoryTableview.reloadData()
            }
        }
        catch {
            print("Error fetching data")
        }
    }
}

extension PopUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let model = models[indexPath.row]
        
        cell.textLabel?.text      = model.transferType
        cell.textLabel?.font      = UIFont(name: "Avenir-Medium", size: 20)
        cell.textLabel?.textColor = Colors.lightTextLabel
        cell.backgroundColor      = Colors.lightBackground
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = models[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
        
        guard let categorySelection = MainViewController.CategorySelection else { return }
        categorySelection(category.transferType)
    }
}
