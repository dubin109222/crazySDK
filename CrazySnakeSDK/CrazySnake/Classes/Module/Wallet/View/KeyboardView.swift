//
//  KeyboardView.swift
//  Platform
//
//  Created by Lee on 28/04/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit

fileprivate let KeyboardWidth: CGFloat = CS_kIsSmallPhone ? (CS_kScreenH - 100) : CS_kScreenH

class KeyboardView: UIView {
    
    var inputChange: CS_StringBlock?
    var clickDelete: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: CS_kScreenW-KeyboardWidth, y: 0, width: KeyboardWidth, height: CS_kScreenH))
        ls_addCorner([.topLeft,.bottomLeft], cornerRadius: 20)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 6
        layout.itemSize = KeyboardItemCell.itemSize()
        let view = UICollectionView(frame: CGRect(x: 32, y: 64, width: KeyboardWidth-32-32, height: CS_kScreenH-64), collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.register(KeyboardItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(KeyboardItemCell.self))
        return view
    }()
    
    lazy var impactFeedback: UIImpactFeedbackGenerator = {
        let impact = UIImpactFeedbackGenerator(style: .light)
        return impact
    }()
    
}

extension KeyboardView: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: KeyboardItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(KeyboardItemCell.self), for: indexPath) as! KeyboardItemCell
        cell.setData(indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 9 {
            return
        }
        impactFeedback.impactOccurred()
        
        if indexPath.row == 11 {
            self.clickDelete?()
        } else {
            var text = String(format: "%ld", indexPath.row + 1)
            if indexPath.row == 10 {
                text = "0"
            }
            self.inputChange?(text)
        }
    }
    
}


//MARK: UI
extension KeyboardView {
    fileprivate func setupView() {
        backgroundColor = UIColor.ls_dark_3()
        
        addSubview(collectionView)
    }
}

class KeyboardItemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open class func itemSize() -> CGSize {
        return CGSize(width: (KeyboardWidth - 64 - 24*2)/3.0, height: (CS_kScreenH - 64 - 32 - 24*3)/4.0)
    }
    
    open func setData(_ index: IndexPath) {
        wordLabel.text = String(format: "%ld", index.row + 1)
        if index.row == 9 {
            backView.isHidden = true
        } else if index.row == 10 {
            wordLabel.text = "0"
        }
        
        wordLabel.isHidden = index.row == 11
        iconView.isHidden = index.row != 11
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ls_dark_2()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(20))
        label.textAlignment = .center
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icon_keyboard_delete")
        view.isHidden = true
        return view
    }()
    
    private func setupView() {
        contentView.addSubview(backView)
        backView.addSubview(wordLabel)
        backView.addSubview(iconView)
        
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        wordLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

