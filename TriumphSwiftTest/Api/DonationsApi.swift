//
//  DonationsApi.swift
//  TriumphSwiftTest
//
//  Created by Jared Geller on 8/25/21.
//

import Foundation
import FirebaseDatabase

class DonationsApi {
    
    // TODO: We aren't getting any donations from the database!
    func getMyDonations(completion: @escaping ([Donation]?) -> Void) {
        //called on a background thread;
        Database.database().reference().child("myDonations").child("uid1").observe(.value, with: {
            snapshot in

            var donations = [Donation]()
            
            if !snapshot.exists() {
                completion(donations)
            } else if let donationIdDict = snapshot.value as? [String: Bool] {
                
                let dispatchGroup = DispatchGroup();
//                let dispatchSemaphore = DispatchSemaphore(value: 0);
                
                for donationId in donationIdDict {
                    
                    dispatchGroup.enter();
                    Database.database().reference().child("donations").child(donationId.key).observeSingleEvent(of: .value, with: {
                        snapshot in
                        
                        

                        if let donationData = snapshot.value as? [String: Any] {
                            let donation = Donation.transformDonation(dict: donationData, key: snapshot.key)
//                            print(donation.timestamp);
                            donations.append(donation)
                            
                            
                        }
                        
                        dispatchGroup.leave();
                    })
                    
                    
                    
                }
                

                dispatchGroup.notify(queue: .main) {
                    
                    completion(donations);
                }
                
                
            }
            
            
        })
    }
    
    // TODO: Write function to increment the amount donated node under an organization with Id orgId by amount
    func addDonationToOrg(orgId: String, uid: String="uid1", amount: Int, givenAmount: Double, completion: @escaping (Bool) -> Void){
        
        var success = true;
        let dispatch = DispatchGroup();
        
        //the transaction block didn't make sense in the documentation. So i used this method instead. I'm sorry
        
        Database.database().reference().child("organization").child(orgId).updateChildValues(["amountGiven": (Double(amount)+givenAmount)]) { err, ref in
            if(err == nil){
                success = true;
            }else{
                print(err);
                success = false;
            }

            dispatch.leave();
        }

        dispatch.enter();

        dispatch.notify(queue: .main) {
            completion(success)
        }
        
        
    }
    
}
