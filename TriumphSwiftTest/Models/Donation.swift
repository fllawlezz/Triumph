//
//  Donation.swift
//  TriumphSwiftTest
//
//  Created by Jared Geller on 8/25/21.
//

import Foundation

class Donation {
    var amount: Double?
    var timestamp: Double?
    var receiverId: String?
    var senderId: String?
    var id: String?
}

// So we can compare donation objects
extension Donation: Hashable {
    static func == (lhs: Donation, rhs: Donation) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(id)
    }
}


// Initializer for donation model
extension Donation {
    static func transformDonation(dict: [String:Any], key: String) -> Donation {
        let donation = Donation()
        donation.amount = dict["amount"] as? Double
        donation.timestamp = dict["timestamp"] as? Double
        donation.senderId = dict["senderId"] as? String
        donation.receiverId = dict["receiverId"] as? String
        return donation
    }
}
