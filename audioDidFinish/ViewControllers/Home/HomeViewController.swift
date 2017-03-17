//
//  HomeViewController.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 27/02/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblStoryList: UITableView!
    var array = PLIST.shared.mainArray
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        //delete separator of UITableView
        tblStoryList.tableFooterView = UIView(frame: .zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTableviewCell", for: indexPath) as! StoryTableviewCell
        let dict = self.array[indexPath.row] 
        let title = dict["title"] as! String
        let imageName = dict["image"] as! String
        let temp = dict["phrases"] as! [String:Any]
        let arr = temp["array"] as! [[String:Any]]
        let detail = "\(arr.count) 個"
        cell.imgIcon.image = UIImage.init(named: imageName)
        
       cell.lblTitle.text = title
        cell.lblSubtitle.text = detail
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated:true)
        
        let messagesVc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        messagesVc.object = self.array[indexPath.row]
        self.navigationController?.show(messagesVc, sender: self)
    }
}


