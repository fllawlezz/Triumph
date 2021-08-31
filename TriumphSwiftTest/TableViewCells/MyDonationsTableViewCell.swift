import UIKit
import SDWebImage
import FirebaseDatabase

class MyDonationsTableViewCell: UITableViewCell {
    
    // Views and labels
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var usernameLabel = UILabel()
    var moneyLabel = UILabel()
    let profileCircleSize = 43
    
    //variables
    var firstName: String? {
        didSet{
            self.nameLabel.text = firstName!;
        }
    }
    
    var userName: String? {
        didSet{
            self.usernameLabel.text = userName!;
        }
    }
    
    
    var donation: Donation? {
        didSet {
            
            if(donation!.amount != nil){
                moneyLabel.text = "$\(donation!.amount!)"
            }
            
            self.setOrganizationProfileImage(donation!.receiverId!)
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setConstraints() {
        self.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: CGFloat(profileCircleSize)).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: CGFloat(profileCircleSize)).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        self.profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = CGFloat(profileCircleSize/2)
        profileImageView.backgroundColor = UIColor.black;
        
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -12).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        nameLabel.textColor = UIColor.black;
        
        self.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        usernameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        usernameLabel.textColor = UIColor.gray;
    
        
        contentView.addSubview(moneyLabel)
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        moneyLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor, constant: 0).isActive = true
        moneyLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        moneyLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        moneyLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        moneyLabel.text = ""
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setConstraints()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: HELPHER FUNCTIONS
    
    func setOrganizationProfileImage(_ recieverId: String){
        getOrgProfileURL(recieverId) { url in
            
            DispatchQueue.main.async {
                self.profileImageView.sd_setImage(with: URL(string: url!));
        }
//
        }
    }
    
    func getOrgProfileURL(_ recieverId: String, completion: @escaping (String?) -> Void){
        Database.database().reference().child("organization").child(recieverId).child("profilePhotoURL").observeSingleEvent(of: .value, with: {
            snapshot in
            if let profileURL = snapshot.value as? String {
//                print(profileURL);
                completion(profileURL);
            } else {
                completion(nil)
            }
        })
    }
}
