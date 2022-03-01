//
//  MainViewController.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

class HomePageController : UIViewController{
    
    private lazy var contentSize = CGSize(
        width: self.view.frame.width,
        height: self.view.frame.height + 1700
    )
    
    private lazy var  scrollView:UIScrollView = {
       let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nextClassLabel:UILabel = {
        let view = UILabel()
        view.text = "Siguiente clase"
        view.font = view.font.withSize(20)
        return view
    }()
    
    private let todaysClassesLabel:UILabel = {
        let view = UILabel()
        view.text = "Clases de hoy"
        view.font = view.font.withSize(17)
        return view
    }()
    
    private let nextClasView:ClassView = {
        let view = ClassView()
        
        view.setClassName(text: "Inteligencia Artificial")
        view.setTimeName(text: "7:00 - 10:00")
        return view
    }()
    
    private let stackView : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        view.spacing = 20
        view.axis = .vertical
        view.distribution = .equalSpacing
        return view
    }()
    
    private let classesView : ScheduleDetailView = {
        let view = ScheduleDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true

        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "¡Hola Fernando!"
        tabBarItem.title = "inicio"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
        setupViews()
    }
    
    private func setupViews(){
        
  
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        scrollView.addSubview(classesView)
       
        stackView.addArrangedSubview(nextClassLabel)
        stackView.addArrangedSubview(nextClasView)
        stackView.addArrangedSubview(todaysClassesLabel)

        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            classesView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            classesView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            classesView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
      
        ])
        
    }
    
   
}
