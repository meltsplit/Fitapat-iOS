//
//  AppDelegate.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/21.
//

import UIKit

import AuthenticationServices
import FirebaseCore
import FirebaseMessaging
import KakaoSDKAuth
import KakaoSDKCommon

import Sentry

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("👼🏻 \(#function)")
        setUserNotification(application)
        setKaKaoSDK()
        setFirebaseMessaging()
        setSentry()
        setNavigationBar()
        
        _ = DIContainer.shared
        _ = ImageUploadManager.shared
        
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String) async {
        print("🙏🙏🙏🙏🙏application🙏🙏🙏🙏🙏handleEventsForBackgroundURLSession🙏🙏\(identifier)🙏🙏🙏")
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("👼🏻 \(#function)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                      didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("👼🏻 \(#function)")
        print("Unable to register for remote notifications: \(error.localizedDescription)")
     }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("👼🏻 \(#function)")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("👼🏻 \(#function)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("👼🏻 \(#function)")
    }

}

//MARK: - Custom Setting

extension AppDelegate {
    
    private func setUserNotification(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
    }
    
    
    private func setKaKaoSDK() {
        KakaoSDK.initSDK(appKey: Config.kakaoAppKey)
    }
    
    private func setFirebaseMessaging() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
    }
    
    private func setSentry() {
        SentrySDK.start { options in
            options.dsn = Config.sentryDSN
            options.debug = false
        }
    }
    
    
}

//MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       completionHandler([.list, .banner, .sound])
   }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        let tabVC = DIContainer.shared.makeTabBarController()
        UIApplication.shared.changeRootViewController(tabVC)
    }
        
//        guard let apsValue = userInfo["aps"] as? [String : AnyObject],
//              let alertValue = apsValue["data"] as? [String : String] else {
//            
//            let tabVC = ZoocTabBarController()
//            UIApplication.shared.changeRootViewController(tabVC)
//            return
//        }
//
//        guard let familyID = alertValue["familyId"],
//              let recordID = alertValue["recordId"],
//              let petID = alertValue["petId"] else {
//            print("가드에막혔누")
//            return }
    
    private func setNavigationBar() {
        
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.clear]
        backItemAppearance.normal.backgroundImage = .zwImage(.ic_back)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        
        appearance.backButtonAppearance = backItemAppearance
        appearance.setBackIndicatorImage(.zwImage(.empty),
                                         transitionMaskImage: .zwImage(.empty))
//
        appearance.backgroundColor = .zw_background
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = .zw_black
        
    }
}


//MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("📍 Firebase registration token: \(fcmToken ?? "nil"))")

        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
              } else if let token = token {
                  UserDefaultsManager.fcmToken = token
                 print("FCM registration token: \(token)")
              }
        }
    }
}





    
