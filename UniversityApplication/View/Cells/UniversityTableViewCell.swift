import UIKit

protocol UniversityTableViewCellDelegate: AnyObject {
    func didTapWebsiteButton(withURL urlString: String,universityName:String)
    func didTapNumberButton(withNumber number:String)
}
class UniversityTableViewCell: UITableViewCell {
    weak var delegate: UniversityTableViewCellDelegate?
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var faxLabel: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var universitiesLabel: UILabel!
    @IBOutlet weak var infosTableView: UITableView!
    @IBOutlet weak var addFavoriteImageView: UIImageView!
    @IBOutlet weak var rectorLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    private var universityInfos:University?
    private var selectedRowIndex: Int?
    var isExpanded: Bool = false {
          didSet {
              plusImageView.image = isExpanded ? UIImage(systemName: "minus") : UIImage(systemName: "plus")
          }
      }
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareGestures()
    }
    func configure(university: University) {
        universitiesLabel.text = university.name
        setKeyValueText(key: "Rektör ", value: university.rector ,label: rectorLabel)
        setKeyValueText(key: "Adres ", value: university.adress ,label: addressLabel)
        setKeyValueText(key: "Fax ", value: university.fax ,label: faxLabel)
        setKeyValueText(key: "Telefon ", value: university.phone ,label: numberLabel)
        setKeyValueText(key: "Website ", value: university.website,label: websiteLabel)
        self.universityInfos=university
        isFavorite()
        hasInfo()
    }
    @objc private func didTapNumber(){
        if let number = universityInfos?.phone{
            delegate?.didTapNumberButton(withNumber: number.formatPhoneForCall)
        }
    }
    @objc private func didTapWebsite(){
        if let university = universityInfos {
            delegate?.didTapWebsiteButton(withURL: university.website,universityName: university.name)
        }
    }
    private func prepareGestures(){
        let favGesture = UITapGestureRecognizer(target: self, action: #selector(addFavoriteTapped))
        let websiteGesture = UITapGestureRecognizer(target: self, action: #selector(didTapWebsite))
        let phoneGesture = UITapGestureRecognizer(target: self, action: #selector(didTapNumber))
        addFavoriteImageView.image=UIImage(systemName: "heart.fill")
        addFavoriteImageView.isUserInteractionEnabled = true
        numberLabel.isUserInteractionEnabled=true
        websiteLabel.isUserInteractionEnabled=true
        numberLabel.addGestureRecognizer(phoneGesture)
        websiteLabel.addGestureRecognizer(websiteGesture)
        addFavoriteImageView.addGestureRecognizer(favGesture)
    }
   
    @objc func addFavoriteTapped() {
        if let image = addFavoriteImageView.image,
            image == UIImage(systemName: "heart.fill") {
            addFavoriteImageView.image = UIImage(systemName: "heart")
                if let universityName = universityInfos?.name {
                    CoreDataManager.shared.deleteExample(byName:universityName )
                }
            
        } else {
            if let university = universityInfos {
                CoreDataManager.shared.createExample(model: university)
            }
            addFavoriteImageView.image = UIImage(systemName: "heart.fill")
        }
    }
    
    // Üniversitemizin belirtilen koşullara uygun datasının olup olmamasına göre + butonunun gizliliğini kontrol ediyor
    
    private func hasInfo(){
        if  universityInfos?.adress == "-" && universityInfos?.email == "-" && universityInfos?.fax == "-" && universityInfos?.phone == "-"  && universityInfos?.rector == "-" && universityInfos?.website == "-"{
                plusImageView.isHidden = true
            } else {
                plusImageView.isHidden = false
            }    }
    
    
    // Üniversitemizin favoriler listemizde olup olmadığını kontrol edip iconunu ayarlar
    
    func isFavorite() {
        if let name = universityInfos?.name {
            if CoreDataManager.shared.fetchExample(withName: name) != nil {
                addFavoriteImageView.image = UIImage(systemName: "heart.fill")
            } else {
                addFavoriteImageView.image = UIImage(systemName: "heart")
            }
        } else {
           print("University name is nil")
        }
    }
    
    // Labellarımıza key-value şeklinde textini atama işlemini yapan fonksiyonumuz
    
    private func setKeyValueText(key: String, value: String,label:UILabel) {
          let attributedString = NSMutableAttributedString(string: "\(key): \(value)")
          attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: key.count + 1))
          attributedString.addAttribute(.foregroundColor, value: UIColor.link, range: NSRange(location: key.count + 2, length: value.count))
        label.attributedText = attributedString
      }
}
