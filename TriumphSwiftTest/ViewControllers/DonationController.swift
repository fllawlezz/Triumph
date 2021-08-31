//
//  DonationController.swift
//  TriumphSwiftTest
//
//  Created by Brandon In on 8/31/21.
//

import UIKit
import FirebaseDatabase
import SDWebImage

let notificationName = "UpdateAmountGiven"


class DonationController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DonationCellDelegate{

    private let reuseIdentifier = "DonationCell"
    
    var organizations:[Organization] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.alwaysBounceVertical = true;

        // Register cell classes
        
        self.collectionView!.register(DonationCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        getAllOrganizationsMain();
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("org counts: \(organizations.count)")
        return organizations.count;
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DonationCell
        
        cell.organization = organizations[indexPath.item];
//        cell.organization = organizations[0];
        cell.delegate = self;
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2, height: 120);
    }

    //MARK: HELPER FUNCTIONS
    func getAllOrganizationsMain(){
        organizations.removeAll();
        getAllOrganizations { orgs in
            if(orgs != nil){
                for org in orgs!{
                    let org = Organization.transformOrganization(dict: org.value, key: org.key);
                    self.organizations.append(org);
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData();
                }
            }else{
//                print("orgs nil");
            }
        }
    }
    
    func getAllOrganizations(completion: @escaping ([String: [String:Any]]?) -> Void) {
        Database.database().reference().child("organization").observe(.value, with: {
            snapshot in
            
            if let orgData = snapshot.value as? [String: [String:Any]] {
                completion(orgData)
            } else {
                completion(nil)
            }
        })
    }
    
    func handlePressDonateButton(button: UIButton, org: Organization) {
        //show action sheet
        print("pressed donate");
        let orgId = org.id!
        let givenAmount = org.amountGiven!
//        self.handleDonate(orgId, 1, givenAmount: givenAmount, org.name!);
        
//
//
        let actionSheet = UIAlertController(title: "\(org.name!)", message: "Pick how much you want to donate", preferredStyle: .actionSheet);
        actionSheet.addAction(UIAlertAction(title: "$1", style: .default, handler: { action in
            self.handleDonate(orgId, 1, givenAmount: givenAmount, org.name!);
        }))
        actionSheet.addAction(UIAlertAction(title: "$5", style: .default, handler: { action in
            self.handleDonate(orgId, 5, givenAmount: givenAmount, org.name!);
        }))

        actionSheet.addAction(UIAlertAction(title: "$10", style: .default, handler: { action in
            self.handleDonate(orgId, 10, givenAmount: givenAmount, org.name!);
        }))

        actionSheet.addAction(UIAlertAction(title: "$100", style: .default, handler: { action in
            self.handleDonate(orgId, 100, givenAmount: givenAmount, org.name!);
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil));
        self.present(actionSheet, animated: true, completion: nil);
    }
    
    func handleDonate(_ orgId: String ,_ amount: Int, givenAmount: Double, _ orgName: String){
        print("handle donate");
//        print("donate: $\(amount)")
//        let success = Api.Donations.addDonationToOrg(orgId: orgId, uid: "uid1", amount: amount, givenAmount: givenAmount, completion: (Bool) -> Void);
        Api.Donations.addDonationToOrg(orgId: orgId, amount: amount, givenAmount: givenAmount) { bool in
            if(bool){
                self.showSuccessAlert(orgName: orgName, amountDonated: amount, amountGiven: givenAmount, orgId: orgId)
            }else{
                self.showFailureAlert();
            }
        }
        
    }
    
    func showSuccessAlert(orgName: String, amountDonated: Int, amountGiven: Double, orgId: String){
        let alert = UIAlertController(title: "Yay!", message: "You donated $\(amountDonated) to \(orgName)", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Yay!", style: .default, handler: { action in
            //send notification out to refresh the
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil, userInfo: ["amountGiven": (Double(amountDonated)+amountGiven), "orgId": orgId ])
                var count = 20;
                while(count < 40){
                    self.organizations.removeLast();
                    count+=1;
                }
                self.collectionView.reloadData();
            }
            
        }))
        present(alert, animated: true, completion: nil);
    }
    
    func showFailureAlert(){
        let alert = UIAlertController(title: "Oh No!", message: "Your donation failed. Our apologies! Try again later!", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
        present(alert, animated: true, completion: nil);
    }
    
}
