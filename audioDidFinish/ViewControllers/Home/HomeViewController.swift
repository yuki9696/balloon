//
//  HomeViewController.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 27/02/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit
import MessageUI



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    @IBOutlet var tblStoryList: UITableView!
    var array = PLIST.shared.mainArray
    


    func addTapped()
    {
        
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setToRecipients(["balloonappfeedback@gmail.com"])
        mailCompose.setSubject("要求新的用語 👶")
        if MFMailComposeViewController.canSendMail()
            
        {
            self.present(mailCompose, animated: true, completion: nil)
        }
            
        else{
            print("error...!")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"feedbackicon"), style: .plain, target: self, action: #selector(addTapped))
        
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
        
        //color of cells when selected
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.init(red: (238.0/255.0), green: (238.0/255.0), blue: (238.0/255.0), alpha: 1.0)
        cell.selectedBackgroundView =  selectedView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated:true)
        
        let messagesVc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        messagesVc.object = self.array[indexPath.row]
        self.navigationController?.show(messagesVc, sender: self)
    }
}


