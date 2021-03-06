//
//  BrowseCell.swift
//  talk
//
//  Created by ひかりちゃん on 2018/02/28.
//

import UIKit

let cellIdentifiler = "BrowseCell"

protocol BrowseCellDelegate: class {
    func browseCell(_ cell: BrowseCell, didTouchLikeAt model: UserInfoEntity!)
    func browseCell(_ cell: BrowseCell, didTouchDislikeAt model: UserInfoEntity!)
}

class BrowseCell: UICollectionViewCell {

    weak var delegate: BrowseCellDelegate?
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    static var spacing: CGFloat = 10
    static var edgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }

    static var itemSmallHeight: CGFloat {
        let width = (UIScreen.main.bounds.width - spacing*3)/2
        return width
    }
    
    static var itemLargeHeight: CGFloat {
        return itemSmallHeight + 100
    }
        
    
    var imageUrl: String? {
        didSet {
            profileImageView.sd_setImage(with: URL(string: imageUrl ?? ""), placeholderImage: R.image.placeholderImage())
        }
    }
    
    @IBAction func tappedHeart(_ sender: UIButton) {
        if delegate != nil {
            //delegate?.browseCell(self, didTouchLikeAt: model)
        }
    }
    
    @IBAction func tappedClose(_ sender: UIButton) {
        if delegate != nil {
            //delegate?.browseCell(self, didTouchDislikeAt: model)
        }
    }
    
}
