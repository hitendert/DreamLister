//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Hitender Thejaswi on 3/28/17.
//  Copyright © 2017 Hitender Thejaswi. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    // Creating a Timestamp - This function will get the date and assign it to the created attribute of the Item Class
    
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
    }

}
