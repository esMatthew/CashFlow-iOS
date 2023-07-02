//
//  CategoryTableViewItem+CoreDataProperties.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 22/12/22.
//
//

import Foundation
import CoreData


extension CategoryTableViewItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryTableViewItem> {
        return NSFetchRequest<CategoryTableViewItem>(entityName: "CategoryTableViewItem")
    }

    @NSManaged public var transferType: String?

}

extension CategoryTableViewItem : Identifiable {

}
