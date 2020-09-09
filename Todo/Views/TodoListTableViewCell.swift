//
//  TodoListTableViewCell.swift
//  Todo
//
//  Created by Ferrakkem Bhuiyan on 2020-09-07.
//  Copyright © 2020 Ferrakkem Bhuiyan. All rights reserved.
//

import UIKit

class TodoListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabelOutLet: UILabel!
    @IBOutlet weak var checkMarkOutlet: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(title: String) {
        self.titleLabelOutLet.text = title
    }
    
    func configureCellForDetails(title: String) {
        self.detailsLabel.text = title
    }
}
