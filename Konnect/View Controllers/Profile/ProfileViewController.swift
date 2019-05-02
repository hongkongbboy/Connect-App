//
//  ProfileViewController.swift
//  Konnect
//
//  Created by Philip Yu on 4/8/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController {
    
    var facebookUsername: String?
    var instagramUsername: String?
    var linkedinUsername: String?
    var snapchatUsername: String?
    var twitterUsername: String?
    var wechatUsername: String?
    var firstName: String?
    var lastName: String?
    
    var socialMedia = ["facebook", "instagram", "linkedin", "snapchat", "twitter", "wechat"]
    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var facebookUrl: UIButton!
//    @IBOutlet weak var twitterUrl: UIButton!
//    @IBOutlet weak var snapchatUrl: UIButton!
//    @IBOutlet weak var linkedinUrl: UIButton!
//    @IBOutlet weak var wechatUrl: UIButton!
//    @IBOutlet weak var instagramUrl: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
// Locate value of the Social Media Accounts for the login user in Heroku's Parse. iOS always executes the viewdidload before executing the viewdidappear, and therefore, we put the text loading function here.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFUser.query()
        query?.whereKey("username", equalTo: PFUser.current()!.username!)
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                for object in objects! {
                    if object["profileImage"] != nil {
                        let profilePic = object["profileImage"] as! PFFileObject
                        let urlString = profilePic.url!
                        let picurl = URL(string: urlString)!
                        self.profileView.af_setImage(withURL: picurl)
                    }
                    
                    
                    self.firstName = object["firstName"] as? String
                    self.lastName = object["lastName"] as? String
                    self.fullName.text = "\(self.firstName!) \(self.lastName!)"
                    
                    self.tableView.reloadData()
                }
            }
        })
        
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SocialMediaCell
//        cell?.btn.setTitle(socialMedia[indexPath.row], for: .normal)
        cell?.img.image = UIImage(named: socialMedia[indexPath.row])
        switch (indexPath.row) {
        case 0:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)

            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["facebookAccount"] != nil {
                            self.facebookUsername = object["facebookAccount"] as? String
                            print(self.facebookUsername!)
                            cell?.btn.setTitle("Open Facebook - \(self.facebookUsername!)", for: .normal)
                        }}}})
        case 1:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["instagramAccount"] != nil {
                            self.instagramUsername = object["instagramAccount"] as? String
                            print(self.instagramUsername!)
                            cell?.btn.setTitle("Open Instagram - \(self.instagramUsername!)", for: .normal)
                        }}}})
        case 2:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["linkedinAccount"] != nil {
                            self.linkedinUsername = object["linkedinAccount"] as? String
                            print(self.linkedinUsername!)
                            cell?.btn.setTitle("Open LinkedIn - \(self.linkedinUsername!)", for: .normal)
                        }}}})
        case 3:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["snapchatAccount"] != nil {
                            self.snapchatUsername = object["snapchatAccount"] as? String
                            print(self.snapchatUsername!)
                            cell?.btn.setTitle("Open Snapchat - \(self.snapchatUsername!)", for: .normal)
                        }}}})
        case 4:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["twitterAccount"] != nil {
                            self.twitterUsername = object["twitterAccount"] as? String
                            print(self.twitterUsername!)
                            cell?.btn.setTitle("Open Twitter - \(self.twitterUsername!)", for: .normal)
                        }}}})
        case 5:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["wechatAccount"] != nil {
                            self.wechatUsername = object["wechatAccount"] as? String
                            print(self.wechatUsername!)
                            cell?.btn.setTitle("Open WeChat - \(self.wechatUsername!)", for: .normal)
                        }}}})
        default:
            print("Error")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["facebookAccount"] != nil {
                            if UIApplication.shared.canOpenURL(URL(string: "facebook://profile/\(self.facebookUsername!)")!) {
                                UIApplication.shared.open(URL(string: "facebook://profile/\(self.facebookUsername!)")!, options: [:])
                            }
                            else {
                                UIApplication.shared.open(URL(string: "https://www.facebook.com/\(self.facebookUsername!)")!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
            })
        case 1:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["instagramAccount"] != nil {
                            if UIApplication.shared.canOpenURL(URL(string: "instagram://user?username=\(self.instagramUsername!)")!) {
                                UIApplication.shared.open(URL(string: "instagram://user?username=\(self.instagramUsername!)")!, options: [:])
                            }
                            else {
                                UIApplication.shared.open(URL(string: "https://www.instagram.com/\(self.instagramUsername!)")!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
            })
        case 2:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["linkedinAccount"] != nil {
                            if UIApplication.shared.canOpenURL(URL(string: "linkedin://profile/\(self.linkedinUsername!)")!) {
                                UIApplication.shared.open(URL(string: "linkedin://profile/\(self.linkedinUsername!)")!, options: [:])
                            }
                            else {
                                UIApplication.shared.open(URL(string: "https://www.linkedin.com/in/\(self.linkedinUsername!)")!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
            })
        case 3:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["snapchatAccount"] != nil {
                            if UIApplication.shared.canOpenURL(URL(string: "snapchat://add/\(self.snapchatUsername!)")!) {
                                UIApplication.shared.open(URL(string: "snapchat://add/\(self.snapchatUsername!)")!, options: [:])
                            }
                            else {
                                UIApplication.shared.open(URL(string: "https://www.snapchat.com/add/\(self.snapchatUsername!)")!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
            })
        case 4:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["twitterAccount"] != nil {
                            if UIApplication.shared.canOpenURL(URL(string: "twitter://profile/\(self.twitterUsername!)")!) {
                                UIApplication.shared.open(URL(string: "twitter://profile/\(self.twitterUsername!)")!, options: [:])
                            }
                            else {
                                UIApplication.shared.open(URL(string: "https://www.twitter.com/\(self.twitterUsername!)")!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
            })
        case 5:
            let query = PFUser.query()
            query?.whereKey("username", equalTo: PFUser.current()!.username!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if object["wechatAccount"] != nil {
                            if UIApplication.shared.canOpenURL(URL(string: "weixin://dl/profile/\(self.wechatUsername!)")!) {
                                UIApplication.shared.open(URL(string: "weixin://dl/profile/\(self.wechatUsername!)")!, options: [:])
                            }
                            else {
                                UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/wechat/id414478124")!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
            })
        default:
            print("Error with switch statement.")
        }
        }
}
