//
//  UniversityTableViewCell.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 4.04.2024.
//

import UIKit

protocol CitiesTableViewCellDelegate: AnyObject {
    func didTapWebsiteButton(withURL urlString: String,webTitle:String)
    func didTapNumberButton(withNumber number:String)
}
class CitiesTableViewCell: UITableViewCell {
    weak var delegate: CitiesTableViewCellDelegate?
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var universityTableView: UITableView!
    private var university:UniversityData?
    private var url:String?
    private var webTitle:String?
    private var universityCount: Int = 0
    private var selectedRowIndex: Int?
    var isExpanded: Bool = false {
          didSet {
              plusImageView.image = isExpanded ? UIImage(systemName: "minus") : UIImage(systemName: "plus")
          }
      }
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareTable()
    }
    private func prepareTable(){
        universityTableView.delegate = self
        universityTableView.dataSource = self
        universityTableView.register(UINib(nibName: "UniversityTableViewCell", bundle: nil), forCellReuseIdentifier: "UniversityTableViewCell")
    }
    
    //Şehrimizin üniversiteye sahip olup olmamasına göre + butonunun görünümünü kontrol eden fonksiyonumuz
    
    private func hasUniversity(){
        if university?.universities.count == 0 {
                plusImageView.isHidden = true
            } else {
                plusImageView.isHidden = false
            }    }
    
    
    func configure(university:UniversityData) {
        self.university=university
        self.universityCount = university.universities.count
        cityLabel.text = university.province
        hasUniversity()
        universityTableView.reloadData()
    }
}
extension CitiesTableViewCell: UITableViewDataSource, UITableViewDelegate,UniversityTableViewCellDelegate {
    func didTapNumberButton(withNumber number: String) {
        delegate?.didTapNumberButton(withNumber: number)
    }
    func didTapWebsiteButton(withURL urlString: String, universityName: String) {
        url = urlString
        webTitle = universityName
        if let url = url, let webTitle = webTitle {
            delegate?.didTapWebsiteButton(withURL: url, webTitle: webTitle)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universityCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityTableViewCell", for: indexPath) as? UniversityTableViewCell else {
            return UITableViewCell()
        }
            cell.configure(university: university!.universities[indexPath.row])
            cell.delegate=self
            let isExpanded = indexPath.row == selectedRowIndex
            cell.isExpanded = isExpanded
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedRowIndex = selectedRowIndex, indexPath.row == selectedRowIndex {
            return CGFloat(240)
        } else {
            return CGFloat(40)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedUniversity = university?.universities[indexPath.row],
           selectedUniversity.adress == "-" && selectedUniversity.email == "-" && selectedUniversity.fax == "-" && selectedUniversity.phone == "-"  && selectedUniversity.rector == "-" && selectedUniversity.website == "-" {
               return
           }
            if selectedRowIndex == indexPath.row {
                selectedRowIndex = nil
            } else {
                selectedRowIndex = indexPath.row
            }
        tableView.reloadData()

     
        
        

    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UniversityTableViewCell {
            cell.isExpanded = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}



