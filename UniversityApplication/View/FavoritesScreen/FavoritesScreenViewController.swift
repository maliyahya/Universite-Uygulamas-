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
    private var viewModel = FavoriteScreenViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTable()
        getFavorites()
    }
    private func prepareTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoritesTableViewCell")
    }
    
    private func getFavorites(){
        viewModel.favorites=CoreDataManager.shared.fetchExamples()
        if (viewModel.favorites==[]){
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
            if let phoneURL = URL(string: "tel://\(number)") {
                       UIApplication.shared.open(phoneURL, options: [:]) { success in
                           if success {
                               print("Phone call initiated successfully")
                           } else {
                               self.showAlert(message: "Arama gerçekleştirilemedi")
                           }
                       }
                   } else {
                       print("Invalid phone number or URL")
                   }  }
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
        return viewModel.favorites?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        if let universityData = viewModel.favorites?[indexPath.row] {
            cell.configure(model: universityData)
            cell.delegate=self
            let isExpanded = indexPath.row == viewModel.selectedRowIndex
            cell.isExpanded = isExpanded
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedRowIndex = viewModel.selectedRowIndex, indexPath.row == selectedRowIndex {
            return CGFloat(240)
        } else {
            return CGFloat(40)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Data yoksa seçilememesini sağlayan kod bloğu
        if let selectedUniversity = viewModel.favorites?[indexPath.row],
           selectedUniversity.adress == "-" && selectedUniversity.email == "-" && selectedUniversity.fax == "-" && selectedUniversity.phone == "-"  && selectedUniversity.rector == "-" && selectedUniversity.website == "-" {
               return
           }
        
        if viewModel.selectedRowIndex == indexPath.row {
            viewModel.selectedRowIndex = nil
            if let cell = tableView.cellForRow(at: indexPath) as? FavoritesTableViewCell {
                cell.isExpanded = false
            }
        } else {
            viewModel.selectedRowIndex = indexPath.row
            if let cell = tableView.cellForRow(at: indexPath) as? FavoritesTableViewCell {
                cell.isExpanded = true
            }
        }
        tableView.reloadData()
        
        //Seçilen celle  göre ekranın kaydırılmasını sağlayan fonksiyonumuz
        if let selectedCell = tableView.cellForRow(at: indexPath) {
                let yOffset = selectedCell.frame.origin.y - 200
                if yOffset > 0 {
                    tableView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
                } else {
                    tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: true)
                }
            }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FavoritesTableViewCell {
            cell.isExpanded = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
   

    
    
}

