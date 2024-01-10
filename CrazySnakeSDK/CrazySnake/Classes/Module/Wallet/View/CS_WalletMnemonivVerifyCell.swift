//
//  CS_WalletMnemonivVerifyCell.swift
//  CrazyWallet
//
//  Created by Lee on 30/06/2023.
//

import UIKit

class CS_WalletMnemonivVerifyCell: UICollectionViewCell {
    
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
        label.ls_cornerRadius(6)
        label.backgroundColor = .ls_color("#1C1C1E")
        label.borderColor = .ls_color("#2D2D2D")
        label.borderWidth = 1
        return label
    }()
}

//MARK: open
extension CS_WalletMnemonivVerifyCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: (CS_kScreenW - CS_ms(32)*2 - 10*5)/6.0, height: 60)
    }
    
    public class func itemSizeForBackup() -> CGSize {
        return CGSize(width: (CS_kScreenW - 32*2 - 16*2)/3.0, height: 43)
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
extension CS_WalletMnemonivVerifyCell {
    
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
            make.left.right.equalToSuperview()
            make.top.equalTo(14)
            make.height.equalTo(43)
        }
    }
}
