//
//  ListViewController.swift
//  MapKit-TravelBook
//
//  Created by Murat on 4.11.2021.
//

import UIKit
import CoreData

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var placesNameArray=[String]()
    var placesIdArray = [UUID]()
    var chosenTitle = ""
    var chosenId = UUID()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        tableView.delegate=self
        tableView.dataSource=self
        getCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(getCoreData), name: NSNotification.Name("NewPlace"), object: nil)
    }
    
    @objc func getCoreData(){
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        fetchReq.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchReq)
            
            if results.count > 0 {
                self .placesIdArray.removeAll(keepingCapacity: false)
                self.placesNameArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                    if let name =  result.value(forKey: "title") as? String{
                        self.placesNameArray.append(name)
                    }
                    if let id = result.value(forKey: "id") as? UUID{
                        self.placesIdArray.append(id)
                    }
                    tableView.reloadData()

              
                    
                }
            }
            
        }
        catch{
            print("error")
        }
        
        
    }
    
    @objc func addButtonClicked() {
        chosenTitle = ""
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placesNameArray[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesNameArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTitle = placesNameArray[indexPath.row]
        chosenId = placesIdArray[indexPath.row]
        performSegue(withIdentifier: "toViewController", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toViewController"{
            let destinationVC = segue.destination as! ViewController
            
            destinationVC.selectedTitle=chosenTitle
            destinationVC.selectedId=chosenId
            
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    
}

