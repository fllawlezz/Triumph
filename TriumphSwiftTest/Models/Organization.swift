//
//  Organization.swift
//  TriumphSwiftTest
//
//  Created by Jared Geller on 8/25/21.
//

import Foundation

class Organization {
    var name: String?
    var amountGiven: Double?
    var profilePhotoURL: String?
    var id: String?
}

// So we can compare organization objects
extension Organization: Hashable {
    static func == (lhs: Organization, rhs: Organization) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(id)
    }
}


// Initializer for organization model
extension Organization {
    static func transformOrganization(dict: [String:Any], key: String) -> Organization {
        let org = Organization()
        org.name = dict["name"] as? String
        org.amountGiven = dict["amountGiven"] as? Double
        org.id = key as? String
        org.profilePhotoURL = dict["profilePhotoURL"] as? String
        return org
    }
}
