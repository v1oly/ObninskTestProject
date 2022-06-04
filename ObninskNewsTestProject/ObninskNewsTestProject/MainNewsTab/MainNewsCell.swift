import UIKit

class MainNewsCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var newsHeaderLabel: UITextView!
    @IBOutlet var dateLabel: UITextView!
    var dateFormatter = RelativeDateTimeFormatter()
    
    var cellIdentifier: String?
    
    var title: String?
    var id: String?
    var date: Int = 0
    var image: UIImage?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        newsHeaderLabel.text = nil
        dateLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsHeaderLabel.isEditable = false
        newsHeaderLabel.textContainer.maximumNumberOfLines = 4
        newsHeaderLabel.isScrollEnabled = false
        newsHeaderLabel.font = UIFont(name: "arial", size: 18)
        
        dateLabel.isEditable = false
        dateLabel.isScrollEnabled = false
        dateLabel.textContainer.maximumNumberOfLines = 1
        dateLabel.font = UIFont(name: "arial", size: 13)
        dateLabel.textColor = UIColor.lightGray
        
     
        dateFormatter.locale = Locale(identifier: "ru_GB")
        dateFormatter.unitsStyle = .full
        
        let formatter = RelativeDateTimeFormatter()
    }
    
    func configure(newsObject: NewsAPIResponse) {
        
        id = newsObject.id
        title = newsObject.title
        date = newsObject.date
        
        newsHeaderLabel.text = title
        dateLabel.text = convertTimastampToDate(timestomp: date)
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
        return UINib(nibName: "MainNewsCell", bundle: nil)
    }
    
    override func layoutSubviews() {
        newsHeaderLabel.sizeToFit()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
}
