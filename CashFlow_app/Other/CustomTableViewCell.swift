//
//  CustomTableViewCell.swift
//  CashFlow_app
//
//  Created by Mate Escobar on 19/12/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "UITableViewCellIdentifier"
    
    var TBWidth: CGFloat = 0
    
    public var valueLabel: UILabel = {
        let label = UILabel()
        
        label.text          = "Test"
        label.textAlignment = .center
        label.font          = UIFont(name: "Avenir-Medium", size: 15)
        
        return label
    }()
    
    public var dateLabel: UILabel = {
        let label = UILabel()
        
        label.text          = "Test2"
        label.textAlignment = .center
        label.font          = UIFont(name: "Avenir-Medium", size: 15)
        label.textColor     = Colors.lightTextLabel
        
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
        contentView.addSubview(dateLabel)
        
        TBWidth = MainViewController.TBWidth
        
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        valueLabel.frame = CGRect(x: 0,                 y: contentView.bounds.minY, width: CGFloat(TBWidth / 3), height: contentView.bounds.height)
        typeLabel.frame  = CGRect(x: TBWidth / 3,       y: contentView.bounds.minY, width: CGFloat(TBWidth / 3), height: contentView.bounds.height)
        dateLabel.frame  = CGRect(x: (TBWidth / 3) * 2, y: contentView.bounds.minY, width: CGFloat(TBWidth / 3), height: contentView.bounds.height)
    }
}
