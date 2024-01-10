//
//  CS_NFTIncubateSuccessAlert.swift
//  CrazySnake
//
//  Created by Lee on 10/03/2023.
//

import UIKit

class CS_NFTIncubateSuccessAlert: CS_BaseAlert {

    var clickMoreAction: CS_NoParasBlock?
    var incubateSuccess: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTDataModel?) {
        guard let model = model else { return }
        let url = URL.init(string: model.image)
        imageView.contentMode = .scaleAspectFill
        imageView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
    }
    
    lazy var succssTips: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("lab_incubation_bg_success@2x")
        view.isHidden = true
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
//        view.image = UIImage.ls_bundle("icon_empty_data")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 16))
        button.addTarget(self, action: #selector(clickSeeMoreButton(_:)), for: .touchUpInside)
        button.setTitle("See more", for: .normal)
        button.setTitleColor(.ls_color("#46F490"), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setImage(UIImage.ls_bundle("nft_icon_incubate_more@2x"), for: .normal)
        button.ls_layout(.imageRight,padding: 5)
        return button
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "Congratulations on getting an NFT, see more on \"My NFT\""
        return label
    }()

}

//MARK: action
extension CS_NFTIncubateSuccessAlert {
    @objc private func clickSeeMoreButton(_ sender: UIButton) {
        dismissSelf()
        clickMoreAction?()
    }
}


//MARK: UI
extension CS_NFTIncubateSuccessAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.7)
        self.contentView.isHidden = true
        
        addSubview(succssTips)
        addSubview(imageView)
        addSubview(moreButton)
        addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-38)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(infoLabel.snp.top).offset(-26)
            make.width.equalTo(90)
            make.height.equalTo(16)
        }
        
        succssTips.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(moreButton).offset(-4)
            make.width.height.equalTo(229)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(succssTips)
            make.centerY.equalTo(succssTips)
            make.width.equalTo(144*1.2)
            make.height.equalTo(152*1.2)
        }
    }
}
