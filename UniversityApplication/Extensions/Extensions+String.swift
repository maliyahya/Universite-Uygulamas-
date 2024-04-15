//
//  Extensions+String.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 12.04.2024.
//

import Foundation


//Website linklerimizin bazıların https güvenlik protokolü olmadığı webview olarak açamıyorduk.Hepsine extension ile https eklemelerini sağladık.

extension String {
    func withHTTPScheme() -> String {
        if !self.hasPrefix("http://") && !self.hasPrefix("https://") {
            return "https://" + self
        }
        return self
    }
}


// Telefon numaralarını uygun formata çevirme extensionu

extension String{
    
    var formatPhoneForCall:String{
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}

