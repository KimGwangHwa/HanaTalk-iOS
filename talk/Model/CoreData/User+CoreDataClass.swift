//
//  User+CoreDataClass.swift
//  
//
//  Created by ひかりちゃん on 2017/10/23.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    //private init() {}
    
    class func createNewRecord() -> User {
        let tweet = NSEntityDescription.entity(forEntityName: EntityName.User.rawValue, in: CoreDataManager.shared.managedObjectContext)
        let user = User(entity: tweet!, insertInto: CoreDataManager.shared.managedObjectContext)
        return user
    }

}