//
//  MeasurementsViewController.swift
//  FinalProject
//
//  Created by William Nesham on 7/18/18.
//  Copyright © 2018 UMSL. All rights reserved.
//

import UIKit

class MeasurementsViewController: UITableViewController {
    
    @IBOutlet weak var costumeTableView: UITableView!
    
    let model = CostumeModel()
    
    weak var delegate: DataViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        model.delegate = self
        
///////////////////////////////////////
        //Debug reset data.
//        let costumes: [CostumeMeasurements] = []
//        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: costumes)
//        UserDefaults.standard.set(encodedData, forKey: "Costumes")
//        UserDefaults.standard.synchronize()

        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "costumeCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let titles = model.getTitles() {
            return titles.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "costumeCell")

        if let titles = model.getTitles() {
            //Set cell
            cell.textLabel?.text = titles[indexPath.row]
            cell.detailTextLabel?.text = model.getSubtitles()[indexPath.row]
            cell.accessoryType = .disclosureIndicator
//            cell.backgroundColor = UIColor.clear
        } else {
            //There is no cell. Never gets called
            cell.textLabel?.text = "Table Cell"
            cell.detailTextLabel?.text = "Empty Table Cell."
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.red
        }
        
        return cell
    }
    
    //If user taps a row, go to DataView to edit the cell data.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        editCostume(selectedRow: indexPath.row)
    }
    
}


extension MeasurementsViewController: CostumesModelDelegate {
    func dataUpdated() {
        tableView.reloadData()
    }
}

extension MeasurementsViewController: DataViewDelegate {
    func createNewCostume() {}
    func removeCostume() {}
    
    func editCostume(selectedRow: Int) {
        model.selectedRow = selectedRow
        self.performSegue(withIdentifier: "EditCostume", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "EditCostume" {
            let dataView = segue.destination as! DataViewController
            dataView.costume = model.getDecodedCostumes()[model.selectedRow]
        }
        
    }
}



