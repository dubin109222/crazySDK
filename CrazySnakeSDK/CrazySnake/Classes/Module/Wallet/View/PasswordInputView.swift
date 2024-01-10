//
//  PasswordInputView.swift
//  Platform
//
//  Created by Lee on 06/05/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit

class PasswordInputView: UIView {
    
    var text: String = "" {
        didSet {
            let count = text.count
            for (index, item) in itemList.enumerated() {
                item.isSelected = count == index
                if index < count {
                    item.titleLabel.text = text[index...index]
                } else {
                    item.titleLabel.text = ""
                }
            }
        }
    }
    
    private var itemList = [PasswordInputItem]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var item0: PasswordInputItem = {
        let item = PasswordInputItem()
        item.isSelected = true
        return item
    }()
    
    lazy var item1: PasswordInputItem = {
        let item = PasswordInputItem()
        return item
    }()
    
    lazy var item2: PasswordInputItem = {
        let item = PasswordInputItem()
        return item
    }()
    
    lazy var item3: PasswordInputItem = {
        let item = PasswordInputItem()
        return item
    }()
    
    lazy var item4: PasswordInputItem = {
        let item = PasswordInputItem()
        return item
    }()
    
    lazy var item5: PasswordInputItem = {
        let item = PasswordInputItem()
        return item
    }()
}

//MARK: UI
extension PasswordInputView {
    
    private func setupView() {
        addSubview(item0)
        addSubview(item1)
        addSubview(item2)
        addSubview(item3)
        addSubview(item4)
        addSubview(item5)
        
        itemList.append(item0)
        itemList.append(item1)
        itemList.append(item2)
        itemList.append(item3)
        itemList.append(item4)
        itemList.append(item5)
        
        item0.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(0)
            make.width.equalToSuperview().dividedBy(6)
        }
        
        item1.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(item0.snp.right)
            make.width.equalTo(item0)
        }
        
        item2.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(item1.snp.right)
            make.width.equalTo(item0)
        }
        
        item3.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(item2.snp.right)
            make.width.equalTo(item0)
        }
        
        item4.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(item3.snp.right)
            make.width.equalTo(item0)
        }
        
        item5.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(item4.snp.right)
            make.width.equalTo(item0)
        }
    }
}

class PasswordInputItem: UIView{
    
    var isSelected:Bool = false {
        didSet{
            if isSelected {
                line.backgroundColor = .ls_white()
            } else {
                line.backgroundColor = .ls_color("#D3E3E7")
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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(20))
        label.textAlignment = .center
        return label
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#D3E3E7")
        view.cornerRadius = 1
        return view
    }()
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(line)
        
        line.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(line)
            make.bottom.equalTo(line.snp.top).offset(-8)
        }
    }
}
