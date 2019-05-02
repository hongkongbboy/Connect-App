//
//  ContactRequestsViewController.swift
//  Konnect
//
//  Created by Philip Yu on 4/16/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class ContactRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var receivedCell: ContactReceivedRequestTableViewCell! = nil
    var sentCell: ContactSentRequestTableViewCell! = nil
    var selectedSegment = 1
    var myRefreshControl: UIRefreshControl!
    var receivedRequests: [String] = []
    var receivedFullName: [String] = []
    var sentRequests: [String] = []
    var sentFullName: [String] = []
    let currentUser = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchRequests()
        
        myRefreshControl = UIRefreshControl()
        myRefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(myRefreshControl, at: 0)
        
    }
    
    // Implement the delay method
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    // Call the delay method in your onRefresh() method
    @objc func onRefresh() {
        run(after: 2) {
            print("Requests List: Pulled to refresh...")
            self.myRefreshControl.endRefreshing()
            self.fetchRequests()
        }
    }
    
    func getData(className: String,
                 key: String? = nil, equalTo: AnyObject? = nil,
                 withCompletionBlock block: @escaping PFArrayResultBlock) {
        
        let query = PFQuery(className: className)
        query.whereKey(key!, equalTo: equalTo!)
        query.findObjectsInBackground(block: block)
        
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onAcceptRequest(_ sender: Any) {
        
        let toUser = currentUser.username!
        let fromUser = receivedCell!.usernameLabel.text!
        var user: PFUser?
        var user2: PFUser?
//        var
        
        // TEST
//        getData(className: "_User", key: "username", equalTo: currentUser) { (objects, error) in
//            if error == nil {
//
//            }
//        }
        // TEST
        
        getData(className: "Contacts", key: "username", equalTo: currentUser) { (objects, error) in
            if error == nil {
                for object in objects! as! [PFObject] {
                    object.addUniqueObject(fromUser, forKey: "friends")
                    object.addUniqueObject(Date(), forKey: "becameFriendsAt")
                    object.saveInBackground()
                }
                
                self.fetchRequests()
            }
        }
        
        getData(className: "_User", key: "username", equalTo: fromUser as AnyObject) { (object, error) in
            if error == nil {
                for object in object! as! [PFObject] {
                    user = object as? PFUser
                }
                
                self.getData(className: "Contacts", key: "username", equalTo: user!, withCompletionBlock: { (objects, error) in
                    if error == nil {
                        for object in objects! as! [PFObject] {
                            object.addUniqueObject(toUser, forKey: "friends")
                            object.addUniqueObject(Date(), forKey: "becameFriendsAt")
                            object.saveInBackground()
                        }
                        
                        self.fetchRequests()
                    }
                })
            }
        }
        
        getData(className: "Contacts", key: "username", equalTo: currentUser) { (objects, error) in
            if error == nil {
                for object in objects! as! [PFObject]  {
                    object.remove(fromUser, forKey: "receivedRequests")
                    object.saveInBackground()
                }
                
                self.fetchRequests()
            }
        }
        
        getData(className: "_User", key: "username", equalTo: fromUser as AnyObject) { (objects, error) in
            if error == nil {
                for object in objects! as! [PFObject] {
                    user2 = object as? PFUser
                }
                
                self.getData(className: "Contacts", key: "username", equalTo: user2!, withCompletionBlock: { (objects, error) in
                    if error == nil {
                        for object in objects! as! [PFObject] {
                            object.remove(toUser, forKey: "sentRequests")
                            object.saveInBackground()
                        }
                        
                        self.fetchRequests()
                    }
                })
            }
        }
        
    }
    
    @IBAction func onDeclineRequest(_ sender: Any) {
        
        let fromUser = receivedCell!.usernameLabel.text!
        var user: PFUser?
        
        getData(className: "Contacts", key: "username", equalTo: currentUser) { (objects, error) in
            if error == nil {
                for object in objects! as! [PFObject] {
                    object.remove(fromUser, forKey: "receivedRequests")
                    object.saveInBackground()
                }
                
                self.fetchRequests()
            }
        }
        
        getData(className: "_User", key: "username", equalTo: fromUser as AnyObject) { (objects, error) in
            if error == nil {
                for object in objects as! [PFObject] {
                    user = object as? PFUser
                }
            }
            
            self.getData(className: "Contacts", key: "username", equalTo: user!, withCompletionBlock: { (objects, error) in
                if error == nil {
                    for object in objects! as! [PFObject] {
                        object.remove(self.currentUser.username!, forKey: "sentRequests")
                        object.saveInBackground()
                    }
                    
                    self.fetchRequests()
                }
            })
        }
        
    }
    
    func fetchRequests() {
        
//        let requestQuery = PFUser.query()!
//        let sentQuery = PFUser.query()!
        
        getData(className: "Contacts", key: "username", equalTo: currentUser) { (objects, error) in
            if error == nil {
                for object in objects! as! [PFObject] {
                    if (object["receivedRequests"] != nil) {
                        self.receivedRequests = object["receivedRequests"]! as! [String]
                    }
                    
                    if (object["sentRequests"] != nil) {
                        self.sentRequests = object["sentRequests"]! as! [String]
                    }
                    
//                    requestQuery.whereKey("username", containedIn: self.receivedRequests)
//                    sentQuery.whereKey("username", containedIn: self.sentRequests)
//
//                    requestQuery.findObjectsInBackground(block: { (objects, error) in
//                        if error == nil {
//                            for object in objects! {
//                                if let user = object as? PFUser {
//                                    let firstName = user["firstName"] as! String
//                                    let lastName = user["lastName"] as! String
//                                    let fullName = firstName + " " + lastName
//                                    self.receivedFullName.append(fullName)
//                                }
//                            }
//
//                            self.tableView.reloadData()
//                        }
//                    })
//
//                    sentQuery.findObjectsInBackground(block: { (objects, error) in
//                        if error == nil {
//                            for object in objects! {
//                                if let user = object as? PFUser {
//                                    let firstName = user["firstName"] as! String
//                                    let lastName = user["lastName"] as! String
//                                    let fullName = firstName + " " + lastName
//                                    self.sentFullName.append(fullName)
//                                }
//                            }
//
//                            self.tableView.reloadData()
//                        }
//                    })
                    
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            selectedSegment = 1
        } else {
            selectedSegment = 2
        }
        
        tableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
                if selectedSegment == 1 {
                    if receivedRequests.count == 0 {
                        return 1
                    } else {
                        return receivedRequests.count
                    }
                } else if selectedSegment == 2 {
                    if sentRequests.count == 0 {
                        return 1
                    } else {
                        return sentRequests.count
                    }
                } else {
                    if receivedRequests.count == 0 {
                        return 1
                    } else {
                        return receivedRequests.count
                    }
                }
        
//        if selectedSegment == 1 {
//            if receivedFullName.count == 0 {
//                return 1
//            } else {
//                return receivedFullName.count
//            }
//        } else if selectedSegment == 2 {
//            if sentFullName.count == 0 {
//                return 1
//            } else {
//                return sentFullName.count
//            }
//        } else {
//            if receivedFullName.count == 0 {
//                return 1
//            } else {
//                return receivedFullName.count
//            }
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        receivedCell = tableView.dequeueReusableCell(withIdentifier: "Received Cell", for: indexPath) as? ContactReceivedRequestTableViewCell
        sentCell = tableView.dequeueReusableCell(withIdentifier: "Sent Cell", for: indexPath) as? ContactSentRequestTableViewCell
        
        receivedCell.acceptButton.tag = indexPath.row
        receivedCell.acceptButton.addTarget(self, action: #selector(onAcceptRequest(_:)), for: .touchUpInside)
        receivedCell.declineButton.tag = indexPath.row
        receivedCell.declineButton.addTarget(self, action: #selector(onDeclineRequest(_:)), for: .touchUpInside)
        
        if receivedRequests.isEmpty {
            receivedCell.textLabel?.text = "No friendship request found..."
            receivedCell.textLabel!.font = UIFont.systemFont(ofSize: 17.0)
            receivedCell.textLabel?.textAlignment = NSTextAlignment.center
            receivedCell.usernameLabel.isHidden = true
            receivedCell.profileImageView.isHidden = true
            receivedCell.acceptButton.isHidden = true
            receivedCell.declineButton.isHidden = true
        } else {
            receivedCell.usernameLabel.text = receivedRequests[indexPath.row]
//                        receivedCell.usernameLabel.text = receivedFullName[indexPath.row]
        }
        
        if sentRequests.isEmpty {
            sentCell.textLabel?.text = "No friendship request sent..."
            sentCell.textLabel!.font = UIFont.systemFont(ofSize: 17.0)
            sentCell.textLabel?.textAlignment = NSTextAlignment.center
            sentCell.usernameLabel.isHidden = true
            sentCell.profileImageView.isHidden = true
        } else {
            sentCell.usernameLabel.text = sentRequests[indexPath.row]
//                        sentCell.usernameLabel.text = sentFullName[indexPath.row]
        }
        
        if selectedSegment == 1 {
            return receivedCell
        } else if selectedSegment == 2 {
            return sentCell
        } else {
            return receivedCell
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
