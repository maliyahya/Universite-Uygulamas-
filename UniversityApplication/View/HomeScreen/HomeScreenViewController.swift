//
//  HomeScreenViewController.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 4.04.2024.
//

import UIKit


class HomeScreenViewController: UIViewController {
     var viewModel=HomeScreenViewModel()
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden=true
        prepareTable()
        prepareFavoritesButton()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NSNotification.Name("UpdateTable"), object: nil)
    }
    @objc func updateTable() {
         tableView.reloadData()
     }
    @IBAction func didTapExpand(_ sender: Any) {
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            if let cell = tableView.cellForRow(at: indexPath) as? CitiesTableViewCell {
                cell.isExpanded = false
                viewModel.selectedRowIndex=nil
            }
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    private func prepareTable(){
        tableView.delegate=self
        tableView.dataSource=self
        tableView.register(UINib(nibName: "CitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "CitiesTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    private func prepareFavoritesButton(){
        favoritesButton.target = self
                favoritesButton.action = #selector(favoritesButtonTapped)
    }
    
    @objc func favoritesButtonTapped() {
        if let vc = UIStoryboard(name: "FavoritesScreenViewController", bundle: nil).instantiateViewController(withIdentifier: "FavoritesScreenViewController") as? FavoritesScreenViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
    }
    private func showActivityIndicator() {
        activityIndicator.isHidden=false
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.activityIndicator.isHidden=true
            self.reloadTableView()
        }
    }
    private func reloadTableView() {
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        if offsetY > contentHeight - screenHeight && !viewModel.isFetchingData && viewModel.pageNumber < 3 {
            viewModel.isFetchingData = true
            showActivityIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.viewModel.pageNumber += 1
                NetworkManager.shared.getUniversityList(pageNumber: self.viewModel.pageNumber) { result in
                    self.viewModel.isFetchingData = false
                    switch result {
                    case .success(let success):
                        self.viewModel.universities?.append(contentsOf: success.data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(_):
                        DispatchQueue.main.async {
                            self.showError(message: "Verileri çekerken bir hatayla karşılaşıldı")
                        }
                    }
                }
            }
        }
    }
}
extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.universities?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesTableViewCell", for: indexPath) as? CitiesTableViewCell else {
            return UITableViewCell()
        }
        if let universityData = viewModel.universities?[indexPath.row] {
            cell.configure(university: universityData)
            cell.delegate=self
            let isExpanded = indexPath.row == viewModel.selectedRowIndex
            cell.isExpanded = isExpanded
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedRowIndex = viewModel.selectedRowIndex, indexPath.row == selectedRowIndex {
            return CGFloat((viewModel.universities?[selectedRowIndex].universities.count ?? 0) * 40+252)
          } else {
              return UITableView.automaticDimension
          }    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let universitiesCount = viewModel.universities?[indexPath.row].universities.count, universitiesCount == 0 {
            return
        }

        if viewModel.selectedRowIndex == indexPath.row {
            viewModel.selectedRowIndex = nil
        } else {
            viewModel.selectedRowIndex = indexPath.row
        }
        tableView.reloadData()
    }
}
extension HomeScreenViewController: CitiesTableViewCellDelegate {
    func didTapNumberButton(withNumber number: String) {
        if let phoneURL = URL(string: "tel://\(number)") {
                   UIApplication.shared.open(phoneURL, options: [:]) { success in
                       if success {
                           print("Phone call initiated successfully")
                       } else {
                           self.showError(message: "Arama gerçekleştirilemedi")
                       }
                   }
               } else {
                   print("Invalid phone number or URL")
               }  }
    
    func didTapWebsiteButton(withURL urlString: String, webTitle: String) {
        if let vc = UIStoryboard(name: "WebViewViewController", bundle: nil).instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController {
            vc.webSiteUrl=urlString
            vc.webTitle=webTitle
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
  
}



