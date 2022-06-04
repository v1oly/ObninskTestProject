import Foundation
import UIKit

class NewsCategoriesView: UIView {
    
    var viewWidth: CGFloat
    var viewHeight: CGFloat
    
    let onAllNewsClicked: () -> ()
    let onBreakingNewsClicked: () -> ()
    
    var isAllNewsButtonClicked = true
    var isBreakingNewButtonClicked = false
    
    let allNewsButton = UIButton()
    let breakingNewsButton = UIButton()
    let rubricsButton = UIButton()
    
    init(
        viewWidth: CGFloat,
        viewHeight: CGFloat,
        onAllNewsClicked: @escaping () -> (),
        onBreakingNewsClicked: @escaping () -> ()
    ) {
        self.viewWidth = viewWidth
        self.viewHeight = viewHeight
        self.onAllNewsClicked = onAllNewsClicked
        self.onBreakingNewsClicked = onBreakingNewsClicked
        super.init(frame: CGRect(x: 0, y: 0, width: viewWidth , height: viewHeight))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Required coder not founded!")
    }
    
    func setup() {
        allNewsButton.addTarget(self, action: #selector(sortToAllNews(_:)), for: .touchUpInside)
        allNewsButton.setTitle("Все новости", for: .normal)
        allNewsButton.backgroundColor = #colorLiteral(red: 0.3091165721, green: 0.3757572174, blue: 0.8683847785, alpha: 1)
        allNewsButton.layer.cornerRadius = 20
        self.addSubview(allNewsButton)
        
        breakingNewsButton.addTarget(self, action: #selector(sortToBreakingNews(_:)), for: .touchUpInside)

        breakingNewsButton.setTitle("Важное", for: .normal)
        breakingNewsButton.setTitleColor(#colorLiteral(red: 0.778773129, green: 0.1845878363, blue: 0.2396543324, alpha: 1), for: .normal)
        breakingNewsButton.backgroundColor = #colorLiteral(red: 1, green: 0.4343354106, blue: 0.5530262589, alpha: 1)

        breakingNewsButton.layer.cornerRadius = 20
        self.addSubview(breakingNewsButton)
        
        rubricsButton.addTarget(self, action: #selector(goToNewRubrics(_:)), for: .touchUpInside)
        rubricsButton.setTitleColor(.blue, for: .normal)
        rubricsButton.setTitle("Рубрики >", for: .normal)
        self.addSubview(rubricsButton)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        allNewsButton.frame.size = CGSize(width: viewWidth/3.5, height: viewHeight/2.5)
        allNewsButton.center = CGPoint(x: allNewsButton.frame.width/2 + 15 , y: viewHeight/2)
        allNewsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        breakingNewsButton.frame.size = CGSize(width: allNewsButton.frame.width - allNewsButton.frame.width/3.3, height: viewHeight/2.5)
        breakingNewsButton.center = CGPoint(x: (allNewsButton.frame.width + 15) + breakingNewsButton.frame.width/2 + 15, y: viewHeight/2)
        breakingNewsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        rubricsButton.frame.size = CGSize(width: breakingNewsButton.frame.width+20, height: viewHeight/2.5)
        rubricsButton.center = CGPoint(x: (viewWidth - rubricsButton.frame.width/2) - 10, y: viewHeight/2)
        rubricsButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @objc
    func sortToAllNews(_ sender: UIButton) {
        if isAllNewsButtonClicked == false {
            allNewsButton.backgroundColor = #colorLiteral(red: 0.3091165721, green: 0.3757572174, blue: 0.8683847785, alpha: 1)
            allNewsButton.setTitleColor(.white, for: .normal)
            isAllNewsButtonClicked = true
            isBreakingNewButtonClicked = false
            breakingNewsButton.backgroundColor = #colorLiteral(red: 1, green: 0.4343354106, blue: 0.5530262589, alpha: 1)
            breakingNewsButton.setTitleColor(.white, for: .normal)
            onAllNewsClicked()
        }
    }
    @objc
    func sortToBreakingNews(_ sender: UIButton) {
        if isBreakingNewButtonClicked == false {
            breakingNewsButton.backgroundColor = #colorLiteral(red: 0.3091165721, green: 0.3757572174, blue: 0.8683847785, alpha: 1)
            breakingNewsButton.setTitleColor(.white, for: .normal)
            isAllNewsButtonClicked = false
            isBreakingNewButtonClicked = true
            allNewsButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            allNewsButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
            onBreakingNewsClicked()
        }
        print("all news clicked - \(isAllNewsButtonClicked)")
        print("breaking news clicked - \(isBreakingNewButtonClicked)")
   
    }
    @objc
    func goToNewRubrics(_ sender: UIButton) {
        print("Rubricks clicked")
    }
}
