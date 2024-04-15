//
//  FavoritesViewController.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 9.04.2024.
//

import UIKit

class FavoritesScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    let vc = FavoriteScreenViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Favorilerim"
        prepareTable()
        getFavorites()
    }
    private func prepareTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoritesTableViewCell")
    }
    
    private func getFavorites(){
        vc.favorites=CoreDataManager.shared.fetchExamples()
        if (vc.favorites==[]){
            infoLabel.isHidden=false
        }
        else{
            infoLabel.isHidden=true
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension FavoritesScreenViewController:UITableViewDelegate,UITableViewDataSource,FavoritesTableViewCellDelegate{
    func didTapNumber(UniversityPhoneNumber number: String) {
        print(number)
    }
    
    func didTapWebsite(forUniversityWithWebsite url: String,webTitle:String) {
            if let vc = UIStoryboard(name: "WebViewViewController", bundle: nil).instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController {
                vc.webSiteUrl=url
                vc.webTitle=webTitle
                navigationController?.pushViewController(vc, animated: true)
            }
    }

  
    
    func favoriteStatusDidChange(forUniversityWithName name: String) {
        getFavorites()
        tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name("UpdateTable"), object: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vc.favorites?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        if let favoriteUniversities = vc.favorites, indexPath.row < favoriteUniversities.count+1 {
            cell.configure(model: favoriteUniversities[indexPath.row])
        }
        cell.delegate=self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedRowIndex = vc.selectedRowIndex, indexPath.row == selectedRowIndex {
            return CGFloat(240)
        } else {
            return CGFloat(40)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedUniversity = vc.favorites?[indexPath.row],
           selectedUniversity.adress == "-" && selectedUniversity.email == "-" && selectedUniversity.fax == "-" && selectedUniversity.phone == "-"  && selectedUniversity.rector == "-" && selectedUniversity.website == "-" {
               return
           }

        if vc.selectedRowIndex == indexPath.row {
            vc.selectedRowIndex = nil
            if let cell = tableView.cellForRow(at: indexPath) as? FavoritesTableViewCell {
                cell.isExpanded = false
            }
        } else {
            vc.selectedRowIndex = indexPath.row
            if let cell = tableView.cellForRow(at: indexPath) as? FavoritesTableViewCell {
                cell.isExpanded = true
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FavoritesTableViewCell {
            cell.isExpanded = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
   

    
    
}

