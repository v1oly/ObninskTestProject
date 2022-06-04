//
//  DetailsViewCell.swift
//  ObninskNewsTestProject
//
//  Created by Markus on 04.06.2022.
//

import UIKit

class DetailsViewCell: UICollectionViewCell {
    
    var dateFormatter = RelativeDateTimeFormatter()
    
    @IBOutlet weak var origignalImage: UIImageView!
    
    @IBOutlet weak var dateTime: UILabel!
    
    @IBOutlet weak var newsCategory: UILabel!
    
    @IBOutlet weak var newsTitle: UITextView!
    
    @IBOutlet weak var newsText: UITextView!
    
    @IBOutlet weak var doULikePostLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    

    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var dislikeCountLabel: UILabel!
    
    @IBOutlet weak var authorName: UITextView!
    @IBOutlet weak var authorNameLabel: UITextView!
    
    @IBOutlet weak var howManySeeImageView: UIImageView!
    @IBOutlet weak var countOfViewsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsTitle.isEditable = false
        newsTitle.isScrollEnabled = false
        newsTitle.font = UIFont(name: "arial", size: 18)
        
        newsText.isEditable = false
        newsText.isScrollEnabled = false
        newsText.font = UIFont(name: "arial", size: 16)
        
        authorName.isEditable = false
        authorName.isScrollEnabled = false
        authorName.font = UIFont(name: "arial", size: 16)
        
        
        dateFormatter.locale = Locale(identifier: "ru_GB")
        dateFormatter.unitsStyle = .full
        
        doULikePostLabel.font = UIFont(name: "arial", size: 16)
        doULikePostLabel.text = "Оцените публикацию"
        
        authorName.font = UIFont(name: "arial", size: 16)
        authorName.text = "Автор публикации"
        
        likeButton.imageView?.image = UIImage(named: "like")
        dislikeButton.imageView?.image = UIImage(named: "dislike")
        howManySeeImageView.image = UIImage(named: "countOfView")
        self.backgroundColor = .green
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: "DetailsViewCell", bundle: nil)
    }
    
    func configure(item: DetailsNewsAPIResponse, image: UIImage?) {
        origignalImage.image = image
        dateTime.text = convertTimastampToDate(timestomp: item.date)
        newsCategory.text = item.tag
        newsTitle.text = item.title
        newsText.text = item.text
        likeCountLabel.text = item.plus
        dislikeCountLabel.text = String(item.minus)
        authorName.text = item.author
        countOfViewsLabel.text = String(item.review_count)
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        newsTitle.sizeToFit()
        newsText.sizeToFit()
        dateTime.sizeToFit()
        newsCategory.sizeToFit()
        doULikePostLabel.sizeToFit()
        likeCountLabel.sizeToFit()
        dislikeCountLabel.sizeToFit()
        authorName.sizeToFit()
        authorNameLabel.sizeToFit()
        countOfViewsLabel.sizeToFit()
    }
    
    private func convertTimastampToDate(timestomp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestomp))
        let returnDate = dateFormatter.localizedString(for: date, relativeTo: Date.now)
        return returnDate
    }
}
