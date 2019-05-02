//
//  FeedTableViewController.swift
//  Konnect
//
//  Created by Philip Yu on 4/14/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
    var myRefreshControl: UIRefreshControl!
    var friendsFullName: [String] = []
    var friends: [String] = []
    var becameFriendsAt = [Date]()
    let currentUser = PFUser.current()!
    
    var testarr = ["Test", "Array"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        myRefreshControl = UIRefreshControl()
        myRefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(myRefreshControl, at: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchContactData()
    }
    
    // Implement the delay method
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    // Call the delay method in your onRefresh() method
    @objc func onRefresh() {
        run(after: 2) {
            print("Feed: Pulled to refresh...")
            self.myRefreshControl.endRefreshing()
            self.fetchContactData()
        }
    }
    
    func getData(className: String,
                 key: String? = nil, equalTo: AnyObject? = nil,
                 withCompletionBlock block: @escaping PFArrayResultBlock) {
        
        let query = PFQuery(className: className)
        query.whereKey(key!, equalTo: equalTo!)
        query.findObjectsInBackground(block: block)
        
    }
    
    func fetchContactData() {
        
        getData(className: "Contacts", key: "username", equalTo: currentUser) { (objects, error) in
            if error == nil {
                for object in objects! as! [PFObject] {
                    if object["friends"] != nil {
                        self.friends = object["friends"] as! [String]
                    }
                    
                    if object["becameFriendsAt"] != nil {
                        self.becameFriendsAt = object["becameFriendsAt"] as! [Date]
                    }
                }
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    @IBAction func onLogout(_ sender: Any) {
        
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginViewController
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
//        return friendsFullName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        
        // Configure the cell...
        
//        cell.feedLabel.text = "You and \"\(self.friendsFullName[self.friendsFullName.count - indexPath.row - 1])\" have connected!"
        cell.feedLabel.text = "You and \"\(self.friends[self.friends.count - indexPath.row - 1])\" have connected!"
        let date = self.becameFriendsAt[self.becameFriendsAt.count - indexPath.row - 1]
        let time = date.timeAgoDisplay()
        cell.timestampLabel.text = "\(time)"
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func getRelativeTime(timeString: String) -> String {
        
        let time: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        return time.timeAgoDisplay()
        
    }
    
}

extension Date {
    
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / 60) minutes ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / 60 / 60) hours ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / 60 / 60 / 24) days ago"
        }
        
        return "\(secondsAgo / 60 / 60 / 24 / 7) weeks ago"
    }
    
}

