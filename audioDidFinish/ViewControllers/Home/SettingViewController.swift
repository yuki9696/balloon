//
//  SettingViewController.swift
//  audioDidFinish
//
//  Created by Yuki Yamamoto on 2017/03/15.
//  Copyright © 2017年 Nitin Gohel. All rights reserved.
//

import UIKit
import MessageUI


class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    var settingsList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.settingsList.append("向朋友分享 APP")
        self.settingsList.append("要求新的用語")
        self.settingsList.append("傳送意見回饋")

        self.tableView.reloadData()
        
        //delete separator of UITableView
        tableView.tableFooterView = UIView(frame: .zero)
    }
    

    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func closeVew() {
        self.dismiss(animated: true, completion: nil)
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        let settingItem = self.settingsList[indexPath.row]
        
        cell.textLabel?.text = settingItem
        
        //color of cells when selected
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.init(red: (238.0/255.0), green: (238.0/255.0), blue: (238.0/255.0), alpha: 1.0)
        cell.selectedBackgroundView =  selectedView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsList.count
    }
    
        
        private func sendMail(to recipient: String, subject: String) {
            let mailCompose = MFMailComposeViewController()
            mailCompose.mailComposeDelegate = self
            mailCompose.setToRecipients([recipient])
            mailCompose.setSubject(subject)
            mailCompose.setMessageBody("text", isHTML: false)
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailCompose, animated: true, completion: nil)
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            tableView.deselectRow(at: indexPath, animated: true)

            
            switch indexPath.row {
            case 0:
                
                let message = "Balloonで日本語を勉強しよう！"
                let shareView = UIActivityViewController(activityItems: [message], applicationActivities: nil)
                self.present(shareView, animated: true, completion: nil);break;
            case 1:
                
                let mailCompose = MFMailComposeViewController()
                
                mailCompose.mailComposeDelegate = self
                
                mailCompose.setToRecipients(["balloonappfeedback@gmail.com"])
                
                mailCompose.setSubject("傳送意見回饋")
                
                mailCompose.setMessageBody("", isHTML: false)
                
                if MFMailComposeViewController.canSendMail()
                    
                {
                    
                    self.present(mailCompose, animated: true, completion: nil)
                    
                };break;
            case 2:
                
                let mailCompose = MFMailComposeViewController()
                
                mailCompose.mailComposeDelegate = self
                
                mailCompose.setToRecipients(["balloonappfeedback@gmail.com"])
                
                mailCompose.setSubject("要求新的用語 👶")
                
                mailCompose.setMessageBody("", isHTML: false)
                
                if MFMailComposeViewController.canSendMail()
                    
                {
                    
                    self.present(mailCompose, animated: true, completion: nil)
                    
                };break;
            default: break
                
            }
        }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            
            controller.dismiss(animated: true, completion: nil)
            
        }
        
}
