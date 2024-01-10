//
//  CS_NFTStarView.swift
//  CrazySnake
//
//  Created by Lee on 08/03/2023.
//

import UIKit

class CS_NFTStarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showStar(_ num: Int, color: UIColor?, image: UIImage?) {
        let icon = image?.withRenderingMode(.alwaysTemplate)
//        star1.isHidden = num < 1
        star1.isHidden = false
        star2.isHidden = num < 2
        star3.isHidden = num < 3
        star4.isHidden = num < 4
        star5.isHidden = num < 5
        star6.isHidden = num < 6
        
        star1.image = icon
        star2.image = icon
        star3.image = icon
        star4.image = icon
        star5.image = icon
        star6.image = icon
        
        star1.tintColor = color
        star2.tintColor = color
        star3.tintColor = color
        star4.tintColor = color
        star5.tintColor = color
        star6.tintColor = color
        
        if num == 0 {
            star1.tintColor = .ls_color("#999999")
        }
    }
    
    func showRightStar(_ num: Int, color: UIColor?, image: UIImage?) {
        let icon = image?.withRenderingMode(.alwaysTemplate)
        star1.isHidden = num < 6
        star2.isHidden = num < 5
        star3.isHidden = num < 4
        star4.isHidden = num < 3
        star5.isHidden = num < 2
        star6.isHidden = false
        
        star1.image = icon
        star2.image = icon
        star3.image = icon
        star4.image = icon
        star5.image = icon
        star6.image = icon
        
        star1.tintColor = color
        star2.tintColor = color
        star3.tintColor = color
        star4.tintColor = color
        star5.tintColor = color
        star6.tintColor = color
        
        if num == 0 {
            star6.tintColor = .ls_color("#999999")
        }
    }
    
    func showMiddleStar(_ num: Int, color: UIColor?, image: UIImage?) {
        let icon = image?.withRenderingMode(.alwaysTemplate)
        star1.isHidden = num < 5
        star2.isHidden = num < 3
        star3.isHidden = false
        star4.isHidden = num < 2
        star5.isHidden = num < 4
        star6.isHidden = num < 6
        
        star1.image = icon
        star2.image = icon
        star3.image = icon
        star4.image = icon
        star5.image = icon
        star6.image = icon
        
        star1.tintColor = color
        star2.tintColor = color
        star3.tintColor = color
        star4.tintColor = color
        star5.tintColor = color
        star6.tintColor = color
        
        if num == 0 {
            star3.tintColor = .ls_color("#999999")
        }
    }
    
    lazy var star1: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        view.image = UIImage.ls_bundle( "nft_icon_upgrade_1@2x")
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .ls_color("#8DFF8E")
        view.isHidden = true
        return view
    }()
    
    lazy var star2: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 16, y: 0, width: 12, height: 12))
        view.image = UIImage.ls_bundle( "nft_icon_upgrade_1@2x")
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .ls_color("#8DFF8E")
        view.isHidden = true
        return view
    }()
    
    lazy var star3: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 32, y: 0, width: 12, height: 12))
        view.image = UIImage.ls_bundle( "nft_icon_upgrade_1@2x")
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .ls_color("#8DFF8E")
        view.isHidden = true
        return view
    }()
    
    lazy var star4: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 48, y: 0, width: 12, height: 12))
        view.image = UIImage.ls_bundle( "nft_icon_upgrade_1@2x")
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .ls_color("#8DFF8E")
        view.isHidden = true
        return view
    }()
    
    lazy var star5: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 64, y: 0, width: 12, height: 12))
        view.image = UIImage.ls_bundle( "nft_icon_upgrade_1@2x")
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .ls_color("#8DFF8E")
        view.isHidden = true
        return view
    }()
    
    lazy var star6: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 80, y: 0, width: 12, height: 12))
        view.image = UIImage.ls_bundle( "nft_icon_upgrade_1@2x")
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .ls_color("#8DFF8E")
        view.isHidden = true
        return view
    }()

}

//MARK: UI
extension CS_NFTStarView {
    
    private func setupView() {
        addSubview(star1)
        addSubview(star2)
        addSubview(star3)
        addSubview(star4)
        addSubview(star5)
        addSubview(star6)
    }
}
