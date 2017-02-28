//
//  ViewController.swift
//  GregsonRaevan_CE10
//
//  Created by Raevan Gregson on 12/17/16.
//  Copyright © 2016 Raevan Gregson. All rights reserved.
//

import UIKit

private let identifier = "Cell"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    //outlets for ui
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    //custom object and array to hold the objects
    var legistlators = [Legistlator]()
    var legistlator:Legistlator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        activity.startAnimating()
        
        //assign the table view delegate to self so the functions are called correctly
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //set up the session
        let config = URLSessionConfiguration.default
        
        //create the session
        let session = URLSession(configuration: config)
        
        //setup a variable to hold the url if its not nil
        if let url = URL(string:"https://congress.api.sunlightfoundation.com/legislators?apikey=[1f4393dfee044bb18bb580ef0beb9437]&per_page=all"){
            
            //create the task for the session to do
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                if error != nil{
                    //error check
                    print("Data Task failed with error:\(error)")
                    return
                }
                //console will print success if all is well then another check which within I call the function to parse my JSON data
                print ("Success")
                if let http = response as? HTTPURLResponse{
                    if http.statusCode == 200{
                        self.parseJSON(data: data!)
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
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
    
    //setup my cells, looping through the array of my custom objects and assigning each property to the UIlabel it belongs to, doing a test statment to distinguish the color of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
        let value = legistlators[indexPath.row]
        cell.nameLabel.text = value.fullName
        cell.bioGuideLabel.text = value.bioGuide
        cell.partyLabel.text = value.party
        cell.stateLabel.text = value.state
        if value.party == "R"{
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.25)
        }
        else{
            cell.backgroundColor = UIColor.blue.withAlphaComponent(0.25)
        }
        
        
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Legistlators"
    }
    //count the objects in side of the array holding them
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legistlators.count
    }
    
    //this is the function that I call in the viewdidload during the task, to be performed in the background
    private func parseJSON(data:Data){
        var firstName:String?
        var middleName:String?
        var lastName:String?
        var bioGuide:String?
        var state: String?
        var party:String?
        var title:String?
        
        let defaultValue = " "
        
        //do try check for my json deserialization to get the data object
        do{
            let json = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
            //parse the data object into an array of dictionaries in order to reach the dictionaries that hold the key values of info
            if let rootDictionary = json as? [NSObject:AnyObject],
                let rootData = rootDictionary["results" as NSObject] as? [[NSObject:AnyObject]]{
                for value in rootData{
                    
                    //if the value of any of the keys are nil I assign a default value " "
                    for(key,value) in value{
                        if key as! String == "first_name" {
                            firstName = value as? String ?? defaultValue
                        }
                        else if key as! String == "middle_name"{
                            middleName = value as? String ?? defaultValue
                        }
                        else if key as! String == "last_name"{
                            lastName = value as? String ?? defaultValue
                        }
                        else if key as! String == "bioguide_id"{
                            bioGuide = value as? String ?? defaultValue
                        }
                        else if key as! String == "state"{
                            state = value as? String ?? defaultValue
                        }
                        else if key as! String == "party"{
                            party = value as? String ?? defaultValue
                        }
                        else if key as! String == "title"{
                            title = value as? String ?? defaultValue
                        }
                    }
                    //I create my custom object and append it to my array
                    if firstName != nil && middleName != nil && lastName != nil && bioGuide != nil && state != nil && title != nil && party != nil{
                        let fullName = firstName!+" "+middleName!+" "+lastName!+" "
                        let legislator = Legistlator(fullName:fullName,bioGuide:bioGuide!,party:party!,title:title!,state:state!)
                        legistlators.append(legislator)
                    }
                }
            }
            
        }catch{
            print(error)
        }
    }
    
    //when a row is selected assign my custom object holder variable to the selected index so when the performsegue is called I can use the holder to pass the information
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        legistlator = Legistlator(fullName:legistlators[indexPath.row].fullName!,bioGuide:legistlators[indexPath.row].bioGuide!,party:legistlators[indexPath.row].party!,title:legistlators[indexPath.row].title!,state:legistlators[indexPath.row].state!)
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    //the segue where I pass the variable data
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        let destinationNavigationController = segue.destination as! DetailViewController
        destinationNavigationController.legistlator = legistlator
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

