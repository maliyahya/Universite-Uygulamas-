//
//  SplashScreenViewController.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 4.04.2024.
//

import UIKit
class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUniversityList()
    }
    func fetchUniversityList() {
        NetworkManager.shared.getUniversityList(pageNumber: 1) { result in
            switch result {
            case .success(let universities):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigateToMainScreen(with: universities)
                    
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError(message: "Üniversite verilerini çekerken hata ile karşılaşıldı")
                }
            }
        }
    }

    func navigateToMainScreen(with universities: AllUniversitiesModel) {
        if let mainViewController = UIStoryboard(name: "HomeScreenViewController", bundle: nil).instantiateViewController(withIdentifier: "HomeScreenViewController") as? HomeScreenViewController {
            
            mainViewController.vc.setUniversities(universities.data)
            
            let navigationController = UINavigationController(rootViewController: mainViewController)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }



    func showError(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
