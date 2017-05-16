//
//  ContactsListClass.swift
//  ContactsList
//
//  Created by Admin on 5/13/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

import UIKit

import SwiftyJSON

class ContactsList {
    private let fileURL = NSURL(fileURLWithPath: "/tmp/contacts.json") as URL
    
    enum SortField : Int{
        case firstName = 0
        case lastName = 1
        case phoneNumber = 2
        case email = 3
    }
    
    private var listOfContacts : [Contact]
    {
        didSet {
            self.writeDataToJson()
        }
    }
    
    init() {
        self.listOfContacts = [Contact]()
        
        if let savedSortFieldCode = UserDefaults.standard.value(forKey: "savedSortFieldCode") {
            self.setSortFieldFromIndex(savedSortFieldCode as! Int)
        }
        
        self.readJson()
    }
    
    var count : Int {
        return self.listOfContacts.count
    }
    
    var currentSortField : SortField = .lastName
    
    public func setSortFieldFromIndex(_ index : Int) {
        switch index {
        case 0:
            self.currentSortField = .firstName
        case 1:
            self.currentSortField = .lastName
        case 2:
            self.currentSortField = .phoneNumber
        case 3:
            self.currentSortField = .email
        default:
            return
        }
    }
    
    private func writeDataToJson() {
        let dict = self.getDictionary()
        let json = JSON(dict)
        
        do {
            let data = try json.rawData()
            
            try data.write(to: fileURL , options: .atomic)
        } catch {
            print(error)
        }
    }
    
    private func readJson() {
        do {
            let data = try Data(contentsOf: fileURL)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: [String : String]] {
                self.loadFromDictionary(object)
            } else {
                print("JSON is invalid")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func getList(searchString : String = "") -> [Contact] {
        let result : [Contact]
        
        let searchStringLowercased = searchString.lowercased().trimmingCharacters(in: .whitespaces)
        
        if searchString == "" {
            result = self.listOfContacts
        } else {
            result = self.listOfContacts.filter({
                (contact : Contact) -> Bool in
                return contact.searchString.range(of: searchStringLowercased) != nil
            })
        }
        
        var closure : (Contact, Contact) -> Bool
        
        switch self.currentSortField {
        case .firstName :
            closure = { (value1 : Contact, value2 : Contact) -> Bool in return value1.firstName < value2.firstName }
        case .lastName :
            closure = { (value1 : Contact, value2 : Contact) -> Bool in return value1.lastName < value2.lastName }
        case .phoneNumber :
            closure = { (value1 : Contact, value2 : Contact) -> Bool in return value1.phoneNumber < value2.phoneNumber }
        case .email :
            closure = { (value1 : Contact, value2 : Contact) -> Bool in return value1.email < value2.email }
        }
        
        return result.sorted(by: closure)
    }
    
    func addContact(_ newContact : Contact) {
        self.listOfContacts.append(newContact)
    }
    
    func addContact(firstName : String, lastName : String, phoneNumber : String, email : String) {
        
        if "\(firstName)\(lastName)\(phoneNumber)\(email)" == "" {
            return
        }
        
        let newContact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
        
        self.listOfContacts.append(newContact)
    }
    
    func addContact(firstName : String, lastName : String, phoneNumber : String, email : String, uuid : String) {
        
        if "\(firstName)\(lastName)\(phoneNumber)\(email)" == "" {
            return
        }
        
        let newContact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, uuid: uuid)
        
        self.listOfContacts.append(newContact)

    }
    
    func editContact(firstName : String, lastName : String, phoneNumber : String, email : String, uuid : String) {
        if let contact = self.getByUuid(uuid) {
            contact.firstName = firstName
            
            contact.lastName = lastName
            
            contact.phoneNumber = phoneNumber
            
            contact.email = email
            
            self.writeDataToJson()
        }
    }
    
    func getByIndex(_ index : Int) -> Contact {
        if index > self.count {
            return Contact()
        } else {
            return self.getList()[index]
        }
    }
    
    func getByUuid(_ uuid : String) -> Contact? {
        let filteredArray = self.listOfContacts.filter({ $0.uuid == uuid })
        
        let result : Contact?
        
        if filteredArray.count > 0 {
            result = filteredArray[0]
        } else {
            result = nil
        }
        
        return result
    }
    
    func deleteByIndex(_ index : Int) {
        self.deleteContact(self.getByIndex(index))
    }
    
    public func deleteByUuid(_ uuid : String) {
        if let contact = self.getByUuid(uuid) {
            self.deleteContact(contact)
        }
    }
    
    func deleteContact(_ contact : Contact) {
        if contact.uuid != "" {
            if let removeIndex = self.listOfContacts.index(where: { $0.uuid == contact.uuid }) {
                    self.listOfContacts.remove(at: removeIndex)
            }
        }
    }
    
    private func getDictionary() -> [String : [String : String]] {
        var result = [String : [String : String]]()
        for contact in self.listOfContacts {
            let data = [
                "firstName" : contact.firstName,
                "lastName" : contact.lastName,
                "phoneNumber" : contact.phoneNumber,
                "email" : contact.email
            ]
            
            result.updateValue(data, forKey: contact.uuid)
        }
        
        return result
    }
    
    private func loadFromDictionary(_ dictionary : [String : [String : String]]) {
        for uuidDictionary in dictionary {
            let dictValue = uuidDictionary.value
            self.addContact(firstName: dictValue["firstName"] ?? "", lastName: dictValue["lastName"] ?? "", phoneNumber: dictValue["phoneNumber"] ?? "", email: dictValue["email"] ?? "", uuid: uuidDictionary.key)
        }
    }
}

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
















