//
//  CS_TableViewCell.swift
//  CrazySnake
//
//  Created by Lee on 15/05/2023.
//

import UIKit

class CS_ShareWithdrawCell: UITableViewCell {
    
    typealias CS_ShareWithdrawBlock = (CS_ShareWithdrawItemModel) -> Void
    
    var clickWithdrawAction: CS_ShareWithdrawBlock?

    var currentToken: CS_ShareTokenModel?
    var selectedItem: CS_ShareWithdrawItemModel? {
        didSet {
            loadSwapData()
        }
    }
    var dataSource = [CS_ShareWithdrawItemModel]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CS_ShareWithdrawItemCell.itemSize()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        view.backgroundColor = .ls_color("#ABABAB",alpha: 0.6)
        view.ls_cornerRadius(5)
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.register(CS_ShareWithdrawItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_ShareWithdrawItemCell.self))
        return view
    }()

    lazy var receiveBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#333333")
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var receiveTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#F8F8F8")
        return view
    }()
    
    lazy var receiveLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_font(14))
        label.text = "crazy_str_expected_to_receive".ls_localized
        return label
    }()
    
    lazy var cashBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#3A3A3A")
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var cashLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(10))
        label.text = TokenName.Snake.name()
        return label
    }()
    
    lazy var cashAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#46F490"), .ls_boldFont(19))
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_mediumFont(12))
        label.numberOfLines = 0
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setBackgroundImage(UIImage.ls_bundle("share_bg_withdraw_btn@2x"), for: .normal)
        button.titleLabel?.font = .ls_boldFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_withdraw".ls_localized, for: .normal)
        return button
    }()
    
}

//MARK: data
extension CS_ShareWithdrawCell {
    func setData(_ data: CS_ShareWithdrawModel?) {
        guard let data = data else { return }
        currentToken = data.tokens.first
        cashLabel.text = currentToken?.name
        dataSource = data.list
        selectedItem = dataSource.first(where: { item in
            item.valid == true
        })
        collectionView.reloadData()
    }
}


//MARK: action
extension CS_ShareWithdrawCell {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        guard let item = selectedItem else { return }
        clickWithdrawAction?(item)
    }
}

//MARK: request
extension CS_ShareWithdrawCell {
    func loadSwapData() {
        guard let token = currentToken, let item = selectedItem else { return }
        weak var weakSelf = self
        CSNetworkManager.shared.getShareSwapData(token.name, amount: item.cash) { resp in
            if resp.status == .success {
                weakSelf?.cashAmountLabel.text = resp.data?.token
            }
        }
    }
}


extension CS_ShareWithdrawCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_ShareWithdrawItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_ShareWithdrawItemCell.self), for: indexPath) as! CS_ShareWithdrawItemCell
        let model = dataSource[indexPath.row]
        cell.setData(model, selected: selectedItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if model.valid {
           selectedItem = model
            collectionView.reloadData()
        } else {
            LSHUD.showInfo("crazy_str_insufficient_quota".ls_localized)
        }
    }
}


//MARK: UI
extension CS_ShareWithdrawCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(collectionView)
        contentView.addSubview(receiveBackView)
        receiveBackView.addSubview(receiveTopView)
        receiveTopView.addSubview(receiveLabel)
        receiveBackView.addSubview(cashBackView)
        cashBackView.addSubview(cashLabel)
        cashBackView.addSubview(cashAmountLabel)
        receiveBackView.addSubview(infoLabel)
        contentView.addSubview(confirmButton)
        
        collectionView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(108)
        }
        
        receiveBackView.snp.makeConstraints { make in
            make.left.right.equalTo(collectionView)
            make.top.equalTo(collectionView.snp.bottom).offset(14)
            make.height.equalTo(78)
        }
        
        receiveTopView.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
            make.height.equalTo(24)
        }
        
        receiveLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        cashBackView.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.top.equalTo(receiveTopView.snp.bottom).offset(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(180)
        }
        
        cashLabel.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.top.equalTo(4)
        }
        
        cashAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(cashLabel)
            make.bottom.equalTo(-2)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(receiveTopView.snp.bottom).offset(10)
            make.left.equalTo(cashBackView.snp.right).offset(50)
            make.right.equalTo(-46)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(receiveBackView.snp.bottom).offset(19)
            make.width.equalTo(139)
            make.height.equalTo(42)
        }
    }
}
