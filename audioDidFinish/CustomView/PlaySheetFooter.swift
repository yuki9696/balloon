//
//  PlaySheetFooter.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 10/03/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit

class PlaySheetFooter: UITableViewHeaderFooterView {
    @IBOutlet var lblContent:UILabel! {
        didSet{
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.backgroundView = view
    }
}
