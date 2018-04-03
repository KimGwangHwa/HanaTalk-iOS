//
//  ParseHelper.swift
//  talk
//
//  Created by ひかりちゃん on 2018/03/17.
//

import UIKit
import Parse


fileprivate let applicationId = "ArTrHaVDOzyC4Wbr0up1BMnGfNauYTKhZunQZ1PK"
fileprivate let clientKey = "EUwwJWILGla9CLLHv8sKe6cicLU3HBYD8PyrARS1"
fileprivate let server = "https://parseapi.back4app.com"

class ParseHelper: NSObject {
    
    class func installations(with application: UIApplication) {
        let configuration = ParseClientConfiguration {
            $0.applicationId = applicationId
            $0.clientKey = clientKey
            $0.server = server
            $0.isLocalDatastoreEnabled = true
        }
        Parse.initialize(with: configuration)
        
        // notification
        let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.sound, UIUserNotificationType.badge]
        
        let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

    }
    
    class func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) {

        let installation = PFInstallation.current()
        if let userInfo = DataManager.shared.currentuserInfo, let objectId = userInfo.objectId {
            installation?.addUniqueObject(objectId, forKey: "channels")
        }
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()
    }
    
    // MARK: - Push Notification
    
    class func sendMessage(_ message: Message?, completion: ((Bool) -> Void)?) {
        let objectId = message?.receiver?.objectId ?? ""
        let textString = message?.text ?? ""
        let imageURL = message?.imageURL ?? ""
        let type =  message?.type ?? 0
        let from = message?.sender?.objectId ?? ""
        let to = message?.receiver?.objectId ?? ""
        let alert = message?.title ?? ""
        let talkRoomId = message?.talkRoom?.objectId
        
        let push = PFPush()
        push.setChannel(objectId)
        push.setData([
            kPushNotificationAlert : alert,
            kPushNotificationFrom : from,
            kPushNotificationTo : to,
            kPushNotificationText : textString,
            kPushNotificationType: type,
            kPushNotificationImageURL : imageURL,
            kPushNotificationId : objectId,
            kPushNotificationTalkRoomId : talkRoomId ?? ""
            ])
        push.sendInBackground { (isSuccess, error) in
            message?.pinInBackground()
            if let guardCompletion = completion {
                guardCompletion(error == nil ? true : false)
            }
        }
    }
    
    class func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any]) {
//        PFPush.handle(userInfo)
        let message = Message.newReceiveRemoteNotification(userInfo)
        message.pinInBackground()
        
        NotificationCenter.default.post(name: .PushNotificationDidRecive, object: message, userInfo: userInfo)
    }
    
}
