//
//  SidebarItems.swift
//  siase
//
//  Created by Fernando Maldonado on 31/01/23.
//

import Foundation
import UIKit

enum SidebarItemType: Int {
    case header, expandableRow, row
}

enum SidebarSection: Int {
    case menu, careers
}

struct SidebarItem: Hashable, Identifiable {
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
