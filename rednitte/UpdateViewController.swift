//
//  UpdateViewController.swift
//  rednitte
//
//  Created by 板垣智也 on 2019/04/09.
//  Copyright © 2019 板垣智也. All rights reserved.
//

import UIKit
import Parse

class UpdateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userGenderSwitch: UISwitch!
    @IBOutlet weak var interestedGenderSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        
        // init each item
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            userGenderSwitch.setOn(isFemale, animated: true)
        }
        
        if let interestedInWoman = PFUser.current()?["isInterested"] as? Bool {
            interestedGenderSwitch.setOn(interestedInWoman, animated: true)
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFileObject {
            photo.getDataInBackground { (data, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.profileImageView.image = image
                    }
                }
            }
        }
        
        createWomen()
        
    }
    
    func createWomen() {
        let imageUrls = [
            "http://www.essentialwebcomics.com/showcase/component/joomgallery/image?format=raw&type=img&id=742",
            "https://vignette.wikia.nocookie.net/simpsons/images/b/b6/Jenny_%28Official_Image%29.PNG/revision/latest?cb=20130116031220",
            "https://i.pinimg.com/originals/24/83/1e/24831ee66f32ef85d625d92913f5cc43.gif",
            "https://data.whicdn.com/images/272475851/large.jpg",
            "https://vignette.wikia.nocookie.net/20thcenturyfox/images/5/56/Annabel.png/revision/latest?cb=20170219153358"
        ]
        
        var counter = 5
        for imageUrl in imageUrls {
            counter += 1
            if let url = URL(string: imageUrl) {
                if let data = try? Data(contentsOf: url) {
                    let imageFile = PFFileObject(name: "photo.png", data: data)
                    
                    let user = PFUser()
                    user["photo"] = imageFile
                    user.username = String(counter)
                    user.password = "test123"
                    user["isFemale"] = true
                    user["isInterested"] = false
                    
                    user.signUpInBackground { (success, error) in
                        if success {
                            print("Women user created")
                        }
                    }
                }
            }
            
        }
    }
    
    @IBAction func updateImageTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterested"] = interestedGenderSwitch.isOn
        
        if let image = profileImageView.image {
            let imageData = image.pngData()
            PFUser.current()?["photo"] = PFFileObject(name: "profile.png", data: imageData!)
            PFUser.current()?.saveInBackground(block: {(success, error) in
                if error != nil {
                    var errorMessage = "Update Failed - Try Again"
                    
                    if let newError = error as NSError? {
                        if let detailError = newError.userInfo["error"] as? String {
                            errorMessage = detailError
                        }
                    }
                    
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                } else {
                    print("Sign Up Successful")
                }
            })
        }
        
        
    }
    
}
