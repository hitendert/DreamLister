//
//  MaterialView.swift
//  DreamLister
//
//  Created by Hitender Thejaswi on 3/28/17.
//  Copyright © 2017 Hitender Thejaswi. All rights reserved.
//

import UIKit

private var materialKey = false

// By doing so, anything that will extend the UIView will have the same styling that has been done below
extension UIView {

// @IBInspectable enables this particular variable to be available in the Attributes inspector  
    @IBInspectable var materialDesign: Bool
    {
        get {
            return materialKey
        }
        
        set {
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
                
            }
        }
        
    }

}
