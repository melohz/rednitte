//
//  MatchesViewController.swift
//  rednitte
//
//  Created by 板垣智也 on 2019/04/09.
//  Copyright © 2019 板垣智也. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var images : [UIImage] = []
    var userIds : [String] = []
    var messages : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            if let acceptedPeeps = PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectId", containedIn: acceptedPeeps)
                
                query.findObjectsInBackground { (objects, error) in
                    if let users = objects {
                        for user in users {
                            if let theUser = user as? PFUser {
                                if let imageFile = theUser["photo"] as? PFFileObject {
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if let imageData = data {
                                            if let image = UIImage(data: imageData) {
                                                
                                                if let objectId = theUser.objectId {
                                                    let messageQuery = PFQuery(className: "Message")
                                                    
                                                    messageQuery.whereKey("recipient", equalTo: PFUser.current()?.objectId as Any)
                                                    messageQuery.whereKey("sender", equalTo: theUser.objectId as Any)
                                                    
                                                    messageQuery.findObjectsInBackground(block: { (objects, error) in
                                                        var messageText = "No Message from this user."
                                                        
                                                        if let objects = objects {
                                                            for message in objects {
                                                                
                                                                if let content = message["content"] as? String {
                                                                    messageText = content
                                                                }
                                                            }
                                                        }
                                                        self.messages.append(messageText)
                                                        self.userIds.append(objectId)
                                                        self.images.append(image)
                                                        
                                                        self.tableView.reloadData()
                                                    })
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mtachCell", for: indexPath) as? MatchTableViewCell {
            cell.messageLabel.text = "You haven't received a message yet"
            cell.profileImageView.image = images[indexPath.row]
            cell.recipientObjectId = userIds[indexPath.row]
            cell.messageLabel.text = messages[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
}
