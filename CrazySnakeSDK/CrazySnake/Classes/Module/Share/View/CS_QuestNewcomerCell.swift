//
//  CS_QuestNewcomerCell.swift
//  CrazySnake
//
//  Created by Lee on 09/05/2023.
//

import UIKit

class CS_QuestNewcomerCell: UITableViewCell {
    
    typealias CS_QuestClaimBlock = (CS_ShareTaskModel) -> Void
    
    var clickClaimAction: CS_QuestClaimBlock?
    var dataSource = [CS_ShareTaskModel]()

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
        layout.itemSize = CS_QuestBenefitCell.itemSize()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        view.backgroundColor = .ls_color("#ABABAB",alpha: 0.6)
        view.ls_cornerRadius(5)
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.register(CS_QuestBenefitCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_QuestBenefitCell.self))
        return view
    }()

}

//MARK: data
extension CS_QuestNewcomerCell {
    func setData(_ list: [CS_ShareTaskModel]?) {
        guard let list = list else { return }
        dataSource = list
        collectionView.reloadData()
    }
}


extension CS_QuestNewcomerCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_QuestBenefitCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_QuestBenefitCell.self), for: indexPath) as! CS_QuestBenefitCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        cell.clickClaimAction = {
            self.clickClaimAction?(model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


//MARK: UI
extension CS_QuestNewcomerCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
