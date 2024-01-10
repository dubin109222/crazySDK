//
//  MnemonicCollectCell.swift
//  Platform
//
//  Created by Lee on 23/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit

class MnemonicCollectCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var indexLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 12))
        label.ls_set(UIColor.ls_color("#999999"), UIFont.ls_mediumFont(10))
        label.textAlignment = .center
        return label
    }()
    
    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), UIFont.ls_mediumFont(15))
        label.textAlignment = .center
        return label
    }()
}

//MARK: open
extension MnemonicCollectCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: (CS_kScreenW - CS_ms(32)*2 - 10*5)/6.0, height: 43)
    }
    
    public class func itemSizeForBackup() -> CGSize {
        return CGSize(width: (CS_kScreenW - CS_ms(32)*2 - 16*3)/6.0, height: 43)
    }
    
    func setData(_ model: MnemonicVerifyModel){
        indexLabel.text = "\(model.mnemonic?.index ?? 0 + 1)"
        wordLabel.text = model.selected?.word
    }
    
    func setVerifyData(_ model: MnemonicVerifyModel){
        indexLabel.text = "第\(model.mnemonic?.index ?? 0 + 1)個"
        wordLabel.text = model.selected?.word
    }
    
    func setData(_ selectedModel: MnemonicWordModel?, index: Int, firstErrorIndex: Int, mnemonicWordsList: [MnemonicWordModel]) -> Bool {
        indexLabel.text = "\(index)"
        wordLabel.text = selectedModel?.word
        var isCorrect = true
        if firstErrorIndex > 0 && firstErrorIndex < index {
            isCorrect = false
        } else {
            let model: MnemonicWordModel? = mnemonicWordsList.ls_objectAt(index-1) as? MnemonicWordModel
            if selectedModel != nil && model?.word != selectedModel?.word {
                isCorrect = false
            }
        }
        
        wordLabel.textColor = isCorrect ? UIColor.ls_dark_2() : UIColor.ls_red()
        
        return isCorrect
    }
}

//MARK: UI
extension MnemonicCollectCell {
    
    fileprivate func setupView() {
        contentView.addSubview(backView)
        contentView.addSubview(indexLabel)
        contentView.addSubview(wordLabel)
        
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        indexLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(12)
        }
        
        wordLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(14)
        }
    }
}
