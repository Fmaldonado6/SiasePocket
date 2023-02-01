//
//  CareerView.swift
//  siase
//
//  Created by Fernando Maldonado on 14/04/22.
//

import Foundation
import UIKit

class ScheduleView :UIView{
    
    private let textStackView:UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private let scheduleLabel:UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(15)
        return view
    }()

    
    private let iconView:UIImageView = {
        let imageConfiguration:UIImage.Configuration = UIImage.SymbolConfiguration(scale: .small)
        let image = UIImage(systemName: "clock",withConfiguration: imageConfiguration)
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    func setScheduletext(text:String){
        scheduleLabel.text = text
    }
    

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = Colors.Light.surfaceVariant | Colors.Dark.surfaceVariant

        
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )

        self.layer.cornerRadius = 15
        setupViews()
        
    }
    
    private func setupViews(){
        self.addSubview(iconView)
        self.addSubview(textStackView)
        
        textStackView.addArrangedSubview(scheduleLabel)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            iconView.topAnchor.constraint(equalTo: self.topAnchor,constant: 20),
            iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -20),
            iconView.widthAnchor.constraint(equalToConstant: 25),
            textStackView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor,constant: 10),
            textStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
            textStackView.topAnchor.constraint(equalTo: self.topAnchor,constant: 20),
            textStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -20)
        ])
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
