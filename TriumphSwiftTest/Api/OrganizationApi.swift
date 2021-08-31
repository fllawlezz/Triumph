//
//  OrganizationApi.swift
//  TriumphSwiftTest
//
//  Created by Jared Geller on 8/25/21.
//

import Foundation
import FirebaseDatabase

class OrganizationApi {
    func getOrganizationFromId(orgId: String, completion: @escaping (Organization?) -> Void) {
        Database.database().reference().child("organization").child(orgId).observeSingleEvent(of: .value, with: {
            snapshot in
            if let orgData = snapshot.value as? [String: Any] {
                let org = Organization.transformOrganization(dict: orgData, key: snapshot.key)
                completion(org)
            } else {
                completion(nil)
            }
        })
    }
}
