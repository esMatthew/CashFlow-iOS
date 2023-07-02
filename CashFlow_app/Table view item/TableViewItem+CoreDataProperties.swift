//
//  TableViewItem+CoreDataProperties.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 23/12/22.
//
//

import Foundation
import CoreData


extension TableViewItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TableViewItem> {
        return NSFetchRequest<TableViewItem>(entityName: "TableViewItem")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isIncome: Bool
    @NSManaged public var value: String?
    @NSManaged public var transferType: String?

}

extension TableViewItem : Identifiable {

}
