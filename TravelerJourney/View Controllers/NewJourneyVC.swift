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
    @IBOutlet weak var dateTextFiled: UITextField!
    
    var datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isCreationJourney  {
            mainButton.setTitle("تعديل", for: .normal)
            navigationItem.title = "تعديل الرحلة"
            
            if let journey = editedJourney {
                titleTextFiled.text = journey.title
                detailsTextView.text = journey.details
                journeyImageView.image = journey.image
                dateTextFiled.text = journey.date
            }
        }

        createDatePicker()


    }
    
    func createDatePicker(){
        dateTextFiled.textAlignment = .center

        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateChanged))
        toolbar.setItems([doneBtn], animated: true)

        datePicker.preferredDatePickerStyle = .wheels

        dateTextFiled.inputAccessoryView = toolbar

        dateTextFiled.inputView = datePicker    

    }
    
    @objc func dateChanged(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
        
        dateTextFiled.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    


    @IBAction func addButtonClicked(_ sender: Any) {
        if isCreationJourney {
        
            let journey = Journey(title: titleTextFiled.text!, image: journeyImageView.image, details: detailsTextView.text, date: dateTextFiled.text!)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newJourneyAdded"), object: nil, userInfo: ["addedJourney" : journey])
        
        let alert = UIAlertController(title: "تمت الاضافة", message: "تم اضافة الرحلة", preferredStyle: UIAlertController.Style.alert)
        
        let closeAction = UIAlertAction(title: "تم", style: UIAlertAction.Style.default) { _ in
            self.tabBarController?.selectedIndex = 0
            
            self.titleTextFiled.text = ""
            self.detailsTextView.text = ""
            self.dateTextFiled.text = ""
            
        }
        alert.addAction(closeAction)
        present(alert, animated: true, completion: {
            
        })
            
        } else {
            let journey = Journey(title: titleTextFiled.text!, image: journeyImageView.image, details: detailsTextView.text, date: dateTextFiled.text)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentJourneyEdited"), object: nil, userInfo: ["editedJourney": journey, "editedJourneyIndex": editedJourneyIndex])
            
            let alert = UIAlertController(title: "تم التعديل", message: "تم تعديل الرحلة", preferredStyle: UIAlertController.Style.alert)
            
            let closeAction = UIAlertAction(title: "تم", style: UIAlertAction.Style.default) { _ in
                self.navigationController?.popViewController(animated: true)
                self.titleTextFiled.text = ""
                self.detailsTextView.text = ""
                self.dateTextFiled.text = ""
                
            }
            alert.addAction(closeAction)
            present(alert, animated: true, completion: {
                
            })
            
    
        }
            
            
    }
    
    @IBAction func changeButtonClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }

    
    
}

extension NewJourneyVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true, completion: nil)
        journeyImageView.image = image
    }
    
 
}
