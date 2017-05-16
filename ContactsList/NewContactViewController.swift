//
//  NewContactViewController.swift
//  ContactsList
//
//  Created by Maksym Korostelov on 5/15/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class NewContactViewController: UITableViewController {

    var contact : Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedContact = contact {
            labelFirstName?.text = selectedContact.firstName
            
            labelLastName?.text = selectedContact.lastName
            
            labelPhoneNumber?.text = selectedContact.phoneNumber
            
            labelEmail?.text = selectedContact.email
        } else {
            outletDeleteContact.tintColor = UIColor.clear
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var labelFirstName: UITextField!
    @IBOutlet weak var labelLastName: UITextField!
    @IBOutlet weak var labelPhoneNumber: UITextField!
    @IBOutlet weak var labelEmail: UITextField!
    @IBOutlet weak var outletDeleteContact: UIBarButtonItem!
    @IBAction func actionCreateContact(_ sender: UIBarButtonItem) {
        
        let dataDict:[String: String] = [
            "firstName"     : labelFirstName?.text ?? "",
            "lastName"      : labelLastName?.text  ?? "",
            "phoneNumber"   : labelPhoneNumber?.text  ?? "",
            "email"         : labelEmail?.text ?? "",
            "uuid"          : contact?.uuid ?? ""]
        
        // post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createContact"), object: nil, userInfo: dataDict)
        // `default` is now a property, not a method call

        closeAll()
    }
    
    func closeAll() {
        self.performSegueToReturnBack()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionBack(_ sender: UIBarButtonItem) {
        closeAll()
    }
   
    @IBAction func actionDeleteContact(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteContact"), object: nil, userInfo: ["uuid" : contact?.uuid ?? ""])
        
        closeAll()
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
