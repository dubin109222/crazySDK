//
//  CS_VoucherGetAlert.swift
//  CrazySnake
//
//  Created by BigB on 2023/11/13.
//

import Foundation
import UIKit
import SwiftyAttributes
import Kingfisher

class CS_VoucherGetCell: UICollectionViewCell {
    
    let iconView = UIImageView()
    
    var model :ListRewardItem? = nil {
        didSet {
            if model?.reward_type == "4" 
                || model?.reward_type == "reward_prop" { // 道具
                let pro = CS_NFTPropsType(rawValue: model!.prop_id)
                iconView.image = pro?.iconImage()
                nameLb.text = pro?.disPlayName()
            } else if model?.reward_type == "1" 
                        || model?.reward_type == "reward_gascoin" { // gas
                
                iconView.image = TokenName.GasCoin.icon()
                nameLb.text = TokenName.GasCoin.name()
            } else if model?.reward_type == "2" {
                iconView.image = TokenName.Diamond2.icon()
                nameLb.text = TokenName.Diamond2.name()
            } else if model?.reward_type == "3" { // nft
                let url = URL.init(string: model!.reward_img)
                iconView.kf.setImage(with: url , placeholder: UIImage.ls_bundle("icon_loading_data@2x"), options: nil , completionHandler: nil)
                nameLb.text = ""
            }

            numberLb.text = "x" + (model?.reward_num ?? "")

        }
    }
     
    lazy var numberLb: UILabel = {
        let numberLb = UILabel()
        numberLb.textColor = .white
        numberLb.font = .ls_JostRomanFont(14)
        return numberLb
    }()
    
    lazy var nameLb: UILabel = {
        let nameLb = UILabel()
        nameLb.textColor = .white
        nameLb.font = .ls_JostRomanFont(12)
        return nameLb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .ls_color("#202030")
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        
        self.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(65)
        }
        
        self.addSubview(nameLb)
        nameLb.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(numberLb)
        numberLb.snp.makeConstraints { make in
            make.bottom.equalTo(iconView).offset(-12)
            make.right.equalTo(iconView).offset(4)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CS_VoucherGetAlert: CS_BaseAlert {

    var clickReceiveAction: CS_NoParasBlock?
    var model: ListRewardItem?{
        didSet{
            updateData()
            self.collectionView.isHidden = true
            self.iconView.isHidden = false
            self.nameLabel.isHidden = false
            self.numberLb.isHidden = false

        }
    }
    var list: [ListRewardItem]? {
        didSet {
            
            if (list?.count ?? 0) <= 5 {
                self.collectionView.snp.updateConstraints { make in
                    make.width.equalTo((105 + 10) * (list?.count ?? 0))
                }
            } else {
                self.collectionView.snp.updateConstraints { make in
                    make.width.equalTo((105 + 10) * (list?.count ?? 0))
                }
            }
            
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
            self.iconView.isHidden = true
            self.nameLabel.isHidden = true
            self.numberLb.isHidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(){
        guard let model = model else { return }
        if model.reward_type == "4" 
            || model.reward_type == "reward_prop" { // 道具
            let pro = CS_NFTPropsType(rawValue: model.prop_id)
            iconView.image = pro?.iconImage()
            nameLabel.text = pro?.disPlayName()

        } else if model.reward_type == "1"
            || model.reward_type == "reward_gascoin" { // gas

            iconView.image = TokenName.GasCoin.icon()
            nameLabel.text = TokenName.GasCoin.name()
        } else if model.reward_type == "2" {
            iconView.image = TokenName.Diamond2.icon()
            nameLabel.text = TokenName.Diamond2.name()
        } else if model.reward_type == "3" { // nft
            let url = URL.init(string: model.reward_img)
            iconView.kf.setImage(with: url , placeholder: UIImage.ls_bundle("icon_loading_data@2x"), options: nil , completionHandler: nil)
            nameLabel.text = ""
        }
        numberLb.text = "x" + model.reward_num

    }
    
    lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: collectionLayout)
        collectionView.register(CS_VoucherGetCell.self, forCellWithReuseIdentifier: "CS_VoucherGetCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        // 注册
        return collectionView
    }()
    
    lazy var toptitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(19))
        label.textAlignment = .center
        label.text = "crazy_str_congratulations".ls_localized
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    
    lazy var numberLb: UILabel = {
        let numberLb = UILabel()
        numberLb.textColor = .white
        numberLb.font = .ls_JostRomanFont(14)
        return numberLb
    }()

    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .center
//        label.ls_cornerRadius(12.5)
//        label.backgroundColor = .ls_white(0.1)
        return label
    }()

    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 160, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_received".ls_localized, for: .normal)
        return button
    }()
}

extension CS_VoucherGetAlert: UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CS_VoucherGetCell", for: indexPath) as! CS_VoucherGetCell
        cell.model = self.list?[indexPath.row]
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 20
        cell.backgroundColor = UIColor.ls_color("#202030")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(105, 94)
    }
}

extension CS_VoucherGetAlert: UICollectionViewDelegate {
    
}

//MARK: action
extension CS_VoucherGetAlert {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        clickReceiveAction?()
        dismissSelf()
    }
}


//MARK: UI
extension CS_VoucherGetAlert {
    
    private func setupView() {
        tapDismissEnable = false
        contentView.isHidden = true
        backView.backgroundColor = .ls_color("#11111A", alpha: 0.7)
        addSubview(toptitleLabel)
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(confirmButton)
        addSubview(collectionView)
        addSubview(numberLb)
        
        iconView.image = .ls_bundle("icon_loading_data@2x")
        iconView.isHidden = true
        nameLabel.text = "loading"
        nameLabel.isHidden = true
        numberLb.isHidden = true
        collectionView.isHidden = true
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        toptitleLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(iconView.snp.top).offset(-6)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(4)
            make.width.equalTo(142)
            make.height.equalTo(25)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
//            make.left.equalToSuperview().offset(CS_RH(20))
//            make.right.equalToSuperview().offset(-CS_RH(20))
            make.width.equalTo((105 + 10) * 5)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
        }
        
        numberLb.snp.makeConstraints { make in
            make.bottom.equalTo(iconView).offset(-12)
            make.right.equalTo(iconView).offset(4)
        }

    }
}
