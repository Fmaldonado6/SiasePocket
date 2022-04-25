//
//  Notifications.swift
//  siase
//
//  Created by Fernando Maldonado on 23/04/22.
//

import Foundation

struct Notification{
    var identifier:String
    var title:String
    var subtitle:String
    var trigger:DateComponents
}


class NotificationCategory{
    static let identifier = "ClassNotifications"
}
