//
//  ContactTableViewController.swift
//  Konnect
//
//  Created by Philip Yu on 4/14/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class ContactTableViewController: UITableViewController {
    
    var myRefreshControl: UIRefreshControl!
    var friends: [String] = []
    var friendsFullName: [String] = []
    var becameFriendsAt = [Date]()
    let currentUser = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        fetchFriends()
        
        myRefreshControl = UIRefreshControl()
        myRefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(myRefreshControl, at: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFriends()
    }
    
    // Implement the delay method
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    // Call the delay method in your onRefresh() method
    @objc func onRefresh() {
        run(after: 2) {
            print("Contact List: Pulled to refresh...")
            self.myRefreshControl.endRefreshing()
            self.fetchFriends()
        }
    }
    
    func getData(className: String,
                 key: String? = nil, equalTo: AnyObject? = nil,
                 withCompletionBlock block: @escaping PFArrayResultBlock) {
        
        let query = PFQuery(className: className)
        query.whereKey(key!, equalTo: equalTo!)
        query.findObjectsInBackground(block: block)
        
    }
    
    func fetchFriends() {
        
        let query = PFUser.query()!
        
        getData(className: "Contacts", key: "username", equalTo: currentUser) { (objects, error) in
            
            self.friendsFullName.removeAll(keepingCapacity: false)
            
            if error == nil {
                for object in objects! as! [PFObject] {
                    if object["friends"] != nil {
                        self.friends = object["friends"] as! [String]
                    }
                    
                    if object["becameFriendsAt"] != nil {
                        self.becameFriendsAt = object["becameFriendsAt"] as! [Date]
                    }
                }
                
                query.whereKey("username", containedIn: self.friends)
                
                query.findObjectsInBackground(block: { (objects, error) in
                    if error == nil {
                        for object in objects! {
                            if let user = object as? PFUser {
                                let firstName = user["firstName"] as! String
                                let lastName = user["lastName"] as! String
                                let fullName = firstName + " " + lastName
                                self.friendsFullName.append(fullName)
                            }
                        }
                        
                        self.tableView.reloadData()
                    }
                })
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.friendsFullName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        
        cell.usernameLabel.text = friendsFullName[indexPath.row]
        
        // Configure the cell...
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            self.tableView.beginUpdates()
            
            // Remove friend from current user's contact list
            getData(className: "Contacts", key: "username", equalTo: currentUser) { (objects, error) in
                if error == nil {
                    for object in objects! as! [PFObject] {
                        if object["friends"] != nil {
                            object.remove(self.friends[indexPath.row], forKey: "friends")

                            self.friends.remove(at: indexPath.row)
                            self.friendsFullName.remove(at: indexPath.row)
                            self.becameFriendsAt.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .fade)

                            object.setValue(self.becameFriendsAt, forKey: "becameFriendsAt")
                            object.saveInBackground()
                        }
                    }
                }
            }

            // Remove friend from friend's contact list
            getData(className: "_User", key: "username", equalTo: self.friends[indexPath.row] as AnyObject) { (objects, error) in

                var user: PFUser?

                if error == nil {
                    for object in objects! as! [PFObject] {
                        user = object as? PFUser
                    }
                }

                self.getData(className: "Contacts", key: "username", equalTo: user!, withCompletionBlock: { (objects, error) in
                    if error == nil {
                        for object in objects! as! [PFObject] {
                            if object["friends"] != nil {
                                object.remove(self.currentUser.username!, forKey: "friends")
                                object.setObject(self.becameFriendsAt, forKey: "becameFriendsAt")
                                object.saveInBackground()
                            }
                        }
                    }
                })
            }
            
            self.tableView.endUpdates()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


