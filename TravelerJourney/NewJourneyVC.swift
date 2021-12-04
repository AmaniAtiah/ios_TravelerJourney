//
//  NewJourneyVC.swift
//  TravelerJourney
//
//  Created by Amani Atiah on 27/04/1443 AH.
//

import UIKit

class NewJourneyVC: UIViewController {
    var isCreationJourney = true
    var editedJourney: Journey?
    var editedJourneyIndex: Int?

    @IBOutlet weak var journeyImageView: UIImageView!
    @IBOutlet weak var titleTextFiled: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var mainButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isCreationJourney == false {
            mainButton.setTitle("تعديل", for: .normal)
            navigationItem.title = "تعديل الرحلة"
            
            if let journey = editedJourney {
                titleTextFiled.text = journey.title
                detailsTextView.text = journey.details
                journeyImageView.image = journey.image
            }
        }


    }
    

    @IBAction func addButtonClicked(_ sender: Any) {
        if isCreationJourney {
        
        let journey = Journey(title: titleTextFiled.text!, image: nil, details: detailsTextView.text)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newJourneyAdded"), object: nil, userInfo: ["addedJourney" : journey])
        
        let alert = UIAlertController(title: "تمت الاضافة", message: "تم اضافة الرحلة", preferredStyle: UIAlertController.Style.alert)
        
        let closeAction = UIAlertAction(title: "تم", style: UIAlertAction.Style.default) { _ in
            self.tabBarController?.selectedIndex = 0
            
            self.titleTextFiled.text = ""
            self.detailsTextView.text = ""
            
        }
        alert.addAction(closeAction)
        present(alert, animated: true, completion: {
            
        })
            
        } else {
            let journey = Journey(title: titleTextFiled.text!, image: nil, details: detailsTextView.text)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentJourneyEdited"), object: nil, userInfo: ["editedJourney": journey, "editedJourneyIndex": editedJourneyIndex])
            
            let alert = UIAlertController(title: "تم التعديل", message: "تم تعديل الرحلة", preferredStyle: UIAlertController.Style.alert)
            
            let closeAction = UIAlertAction(title: "تم", style: UIAlertAction.Style.default) { _ in
                self.navigationController?.popViewController(animated: true)
//                self.titleTextFiled.text = ""
//                self.detailsTextView.text = ""
                
            }
            alert.addAction(closeAction)
            present(alert, animated: true, completion: {
                
            })
            
    
        }
            
            
    }
    
}
