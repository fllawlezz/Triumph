//
//  TabBarController.swift
//  TriumphSwiftTest
//
//  Created by Brandon In on 8/31/21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var goodViewController: UIViewController?;
    var donationViewController: UICollectionViewController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self;
        self.tabBar.isTranslucent = false;
        
        goodViewController = GoodViewController();
        goodViewController?.title = "Home"
        let layout = UICollectionViewFlowLayout();
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        donationViewController = DonationController(collectionViewLayout: layout )
        donationViewController?.title = "Donations"
        // Do any additional setup after loading the view.
        viewControllers = [goodViewController!, donationViewController!]
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
