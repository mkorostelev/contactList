//
//  ContactsTableViewCell.swift
//  ContactsList
//
//  Created by Admin on 5/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

//    @IBOutlet weak var fullName: UILabel!
//    
//    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func fillCellByContact(_ contact : Contact) {
        self.fullName?.text = contact.fullName
        
        self.phoneNumber?.text = contact.phoneNumber
    }
    
    public static var nibName : String {
        return "ContactsTableViewCell"//String(describing: ContactsTableViewCell())
    }
    
    public static var reuseIdentifier : String {
        return "ContactsTableViewCell"//String(describing: ContactsTableViewCell())
    }
    
}
