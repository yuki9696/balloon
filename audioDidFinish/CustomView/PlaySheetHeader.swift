//
//  PlaySheetHeader.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 01/03/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit

class PlaySheetHeader: UITableViewHeaderFooterView {
    
    @IBOutlet var bubbleView:UIView!
    @IBOutlet var LBLTitle:UILabel!
    @IBOutlet var LBLDetail:UILabel!
    @IBOutlet var IMGView:UIImageView!
    @IBOutlet var IMGTitle:UIImageView!
    
    var animate = false {
        didSet{
            if self.animate == true {
                self.IMGView.startAnimating()
                self.bubbleView.backgroundColor = UIColor(red: 195.0/265.0, green: 236.0/255.0, blue: 254.0/255.0, alpha: 1)
            }else {
                self.IMGView.stopAnimating()
                self.bubbleView.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 245.0/255.0, alpha: 1)
            }
        }
    }
    
    var message:[String:Any]? {
        didSet{
            guard let msg = self.message else { return  }
            let title = msg["title"] as! String
            self.LBLTitle.text = title
            let details = msg["detail"] as! String
            self.LBLDetail.text = details
            let ImageName = msg["image"] as! String
            self.IMGTitle.image  = UIImage.init(named: ImageName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.bubbleView.layer.cornerRadius = 12
        //self.bubbleView.layer.masksToBounds = true
        
        //self.IMGTitle.layer.cornerRadius = 8
        //self.IMGTitle.layer.masksToBounds = true
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.backgroundView = view
        //self.IMGView.animationImages = [#imageLiteral(resourceName: "speaker2")]
        //self.IMGView.animationDuration = 0.25
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
