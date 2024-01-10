//
//  CS_NFTSetInfoCell.swift
//  CrazySnake
//
//  Created by Lee on 31/05/2023.
//

import UIKit

class CS_NFTSetInfoCell: UICollectionViewCell {
    
    var infoModel: CS_NFTSetInfoModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTSetInfoModel?) {
        infoModel = model
        guard let model = model else { return }
        nameLabel.text = model.set_class.cs_configName()
        let url = URL.init(string: model.image)
        coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        
        collectionView.reloadData()
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#ABABAB",alpha: 0.6)
        view.ls_cornerRadius(10)
        return view
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#363636")
        view.ls_cornerRadius(10)
        return view
    }()
    
    lazy var coverView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 106, height: 119))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var coverBack: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("nft_stake_bg_set@2x")
//        view.isHidden = true
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_font(19))
        label.textAlignment = .center
        return label
    }()
    
    lazy var collectedLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_font(12))
        label.textAlignment = .center
        label.ls_cornerRadius(5)
        label.backgroundColor = .ls_white(0.1)
        label.text = "crazy_str_collected".ls_localized
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CS_NFTSetInfoItemCell.itemSize()
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(CS_NFTSetInfoItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_NFTSetInfoItemCell.self))
        return view
    }()
    
}

extension CS_NFTSetInfoCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTSetInfoItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTSetInfoItemCell.self), for: indexPath) as! CS_NFTSetInfoItemCell
        let model = infoModel?.qualitiesList[indexPath.row] ?? 0
        
        cell.setData(model, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoModel?.qualities.count ?? 0
    }
}

//MARK: open
extension CS_NFTSetInfoCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: 316, height: 178)
    }
}

//MARK: UI
extension CS_NFTSetInfoCell {
    
    fileprivate func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(infoView)
        infoView.addSubview(coverBack)
        infoView.addSubview(coverView)
        infoView.addSubview(nameLabel)
        infoView.addSubview(collectedLabel)
        infoView.addSubview(collectionView)
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        infoView.snp.makeConstraints { make in
            make.left.top.equalTo(5)
            make.right.bottom.equalTo(-5)
        }
        
        coverBack.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(149)
            make.height.equalTo(153)
        }
        
        coverView.snp.makeConstraints { make in
            make.left.top.equalTo(coverBack)
            make.right.bottom.equalTo(coverBack).offset(-6)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(coverBack.snp.right).offset(6)
            make.top.equalTo(coverBack)
        }
        
        collectedLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(38)
            make.width.equalTo(80)
            make.height.equalTo(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel).offset(-4)
            make.top.equalTo(66)
            make.bottom.equalTo(0)
            make.right.equalTo(infoView).offset(-4)
        }
        
    }
}

class CS_NFTSetInfoItemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ collect: Int, index: Int) {
        let quality = CS_NFTQuality(rawValue: index+1)
        nameLabel.text = quality?.name()
        iconView.image = quality?.icon()?.withRenderingMode(.alwaysTemplate)
        if collect == 1 {
            nameLabel.textColor = quality?.color()
            iconView.tintColor = quality?.color()
        } else {
            nameLabel.textColor = .ls_text_gray()
            iconView.tintColor = .ls_text_gray()
        }
        
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(10))
        label.textAlignment = .center
        return label
    }()
}

//MARK: open
extension CS_NFTSetInfoItemCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: 46, height: 40)
    }
   
}

//MARK: UI
extension CS_NFTSetInfoItemCell {
    
    fileprivate func setupView() {
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
    }
}
