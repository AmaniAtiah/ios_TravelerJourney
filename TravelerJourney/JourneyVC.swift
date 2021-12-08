//
//  JourneyVC.swift
//  TravelerJourney
//
//  Created by Amani Atiah on 25/04/1443 AH.
//

import UIKit
import CoreData

class JourneyVC: UIViewController {

    var index: Int!
    var journey: Journey!
    var journeyArray: [Journey] = []
    @IBOutlet weak var journeytableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.journeyArray = getJounreys()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newJourneyAdded), name: NSNotification.Name(rawValue: "newJourneyAdded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentJourneyEdited), name: NSNotification.Name(rawValue: "CurrentJourneyEdited"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(journeyDeleted), name: NSNotification.Name(rawValue: "journeyDeleted"), object: nil)
        
        journeytableView.dataSource = self
        journeytableView.delegate = self
    

    }
   
    @objc func newJourneyAdded(notification: Notification) {
        if let myJourney = notification.userInfo?["addedJourney"] as? Journey {
            journeyArray.append(myJourney)
            journeytableView.reloadData()
            storeJourney(journey: myJourney)
            
        }
    }
    
    @objc func currentJourneyEdited(notification: Notification) {
        if let myJourney = notification.userInfo?["editedJourney"] as? Journey {
            if let index = notification.userInfo?["editedJourneyIndex"] as? Int {
                journeyArray[index] = myJourney
                journeytableView.reloadData()
                updateJourney(journey: myJourney, index: index)
            }
        }
     }
    
    @objc func journeyDeleted(notification: Notification) {
        if let index = notification.userInfo?["deletedJourneyIndex"] as? Int {
            journeyArray.remove(at: index)
            journeytableView.reloadData()
        }
    }
    
   
    func storeJourney(journey: Journey) {
        guard let appDelegates = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appDelegates.persistentContainer.viewContext
        guard let journeyEntity = NSEntityDescription.entity(forEntityName: "Journey", in: manageContext) else {return}
        let journeyObject = NSManagedObject.init(entity: journeyEntity, insertInto: manageContext)
        journeyObject.setValue(journey.title, forKey: "title")
        journeyObject.setValue(journey.details, forKey: "details")
        
        if let image = journey.image {
            let imageData = image.jpegData(compressionQuality: 1)
            journeyObject.setValue(imageData, forKey: "image")
            
        }
        do {
            try manageContext.save()
            print("Success")
            
        } catch {
            print("Error")
        }
    }
    
    func updateJourney(journey: Journey, index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Journey")
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            result[index].setValue(journey.title, forKey: "title")
            result[index].setValue(journey.details, forKey: "details")
            
            if let image = journey.image {
                let imageData = image.jpegData(compressionQuality: 1)
                result[index].setValue(imageData, forKey: "image")
                
            }
            
            try context.save()
            print("=====Success=====")
        } catch {
            print("=====Error=====")
        }
    }
    
    func deleteJourney(index: Int) {
        guard let appDelegat = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegat.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Journey")
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let journeyDelete = result[index]
            context.delete(journeyDelete)
            
            try context.save()
            print("====Success=====")
            
        } catch {
            print("=====Error=====")
        }
    }
    
    func getJounreys() -> [Journey] {
        var journeys: [Journey] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Journey")
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            for managedJourney in result {
                print(managedJourney)
                let title = managedJourney.value(forKey: "title") as? String
                let details = managedJourney.value(forKey: "details") as? String
                
                var journeyImage: UIImage? = nil
                if let imageFormContext = managedJourney.value(forKey: "image") as? Data {
                    journeyImage = UIImage(data: imageFormContext)
                }
                
                let journey = Journey(title: title ?? "", image: journeyImage, details: details ?? "")
                journeys.append(journey)
            }
        } catch {
            print("=====Error======")
        }
        return journeys
    }
    
}



extension JourneyVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journeyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyCell") as! JourneyCell
        
         journey = journeyArray[indexPath.row]
        cell.journeyTitleLabel.text = journey.title
  
 
        
        if journey.image != nil {
            cell.journeyImageView.image = journey.image
        } else {
            cell.journeyImageView.image = UIImage(named: "Image")
        }
  

//        cell.updateButtonClicked.tag = indexPath.row
//        cell.updateButtonClicked.addTarget(self, action: #selector(updateButton), for: .touchUpInside)
        
        
            
        return cell
    }
    
//    @objc func updateButton(sender: UIButton) {
//
//        let indexPath = IndexPath(row: sender.tag, section: 0)
//        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NewJourneyVC") as? NewJourneyVC {
//
//            viewController.isCreationJourney = false
//            viewController.editedJourney = journeyArray[indexPath.row]
//
//            //journey =
//            viewController.editedJourneyIndex = index
//
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
//
//    }
//
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "") {(action, view, completionHandler) in
            
            let confirmAlert = UIAlertController(title: "تنبية", message: "هل انت متاكد من رغبتك في اتمام عملية الحذف", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "تاكيد الحذف", style: .destructive) { alert in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "journeyDeleted"), object: nil, userInfo: ["deletedJourneyIndex": indexPath.row])
                
                let alert = UIAlertController(title: "تم", message: "تم حذف المهمة بنجاح", preferredStyle: .alert)
                
                let closeAction = UIAlertAction(title: "تم", style: .default) {
                    alert in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(closeAction)
                self.present(alert, animated: true, completion: nil)
            }
            
   
            
            let cancelAction = UIAlertAction(title: "اغلاق", style: .default, handler: nil)
            
           // self.journeyArray.remove(at: indexPath.row)
          //  tableView.beginUpdates()
            
            
            //tableView.deleteRows(at: [indexPath], with: .automatic)
            
            confirmAlert.addAction(confirmAction)
            self.present(confirmAlert, animated: true, completion: nil)
            confirmAlert.addAction(cancelAction)
           // tableView.endUpdates()
            completionHandler(true)
            
           // self.JourneytableView.reloadData()

            
  
            
                
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "") {(action, view, completionHandler) in
            
    
   
            tableView.beginUpdates()
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NewJourneyVC") as? NewJourneyVC {
                
                viewController.isCreationJourney = false
                viewController.editedJourney = self.journeyArray[indexPath.row]
                viewController.editedJourneyIndex = indexPath.row
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
 
            tableView.endUpdates()
            completionHandler(true)
            
       //     let journey = self.journeyArray[indexPath.row]
            
   

      
        }
        
        
        deleteAction.image = UIImage(systemName: "trash")
        updateAction.image = UIImage(systemName: "square.and.pencil")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let journey = journeyArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? JourneyDetailsVC
    
        
        if let viewController = vc {
            viewController.journey = journey
            viewController.index = indexPath.row
          
            navigationController?.pushViewController(viewController, animated: true)
        }
     
    }
    
}

