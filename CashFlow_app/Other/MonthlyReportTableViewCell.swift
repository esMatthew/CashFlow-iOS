//
//  MonthlyReportTableViewCell.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 5/02/23.
//

import UIKit

class MonthlyReportTableViewCell: UITableViewCell {
    static let identifier = "MRIdentifier"
    
    var TBWidth: CGFloat = 0
    
    public var valueLabel: UILabel = {
        let label = UILabel()
        
        label.text          = "Value"
        label.textAlignment = .center
        label.font          = UIFont(name: "Avenir-Medium", size: 15)
        
        return label
    }()
    
    public var typeLabel: UILabel = {
        let label = UILabel()
        
        label.text          = "Type"
        label.textAlignment = .center
        label.font          = UIFont(name: "Avenir-Medium", size: 15)
        label.textColor     = Colors.lightTextLabel
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(valueLabel)
        contentView.addSubview(typeLabel)
        
        TBWidth = MonthlyReportViewController.TBWidth
        
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        valueLabel.frame = CGRect(x: TBWidth / 2, y: contentView.bounds.minY, width: CGFloat(TBWidth / 2), height: contentView.bounds.height)
        typeLabel.frame  = CGRect(x: 0,           y: contentView.bounds.minY, width: CGFloat(TBWidth / 2), height: contentView.bounds.height)
    }
}
