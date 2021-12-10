//
//  JournetStorage.swift
//  TravelerJourney
//
//  Created by Amani Atiah on 06/05/1443 AH.
//

import Foundation
import UIKit
import CoreData

class JourneyStorage {
    
    static func storeJourney(journey: Journey) {
        guard let appDelegates = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appDelegates.persistentContainer.viewContext
        guard let journeyEntity = NSEntityDescription.entity(forEntityName: "Journey", in: manageContext) else {return}
        let journeyObject = NSManagedObject.init(entity: journeyEntity, insertInto: manageContext)
        journeyObject.setValue(journey.title, forKey: "title")
        journeyObject.setValue(journey.details, forKey: "details")
        journeyObject.setValue(journey.date, forKey: "date")
        
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
    
    static func updateJourney(journey: Journey, index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Journey")
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            result[index].setValue(journey.title, forKey: "title")
            result[index].setValue(journey.details, forKey: "details")
            result[index].setValue(journey.date, forKey: "date")

            
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
    
    static func deleteJourney(index: Int) {
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
    
    static func getJounreys() -> [Journey] {
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
                let date = managedJourney.value(forKey: "date") as? String

                
                var journeyImage: UIImage? = nil
                if let imageFormContext = managedJourney.value(forKey: "image") as? Data {
                    journeyImage = UIImage(data: imageFormContext)
                }
                
                let journey = Journey(title: title ?? "", image: journeyImage, details: details ?? "", date: date)
                journeys.append(journey)
            }
        } catch {
            print("=====Error======")
        }
        return journeys
    }
    
}
