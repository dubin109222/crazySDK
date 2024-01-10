//
//  CS_NFTIncubateProgressView.swift
//  CrazySnake
//
//  Created by Lee on 09/03/2023.
//

import UIKit

class CS_NFTIncubateProgressView: UIView {

    var incubateDetail: CS_NFTIncubaDetail?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func updateExperience(_ amount: Int) {
        guard let model = incubateDetail else { return }
        levelWillIcon.isHidden = amount == 0
        var totel = model.end_time - model.start_time
        if totel <= 0 {
            return
        }
        let cureent: Double = Date().timeIntervalSince1970 - model.start_time + model.speedup
//        let need: Double = Double(nftModel?.experience ?? 0)
        let cureentMulti = cureent/totel
        var willMulti = (cureent+Double(amount))/totel
        if willMulti > 1 {
            willMulti = 1
        }
        
        levelWillView.snp.remakeConstraints { make in
            make.left.top.bottom.equalTo(levelBackView)
            make.width.equalTo(levelBackView.snp.width).multipliedBy(willMulti)
        }
        
        levelNowView.snp.remakeConstraints { make in
            make.left.top.bottom.equalTo(levelBackView)
            make.width.equalTo(levelBackView.snp.width).multipliedBy(cureentMulti)
        }
    }
    
    func setData(_ model: CS_NFTIncubaDetail) {
        incubateDetail = model
        updateExperience(0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.text = "Incubation time:"
        return label
    }()
    
    lazy var levelBackView: UIImageView = {
        let view = UIImageView()
        view.ls_cornerRadius(10)
        view.ls_border(color: .ls_color("#BABABA"),width: 2)
        view.backgroundColor = .ls_white()
        return view
    }()
    
    lazy var levelWillView: UIImageView = {
        let view = UIImageView()
        view.ls_cornerRadius(10)
        view.backgroundColor = .ls_color("#BABBBB")
        return view
    }()
    
    lazy var levelWillIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_icon_incubate_feed@2x")
        view.isHidden = true
        return view
    }()
    
    lazy var levelNowView: UIImageView = {
        let view = UIImageView()
        view.ls_cornerRadius(10)
        view.backgroundColor = .ls_dark_4()
        return view
    }()
    
}

//MARK: UI
extension CS_NFTIncubateProgressView {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(levelBackView)
        addSubview(levelWillView)
        addSubview(levelNowView)
        addSubview(levelWillIcon)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(3)
            make.top.equalToSuperview()
        }
        
        levelBackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
        
        levelWillView.snp.makeConstraints { make in
            make.left.top.equalTo(levelBackView).offset(1)
            make.bottom.equalTo(levelBackView).offset(-1)
            make.width.equalTo(levelBackView.snp.width).multipliedBy(0)
        }
        
        levelWillIcon.snp.makeConstraints { make in
            make.centerY.equalTo(levelWillView)
            make.centerX.equalTo(levelWillView.snp.right)
            make.width.equalTo(27)
            make.height.equalTo(31)
        }
        
        levelNowView.snp.makeConstraints { make in
            make.left.top.equalTo(levelBackView).offset(1)
            make.bottom.equalTo(levelBackView).offset(-1)
            make.width.equalTo(levelBackView.snp.width).multipliedBy(0)
        }
    }
}
