//
//  SettingsCell.swift
//  siase
//
//  Created by Fernando Maldonado on 23/04/22.
//

import Foundation

import UIKit

struct SettingsSection{
    var label:String
    var settings:[SettingsModel]
}

struct SettingsModel{
    var label:String
    var icon:String
    var subtitle:String
    var action:()->Void
}

class SettingsCell:UITableViewCell{
    
    static let identifier = "SettingsCell"

    
    func configure(index:Int,max:Int, model:SettingsModel){
        self.backgroundColor = .systemBackground
        var config = UIListContentConfiguration.subtitleCell()
        config.text = model.label
        config.textProperties.font = config.textProperties.font.withSize(16)
        let imageConfiguration:UIImage.Configuration = UIImage.SymbolConfiguration(scale: .medium)
        let image = UIImage(systemName: model.icon,withConfiguration: imageConfiguration)
        image?.withTintColor(.label)
        config.image = image
        config.imageToTextPadding = 15
        config.imageProperties.tintColor = .systemGray
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
