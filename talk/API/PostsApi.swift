//
//  PostsApi.swift
//  talk
//
//  Created by ひかりちゃん on 2017/11/20.
//

import UIKit
import Parse

class PostsApi: NSObject {
    typealias PostsListCompletionHandler = (Response<[Posts]>) -> Void
    
    class func findAllPosts(completion: @escaping PostsListCompletionHandler) {
        findPosts(completion: completion)
     }
    
    class func findPosts(by userInfoObjectId: String? = nil, completion: @escaping PostsListCompletionHandler) {
        let postsQuery = PFQuery(className: "Posts")
        if (userInfoObjectId != nil) {
            postsQuery.whereKey("poster", equalTo: PFObject(withoutDataWithClassName: "UserInfo", objectId: userInfoObjectId))
        }
        postsQuery.includeKeys(["poster", "likeds", "messages"])
        postsQuery.findObjectsInBackground { (pfobjects, error) in
            
            if let guardObjects = pfobjects {
                var retObjects = [Posts]()
                for object in guardObjects {
                    if let postsObject = Posts.convertPosts(with: object) {
                        retObjects.append(postsObject)
                    }
                }
                let response = Response<[Posts]>()
                response.data = retObjects
                response.status = error != nil ? .failure : .success
                completion(response)
                
            }
        }
    }
    
    class func uploadPosts(_ posts: Posts, completion: @escaping StatusCompletionHandler) {
        let pfObject = PFObject(className: "Posts")
        pfObject["contents"] = posts.contents
        pfObject["poster"] = PFObject(withoutDataWithClassName: "UserInfo", objectId: DataManager.shared.currentuserInfo?.objectId)
        pfObject.saveInBackground { (isSuccess, error) in
            UploadImageApi.uploadImagesInBackground(posts.images, className: "Posts", objectId: pfObject.objectId, columnName: "imageUrls", completion: { (status) in
                completion(isSuccess == true ? .success: .failure )
            })
        }
    }
    
}
