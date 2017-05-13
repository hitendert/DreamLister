//
//  MainVC.swift
//  DreamLister
//
//  Created by Hitender Thejaswi on 3/28/17.
//  Copyright © 2017 Hitender Thejaswi. All rights reserved.
//

import UIKit

import CoreData // This is the first thing that you do.

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource,
NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segment: UISegmentedControl!

    
    var controller : NSFetchedResultsController<Item>!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
            //generateTestData()
            attemptFetch()
       
            

}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
   
        return cell
    }
    
    func configureCell(cell : ItemCell, indexPath : NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        
        cell.configureCell(item: item)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
// ----> Core Data implementation starts here 
    
    func attemptFetch() {
        
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        
        if segment.selectedSegmentIndex == 0 {
        fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        // This below line tells the controller to listen to itself.
        controller.delegate = self
        
        self.controller = controller
        
        
        
        do {
            try controller.performFetch()
        } catch {
            let err = error as NSError
            print("\(err)")
        }
        
    }
    
    // ----> Starts to listen for any change.
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // <--- Ends to listen for any change.
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
              }
            break
            
        case.delete:
            
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        
        case.update:
            
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                
            }
            break
            
        case.move:
            
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            
        }
    }
    
    
    func generateTestData() {
        
        let item = Item(context: context)
        item.title = "New Macbook Pro"
        item.price = 1800
        item.details = "This is my favourite computer"
        
        let item2 = Item(context: context)
        item2.title = "Bose Earphones"
        item2.price = 300
        item2.details = "This is my favourite headphones"
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "This is my favourite car"
        
        ad.saveContext()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 1 {
            
            let item = objs[indexPath.row]
            
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ItemDetailsVC" {
            
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
    }
    
    
    
    
    
    
}

    
    
    






































