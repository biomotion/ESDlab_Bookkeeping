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
        
        let name = dataArray[indexPath.row]["name"] as? String ?? "No name"
        let cost = dataArray[indexPath.row]["cost"] as? Double ?? 0.0
        
        //cell.textLabel?.text = "\(dataArray[indexPath.row])"
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = "\(cost)"
        return cell
    }
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var newCostField: UITextField!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //var dataArray:[Double] = [123, 456, 789]
    var dataArray = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadDataArray()
        updateTotal()
    }
    @IBAction func addData(_ sender: Any) {
        guard let newCostString = newCostField.text, !newCostString.isEmpty else{return}
        guard let newCost = Double(newCostString) else {return}
        guard let newName = nameField.text, !newName.isEmpty else { return }
        
        let newDate = Date()
        dataArray.append(["name":newName,"cost":newCost,"date":newDate])
        
        tableView.reloadData()
        updateTotal()
        newCostField.text = ""
        nameField.text = ""
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
            total += elements["cost"] as? Double ?? 0.0
        }
        
        totalCostLabel.text = String(total)
        saveDataArray()
    }
    
    func writeStringToFile(writeString:String, fileName:String){
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{ return}
        let fileURL = dir.appendingPathComponent(fileName)
        
        do{
            try writeString.write(to: fileURL, atomically: false, encoding: .utf8)
        }catch{
            print("write error")
        }
    }
    
    func readFileToString(fileName:String) -> String{
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{ return "" }
        let fileURL = dir.appendingPathComponent(fileName)
        var readString = ""
        
        do{
            try readString = String.init(contentsOf: fileURL, encoding: .utf8)
        }catch{
            print("read error")
        }
        return readString
    }
    
    func saveDataArray(){
        var finalString = ""
        
        for dictionary in dataArray{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            
            finalString += formatter.string(from: dictionary["date"] as? Date ?? Date())
            finalString += ","
            finalString += dictionary["name"] as? String ?? "no name"
            finalString += ","
            finalString += String( dictionary["cost"] as? Double ?? 0.0)
            finalString += "\n"
            
        }
        writeStringToFile(writeString: finalString, fileName: "data.txt")
    }
    
    func loadDataArray(){
        var finalArray = [[String:Any]]()
        let csvString = readFileToString(fileName: "data.txt")
        let lineOfString = csvString.components(separatedBy: "\n")
        if csvString == ""{
            return
        }
        
        for line in lineOfString{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            if(line == ""){ continue }
            let datas = line.components(separatedBy: ",")
            print(datas)
            let newDate = formatter.date(from: datas[0])
            let newCostString = datas[2]
            guard let newCost = Double(newCostString) else {return}
            let newName = datas[1]
            
            
            finalArray.append(["name":newName,"cost":newCost,"date":newDate ?? Date()])
            
        }
        dataArray = finalArray
        tableView.reloadData()
        updateTotal()
    }
}

