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
    
    public struct Menuitem{
        let name:String
        let iconName:String
        let viewController:UIViewController
    }
    
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>!

    
    private let careersHeader = SidebarItem.header(title: "Carreras",id: RowIdentifier.careers)
    private var menuItems:[Menuitem] = []
    
    private var careersSectionSnapshot :NSDiffableDataSourceSectionSnapshot<SidebarItem>!
    
    private var careersSnapshots : [NSDiffableDataSourceSectionSnapshot<SidebarItem>] = []
    private var careerItems:[SidebarItem] = []
    
    private var onMenuItemSelected: (UIViewController)->Void = {vc in}
    private var onCareerOptionSelected:(SidebarItem)->Void = {item in}
    private var onScheduleSelected:(SidebarItem)->Void = {item in}
    private var onSidebarLoaded: ()->Void = {}
    
    private var careerOptionChildren : [UUID:[SidebarItem]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
        onSidebarLoaded()
    }
    
    func setMenuItemSelected(listener:@escaping (UIViewController)->Void){
        self.onMenuItemSelected = listener
    }
    
    func setCareerOptionSelected(listener:@escaping (SidebarItem)->Void){
        self.onCareerOptionSelected = listener
    }
    
    func setOnScheduleSelected(listener:@escaping (SidebarItem)->Void){
        self.onScheduleSelected = listener
    }
    
    func setOnSidebarLoaded(listener:@escaping ()->Void){
        self.onSidebarLoaded = listener
    }
    
    func setMenuItems(menuItems:[Menuitem]){
        self.menuItems = menuItems
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
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
            
            contentConfiguration.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: 10, leading: 0, bottom: 10, trailing: 0)
            
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
        
        let kardexRowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            contentConfiguration.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: 10, leading: 0, bottom: 10, trailing: 0)
            
            cell.contentConfiguration = contentConfiguration
        }
        
        
        let scheduleOptionRowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            contentConfiguration.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: 10, leading: 0, bottom: 10, trailing: 0)
            
            cell.contentConfiguration = contentConfiguration
        }
        
        
        
        let loadingRowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            let stackView = {
                let view = UIStackView()
                view.axis = .horizontal
                view.distribution = .equalCentering
                view.alignment = .center
                view.translatesAutoresizingMaskIntoConstraints = false
                
                return view
            }()
            
            
            let loading = {
                let view = UIActivityIndicatorView()
                view.startAnimating()
                return view
            }()
            
            stackView.addArrangedSubview(loading)
            
            cell.addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: cell.leadingAnchor,constant: 0),
                stackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor,constant: 0),
                stackView.topAnchor.constraint(equalTo: cell.topAnchor,constant: 10),
                stackView.bottomAnchor.constraint(equalTo: cell.bottomAnchor,constant: -10)
            ])
        }
        
        dataSource = UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell in
            
            switch item.type {
            case .header:
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            case .expandableRow:
                return collectionView.dequeueConfiguredReusableCell(using: expandableRowRegistration, for: indexPath, item: item)
            case .scheduleRow:
                return collectionView.dequeueConfiguredReusableCell(using: expandableRowRegistration, for: indexPath,item: item)
            case .kardexRow:
                return collectionView.dequeueConfiguredReusableCell(using: kardexRowRegistration, for: indexPath, item:item)
            case .loadingRow:
                return collectionView.dequeueConfiguredReusableCell(using: loadingRowRegistration, for: indexPath, item:item)
            case .scheduleOptionRow:
                return collectionView.dequeueConfiguredReusableCell(using: scheduleOptionRowRegistration, for: indexPath, item:item)
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
            
            let kardex = SidebarItem.kardexRow(
                title: "Kardex",
                subtitle: nil,
                image: UIImage(systemName: "text.badge.checkmark"),
                claveCarrera: career.claveCarrera,
                claveDependencia: career.claveDependencia,
                id: UUID()
            )
            
            let schedule = SidebarItem.scheduleRow(
                title: "Horarios",
                subtitle: nil,
                image: UIImage(systemName: "clock"),
                claveCarrera: career.claveCarrera,
                claveDependencia: career.claveDependencia,
                id: UUID()
            )
            
            careerItems.append(row)
            
            appendToCareerSection(sideBarItems: [row], to: careersHeader)
            appendToCareerSection(sideBarItems: [schedule,kardex], to: row)
            appendToCareerSection(sideBarItems: [SidebarItem.loadingRow(title: "Cargando")], to: schedule)
            
        }
    }
    
    
    func appendToCareerSection(sideBarItems:[SidebarItem], to:SidebarItem,replace:Bool = false){
        if(replace){
            careersSectionSnapshot.delete(careerOptionChildren[to.id] ?? [])
        }
        careerOptionChildren[to.id] = sideBarItems
        careersSectionSnapshot.append(sideBarItems,to:to)
        dataSource.apply(careersSectionSnapshot,to:.careers,animatingDifferences:true)
        
    }
    
    
}

@available(iOS 14, *)
extension Sidebar: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sidebarItem = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if(sidebarItem.type == SidebarItemType.loadingRow){
            collectionView.deselectItem(at: indexPath, animated: false)
            return
        }
        
        if(sidebarItem.type == SidebarItemType.scheduleOptionRow){
            self.onScheduleSelected(sidebarItem)
            return
        }
        
        if(sidebarItem.type == SidebarItemType.kardexRow){
            self.onCareerOptionSelected(sidebarItem)
            return
        }
        
        if(indexPath.section == SidebarSection.menu.rawValue) {
            let index = indexPath.row-1
            onMenuItemSelected(menuItems[index].viewController)
            return
        }
        
        if(indexPath.section == SidebarSection.careers.rawValue){
            didSelectCareer(sidebarItem: sidebarItem)
        }
    }
    
    
    private func didSelectCareer(sidebarItem:SidebarItem){
        if(!careersSectionSnapshot.isExpanded(sidebarItem)){
            careersSectionSnapshot.expand([sidebarItem])
            checkIfCareerOptionIsEmpty(sidebarItem: sidebarItem)
        }else{
            careersSectionSnapshot.collapse([sidebarItem])
        }
        
        dataSource.apply(careersSectionSnapshot,to:.careers,animatingDifferences:true)
    }
    
    private func checkIfCareerOptionIsEmpty(sidebarItem:SidebarItem){
        if(sidebarItem.type != SidebarItemType.kardexRow
           && sidebarItem.type != SidebarItemType.scheduleRow
        ){
            return
        }
        
        guard let children = careerOptionChildren[sidebarItem.id] else { return }
        
        
        if(children.count <= 1){
            self.onCareerOptionSelected(sidebarItem)
        }
        
    }
    
    
}
