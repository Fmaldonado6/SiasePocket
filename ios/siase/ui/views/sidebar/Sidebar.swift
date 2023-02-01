//
//  Sidebar.swift
//  siase
//
//  Created by Fernando Maldonado on 26/07/22.
//

import Foundation
import UIKit

class Sidebar : UIViewController{
    

    
    private struct RowIdentifier {
        static let menu = UUID()
        static let careers = UUID()
    }
    
    private struct Menuitem{
        let name:String
        let iconName:String
        let viewController:UIViewController
    }
    
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>!
    private let menuItems = [
        Menuitem(name: "Inicio", iconName: "house", viewController: HomePageController()),
        Menuitem(name: "Más", iconName: "ellipsis", viewController: MorePageController())
    ]
    
    private let careersHeader = SidebarItem.header(title: "Carreras",id: RowIdentifier.careers)

    private var careersSectionSnapshot :NSDiffableDataSourceSectionSnapshot<SidebarItem>!
    
    private var careersSnapshots : [NSDiffableDataSourceSectionSnapshot<SidebarItem>] = []
    private var careerItems:[SidebarItem] = []
    
    private var onMenuItemSelected: (UIViewController)->Void = {vc in}
    private var onSidebarLoaded: ()->Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
        onSidebarLoaded()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds.inset(by: UIEdgeInsets.init(top: 80, left: 0, bottom: 0, right: 0)),
            collectionViewLayout: createLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout() { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            configuration.showsSeparators = false
            configuration.headerMode = .firstItemInSection
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarHeader()
            contentConfiguration.text = item.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .subheadline)
            contentConfiguration.textProperties.color = .secondaryLabel
            contentConfiguration.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 10, trailing: 0)

            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
            
        }
        
        let expandableRowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            contentConfiguration.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 0)

            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
        }
        
        let rowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            contentConfiguration.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: 10, leading: 0, bottom: 10, trailing: 0)

            cell.contentConfiguration = contentConfiguration
        }
        
        dataSource = UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell in
            
            switch item.type {
            case .header:
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            case .expandableRow:
                return collectionView.dequeueConfiguredReusableCell(using: expandableRowRegistration, for: indexPath, item: item)
            default:
                return collectionView.dequeueConfiguredReusableCell(using: rowRegistration, for: indexPath, item: item)
            }
        }
    }
    
    private func createMenuSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "Menú")
        var items = [SidebarItem]()
        
        for  item in menuItems{
            items.append(.row(title: item.name, subtitle: nil, image: UIImage(systemName: item.iconName)))
        }
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        
        return snapshot
    }
    
    private func createCareersSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        careersSectionSnapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        careersSectionSnapshot.append([careersHeader])
        careersSectionSnapshot.expand([careersHeader])
        return careersSectionSnapshot
    }
    
    private func applyInitialSnapshot() {
        dataSource.apply(createMenuSnapshot(), to: .menu, animatingDifferences: false)
        dataSource.apply(createCareersSnapshot(), to: .careers, animatingDifferences: false)
    }
   
    
    func setMenuItemSelected(listener:@escaping (UIViewController)->Void){
        self.onMenuItemSelected = listener
    }
    
    func setOnSidebarLoaded(listener:@escaping ()->Void){
        self.onSidebarLoaded = listener
    }
    
    func loadCareers(careers:[Career]){
        
        
        for  career in careers{
            let careerNameSplit = career.nombre?.split(separator: "-")
            let careerName = careerNameSplit?.last?.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
            let dependencyName = careerNameSplit?.first?.trimmingCharacters(in: .whitespacesAndNewlines)
            let row = SidebarItem.expandableRow(
                title: careerName ?? "",
                subtitle: dependencyName,
                image: UIImage(systemName: "graduationcap"),
                id: UUID()
            )
            
            let kardex = SidebarItem.expandableRow(
                title: "Kardex",
                subtitle: nil,
                image: UIImage(systemName: "text.badge.checkmark"),
                id: UUID()
            )
            
            let schedule = SidebarItem.expandableRow(
                title: "Horarios",
                subtitle: nil,
                image: UIImage(systemName: "clock"),
                id: UUID()
            )
            
            careerItems.append(row)
            
            appendToCareerSection(sideBarItem: row, to: careersHeader)
            appendToCareerSection(sideBarItem: schedule, to: row)
            appendToCareerSection(sideBarItem: kardex, to: row)
 
        }


    }
    
    
    func appendToCareerSection(sideBarItem:SidebarItem, to:SidebarItem){
        careersSectionSnapshot.append([sideBarItem],to:to)
        dataSource.apply(careersSectionSnapshot,to:.careers,animatingDifferences:true)
        
    }
}

@available(iOS 14, *)
extension Sidebar: UICollectionViewDelegate {
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sidebarItem = dataSource.itemIdentifier(for: indexPath) else { return }
        if(indexPath.section == SidebarSection.menu.rawValue) {
            let index = indexPath.row-1
            onMenuItemSelected(menuItems[index].viewController)
        }
        
        if(indexPath.section == SidebarSection.careers.rawValue){
            didSelectCareer(sidebarItem: sidebarItem)
        }
    }
    
    
    private func didSelectCareer(sidebarItem:SidebarItem){
        if(!careersSectionSnapshot.isExpanded(sidebarItem)){
            careersSectionSnapshot.expand([sidebarItem])
        }else{
            careersSectionSnapshot.collapse([sidebarItem])
        }
        
        dataSource.apply(careersSectionSnapshot,to:.careers,animatingDifferences:true)
    }

    
}
