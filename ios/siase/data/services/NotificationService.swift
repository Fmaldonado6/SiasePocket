//
//  NotificationService.swift
//  siase
//
//  Created by Fernando Maldonado on 23/04/22.
//

import Foundation
import UserNotifications

class NotificationService{
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func requestPermission(completer:@escaping(Bool,Error?)->Void){
        self.notificationCenter.requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: completer
        )
        
        
    }
    
    func hasPermission(completer:@escaping(Bool)->Void){
        self.notificationCenter.getNotificationSettings(completionHandler: { settings in
            completer(settings.authorizationStatus == .authorized)
        })
    }
    
    func scheduleNotification(notification:Notification){
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.subtitle = notification.subtitle
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = NotificationCategory.identifier
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notification.trigger, repeats: true)
        
        let scheduleRequest = UNNotificationRequest(
            identifier: notification.identifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(scheduleRequest)
        {
                  (error) in
                  if let error = error
                  {
                      print("Uh oh! We had an error: \(error)")
                  }
              }
    }
    
    func removeNotifications(){
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    
}
