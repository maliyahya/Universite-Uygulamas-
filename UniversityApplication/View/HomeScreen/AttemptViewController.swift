//
//  HomeScreenViewController.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 4.04.2024.
//

import UIKit

import UIKit

class AttemptViewController: UIViewController {
    var vc=HomeScreenViewModel()
    var selectedRowIndex: Int?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTable()
       
        
    }
    private func prepareTable(){
        tableView.delegate=self
        tableView.dataSource=self
        tableView.rowHeight = UITableView.automaticDimension
        
    }
}



extension AttemptViewController: UITableViewDelegate, UITableViewDataSource {
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vc.universities?.data.count ?? 0
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesTableViewCell", for: indexPath) as? CitiesTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(cityName: vc.universities?.data[indexPath.row].province ?? "", universityCount: vc.universities?.data[indexPath.row].universities.count ?? 0)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedRowIndex = selectedRowIndex, indexPath.row == selectedRowIndex {

            return CGFloat((vc.universities?.data[selectedRowIndex].universities.count ?? 0) * 40+50)
          } else {
              return UITableView.automaticDimension
          }    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowIndex = indexPath.row
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
