//
//  MonthlyReportTableViewItem+CoreDataProperties.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 5/08/23.
//
//

import Foundation
import CoreData


extension MonthlyReportTableViewItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MonthlyReportTableViewItem> {
        return NSFetchRequest<MonthlyReportTableViewItem>(entityName: "MonthlyReportTableViewItem")
    }

    @NSManaged public var transferType: String?
    @NSManaged public var value: String?
    @NSManaged public var date: Date?

}

extension MonthlyReportTableViewItem : Identifiable {

}
