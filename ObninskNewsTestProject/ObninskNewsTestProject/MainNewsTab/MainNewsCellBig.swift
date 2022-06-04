import UIKit

class MainNewsCellBig: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var newsHeaderLabel: UITextView!
    @IBOutlet var textLabel: UITextView!
    @IBOutlet var dateLabel: UITextView!
    var dateFormatter = RelativeDateTimeFormatter()
    
    var cellIdentifier: String?
    

    var title: String?
    var id: String?
    var text: String?
    var date: Int = 0

    var image: UIImage?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        newsHeaderLabel.text = nil
        textLabel.text = nil
        dateLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsHeaderLabel.isEditable = false
        newsHeaderLabel.textContainer.maximumNumberOfLines = 2
        newsHeaderLabel.isScrollEnabled = false
        newsHeaderLabel.font = UIFont(name: "arial", size: 18)
        
        textLabel.isEditable = false
        textLabel.textContainer.maximumNumberOfLines = 3
        textLabel.isScrollEnabled = false
        textLabel.font = UIFont(name: "arial", size: 16)
        
        dateLabel.isEditable = false
        dateLabel.isScrollEnabled = false
        dateLabel.textContainer.maximumNumberOfLines = 1
        dateLabel.font = UIFont(name: "arial", size: 13)
        dateLabel.textColor = UIColor.lightGray
        
     
        dateFormatter.locale = Locale(identifier: "ru_GB")
        dateFormatter.unitsStyle = .full
    }
    
    func configure(newsObject: NewsAPIResponse) {
    
        id = newsObject.id
       
        title = newsObject.title
        text = newsObject.text
        date = newsObject.date
        
        newsHeaderLabel.text = title
        dateLabel.text = convertTimastampToDate(timestomp: date)
        textLabel.text = text
        setNeedsLayout()
    }
    
    func setImage(image: UIImage?, identifier: String) {
        guard cellIdentifier == identifier else { return }
        imageView.image = image
    }
    
    private func convertTimastampToDate(timestomp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestomp))
        let returnDate = dateFormatter.localizedString(for: date, relativeTo: Date.now)
        return returnDate
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MainNewsCellBig", bundle: nil)
    }
    
    override func layoutSubviews() {
        newsHeaderLabel.sizeToFit()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }

}
