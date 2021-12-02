//
//  NewJourneyVC.swift
//  TravelerJourney
//
//  Created by Amani Atiah on 27/04/1443 AH.
//

import UIKit

class NewJourneyVC: UIViewController {

    @IBOutlet weak var journeyImageView: UIImageView!
    @IBOutlet weak var titleTextFiled: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    @IBAction func addButtonClicked(_ sender: Any) {
        let journey = Journey(title: titleTextFiled.text!, image: nil, details: detailsTextView.text)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newJourneyAdded"), object: nil, userInfo: ["addedJourney" : journey])
        
    }
    
}
