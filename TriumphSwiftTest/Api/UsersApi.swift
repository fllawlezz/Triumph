//
//  UsersApi.swift
//  TriumphSwiftTest
//
//  Created by Jared Geller on 8/25/21.
//

import Foundation
import FirebaseDatabase

class UsersApi {
    
    // Gets a user from the current user id. We can assume the user id is "uid1"
    // This function works.
    func getUser(completion: @escaping (User?) -> Void) {
        Database.database().reference().child("users").child("uid1").observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let data = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: data, key: snapshot.key)
                completion(user)
            } else {
                completion(nil)
            }
        })
    }

}
