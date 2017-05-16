//
//  ContactsListTableViewController.swift
//  ContactsList
//
//  Created by Admin on 5/13/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

import SwiftyJSON

class ContactsListTableViewController: UITableViewController {
    
    var contactList = ContactsList()
    
    var selectedContact : Contact?
    
    @IBOutlet var contactListOutlet: UITableView!
    
    @IBOutlet weak var outletSortMethod: UISegmentedControl!
    
    @IBOutlet weak var outletEditButton: UIBarButtonItem!
    
    @IBAction func actionSortMethodChanged(_ sender: UISegmentedControl) {
        contactList.setSortFieldFromIndex(outletSortMethod.selectedSegmentIndex)
        
        UserDefaults.standard.setValue(outletSortMethod.selectedSegmentIndex, forKey: "savedSortFieldCode")
        
        contactListOutlet.reloadData()
    }
    
    @IBAction func actionEditContactList(_ sender: UIBarButtonItem) {
        contactListOutlet.isEditing = !contactListOutlet.isEditing
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mySegue" {
            
            if let toViewController = segue.destination as? ViewContactTableViewController {
                toViewController.contact = selectedContact
            }
        }
    }
    
    // handle notification
    func createContact(_ notification: NSNotification) {
        if let firstName = notification.userInfo?["firstName"],
            let lastName = notification.userInfo?["lastName"],
            let phoneNumber = notification.userInfo?["phoneNumber"],
            let email = notification.userInfo?["email"],
            let uuid = notification.userInfo?["uuid"]
        {
            
            if  uuid as! String != "" {
                // rewrite contact
                contactList.editContact(firstName: firstName as! String, lastName: lastName as! String, phoneNumber: phoneNumber as! String, email: email as! String, uuid: uuid as! String)
            } else {
                // create contact
                contactList.addContact(firstName: firstName as! String, lastName: lastName as! String, phoneNumber: phoneNumber as! String, email: email as! String)
                
            }
        }
        
        setAvailabilityAndReloadData()

    }
    
    func deleteContact(_ notification: NSNotification) {
        if let uuid = notification.userInfo?["uuid"] {
            contactList.deleteByUuid(uuid as! String)
        }
        
        setAvailabilityAndReloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.createContact(_:)), name: NSNotification.Name(rawValue: "createContact"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteContact(_:)), name: NSNotification.Name(rawValue: "deleteContact"), object: nil)

        outletSortMethod.selectedSegmentIndex = contactList.currentSortField.rawValue
        
        setAvailability()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.reuseIdentifier, for: indexPath) as? ContactsTableViewCell {
            let contact = contactList.getByIndex(indexPath.row)
                        
            cell.fillCellByContact(contact)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
 
    @IBAction func buttonAddNewContact(_ sender: UIBarButtonItem) {
        
    }
    
    func setAvailabilityAndReloadData() {
        setAvailability()
        
        contactListOutlet.reloadData()
    }
    
    func setAvailability() {
//        outletEditButton.isEnabled =
        if !(contactList.count > 0) {
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.navigationItem.leftBarButtonItem = self.editButtonItem
        }
        
        outletSortMethod.isHidden = !(contactList.count > 0)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            selectedContact = contactList.getByIndex(indexPath.row)
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contactList.deleteByIndex(indexPath.row)
            
            contactListOutlet.reloadData()
            
            setAvailability()
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
