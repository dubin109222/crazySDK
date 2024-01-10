//
//  CS_NFTLevelUpFeedView.swift
//  CrazySnake
//
//  Created by Lee on 01/03/2023.
//

import UIKit

class CS_NFTLevelUpFeedView: UIView {
    
    typealias DataBlock = (CS_NFTPropModel?) -> Void
    var chooseAction: DataBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var item0: CS_NFTLevelUpFeedItemView = {
        let view = CS_NFTLevelUpFeedItemView()
        view.addTarget(self, action: #selector(clickItem0(_:)), for: .touchUpInside)
        view.isSelectedItem = true
        return view
    }()
    
    lazy var item1: CS_NFTLevelUpFeedItemView = {
        let view = CS_NFTLevelUpFeedItemView()
        view.addTarget(self, action: #selector(clickItem1(_:)), for: .touchUpInside)
        view.iconView.image = UIImage.ls_bundle( "nft_icon_feed_intermadiate@2x")
        return view
    }()
    
    lazy var item2: CS_NFTLevelUpFeedItemView = {
        let view = CS_NFTLevelUpFeedItemView()
        view.addTarget(self, action: #selector(clickItem2(_:)), for: .touchUpInside)
        view.iconView.image = UIImage.ls_bundle( "nft_icon_feed_senior@2x")
        return view
    }()

}

//MARK: action
extension CS_NFTLevelUpFeedView {
    
    @objc func clickItem0(_ sender: UIButton) {
        guard item0.isSelectedItem == false else {
            return
        }
        item0.isSelectedItem = true
        item1.isSelectedItem = false
        item2.isSelectedItem = false
        chooseAction?(item0.propModel)
    }
    
    @objc func clickItem1(_ sender: UIButton) {
        guard item1.isSelectedItem == false else {
            return
        }
        item0.isSelectedItem = false
        item1.isSelectedItem = true
        item2.isSelectedItem = false
        chooseAction?(item1.propModel)
    }
    
    @objc func clickItem2(_ sender: UIButton) {
        guard item2.isSelectedItem == false else {
            return
        }
        item0.isSelectedItem = false
        item1.isSelectedItem = false
        item2.isSelectedItem = true
        chooseAction?(item2.propModel)
    }
    
}


//MARK: UI
extension CS_NFTLevelUpFeedView {
    
    private func setupView() {
        ls_cornerRadius(10)
        backgroundColor = .ls_color("#383639")
        
        addSubview(item0)
        addSubview(item1)
        addSubview(item2)
        
        item1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(45)
        }
        
        item0.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(item1)
            make.right.equalTo(item1.snp.left).offset(-10)
        }
        
        item2.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(item1)
            make.left.equalTo(item1.snp.right).offset(10)
        }
    }
}


class CS_NFTLevelUpFeedItemView: UIButton {
    
    var propModel: CS_NFTPropModel?
    
    var isSelectedItem = false {
        didSet {
            if isSelectedItem {
                ls_border(color: .ls_color("#46F490"),width: 1)
                amountLabel.textColor = .ls_color("#46F490")
            } else {
                ls_border(color: .ls_white(),width: 1)
                amountLabel.textColor = .ls_white()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTPropModel?) {
        propModel = model
        amountLabel.text = "x\(model?.num ?? 0)"
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_icon_feed_primary@2x")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_font(12))
        label.textAlignment = .right
        label.text = ""
        return label
    }()

}

//MARK: UI
extension CS_NFTLevelUpFeedItemView {
    
    private func setupView() {
        ls_cornerRadius(5)
        ls_border(color: .ls_white(),width: 1)
        
        addSubview(iconView)
        addSubview(amountLabel)
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.right.equalTo(iconView).offset(6)
            make.bottom.equalTo(iconView).offset(6)
        }
    }
}
