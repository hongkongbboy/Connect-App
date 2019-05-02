//
//  ContactSearchTableViewController.swift
//  Konnect
//
//  Created by Philip Yu on 4/14/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class ContactSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var myRefreshControl: UIRefreshControl!
    var cell: ContactSearchTableViewCell! = nil
    var searchResults: [String] = []
    var usernameList: [String] = []
    var friends: [String] = []
    var sentRequests: [PFUser] = []
    let currentUser = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        searchBar.delegate = self
        
        fetchUsers() // REMOVE ON DEPLOY
        
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
            print("Search: Pulled to refresh...")
            self.myRefreshControl.endRefreshing()
            self.fetchUsers()
        }
    }
    
    func getData(className: String,
                 key: String? = nil, equalTo: AnyObject? = nil,
                 withCompletionBlock block: @escaping PFArrayResultBlock) {
        
        let query = PFQuery(className: className)
        query.whereKey(key!, equalTo: equalTo!)
        query.findObjectsInBackground(block: block)
        
    }
    
    @IBAction func onSendRequest(_ sender: UIButton!) {
        
        var user: PFUser?
        
        getData(className: "_User", key: "username", equalTo: usernameList[sender.tag] as AnyObject) { (objects, error) in
            if error == nil {
                for object in objects! {
                    user = object as? PFUser
                }
            }
            
            self.getData(className: "Contacts", key: "username", equalTo: user!, withCompletionBlock: { (objects, error) in
                if error == nil {
                    for object in objects! as! [PFObject] {
                        object.addUniqueObject(self.currentUser.username!, forKey: "receivedRequests")
                        object.saveInBackground(block: { (success, error) in
                            sender.isEnabled = false
                            sender.isUserInteractionEnabled = false
                        })
                        
                        self.getData(className: "Contacts", key: "username", equalTo: self.currentUser, withCompletionBlock: { (objects, error) in
                            if error == nil {
                                for object in objects! as! [PFObject] {
                                    object.addUniqueObject(user!.username!, forKey: "sentRequests")
                                    object.saveInBackground()
                                }
                            }
                        })
                    }
                }
            })
        }
        
    }
    
    func fetchUsers() {
        
        let query = PFUser.query()!
        
        getData(className: "Contacts", key: "username", equalTo: currentUser) { (objects, error) in
            
            self.searchResults.removeAll(keepingCapacity: false)
            
            if error == nil {
                for object in objects! as! [PFObject] {
                    if object["sentRequests"] != nil {
                        self.sentRequests = object["sentRequests"] as! [PFUser]
                    }
                    
                    if object["friends"] != nil {
                        self.friends = object["friends"] as! [String]
                    }

                    query.whereKey("username", notContainedIn: self.friends)
                    query.whereKey("username", notEqualTo: self.currentUser.username!)

                    query.findObjectsInBackground(block: { (objects, error) in
                        if error == nil {
                            for object in objects! {
                                if let user = object as? PFUser {
                                    let firstName = user["firstName"] as! String
                                    let lastName = user["lastName"] as! String
                                    let fullName = firstName + " " + lastName
                                    self.searchResults.append(fullName)
                                    self.usernameList.append(user.username!)
                                }
                            }

                            self.tableView.reloadData()
                        }
                    })
                    
                }
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
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "ContactSearchCell", for: indexPath) as? ContactSearchTableViewCell
        
        cell.sendRequestButton.tag = indexPath.row
        cell.sendRequestButton.addTarget(self, action: Selector(("onSendRequest:")), for: .touchUpInside)
        cell.usernameLabel.text = searchResults[indexPath.row]
        
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
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    // MARK: - Navigation
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
