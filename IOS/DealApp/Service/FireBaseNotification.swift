//
//  FireBaseNotification.swift
//  DealApp
//
//  Created by Macbook on 01/11/2021.
//

import Firebase
import UIKit
import UserNotifications
import FirebaseFirestore
import FirebaseMessaging

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate, UIApplicationDelegate {
    
    let userID: String
    
    init(userID: String) {
        self.userID = userID
        super.init()
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    
    
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            let usersRef = Firestore.firestore().collection("users_table").document(userID)
            usersRef.setData(["fcmToken": token], merge: true)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        print("\(content.userInfo)")
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if DEVELOPMENT
            //Develop
            Messaging.messaging().setAPNSToken(deviceToken as Data, type: .sandbox)
        #else
            //Production
            Messaging.messaging().setAPNSToken(deviceToken as Data, type: .prod)
        #endif

    }
}
