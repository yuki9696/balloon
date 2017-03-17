//
//  SecondViewController.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 07/03/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit
class secondViewCell: UITableViewCell {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblDetail:UILabel!
    @IBOutlet var imgIcon:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.selectionStyle = .none
        //self.imgIcon.layer.cornerRadius = 8
        
    }
    
}

class SecondViewController: UIViewController {
    @IBOutlet var tbl:UITableView!
    var phrases = Array<[String:Any]>()
    var object = [String:Any]() {
        didSet{
            let dict = self.object["phrases"] as! [String:Any]
            let arr = dict["array"] as! [[String:Any]]
            self.phrases = arr
        }
    }
    
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblDetail:UILabel!
    @IBOutlet var imgView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbl.tableFooterView = UIView(frame: .zero)

        let headerNib = UINib(nibName: "PlaySheetHeader", bundle: nil)
        self.tbl.register(headerNib, forHeaderFooterViewReuseIdentifier: "PlaySheetHeader")
        
        let title_ = self.object["title"] as! String
         let imageName = self.object["image"] as! String
        let phraseCount = "\(self.phrases.count) 個"
        self.lblTitle.text = title_
        self.lblDetail.text = phraseCount
        self.imgView.image = UIImage.init(named: imageName)
        
        self.tbl.rowHeight = UITableViewAutomaticDimension
        self.tbl.estimatedRowHeight = 44.0
        self.tbl.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tbl.estimatedSectionHeaderHeight = 44.0
        //self.tbl.allowsSelection = false
        self.tbl.dataSource = self
        self.tbl.delegate = self
        //let distance:CGFloat = 77+64
        self.tbl.contentInset = UIEdgeInsets(top: 77, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension SecondViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.phrases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "secondViewCell") as? secondViewCell
        if cell == nil {
            cell = secondViewCell(style: .default, reuseIdentifier: "secondViewCell")
        }
        let info = self.phrases[indexPath.row]
        let title = info["title"] as! String
        let detail = info["detail"] as! String
         let ImageName = info["image"] as! String
        cell?.lblTitle.text = title
        cell?.lblDetail.text = detail
        cell?.imgIcon.image = UIImage.init(named: ImageName)
        return cell!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        
        //return "Section \(section)"
        return "Section \(section)"

   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

//        let vc = PlaySheetViewController_(nibName: "PlaySheetViewController_", bundle: nil)
//        vc.object = self.phrases[indexPath.row]
//        self.navigationController?.show(vc, sender: self)
        let index = indexPath.row
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pageViewController") as! pageViewController
        vc.count = index
        vc.phrase = self.object["phrases"] as! [String:Any]
        self.navigationController?.show(vc, sender: self)
    }
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PlaySheetHeader") as? PlaySheetHeader
//        if view == nil {
//            view = PlaySheetHeader(reuseIdentifier: "PlaySheetHeader")
//        }
//        let title = self.object["title"] as! String
//        let phraseCount = "\(self.phrases.count) phrases"
//        view?.LBLTitle.text = title
//        view?.LBLDetail.text = phraseCount
//        view?.IMGView.isHidden
//        return view
//    }
}
