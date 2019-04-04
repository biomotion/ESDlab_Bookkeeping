//
//  ViewController.swift
//  Bookkeeping
//
//  Created by 李聖誠 on 2019/3/19.
//  Copyright © 2019 nctuesd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic Cell", for: indexPath)
        
        cell.textLabel?.text = "\(dataArray[indexPath.row])"
       
        return cell
    }
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var newCostField: UITextField!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray:[Double] = [123, 456, 789]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateTotal()
    }
    @IBAction func addData(_ sender: Any) {
        guard let newCostString = newCostField.text, !newCostString.isEmpty else{return}
        guard let newCost = Double(newCostString) else {return}
        
        dataArray.append(newCost)
        
        tableView.reloadData()
        updateTotal()
        newCostField.text = ""
        newCostField.resignFirstResponder()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        switch editingStyle{
        case .delete:
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        default:
            break
        }
        updateTotal()
    }
    
    func updateTotal(){
        var total:Double = 0
        
        for elements in dataArray {
            total += elements
        }
        
        totalCostLabel.text = String(total)
 
    }
    
   
    
}

