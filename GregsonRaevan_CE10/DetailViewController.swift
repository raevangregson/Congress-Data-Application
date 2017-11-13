//
//  DetailViewController.swift
//  GregsonRaevan_CE10
//
//  Created by Raevan Gregson on 12/18/16.
//  Copyright © 2016 Raevan Gregson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    //holder where my info is passed too
    var legistlator:Legistlator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating()
        //setup my ui with the vars properties
        self.title = legistlator?.fullName
        nameLabel.text = legistlator?.fullName
        titleLabel.text = legistlator?.title
        stateLabel.text = legistlator?.state
        partyLabel.text = legistlator?.party
        
        //set up the session
        let config = URLSessionConfiguration.default
        
        //create the session
        let session = URLSession(configuration: config)
        
        if let bio = legistlator?.bioGuide {
            
            if let url = URL(string:"https://theunitedstates.io/images/congress/225x275/\(bio).jpg"){
                
                //create the task for the session to do
                let task = session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                    if error != nil{
                        //error check
                        print("Data Task failed with error:\(String(describing: error))")
                        return
                    }
                    //console will print success if all is well then another check which within I call the function to parse my JSON data
                    print ("SuccessPic")
                    if let http = response as? HTTPURLResponse, let data = data{
                        if http.statusCode == 200{
                            let downloadedImage = UIImage(data: data)
                            DispatchQueue.main.async{
                                self.imageView.image = downloadedImage
                                self.activity.hidesWhenStopped = true
                                self.activity.stopAnimating()
                                
                            }
                        }
                    }
                }
                )
                task.resume()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
