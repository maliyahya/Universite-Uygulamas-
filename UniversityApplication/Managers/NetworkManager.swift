//
//  NetworkManager.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 4.04.2024.
//


import Foundation
class NetworkManager{
    static let shared=NetworkManager()
    private init(){}
    
    // Network requestini oluşturma fonksiyonumuz 
    private func createRequest(url:URL?,
                               type:HTTPMethod,
                               completion:@escaping (URLRequest)->Void
    ){
        guard let apiURL=url else {
            return }
        var request=URLRequest(url: apiURL)
        request.timeoutInterval=30
        request.httpMethod=type.rawValue
        completion(request)
    }
    
    func getUniversityList(pageNumber:Int,completion: @escaping (Result<AllUniversitiesModel, Error>) -> Void ) {
        NetworkManager.shared.createRequest(url: URL(string: AppURLs.baseURL + "page-\(pageNumber).json"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, response, error in
                guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                    completion(.failure(error ?? APIError.failedToGetData))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(APIError.invalidResponse))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AllUniversitiesModel.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                    print("JSON decode hatası: \(error)")
                }
            }
            task.resume()
        }
    }


        
    
    
  


    
    
   
}

