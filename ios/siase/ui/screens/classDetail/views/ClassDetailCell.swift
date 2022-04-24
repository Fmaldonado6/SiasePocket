//
//  ClassDetail.swift
//  siase
//
//  Created by Fernando Maldonado on 23/04/22.
//

import Foundation

import UIKit


struct ClassDetailCellModel{
    var label:String
    var subtitle:String
}

class ClassDetailCell:UITableViewCell{
    
    static let identifier = "ClassDetailCell"

    
    func configure(index:Int,max:Int, model:ClassDetailCellModel){
        self.backgroundColor = .systemBackground
        var config = UIListContentConfiguration.subtitleCell()
        config.text = model.label
        config.textProperties.font = config.textProperties.font.withSize(16)
        config.secondaryText = model.subtitle
        config.secondaryTextProperties.color = .systemGray
        
        self.contentConfiguration = config
        self.selectionStyle = .default

        if(index == 0){
            self.layer.cornerRadius = 15
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        
        if(index == max - 1){
            self.layer.cornerRadius = 15
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        
    }
    
}
