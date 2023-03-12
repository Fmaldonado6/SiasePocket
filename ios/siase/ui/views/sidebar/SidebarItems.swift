//
//  SidebarItems.swift
//  siase
//
//  Created by Fernando Maldonado on 31/01/23.
//

import Foundation
import UIKit

enum SidebarItemType: Int {
    case header, expandableRow, row, scheduleRow, kardexRow, loadingRow, scheduleOptionRow
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
    let claveCarrera:String?
    let claveDependencia:String?
    var periodo:String? = nil
    
    
    static func header(
        title: String,
        id: UUID = UUID()
    ) -> Self {
        return SidebarItem(
            id: id,
            type: .header,
            title: title,
            subtitle: nil,
            image: nil,
            claveCarrera: nil,
            claveDependencia: nil
        )
    }
    
    static func expandableRow(
        title: String,
        subtitle: String?,
        image: UIImage?,
        id: UUID = UUID()
    ) -> Self {
        return SidebarItem(
            id: id,
            type: .expandableRow,
            title: title,
            subtitle: subtitle,
            image: image,
            claveCarrera: nil,
            claveDependencia: nil
        )
    }
    
    static func row(
        title: String,
        subtitle: String?,
        image: UIImage?,
        id: UUID = UUID()
    ) -> Self {
        return SidebarItem(
            id: id,
            type: .row,
            title: title,
            subtitle: subtitle,
            image: image,
            claveCarrera: nil,
            claveDependencia: nil
        )
    }
    
    static func loadingRow(
        title: String,
        id: UUID = UUID()
    ) -> Self {
        return SidebarItem(
            id: id,
            type: .loadingRow,
            title: title,
            subtitle: nil,
            image: nil,
            claveCarrera: nil,
            claveDependencia: nil
        )
    }
    
    static func scheduleRow(
        title: String,
        subtitle: String?,
        image: UIImage?,
        claveCarrera:String?,
        claveDependencia:String?,
        id: UUID = UUID()
    ) -> Self {
        return SidebarItem(
            id: id,
            type: .scheduleRow,
            title: title,
            subtitle: subtitle,
            image: image,
            claveCarrera: claveCarrera,
            claveDependencia: claveDependencia
        )
    }
    
    static func scheduleOptionRow(
        title: String,
        image: UIImage?,
        claveCarrera:String?,
        claveDependencia:String?,
        periodo:String?,
        id: UUID = UUID()
    ) -> Self {
        return SidebarItem(
            id: id,
            type: .scheduleOptionRow,
            title: title,
            subtitle: nil,
            image: image,
            claveCarrera: claveCarrera,
            claveDependencia: claveDependencia,
            periodo: periodo
        )
    }
    
    static func kardexRow(
        title: String,
        subtitle: String?,
        image: UIImage?,
        claveCarrera:String?,
        claveDependencia:String?,
        id: UUID = UUID()
    ) -> Self {
        return SidebarItem(
            id: id,
            type: .kardexRow,
            title: title,
            subtitle: subtitle,
            image: image,
            claveCarrera: claveCarrera,
            claveDependencia: claveDependencia
        )
    }
    
}
