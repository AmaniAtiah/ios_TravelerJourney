//
//  JourneyCell.swift
//  TravelerJourney
//
//  Created by Amani Atiah on 26/04/1443 AH.
//

import UIKit

class JourneyCell: UITableViewCell {

    @IBOutlet weak var journeyTitleLabel: UILabel!
    @IBOutlet weak var journeyCreationDateLabel: UILabel!
    @IBOutlet weak var journeyImageView: UIImageView!
    @IBOutlet weak var updateButtonClicked: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
           super.layoutSubviews()
           //set the values for top,left,bottom,right margins
           let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
           contentView.frame = contentView.frame.inset(by: margins)
        
    }
}
