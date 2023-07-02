//
//  CategoriesViewController.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 22/12/22.
//

import UIKit


//MARK: Properties -


class CategoriesViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [CategoryTableViewItem]()
    
    let categoryTableview: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = Colors.lightBackground
        
        return tableView
    }()
}


// MARK: Functions -


extension CategoriesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.lightBackground
        
        view.addSubview(categoryTableview)
        
        categoryTableview.delegate   = self
        categoryTableview.dataSource = self
        
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapAdd)), animated: true)
        
        getAllItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryTableview.frame = view.bounds
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "Create category", message: "Create a new category", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Entertainment, Food, ..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let value = field.text, !value.isEmpty else { return }
            self.createItem(newTransferType: value)
        }))
        
        present(alert, animated: true)
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
    
    func createItem(newTransferType: String) {
        let newItem          = CategoryTableViewItem(context: context)
        newItem.transferType = newTransferType
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            print("Error fetching data")
        }
    }
    
    func deleteItem(item: CategoryTableViewItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            print(FetchingError.couldNotSaveNewData.localizedDescription)
        }
    }
    
    func updateItem(item: CategoryTableViewItem, newTransferType: String) {
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


// MARK: Tableview protocols -


extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let model = models[indexPath.row]
        
        cell.textLabel?.text      = model.transferType
        cell.textLabel?.font      = UIFont(name: "Avenir-Medium", size: 20)
        cell.textLabel?.textColor = Colors.lightTextLabel
        cell.backgroundColor      = Colors.lightBackground
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = models[indexPath.row]
        let sheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
            
            alert.addTextField { field in
                field.placeholder = "Entertainment, Food, ..."
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
                guard let field = alert.textFields?.first, let value = field.text, !value.isEmpty else { return }
                self.updateItem(item: model, newTransferType: value)
            }))
            
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteItem(item: model)
        }))
        
        present(sheet, animated: true)
    }
}
