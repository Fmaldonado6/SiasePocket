//
//  MainCareerSelectionController.swift
//  siase
//
//  Created by Fernando Maldonado on 11/03/22.
//

import Foundation
import UIKit

class MainCareerSelectionController : UIViewController{
    
    private let viewModel:MainCareerSelectionViewModel = DIContainer
        .shared.resolve(type: MainCareerSelectionViewModel.self)!
    
    private let label:UILabel = {
        let view = UILabel()
        view.text = "Selecciona la carrera que está cursando actualmente"
        view.font = view.font.withSize(14)
        view.textColor = Colors.Light.onPrimaryContainer | Colors.Dark.onPrimaryContainer
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let view = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        view.dataSource = self
        view.register(CareerGridCell.self, forCellWithReuseIdentifier: CareerGridCell.identifier)
        return view
    }()
    
    private var careers:[Career] = [Career]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Carreras"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
        viewModel.bindCareers = {careers in
            self.careers = careers
            self.collectionView.reloadData()
        }
        
        viewModel.getCareers()

        
        setupViews()

    }
    
    func setupViews(){
        
        view.addSubview(collectionView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            label.heightAnchor.constraint(equalToConstant: 50),

            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
}


extension MainCareerSelectionController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return careers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CareerGridCell.identifier, for: indexPath) as! CareerGridCell
        cell.configure(index: indexPath.row, career: self.careers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MainScheduleSelectionViewController()
        vc.index = indexPath.row
        vc.career = careers[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainCareerSelectionController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.cellForItem(at: indexPath)?.layoutSubviews()
        return CGSize(width: self.calculateWidth(), height: 100)
    }
    
    private func calculateWidth() -> CGFloat{
        let screenWidth = self.view.frame.size.width

        if(screenWidth < 700) {return screenWidth}
        else if(screenWidth < 1250) {return screenWidth / 2 - 5}
        
        return screenWidth / 3 - 10
    }
    
}
