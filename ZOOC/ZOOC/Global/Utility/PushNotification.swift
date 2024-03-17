//
//  PushNotification.swift
//  ZOOC
//
//  Created by 장석우 on 11/27/23.
//


import UserNotifications

final class PushNotification {
    
    
    static func send(_ model: PushNotificationModel) {
        
        print("😶‍🌫️\(model.title)푸시 알림을 발송합니다.😶‍🌫️")
        let push =  UNMutableNotificationContent()
        
        push.title = model.title
        push.body = model.body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(model.timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: model.id,
                                            content: push,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
}
