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
        
        self.settingsList.append("アプリを友達にシェア 😙")
        self.settingsList.append("新しいフレーズをリクエスト ✉️")
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let message = "Hey download my app [LINK]"
            let shareView = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            self.present(shareView, animated: true, completion: nil)
            
        } else if indexPath.row == 1 {
            let mailCompose = MFMailComposeViewController()
            
            mailCompose.mailComposeDelegate = self
            
            mailCompose.setToRecipients(["uliktodrinksodowe@gmail.com"])
            
            mailCompose.setSubject("feedback")
            
            mailCompose.setMessageBody("text", isHTML: false)
            
            if MFMailComposeViewController.canSendMail()
                
            {
                
                self.present(mailCompose, animated: true, completion: nil)
                
            }
                
            else{
                
                print("error...!")
                
            }
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
}
