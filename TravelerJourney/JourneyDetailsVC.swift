//
//  JourneyDetailsVC.swift
//  TravelerJourney
//
//  Created by Amani Atiah on 29/04/1443 AH.
//

import UIKit

class JourneyDetailsVC: UIViewController {

    var journey: Journey!
    var index: Int!
    @IBOutlet weak var journeyImageView: UIImageView!
    @IBOutlet weak var journeyTitleLabel: UILabel!
    @IBOutlet weak var journeyDetailsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if journey.image != nil {
            journeyImageView.image = journey.image
        } else {
            journeyImageView.image = UIImage(named: "Image-1")
        }
        setUpUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentJourneyEdited), name: NSNotification.Name(rawValue: "CurrentJourneyEdited"), object: nil)
    }
    
    @objc func currentJourneyEdited(notification: Notification) {
        if let journey = notification.userInfo?["editedJoureny"] as? Journey {
            self.journey = journey
            setUpUI()
        }
    }
    
    func setUpUI(){
        journeyDetailsLabel.text = journey.details
        journeyTitleLabel.text = journey.title
        journeyImageView.image = journey.image
    }
    

 
}
