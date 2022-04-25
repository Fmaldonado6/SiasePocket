//
//  CareerView.swift
//  siase
//
//  Created by Fernando Maldonado on 14/04/22.
//

import Foundation
import UIKit

class SubjectView :UIView{
    
    private let textStackView:UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private let subjectLabel:UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(15)
        return view
    }()
    private let oportunityLabel:UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(12)
        view.textColor = .systemGray
        return view
    }()
    
    private let scoreLabel:UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    func setSubjectText(text:String){
        subjectLabel.text = text
    }
    
    func setScoreText(text:String){
        scoreLabel.text = text
    }
    
    func setOportunityText(text:String){
        oportunityLabel.text = text
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
        self.addSubview(textStackView)
        self.addSubview(scoreLabel)
        textStackView.addArrangedSubview(subjectLabel)
        textStackView.addArrangedSubview(oportunityLabel)

        NSLayoutConstraint.activate([
            scoreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
            scoreLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 20),
            scoreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -20),
            scoreLabel.widthAnchor.constraint(equalToConstant: 35),
            textStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
            textStackView.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor,constant: -20),
            textStackView.topAnchor.constraint(equalTo: self.topAnchor,constant: 20),
            textStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -20)
        ])
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
