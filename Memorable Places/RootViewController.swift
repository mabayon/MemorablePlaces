//
//  RootViewController.swift
//  Memorable Places
//
//  Created by Mahieu Bayon on 18/06/2018.
//  Copyright © 2018 M4m0ut. All rights reserved.
//

import UIKit

var activePlace = -1

class RootViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    var places = [Dictionary<String, String>()]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = places[indexPath.row]["name"]
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let placesObject = UserDefaults.standard.object(forKey: "places")
        
        if let tempPlaces = placesObject as? [Dictionary<String, String>] {
            
            places = tempPlaces
        }
        activePlace = -1
        table.reloadData() 
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            places.remove(at: indexPath.row)
            
            table.reloadData()
            
            UserDefaults.standard.set(places, forKey: "places")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activePlace = indexPath.row
        
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
