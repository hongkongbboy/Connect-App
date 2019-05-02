//
//  ProfileEditViewController.swift
//  Konnect
//
//  Created by kin on 4/14/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var socialAccount: UIPickerView!
    @IBOutlet weak var accountUpdateMessage: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    
    var socialMediaArray:[String] = Array()
    var socialPlaceHolder:[String] = Array()
    var facebookData: String?
    var linkedinData: String?
    var instagramData: String?
    var snapchatData: String?
    var twitterData: String?
    var wechatData: String?
    var check: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        socialMediaArray.append("Facebook")
        socialMediaArray.append("Linkedin")
        socialMediaArray.append("Instagram")
        socialMediaArray.append("Snapchat")
        socialMediaArray.append("Twitter")
        socialMediaArray.append("WeChat")
        
        socialPlaceHolder.append("kin.t.lay")
        socialPlaceHolder.append("kin-lay-4489495b")
        socialPlaceHolder.append("hongkongbboy")
        socialPlaceHolder.append("forever1668")
        socialPlaceHolder.append("KinTatLay1")
        socialPlaceHolder.append("hongkongbboy")
        
        socialAccount.dataSource = self
        socialAccount.delegate = self
        
        accountUpdateMessage.text = ""
        usernameField.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return socialMediaArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return socialMediaArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var socialMedia = socialMediaArray[pickerView.selectedRow(inComponent: 0)]
        if component == 0 {
            socialMedia = socialMediaArray[row]
        }
        accountUpdateMessage.text = "Please input your \(socialMedia) username:"
        usernameField.isHidden = false
        usernameField.attributedPlaceholder = NSAttributedString(string: socialPlaceHolder[row])
        print(socialMedia)
        self.check = socialMedia
    }
    
    @IBAction func onImageSave(_ sender: Any) {
        
        let accounts = PFUser.current()!
        let imageData = profileImage.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        accounts["profileImage"] = file
        accounts.saveInBackground {
            (success, error) in
            if success {
                print("saved!")
            } else {
                print("error: \(error)")
            }
        }
    }

    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        profileImage.image = scaledImage
        
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func onSaveButton(_ sender: Any) {
        let accounts = PFUser.current()!
        if check == "Facebook" && !usernameField.text!.isEmpty {
            accounts["facebookAccount"] = usernameField.text
        }
        else if check == "Linkedin" && !usernameField.text!.isEmpty {
            accounts["linkedinAccount"] = usernameField.text
        }
        else if check == "Instagram" && !usernameField.text!.isEmpty {
            accounts["instagramAccount"] = usernameField.text
        }
        else if check == "Snapchat" && !usernameField.text!.isEmpty {
            accounts["snapchatAccount"] = usernameField.text
        }
        else if check == "Twitter" && !usernameField.text!.isEmpty {
            accounts["twitterAccount"] = usernameField.text
        }
        else if check == "WeChat" && !usernameField.text!.isEmpty {
            accounts["wechatAccount"] = usernameField.text
        }
        else {
            print("error!")
        }
        accounts.saveInBackground {
            (success, error) in
            if success {
                print("saved!")
                
            } else {
                print("error!")
            }
        }
        usernameField.text = ""
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
