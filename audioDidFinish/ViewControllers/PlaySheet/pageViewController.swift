//
//  pageViewController.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 07/03/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit

class pageViewController: UIPageViewController {
    var count:Int = 0
    var isGlobal = false
    var nextViewController:PlaySheetViewController_?
    var previousViewController:PlaySheetViewController_?
    
    fileprivate var allPhrases = Array<[String:Any]>()
    var phrase = [String:Any]() {
        didSet {
            //print(phrase)
            self.allPhrases = self.phrase["array"] as! Array<[String:Any]>
        }
    }
    fileprivate var player:AudioPlayer!
    fileprivate var btnNext: UIBarButtonItem!
    fileprivate var btnPrev: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        let vc = self.viewController(forIndex: self.count)!
        let text = "\(count+1)/\(self.allPhrases.count)"
        self.title = text
        self.setViewControllers([vc] , direction: .forward, animated: false, completion: nil)
        self.dataSource = self
        self.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.playTouched(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationHandler(_:)), name: .kCurrentPlayListFinishedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationHandler(_:)), name: .kInturruptGlobalPlayingNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .kCurrentPlayListFinishedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kInturruptGlobalPlayingNotification, object: nil)
        
    }
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent == self.parent {
            self.handleBackAction()
        }
    }
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.handleBackAction()
        }
    }
    func handleBackAction() {
        self.hideToolbar()
    }
    
    //MARK: NotificationCenter
    func notificationHandler(_ note:Notification) {
        if note.name == .kCurrentPlayListFinishedNotification {
            if self.isGlobal == true {
                _ = self.nextPage()
            }
        }else if note.name == .kInturruptGlobalPlayingNotification {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.playTouched(_:)))
            self.hideToolbar()
            self.isGlobal = false
            self.player = nil
        }
    }
}
extension pageViewController {
    //MARK: UIBarButton Actions
    func playTouched(_ sender:UIBarButtonItem){
        if self.isGlobalyPlaying() == false {
            NotificationCenter.default.post(name: .kPlayGlobalyNotification, object: self)
            let img = #imageLiteral(resourceName: "stop")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: img, style: .done, target: self, action: #selector(self.playTouched(_:)))
            self.setToolbar()
            self.isGlobal = true
            let vc = self.curruntViewController()!
            self.player = vc.player
        }else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.playTouched(_:)))
            self.hideToolbar()
            self.isGlobal = false
            NotificationCenter.default.post(name: .kStopGlobalyNotification, object: self)
            self.player = nil
        }
    }
    func isGlobalyPlaying() -> Bool {
        if self.player != nil {
            if self.player.player == nil {
                return false
            }
            if self.player.player!.isPlaying == true {
                return self.isGlobal
            }
        }
        return false
    }
    func setToolbar() {
      //  self.btnNext = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(self.nextPage))
      //  self.btnPrev = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(self.previousePage))
      //  let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      //  self.setToolbarItems([self.btnPrev,flexible,self.btnNext], animated: true)
       // self.navigationController?.setToolbarHidden(false, animated: true)
    }
    func hideToolbar() {
        self.setToolbarItems(nil, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func nextPage() -> Bool {
        
        let next = self.count + 1
        if next >= self.allPhrases.count {
            return false
        }
        let vc = self.viewController(forIndex: next)!
        vc.playAutometically = true
        let text = "\(next+1)/\(self.allPhrases.count)"
        self.title = text
        self.setViewControllers([vc] , direction: .forward, animated: true, completion: nil)
        self.player = vc.player
        self.count = next
        return true
    }
    func previousePage() -> Bool {
        let prev = self.count - 1
        if prev < 0 {
            return false
        }
        let vc = self.viewController(forIndex: prev)!
        vc.playAutometically = true
        let text = "\(prev+1)/\(self.allPhrases.count)"
        self.title = text
        self.setViewControllers([vc] , direction: .reverse, animated: true, completion: nil)
        self.count = prev
        self.player = vc.player
        return true
    }
}
extension pageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PlaySheetViewController_).pageIndex
        if index == NSNotFound {
            return nil
        }
        index += 1
        return self.viewController(forIndex: index)
        //return self.nextViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PlaySheetViewController_).pageIndex
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        return self.viewController(forIndex: index)
        //return self.previousViewController
    }
}
extension pageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if pendingViewControllers.count > 0 {
            let vc = pendingViewControllers.first!
            count = (vc as! PlaySheetViewController_).pageIndex
            let text = "\(count+1)/\(self.allPhrases.count)"
            self.title = text
            //STOP THE CURRENT VIEWCONTROLLER AUDIO. WHILE DRAGGING .....
            let currentVC = self.curruntViewController()
            currentVC?.playAutometically = self.isGlobal
            if currentVC!.player == nil {
                return
            }
            currentVC?.stop()
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed == false {
            count = (previousViewControllers.first! as! PlaySheetViewController_).pageIndex
            let text = "\(count+1)/\(self.allPhrases.count)"
            self.title = text
            let vc = previousViewControllers.first! as! PlaySheetViewController_
            vc.playAutometically = self.isGlobal
            if self.isGlobal == true {
                vc.playAll()
                self.player = vc.player
            }
        }else {
            let currentVC = self.curruntViewController()
            currentVC?.playAutometically = self.isGlobal
            if self.isGlobal == true {
                currentVC?.playAll()
                self.player = currentVC!.player
            }
        }
    }
}
extension pageViewController {
    func viewController(forIndex index:Int) -> PlaySheetViewController_? {
        if index < 0 || index >= self.allPhrases.count {
            return nil
        }
        
        let vc = PlaySheetViewController_(nibName: "PlaySheetViewController_", bundle: nil)
        vc.pageIndex = index
        vc.object = self.allPhrases[index]
        return vc
    }
    func curruntViewController() -> PlaySheetViewController_? {
        return self.viewControllers?.first as? PlaySheetViewController_
    }
    func currentIndex() -> Int {
        if let vc = self.curruntViewController() {
            return vc.pageIndex
        }
        return -1
    }
}
extension pageViewController {
    
}
