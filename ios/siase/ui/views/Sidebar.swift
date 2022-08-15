//
//  Sidebar.swift
//  siase
//
//  Created by Fernando Maldonado on 26/07/22.
//

import Foundation
import UIKit

class Sidebar : UIViewController{
    
    private enum SidebarItemType: Int {
        case header, expandableRow, row
    }
    
    private enum SidebarSection: Int {
        case menu, careers
    }
    
    private struct SidebarItem: Hashable, Identifiable {
        let id: UUID
        let type: SidebarItemType
        let title: String
        let subtitle: String?
        let image: UIImage?
        
        static func header(title: String, id: UUID = UUID()) -> Self {
            return SidebarItem(id: id, type: .header, title: title, subtitle: nil, image: nil)
        }
        
        static func expandableRow(title: String, subtitle: String?, image: UIImage?, id: UUID = UUID()) -> Self {
            return SidebarItem(id: id, type: .expandableRow, title: title, subtitle: subtitle, image: image)
        }
        
        static func row(title: String, subtitle: String?, image: UIImage?, id: UUID = UUID()) -> Self {
            return SidebarItem(id: id, type: .row, title: title, subtitle: subtitle, image: image)
        }
        
    }
    
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
    
    private let careersHeader = SidebarItem.header(title: "Carreras")
    private var careersSnapshot :NSDiffableDataSourceSectionSnapshot<SidebarItem>!
    private let careerItems:[Menuitem] = []
    
    var onMenuItemSelected: (UIViewController)->Void = {vc in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
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
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
        }
        
        let expandableRowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            cell.layoutMargins = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)

            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
        }
        
        let rowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            cell.layoutMargins = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
            
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
        careersSnapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        careersSnapshot.append([careersHeader])
        careersSnapshot.expand([careersHeader])
        return careersSnapshot
    }
    
    private func applyInitialSnapshot() {
        dataSource.apply(createMenuSnapshot(), to: .menu, animatingDifferences: false)
        dataSource.apply(createCareersSnapshot(), to: .careers, animatingDifferences: false)
    }
   
    
    func setMenuItemSelected(listener:@escaping (UIViewController)->Void){
        self.onMenuItemSelected = listener
    }
    func loadCareers(careers:[Career]){
        var items = [SidebarItem]()
        for  career in careers{
            let careerNameSplit = career.nombre?.split(separator: "-")
            let careerName = careerNameSplit?.last?.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
            let dependencyName = careerNameSplit?.first?.trimmingCharacters(in: .whitespacesAndNewlines)
            items.append(.expandableRow(title: careerName ?? "", subtitle: dependencyName, image: UIImage(systemName: "graduationcap")))
        }
        careersSnapshot.append(items, to: careersHeader)


        dataSource.apply(careersSnapshot,to:.careers,animatingDifferences:true)

    }
}

@available(iOS 14, *)
extension Sidebar: UICollectionViewDelegate {
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sidebarItem = dataSource.itemIdentifier(for: indexPath) else { return }

        print("HOLA")
        if(indexPath.section == SidebarSection.menu.rawValue) {
            onMenuItemSelected(menuItems[indexPath.row-1].viewController)
        }
    }
    

    
}
