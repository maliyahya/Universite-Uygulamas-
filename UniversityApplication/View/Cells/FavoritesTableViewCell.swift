//
//  FavoritesTableViewCell.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 9.04.2024.
//

import UIKit

protocol FavoritesTableViewCellDelegate: AnyObject {
    func favoriteStatusDidChange(forUniversityWithName name: String)
    func didTapWebsite(forUniversityWithWebsite url:String,webTitle:String)
    func didTapNumber(UniversityPhoneNumber number:String)
}


class FavoritesTableViewCell: UITableViewCell {
    weak var delegate: FavoritesTableViewCellDelegate?
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var universityName: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var rectorLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var faxLabel: UILabel!
    private var universityInfos:UniversityModel?
    var isExpanded: Bool = false {
          didSet {
              plusImageView.image = isExpanded ? UIImage(systemName: "minus") : UIImage(systemName: "plus")
              
          }
      }
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareGestures()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(model:UniversityModel){
        universityName.text=model.name
        setKeyValueText(key: "Rector ", value: model.rector ?? "",label: rectorLabel)
        setKeyValueText(key: "Adress ", value: model.adress ?? "",label: adressLabel)
        setKeyValueText(key: "Fax ", value: model.fax ?? "",label: faxLabel)
        setKeyValueText(key: "Number ", value: model.phone ?? "",label: numberLabel)
        setKeyValueText(key: "Website ", value: model.website ?? "",label: websiteLabel)
        universityInfos=model
        hasInfo()

    }
    
    // Üniversitemizin belirtilen koşullara uygun datasının olup olmamasına göre + butonunun gizliliğini kontrol ediyor
    private func hasInfo(){
        if  universityInfos?.adress == "-" && universityInfos?.email == "-" && universityInfos?.fax == "-" && universityInfos?.phone == "-"  && universityInfos?.rector == "-" && universityInfos?.website == "-"{
                plusImageView.isHidden = true
            } else {
                plusImageView.isHidden = false
            }    }
   
    private func prepareGestures(){
        let favGesture = UITapGestureRecognizer(target: self, action: #selector(addFavoriteTapped))
        let websiteGesture = UITapGestureRecognizer(target: self, action: #selector(didTapWebsite))
        let phoneGesture = UITapGestureRecognizer(target: self, action: #selector(didTapNumber))
        favoriteImageView.image=UIImage(systemName: "heart.fill")
        favoriteImageView.isUserInteractionEnabled = true
        numberLabel.isUserInteractionEnabled=true
        websiteLabel.isUserInteractionEnabled=true
        numberLabel.addGestureRecognizer(phoneGesture)
        websiteLabel.addGestureRecognizer(websiteGesture)
        favoriteImageView.addGestureRecognizer(favGesture)
    }
    @objc func addFavoriteTapped() {
            if let universityName = universityInfos?.name {
                    CoreDataManager.shared.deleteExample(byName:universityName )
                    delegate?.favoriteStatusDidChange(forUniversityWithName: universityName)
                }
    }
    @objc func didTapWebsite(){
        if let website = universityInfos?.website, let name = universityInfos?.name {
            delegate?.didTapWebsite(forUniversityWithWebsite: website,webTitle: name)
        }
    }
    @objc func didTapNumber(){
        if let number = universityInfos?.phone{
            delegate?.didTapNumber(UniversityPhoneNumber: number.formatPhoneForCall) }
    }
    
    // Labellarımıza key-value şeklinde textini atama işlemini yapan fonksiyonumuz

    func setKeyValueText(key: String, value: String,label:UILabel) {
          let attributedString = NSMutableAttributedString(string: "\(key): \(value)")
          attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: key.count + 1))
          attributedString.addAttribute(.foregroundColor, value: UIColor.link, range: NSRange(location: key.count + 2, length: value.count))
        label.attributedText = attributedString
      }
}
