//
//  RemoteAPIManager.swift
//  talk
//
//  Created by ひかりちゃん on 2017/08/01.
//
//

import UIKit
import Parse

// MARK: Class Delet
class RemoteAPIManager: NSObject {
    
    static let shared = RemoteAPIManager()

    typealias CompletionHandler = (Bool) -> Void

    typealias GetUserInfoListCompletionHandler = (Bool, [UserInfo]?) -> Void
    typealias GetUserInfoCompletionHandler = (Bool, UserInfo?) -> Void

    private override init() {
        super.init()
        initParse()
    }
    
    private func initParse() {
        let configuration = ParseClientConfiguration {
            $0.applicationId = SA_APPLICATIONID
            $0.clientKey = SA_CLIENT_KEY
            $0.server = SA_SERVER
        }
        Parse.initialize(with: configuration)
    }
//    
//    func signUp(request: UserRequest, withCompletion: @escaping CompletionHandler) {
//        
//        let user = PFUser()
//        user.username = request.nickName
//        user.password = request.password
//        user.signUpInBackground { (isSucceeded, error) in
//            withCompletion(isSucceeded)
//        }
//    }
//    
//    func login(request: UserRequest, withCompletion: @escaping CompletionHandler) {
//
//        PFUser.logInWithUsername(inBackground: request.userName, password: request.password) { (user, error) in
//            if user != nil {
//                let loginHistory = LoginHistory.createNewRecord()
//                loginHistory.userName = request.userName
//                loginHistory.password = request.password
//                loginHistory.updateDate = NSDate()
//                loginHistory.objectId = user?.objectId
//                CoreDataManager.shared.saveContext()
//
//                self.getUserInfo(with: DataManager.shared.currentUserObjectId, completion: { (isSuccess, userInfo) in
//                    withCompletion(isSuccess)
//                })
//            }
//            withCompletion(user == nil ? false : true)
//        }
//    }

    func getUserInfo(with userId: String, completion: @escaping GetUserInfoCompletionHandler) {
        let query = PFQuery(className: "UserInfo")
        query.whereKey("userId", equalTo: userId)
        query.findObjectsInBackground(block: { (objects, error) in
                if let infos = UserInfo.convertUserInfos(with: objects) ,
               let currentUserInfo = infos.first {
                DataManager.shared.currentUserInfo = currentUserInfo
                completion(true, currentUserInfo)
            }
        })
    }
  
    func getFollowingUserInfos(completion: @escaping GetUserInfoListCompletionHandler)  {
        
        //userId
        getFollowUserInfo(with: "userId", completion: completion)
    }
    
    func getFollowedUserInfos(completion: @escaping GetUserInfoListCompletionHandler)  {
        
        //followingUserId
        getFollowUserInfo(with: "followingUserId", completion: completion)

    }
    
    private func getFollowUserInfo(with column: String, completion: @escaping GetUserInfoListCompletionHandler) {
    
        let followQuery = PFQuery(className: "Follow")
        followQuery.whereKey(column, equalTo: DataManager.shared.currentUserObjectId)
        followQuery.findObjectsInBackground { (objects, error) in
            var objectIds = [String]()
            for info in Follow.creatFollows(with: objects) {
                objectIds.append(info.objectId ?? "")
            }
            
            let query = PFQuery(className: "UserInfo")
            query.whereKey("userId", containedIn: objectIds)
            query.findObjectsInBackground(block: { (objects, error) in
                completion(true, UserInfo.convertUserInfos(with: objects))
            })
        }
    }
}