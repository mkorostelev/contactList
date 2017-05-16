//
//  ContactClass.swift
//  ContactsList
//
//  Created by Admin on 5/13/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

class Contact {
    var firstName : String
    
    var lastName : String
    
    var phoneNumber : String
    
    var email : String
    
    var uuid : String
    
    var searchString : String {
        return "\(self.firstName) \(self.lastName) \(self.phoneNumber) \(self.email)"
    }
    
    var fullName : String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    init(firstName : String, lastName : String, phoneNumber : String, email : String) {
        self.firstName = firstName
        
        self.lastName = lastName
        
        self.phoneNumber = phoneNumber
        
        self.email = email
        
        self.uuid = UUID().uuidString
    }
    
    init(firstName : String, lastName : String, phoneNumber : String, email : String, uuid: String) {
        self.firstName = firstName
        
        self.lastName = lastName
        
        self.phoneNumber = phoneNumber
        
        self.email = email
        
        self.uuid = uuid
    }
    
    init() {
        self.firstName = ""
        
        self.lastName = ""
        
        self.phoneNumber = ""
        
        self.email = ""
        
        self.uuid = UUID().uuidString
    }
}




















