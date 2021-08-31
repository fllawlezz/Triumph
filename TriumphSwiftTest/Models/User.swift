//
//  User.swift
//  TriumphSwiftTest
//
//  Created by Jared Geller on 8/25/21.
//

import Foundation

class User {
    var name: String?
    var username: String?
    var uid: String?
}

// So we can compare user objects
extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.uid == rhs.uid
    }
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(uid)
    }
}


// Initializer for user model
extension User {
    static func transformUser(dict: [String:Any], key: String) -> User {
        let user = User()
        user.name = dict["name"] as? String
        user.username = dict["username"] as? String
        user.uid = key as? String
        return user
    }
}
