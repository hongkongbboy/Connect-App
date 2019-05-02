//
//  QRAddContactViewController.swift
//  Konnect
//
//  Created by Philip Yu on 4/8/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class QRAddContactViewController: UIViewController {
    
    var contactName: String?
    
    @IBOutlet weak var QRImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        generatorQR()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        generatorQR()
    }
    
    func generatorQR() {
        let query = PFUser.query()
        query?.whereKey("username", equalTo: PFUser.current()!.username!)
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                for object in objects! {
                    if object["username"] != nil {
                        self.contactName = object["username"] as? String
                        print(self.contactName!)
                    }}}})
        if let myString = self.contactName
        {
            let data = myString.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "InputMessage")
            let ciImage = filter?.outputImage
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let transformImage = ciImage?.transformed(by: transform)
            let image = UIImage(ciImage: transformImage!)
            QRImage.image = image
        }
    }
}
