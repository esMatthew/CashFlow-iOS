//
//  MonthlyReportTableViewCell.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 8/07/23.
//

import UIKit

class MonthlyReportTableViewCell: UITableViewCell {
    static let identifier = "MonthlyReportTableViewCellIdentifier"
    
    public var categoryLabel: UILabel = {
        let label = UILabel()
        
        label.text          = "Test"
        label.textAlignment = .center
        label.font          = UIFont(name: "Avenir-Medium", size: 15)
        label.textColor     = Colors.lightTextLabel
        
        return label
    }()
    
    public var valueLabel: UILabel = {
        let label = UILabel()
        
        label.text          = "Test"
        label.textAlignment = .center
        label.font          = UIFont(name: "Avenir-Medium", size: 15)
        label.textColor     = Colors.lightTextLabel
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(valueLabel)
        
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        categoryLabel.frame = CGRect(x: 0, y: contentView.bounds.minY, width: (contentView.bounds.width / 2) + 20, height: contentView.bounds.height)
        valueLabel.frame = CGRect(x: contentView.bounds.width / 2, y: contentView.bounds.minY, width: (contentView.bounds.width / 2) + 20, height: contentView.bounds.height)
    }
}
