//
//  ViewController.swift
//
//  Created by Jared Geller on 11/18/20.
//

import UIKit
import SwiftSpinner

class GoodViewController: UIViewController {
   
    /// Mark -- UI Elements
    let topMessage = UILabel()
    var tableView = UITableView()

    
    // STEP 1 TODO: Get from firebase database and integrate into UI
    var firstName: String?
    var donations: [Donation] = []{
        didSet{
            self.setDonationAmount();
        }
    }
    var amountDonated: Double?
    
    var username: String?
    
    let spinnerContainerView:UIView = {
        let spinnerContainerView = UIView();
        spinnerContainerView.translatesAutoresizingMaskIntoConstraints = false;
        spinnerContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.3);
        return spinnerContainerView;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Dark mode for everything
        if #available(iOS 13.0, *) {
            UIWindow.appearance().overrideUserInterfaceStyle = .dark
        }
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        constrainTopMessage()
        constrainTableView()
        self.topMessage.attributedText = self.getDisplayedAttributedString()
        
        self.view.addSubview(spinnerContainerView);
        spinnerContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        spinnerContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        spinnerContainerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        spinnerContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;

        SwiftSpinner.useContainerView(spinnerContainerView)
        SwiftSpinner.show("Loading your data");
        
        let dispatchQueue = DispatchQueue.global(qos: .background);
        dispatchQueue.async {
            
            let dispatchGroup = DispatchGroup();
            let semaphore = DispatchSemaphore(value: 0);
            let user:UsersApi = UsersApi();
            
            user.getUser { user in

                if(user != nil){
                    self.firstName = user!.name
                    self.username = user!.username

                    semaphore.signal();
                }
            }
            semaphore.wait();

            Api.Donations.getMyDonations(completion: {
                donations in
                
                self.donations = donations ?? []
                
                semaphore.signal();
            })

            semaphore.wait();
            
            DispatchQueue.main.async {
                self.topMessage.attributedText = self.getDisplayedAttributedString();
                self.tableView.reloadData();
                
                self.spinnerContainerView.isHidden = true;
                SwiftSpinner.hide();
            }
        }
    }
    
    // Gets the user message as an attributed string!
    func getDisplayedAttributedString() -> NSMutableAttributedString {
        let firstName = self.firstName;
        
        
        let numberFont = UIFont.systemFont(ofSize: 50, weight: .bold)
        let hiFont = UIFont.systemFont(ofSize: 40, weight: .bold)
        let textFont = UIFont.systemFont(ofSize: 32, weight: .bold)
        let text = NSMutableAttributedString()
        
        if(firstName != nil){
            text.append(NSAttributedString(string: "Hi \(firstName!), \n", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), NSAttributedString.Key.font: hiFont]))
        }else{
            text.append(NSAttributedString(string: "Hi \(firstName), \n", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), NSAttributedString.Key.font: hiFont]))
        }
        
        text.append(NSAttributedString(string: "You have donated", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), NSAttributedString.Key.font: textFont]))
        if(amountDonated != nil){
            text.append(NSAttributedString(string: "$\(amountDonated!)", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1), NSAttributedString.Key.font: numberFont]))
        }else{
            text.append(NSAttributedString(string: "$\(amountDonated)", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1), NSAttributedString.Key.font: numberFont]))
        }
        
        
        text.append(NSAttributedString(string: " this year.", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), NSAttributedString.Key.font: textFont]))
        return text
    }

     /// Mark -- Constraints
    
    func constrainTopMessage() {
        view.addSubview(topMessage)
        topMessage.translatesAutoresizingMaskIntoConstraints = false
        topMessage.textColor = .white
        topMessage.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        topMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        topMessage.numberOfLines = 0
        topMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        topMessage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        topMessage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        topMessage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
    
    func constrainTableView() {
        view.addSubview(tableView)
        tableView.register(MyDonationsTableViewCell.self, forCellReuseIdentifier: "MyDonationsTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topMessage.bottomAnchor, constant: 20).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.isScrollEnabled = true
        tableView.rowHeight = 65
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    //MARK: HELPER FUNCTIONS
    func setDonationAmount(){
        let isolatedDonations = self.donations.map({ return $0.amount!})
        
        self.amountDonated = isolatedDonations.reduce(0.0,+);
        self.topMessage.attributedText = self.getDisplayedAttributedString();
    }
}

extension GoodViewController: UITableViewDataSource, UITableViewDelegate {
    
    // One sections in tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    // Individual section for you and then next section is leaderboard
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (donations ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDonationsTableViewCell", for: indexPath) as! MyDonationsTableViewCell
        cell.firstName = firstName;
        cell.userName = username;
        let donation = donations[indexPath.row]
        cell.donation = donation
        return cell
    }
    

    
}
