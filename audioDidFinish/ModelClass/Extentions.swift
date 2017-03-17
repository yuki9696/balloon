//
//  Extentions.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 10/03/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import Foundation
import UIKit

public extension Notification.Name {
    //com.iosapp.audioDidFinish
    static let kPlayGlobalyNotification = Notification.Name("com.iosapp.playglobaly")
    static let kCurrentPlayListFinishedNotification = Notification.Name("com.iosapp.currentplaylistfinished")
    static let kStopGlobalyNotification = Notification.Name("com.iosapp.stopglobaly")
    static let kInturruptGlobalPlayingNotification = Notification.Name("com.iosapp.inturruptglobal")
}
public extension UINavigationController {
    
}
public extension UIView {
    
    var isFadedOut:Bool {
        get {
            return (self.alpha != 1.0)
        }
    }
    
    var isEnabled : Bool {
        get {
            return self.isUserInteractionEnabled
        }
    }
    
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(duration: TimeInterval = 0.25) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(duration: TimeInterval = 0.25) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func makeDisable(_ animate:Bool = false) {
        if animate == false {
            self.alpha = 0.5
            self.isUserInteractionEnabled = false
        }else {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0.5
                self.isUserInteractionEnabled = false
            })
        }
    }
    
    func makeEnable(_ animate:Bool = false) {
        if animate == false {
            self.alpha = 1.0
            self.isUserInteractionEnabled = true
        }else {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1.0
                self.isUserInteractionEnabled = true
            })
        }
    }
    
    func shadow() {
        self.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.layoutIfNeeded()
    }
    func removeShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 0
        self.layoutIfNeeded()
    }
}
