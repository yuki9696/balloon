//
//  PlaySheetViewController_.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 27/02/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit
let kLeftCell = "PlaySheetCellLeft"
let kRightCell = "PlaySheetCellRight"
let kHeaderView = "PlaySheetHeader"
let kFooterView = "PlaySheetFooter"

class PlaySheetViewController_: UIViewController {
    var pageIndex:Int = 0
    var messages = Array<[String:Any]>()
    var currentIndex = -2
    var object = [String:Any]() {
        didSet{
            let arr = self.object["chats"] as! [[String:Any]]
            self.messages = arr
        }
    }
    var playAutometically = false
    
    @IBOutlet var table:UITableView!
    @IBOutlet var lblBottom:UILabel!
    var player:AudioPlayer!

    //MARK:- instantiate
    init(withPhrase obj:[String:Any]) {
        super.init(nibName: "chat", bundle: nil)
        self.object = obj
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let leftNib = UINib(nibName: kLeftCell, bundle: nil)
        self.table.register(leftNib, forCellReuseIdentifier: kLeftCell)
        let rightNib = UINib(nibName: kRightCell, bundle: nil)
        self.table.register(rightNib, forCellReuseIdentifier: kRightCell)
        let headerNib = UINib(nibName: kHeaderView, bundle: nil)
        self.table.register(headerNib, forHeaderFooterViewReuseIdentifier: kHeaderView)
//        let footerNib = UINib(nibName: kFooterView, bundle: nil)
//        self.table.register(footerNib, forHeaderFooterViewReuseIdentifier: kFooterView)
        
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 44
        self.table.tableFooterView = UIView()
        self.table.dataSource = self
        self.table.delegate = self
        self.table.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapTable(_:)))
        self.table.addGestureRecognizer(tap)
        
        
        
        
        
        
        
        
        
        
        //
        let explanationtext = self.object["explanation"] as! String
        
        
        self.lblBottom.text = explanationtext
        
        

        //self.table.reloadData()
        
        /*  Now,check that audioPlayer should start autometically or not.
            if it is true than play the whole array of audio.
            this code is as same as 'func tapTable(_ gesture:UITapGestureRecognizer)'
         */
        if self.playAutometically == true {
            self.playAll()
            //self.table.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0)
        }
        self.table.bounces = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBottomLabel(_:)))
        self.lblBottom.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationHandler(_:)), name: .kPlayGlobalyNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationHandler(_:)), name: .kStopGlobalyNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.player != nil {
            self.stop()
        }
        NotificationCenter.default.removeObserver(self, name: .kPlayGlobalyNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kStopGlobalyNotification, object: nil)
    }
}
extension PlaySheetViewController_ {
    //MARK: NotificationCenter
    func notificationHandler(_ note:Notification) {
        if note.name == .kStopGlobalyNotification {
            self.stop()
            //self.table.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        }else if note.name == .kPlayGlobalyNotification {
            if self.currentIndex > -1 {
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                self.reloadCell(AtIndexPath: indexPath, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
            }else if self.currentIndex < 0 {
                self.reloadHeaders(atSection: -1, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
            }
            self.playAutometically = true
            self.playAll()
            //self.table.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0)
        }
    }
    func play(withObject msg:[String:Any],isHeader flag:Bool = false) {
        player = AudioPlayer(withStartingClosure: { (_ , index) in
            self.currentIndex = index
            if index < 0 {
                self.reloadHeaders()
            }else{
                let indexPath = IndexPath(row: index, section: 0)
                self.reloadCell(AtIndexPath: indexPath)
            }
        }, andStopingClosure: { (lastIndex) in
            self.currentIndex = -2
            if lastIndex < 0 {
                self.reloadHeaders()
            }else {
                let indexPath = IndexPath(row: lastIndex, section: 0)
                self.reloadCell(AtIndexPath: indexPath)
            }
        }, finishedAllClosure: { (finished) in
            self.currentIndex = -2
            self.table.reloadSections([0], with: .none)
            NotificationCenter.default.post(name: .kCurrentPlayListFinishedNotification, object: self)
        })
        player.isFromHeader = flag
        player.object = msg
    }
    func playAll(){
        player = AudioPlayer(withStartingClosure: { (_ , index) in
            self.currentIndex = index
            if index < 0 {
                self.reloadHeaders()
            }else{
                let indexPath = IndexPath(row: index, section: 0)
                self.reloadCell(AtIndexPath: indexPath)
            }
        }, andStopingClosure: { (lastIndex) in
            self.currentIndex = -2
            if lastIndex < 0 {
                self.reloadHeaders()
            }else {
                let indexPath = IndexPath(row: lastIndex, section: 0)
                self.reloadCell(AtIndexPath: indexPath)
            }
        }, finishedAllClosure: { (finished) in
            self.currentIndex = -2
            self.table.reloadSections([0], with: .none)
            NotificationCenter.default.post(name: .kCurrentPlayListFinishedNotification, object: self)
        })
        player.object = self.object
    }
    func stop() {
        self.player.mode = .stopped
        self.player = nil
        self.currentIndex = -2
        self.reloadHeaders()
        self.table.reloadRows(at: self.table.indexPathsForVisibleRows!, with: .none)
    }
}
extension PlaySheetViewController_ : UITableViewDataSource, UITableViewDelegate {
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row % 2 == 0 {
            //Left Side
            var cell = tableView.dequeueReusableCell(withIdentifier: kLeftCell) as? PlaySheetCellLeft
            if cell == nil {
                cell = PlaySheetCellLeft(style: .default, reuseIdentifier: kLeftCell)
            }
            self.configureCell(cell, atIndexPath: indexPath)
            return cell!
        }
        else {
            //Right Side
            var cell = tableView.dequeueReusableCell(withIdentifier: kRightCell) as? PlaySheetCellRight
            if cell == nil {
                cell = PlaySheetCellRight(style: .default, reuseIdentifier: kRightCell)
            }
            self.configureCell(cell, atIndexPath: indexPath)
            return cell!
        }
    }
    func configureCell(_ cell:UITableViewCell?,atIndexPath indexPath:IndexPath,shouldStop value:Int = 0) {
        if let gestures = cell?.gestureRecognizers {
            for gesture in gestures {
                cell?.removeGestureRecognizer(gesture)
            }
        }
        let row = indexPath.row
        let msg = self.messages[row]
        if row % 2 == 0 {
            if let cell = cell as? PlaySheetCellLeft {
                cell.tag = row
                cell.bubbleView.tag = row
                cell.message = msg
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapLeft(_:)))
                cell.addGestureRecognizer(tap)
                if value == 0 {
                    cell.animate = (self.currentIndex == row)
                }else {
                    cell.animate = false
                }
            }
        }else {
            if let cell = cell as? PlaySheetCellRight {
                cell.tag = row
                cell.bubbleView.tag = row
                cell.message = msg
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapRight(_:)))
                cell.addGestureRecognizer(tap)
                if value == 0 {
                    cell.animate = (self.currentIndex == row)
                }else {
                    cell.animate = false
                }
            }
        }
    }
    func reloadCell(AtIndexPath indexPath:IndexPath,shouldStop value:Int = 0){
        //"value" is default value.
        // if it is 1. it means stop playing animation of this TableViewCell
        let cell = self.table.cellForRow(at: indexPath)
        self.configureCell(cell, atIndexPath: indexPath, shouldStop: value)
        self.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: kHeaderView) as? PlaySheetHeader
        if view == nil {
            view = PlaySheetHeader(reuseIdentifier: kHeaderView)
        }
        self.configureHeader(view)
        return view!
    }
    private func configureHeader(_ view:PlaySheetHeader?,forSection section:Int = 0,shouldStop value:Int = 0) {
        let msg = self.object
        view?.message = msg
        if value == 0 {
            view?.animate = (self.currentIndex == -1)
        }else {
            view?.animate = false
        }
        if let gestures = view?.gestureRecognizers {
            for gesture in gestures {
                view?.removeGestureRecognizer(gesture)
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(_:)))
        view?.addGestureRecognizer(tap)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func reloadHeaders(atSection idx:Int = -1,shouldStop value:Int = 0) {
        if idx == -1 {
            for section in 0...(self.table.numberOfSections - 1) {
                if let header = self.table.headerView(forSection: section) as? PlaySheetHeader {
                    self.configureHeader(header, forSection: section, shouldStop: value)
                }
            }
        }else {
            if let header = self.table.headerView(forSection: idx) as? PlaySheetHeader {
                self.configureHeader(header, forSection: idx, shouldStop: value)
            }
        }
        
    }
}
extension PlaySheetViewController_ {
    func tapLeft(_ gesture:UITapGestureRecognizer){
        if gesture.state == .recognized {
            let cell = gesture.view as! PlaySheetCellLeft
            let bubbleView = cell.bubbleView
            let location = gesture.location(in: cell)
            print(self.currentIndex)
            if self.currentIndex > -1 {
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                self.reloadCell(AtIndexPath: indexPath, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
                if self.currentIndex == cell.tag {
                    self.currentIndex = -2
                    return
                }
            }else if self.currentIndex < 0 {
                self.reloadHeaders(atSection: -1, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
            }
            if self.playAutometically == true {
                self.playAutometically = false
                NotificationCenter.default.post(name: .kInturruptGlobalPlayingNotification, object: nil)
                if player != nil {
                    if self.player.player.isPlaying == true {
                        self.stop()
                    }
                }
            }
            if bubbleView?.frame.contains(location) == true {
                let msg = self.messages[cell.tag]
                self.play(withObject: msg)
            }else {
                self.playAll()
            }
        }
    }
    func tapRight(_ gesture:UITapGestureRecognizer){
        if gesture.state == .recognized {
            let cell = gesture.view as! PlaySheetCellRight
            let bubbleView = cell.bubbleView
            let location = gesture.location(in: cell)
            print(self.currentIndex)
            if self.currentIndex > -1 {
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                self.reloadCell(AtIndexPath: indexPath, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                    
                }
                if self.currentIndex == cell.tag {
                    self.currentIndex = -2
                    return
                }
            }else if self.currentIndex < 0 {
                self.reloadHeaders(atSection: -1, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
            }
            if self.playAutometically == true {
                self.playAutometically = false
                NotificationCenter.default.post(name: .kInturruptGlobalPlayingNotification, object: nil)
                if player != nil {
                    if self.player.player.isPlaying == true {
                        self.stop()
                    }
                }
            }
            if bubbleView?.frame.contains(location) == true {
                let msg = self.messages[cell.tag]
                self.play(withObject: msg)
            }else {
                self.playAll()
            }
        }
    }
    func tapHeader(_ gesture:UITapGestureRecognizer){
        if gesture.state == .recognized {
            let header = gesture.view as! PlaySheetHeader
            let bubbleView = header.bubbleView
            let location = gesture.location(in: header)
            if self.currentIndex > -1 {
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                self.reloadCell(AtIndexPath: indexPath, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
            }else if self.currentIndex < 0 {
                self.reloadHeaders(atSection: -1, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
                if self.currentIndex == -1 {
                    self.currentIndex = -2
                    return
                }
            }
            if self.playAutometically == true {
                self.playAutometically = false
                NotificationCenter.default.post(name: .kInturruptGlobalPlayingNotification, object: nil)
                if player != nil {
                    if self.player.player.isPlaying == true {
                        self.stop()
                    }
                }
            }
            if bubbleView?.frame.contains(location) == true {
                var temp = self.object
                temp.removeValue(forKey: "chats")
                self.play(withObject: temp, isHeader: true)
            }
        }
    }
    func tapTable(_ gesture:UITapGestureRecognizer){
        if gesture.state == .recognized {
            let tbl = gesture.view as! UITableView
            let point = gesture.location(in: tbl)
            let indexPath = self.table.indexPathForRow(at: point)
            if self.currentIndex > -1 {
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                self.reloadCell(AtIndexPath: indexPath, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
            }else if self.currentIndex < 0 {
                self.reloadHeaders(atSection: -1, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
            }
            if self.playAutometically == true {
                self.playAutometically = false
                NotificationCenter.default.post(name: .kInturruptGlobalPlayingNotification, object: nil)
                if player != nil {
                    if self.player.player.isPlaying == true {
                        self.stop()
                    }
                }
            }
            if indexPath == nil {
                self.playAll()
            }
        }
    }
    func tapBottomLabel(_ gesture:UITapGestureRecognizer){
        if gesture.state == .recognized {
            let tbl = gesture.view as! UILabel
            _ = gesture.location(in: tbl)
            //let indexPath = self.table.indexPathForRow(at: point)
            if self.currentIndex > -1 {
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                self.reloadCell(AtIndexPath: indexPath, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
            }else if self.currentIndex < 0 {
                self.reloadHeaders(atSection: -1, shouldStop: 1)
                if player != nil {
                    self.player.mode = .stopped
                    self.player = nil
                }
            }
            if self.playAutometically == true {
                self.playAutometically = false
                NotificationCenter.default.post(name: .kInturruptGlobalPlayingNotification, object: nil)
                if player != nil {
                    if self.player.player.isPlaying == true {
                        self.stop()
                    }
                }
            }
            self.playAll()
        }
    }
}
