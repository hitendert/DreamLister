//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Hitender Thejaswi on 4/6/17.
//  Copyright © 2017 Hitender Thejaswi. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var stores = [Store]()
    
    var itemToEdit : Item? //Editing existing data
    
    var imagePicker : UIImagePickerController! //imagePicker
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
     
        storePicker.delegate = self
        storePicker.dataSource = self
        
        //ImagePicker
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //Imagepicker
        
        
//        let store = Store(context: context)
//        store.name = "Best Buy"
//        
//        let store2 = Store(context: context)
//        store2.name = "Tesla Dealership"
//        
//        let store3 = Store(context: context)
//        store3.name = "Frys Electronics"
//        
//        let store4 = Store(context: context)
//        store4.name = "Target"
//        
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        
//        let store6 = Store(context: context)
//        store6.name = "KMart"
//        
//        ad.saveContext()
        
        getStores()
        
        // Editing existing data
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let store = stores[row]
        
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // code here
    }
    
    func getStores() {
        
        let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            let err = error as NSError
            print("Error while fetching stores")
        }
        
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        var item: Item!
        
        
        
        
        // Editing existing data code starts here --->
        if itemToEdit == nil {
            
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        // Editing existing data code ends here <---
        
        
        //Saving Image to CoreData ---->
        
        var picture = Image(context: context)
        picture.image = thumbImg.image
        item.toImage = picture
        
        //Saving Image to CoreData <----
        
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text{
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text{
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
            
        
        ad.saveContext()
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    // Editing existing data
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                    
                } while (index < stores.count)
            }
            
        }
    }
    
    
    //Delete from CoreData ---->
    @IBAction func deletePressed(_ sender: Any) {
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            ad.saveContext()
            
            navigationController?.popToRootViewController(animated: true)
            
        }
        
    } //delete from CoreData <----
    
    //Image Picker --->
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            thumbImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //Image Picker <-----
    
}
















