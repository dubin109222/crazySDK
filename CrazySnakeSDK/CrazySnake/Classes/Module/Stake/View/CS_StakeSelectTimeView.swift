//
//  CS_StakeSelectTimeView.swift
//  CrazySnake
//
//  Created by Lee on 17/03/2023.
//

import UIKit

class CS_StakeSelectTimeView: UIView {
    
    typealias CS_TimeChangeBlock = (CS_StakeTimeModel) ->()
    var selectTimeChange: CS_TimeChangeBlock?
    private var dataSource = [CS_StakeTimeModel]()
    var selectedModel: CS_StakeTimeModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSource(_ list: [CS_StakeTimeModel]){
        dataSource.removeAll()
        dataSource.append(contentsOf: list)
        if selectedModel == nil, let model = list.first {
            reloadDataWithSelect(model)
        }
        let shortList = list.filter { item in
            return item.type == 1 ? true : false
        }
        shortView.updateSource(shortList)
        let meduimList = list.filter { item in
            return item.type == 2 ? true : false
        }
        meduimView.updateSource(meduimList)
        let longList = list.filter { item in
            return item.type == 3 ? true : false
        }
        longView.updateSource(longList)
        
    }
    
    func reloadDataWithSelect(_ model: CS_StakeTimeModel) {
        selectedModel = model
        selectTimeChange?(model)
        shortView.reloadDataWithSelect(model)
        meduimView.reloadDataWithSelect(model)
        longView.reloadDataWithSelect(model)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(19))
        label.text = "crazy_str_select_time".ls_localized
        return label
    }()
    
    lazy var shortView: CS_StakeSelectTimeSectionView = {
        let view = CS_StakeSelectTimeSectionView()
        view.titleLabel.text = "crazy_str_short".ls_localized
        weak var weakSelf = self
        view.selectTimeChange = { model in
            weakSelf?.reloadDataWithSelect(model)
        }
        return view
    }()
    
    lazy var meduimView: CS_StakeSelectTimeSectionView = {
        let view = CS_StakeSelectTimeSectionView()
        view.titleLabel.text = "crazy_str_meduim".ls_localized
        weak var weakSelf = self
        view.selectTimeChange = { model in
            weakSelf?.reloadDataWithSelect(model)
        }
        return view
    }()
    
    lazy var longView: CS_StakeSelectTimeSectionView = {
        let view = CS_StakeSelectTimeSectionView()
        view.titleLabel.text = "crazy_str_long".ls_localized
        weak var weakSelf = self
        view.selectTimeChange = { model in
            weakSelf?.reloadDataWithSelect(model)
        }
        return view
    }()
    
}

//MARK: UI
extension CS_StakeSelectTimeView {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(shortView)
        addSubview(meduimView)
        addSubview(longView)
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        
        shortView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(34)
            make.top.equalTo(CS_RH(30))
        }
        
        meduimView.snp.makeConstraints { make in
            make.left.right.height.equalTo(shortView)
            make.top.equalTo(CS_RH(75))
        }
        
        longView.snp.makeConstraints { make in
            make.left.right.height.equalTo(shortView)
            make.top.equalTo(CS_RH(120))
        }
    }
}

class CS_StakeSelectTimeSectionView: UIView {
    
    typealias CS_TimeChangeBlock = (CS_StakeTimeModel) ->()
    var selectTimeChange: CS_TimeChangeBlock?
    private var dataSource = [CS_StakeTimeModel]()
    private var selectedModel: CS_StakeTimeModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func updateSource(_ list: [CS_StakeTimeModel]){
        dataSource.removeAll()
        dataSource.append(contentsOf: list)
        collectionView.reloadData()
    }
    
    func reloadDataWithSelect(_ model: CS_StakeTimeModel?) {
        selectedModel = model
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_text_gray(), UIFont.ls_JostRomanFont(12))
        label.text = ""
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.itemSize = CS_StakeSelectTimeCell.itemSize()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(CS_StakeSelectTimeCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_StakeSelectTimeCell.self))
        view.backgroundColor = .clear
        return view
    }()
}

extension CS_StakeSelectTimeSectionView: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_StakeSelectTimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_StakeSelectTimeCell.self), for: indexPath) as! CS_StakeSelectTimeCell
        let model = dataSource[indexPath.row]
        cell.setData(model,selectedItem: selectedModel)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        selectTimeChange?(model)
    }
}

//MARK: UI
extension CS_StakeSelectTimeSectionView {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(62)
            make.height.equalTo(34)
        }
    }
}


class CS_StakeSelectTimeCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_StakeTimeModel?, selectedItem: CS_StakeTimeModel? = nil) {
        guard let model = model else { return }
        contentButton.setTitle(model.displayName(), for: .normal)
        if model.day == selectedItem?.day {
            contentButton.backgroundColor = .ls_color("#CDA4FF")
            contentButton.isSelected = true
        } else {
            contentButton.backgroundColor = .clear
            contentButton.isSelected = false
        }
    }
    
    lazy var contentButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitleColor(.ls_dark_3(), for: .selected)
        button.ls_cornerRadius(12)
        button.borderColor = .ls_white()
        button.borderWidth = 1
        return button
    }()
}

//MARK: open
extension CS_StakeSelectTimeCell {
    
    class func itemSize() -> CGSize {
        return CGSize(width: 70, height: 34)
    }
}

//MARK: UI
extension CS_StakeSelectTimeCell {
    
    fileprivate func setupView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(contentButton)
        contentButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


