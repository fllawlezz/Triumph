//
//  DonationCell.swift
//  TriumphSwiftTest
//
//  Created by Brandon In on 8/31/21.
//

import UIKit

protocol DonationCellDelegate{
    func handlePressDonateButton(button: UIButton, org: Organization);
}

class DonationCell: UICollectionViewCell {
    
    var delegate:DonationCellDelegate!
    
    var organization: Organization?{
        didSet{
            resetData();
            self.organizationNameLabel.text = organization!.name!
            self.amountRaisedLabel.text = "$\(organization!.amountGiven!)"
            self.setupImageView(url: organization!.profilePhotoURL)
        }
    }
    
    lazy var organizationNameLabel: UILabel = {
        let orgLabel = UILabel();
        orgLabel.translatesAutoresizingMaskIntoConstraints = false;
        orgLabel.textColor = UIColor.white;
        orgLabel.text = "Org goes here"
        orgLabel.textAlignment = .right;
        orgLabel.font = UIFont.systemFont(ofSize: 18)
        return orgLabel;
    }()
    
    lazy var amountRaisedLabel: UILabel = {
        let amountRaisedLabel = UILabel();
        amountRaisedLabel.translatesAutoresizingMaskIntoConstraints = false;
        amountRaisedLabel.textColor = UIColor.green;
        amountRaisedLabel.text = "$100000"
        amountRaisedLabel.font = UIFont.systemFont(ofSize: 16)
        amountRaisedLabel.textAlignment = .right;
        return amountRaisedLabel;
        
    }()
    
    lazy var orgImageView: UIImageView = {
        let orgImageView = UIImageView();
        orgImageView.translatesAutoresizingMaskIntoConstraints = false;
        orgImageView.backgroundColor = UIColor.white;
        orgImageView.layer.cornerRadius = 24;
        orgImageView.clipsToBounds = true;
        return orgImageView;
    }()
    
    lazy var donateButton: UIButton = {
        let donateButton = UIButton(type: .system);
        donateButton.translatesAutoresizingMaskIntoConstraints = false;
        donateButton.backgroundColor = UIColor.orange;
        donateButton.setTitle("Donate", for: .normal);
        donateButton.setTitleColor(UIColor.black, for: .normal)
        return donateButton;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupOrgImageView();
        setupOrgNameLabel();
        setupAmountRaised();
        setupDonateButton();
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateAmountGiven), name: Notification.Name(notificationName), object: nil);
    }
    
    required init?(coder: NSCoder) {
        fatalError();
    }
    
    func setupOrgImageView(){
        self.addSubview(orgImageView);
        orgImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true;
//        orgImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true;
        orgImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true;
        orgImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true;
        orgImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true;
    }
    
    func setupOrgNameLabel(){
        self.addSubview(organizationNameLabel);
        organizationNameLabel.leftAnchor.constraint(equalTo: orgImageView.rightAnchor).isActive = true;
        organizationNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true;
        organizationNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true;
        organizationNameLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true;
//        organizationNameLabel.backgroundColor = UIColor.yellow;
    }
    
    func setupAmountRaised(){
        self.addSubview(amountRaisedLabel);
        amountRaisedLabel.leftAnchor.constraint(equalTo: orgImageView.rightAnchor).isActive = true;
        amountRaisedLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true;
        amountRaisedLabel.topAnchor.constraint(equalTo: self.organizationNameLabel.bottomAnchor, constant: 8).isActive = true;
        amountRaisedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true;
    }
    
    func setupDonateButton(){
        self.addSubview(donateButton);
        donateButton.topAnchor.constraint(equalTo: amountRaisedLabel.bottomAnchor, constant: 12).isActive = true;
        donateButton.heightAnchor.constraint(equalToConstant: 36).isActive = true;
        donateButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true;
        donateButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true;
        
        donateButton.addTarget(self, action: #selector(self.handleDonateButtonPressed(button:)), for: .touchUpInside)
    }
    
    func setupImageView(url: String?){
        self.orgImageView.sd_setImage(with: URL(string: url!));
    }
    
    func resetData(){
        self.organizationNameLabel.text = "Org text goes here";
        amountRaisedLabel.text = "$0.00";
        self.orgImageView.image = nil;
        
    }
    
    @objc func handleDonateButtonPressed(button: UIButton){
        self.delegate.handlePressDonateButton(button: button, org: self.organization!)
    }
    
    @objc func handleUpdateAmountGiven(_ notification: NSNotification){
        if let newAmountGiven = notification.userInfo?["amountGiven"] as? Double{
            
            if let orgId = notification.userInfo?["orgId"] as? String{
                if(self.organization!.id == orgId){
                    self.organization?.amountGiven = newAmountGiven;
                    self.amountRaisedLabel.text = "$\(newAmountGiven)"
                }
            }
            
            
        }
    }
}
