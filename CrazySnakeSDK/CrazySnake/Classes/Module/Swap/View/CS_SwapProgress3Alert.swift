//
//  CS_SwapProgress3Alert.swift
//  CrazySnake
//
//  Created by Lee on 04/04/2023.
//

import UIKit

class CS_SwapProgress3Alert: CS_BaseAlert {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_SwapHistoryModel){
        switch model.progress {
        case 1:
            itemView1.setStatus(1)
            itemView2.setStatus(1)
            itemView3.setStatus(1)
            line2.ls_drawDashLine(strokeColor: .ls_color("#46F490"))
            line3.ls_drawDashLine(strokeColor: .ls_color("#46F490"))
        case 2:
            itemView1.setStatus(1)
            itemView2.setStatus(model.status)
            line2.ls_drawDashLine(strokeColor: .ls_color("#46F490"))
            line3.ls_drawDashLine(strokeColor: .ls_text_gray())
        case 3:
            itemView1.setStatus(1)
            itemView2.setStatus(1)
            itemView3.setStatus(model.status)
            line2.ls_drawDashLine(strokeColor: .ls_color("#46F490"))
            line3.ls_drawDashLine(strokeColor: .ls_text_gray())
        default:
            itemView1.setStatus(1)
            itemView2.setStatus(1)
            itemView3.setStatus(1)
            line2.ls_drawDashLine(strokeColor: .ls_color("#46F490"))
            line3.ls_drawDashLine(strokeColor: .ls_color("#46F490"))
            break
        }
    }
    
    lazy var itemView1: CS_SwapProgressItemView = {
        let view = CS_SwapProgressItemView()
        view.titleLabel.text = "Send order"
        return view
    }()
    
    lazy var line2: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 190, height: 1.5))
        return view
    }()
    
    lazy var itemView2: CS_SwapProgressItemView = {
        let view = CS_SwapProgressItemView()
        view.titleLabel.text = "Waiting for blockchain result"
        return view
    }()
    
    lazy var line3: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 190, height: 1.5))
        return view
    }()
    
    lazy var itemView3: CS_SwapProgressItemView = {
        let view = CS_SwapProgressItemView()
        view.titleLabel.text = "Completed"
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 130, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("Understand", for: .normal)
        return button
    }()
    
}

//MARK: action
extension CS_SwapProgress3Alert {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        dismissSelf()
    }
}


//MARK: UI
extension CS_SwapProgress3Alert {
    
    private func setupView() {
        tapDismissEnable = false
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_dark_3()
        contentView.layer.shadowRadius = 0
        contentView.ls_border(color: .ls_dark_5(),width: 1)
        
        contentView.addSubview(itemView1)
        contentView.addSubview(line2)
        contentView.addSubview(itemView2)
        contentView.addSubview(line3)
        contentView.addSubview(itemView3)
        addSubview(confirmButton)
        
        contentView.snp.remakeConstraints { make in
            make.top.equalTo(120)
            make.centerX.equalToSuperview()
            make.width.equalTo(595)
            make.height.equalTo(86)
        }
        
        itemView2.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalTo(contentView)
            make.height.equalTo(60)
            make.width.equalTo(180)
        }
        
        itemView1.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(0)
            make.height.equalTo(itemView2)
            make.width.equalTo(104)
        }
        
        itemView3.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.right.equalTo(0)
            make.height.equalTo(itemView2)
            make.width.equalTo(104)
        }
        
        line2.snp.makeConstraints { make in
            make.left.equalTo(itemView1.iconView.snp.right).offset(22)
            make.centerY.equalTo(itemView1.iconView)
            make.right.equalTo(itemView2.iconView.snp.left).offset(-22)
            make.height.equalTo(1.5)
        }
        
        line3.snp.makeConstraints { make in
            make.left.equalTo(itemView2.iconView.snp.right).offset(22)
            make.centerY.equalTo(itemView1.iconView)
            make.right.equalTo(itemView3.iconView.snp.left).offset(-22)
            make.height.equalTo(1.5)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(16)
            make.centerX.equalTo(contentView)
            make.height.equalTo(40)
            make.width.equalTo(130)
        }
    }
}



class CS_SwapProgressItemView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatus(_ status: Int){
        switch status {
        case 0:
            iconView.image = UIImage.ls_bundle("swap_icon_progress_pending@2x")
        case 1:
            iconView.image = UIImage.ls_bundle("swap_icon_progress_success@2x")
        case 2:
            iconView.image = UIImage.ls_bundle("swap_icon_progress_error@2x")
        case 3:
            iconView.image = UIImage.ls_bundle("swap_icon_progress_success@2x")
        default:
            break
        }
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("swap_icon_progress_pending@2x")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}

//MARK: UI
extension CS_SwapProgressItemView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(titleLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.top.equalTo(iconView.snp.bottom).offset(15)
        }
    }
}


