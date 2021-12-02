//
//  JourneyVC.swift
//  TravelerJourney
//
//  Created by Amani Atiah on 25/04/1443 AH.
//

import UIKit

class JourneyVC: UIViewController {
    
    var journeyArray = [
        Journey(title: "رحلتي الى القاهرة", image: UIImage(named: "Image"), details: "رحلتي الى القاهرة"),
        
        Journey(title: "رحلتي الى دبي", image: UIImage(named: "Image"), details: "رحلتي الى دبي")
        
    ]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newJourneyAdded), name: NSNotification.Name(rawValue: "newJourneyAdded"), object: nil)
        
        
        tableView.dataSource = self
        tableView.delegate = self
    

    }
   
    @objc func newJourneyAdded(notification: Notification) {
        if let journey = notification.userInfo?["addedJourney"] as? Journey {
            journeyArray.append(journey)
            tableView.reloadData()
            
        }
    }
    
   
    
}



extension JourneyVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journeyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyCell") as! JourneyCell
        
        let journey = journeyArray[indexPath.row]
        cell.journeyTitleLabel.text = journey.title
        
        if journey.image != nil {
            cell.journeyImageView.image = journey.image
        } else {
            cell.journeyImageView.image = UIImage(named: "Image")
        }
        
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") {(action, view, completionHandler) in
            self.journeyArray.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            completionHandler(true)
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "") {(action, view, completionHandler) in
            tableView.beginUpdates()
            tableView.endUpdates()
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        updateAction.image = UIImage(systemName: "square.and.pencil")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        
        
    }
    
    
}
