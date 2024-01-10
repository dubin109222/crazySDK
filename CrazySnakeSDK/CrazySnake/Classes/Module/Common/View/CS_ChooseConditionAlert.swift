//
//  CS_ChosseConditionAlert.swift
//  CrazySnake
//
//  Created by BigB on 2023/7/11.
//
//  筛选条件的弹窗

import UIKit
import SnapKit

protocol CS_ChooseConditionAlertDataSource {
    var chooseData : [CS_MarketChooseTitleCell.CellData]? { get }
    
    func requestList()

}

class CS_ChooseConditionAlert: CS_BaseAlert {
    
    // 用于存储每个组选中的单元格索引路径
    lazy var selectedIndexPaths: [IndexPath] = {
        return [IndexPath]()
    }() {
        didSet {
            if !isLoading {
                self.selectedHandle?(selectedIndexPaths)
            }
        }
    }

    var indexPaths: [IndexPath]? = nil {
        didSet {
            self.selectedIndexPaths = indexPaths ?? []
        }
    }
    
    var data : [CS_MarketChooseTitleCell.CellData]? {
        didSet {
            self.collectionView.reloadData()
            if let list = indexPaths {
                for indexPath in list  {
                    self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                }
            }
        }
    }
    
    public var selectedHandle : (([IndexPath]) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.snp.remakeConstraints { make in
            make.right.equalTo(-20)
            make.top.equalTo(80.5)
        }

        self.initSubViews()
        closeButton.isHidden = true
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        self.contentView.backgroundColor = .ls_color("#EDE4FF")

        
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(CS_MarketChooseTitleCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CS_MarketChooseTitleCell")
        collectionView.register(CS_MarketChooseCell.self, forCellWithReuseIdentifier: "CS_MarketChooseCell")
        
        return collectionView
    }()

    
    
    func initSubViews()  {
        self.contentView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 366, height: 219))
        }
        
        contentView.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.bottom.equalToSuperview()
        }
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
    }
    
    var isLoading = false
}


extension CS_ChooseConditionAlert: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?[section].list?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CS_MarketChooseCell", for: indexPath) as? CS_MarketChooseCell {
            cell.data = self.data?[indexPath.section].list?[indexPath.row]
            cell.isSelected = true
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CS_MarketChooseTitleCell", for: indexPath) as? CS_MarketChooseTitleCell {
                cell.resetBtn.isHidden = indexPath.section != 0
                cell.data = self.data?[indexPath.section]
                weak var weakSelf = self
                cell.removeAllHandle = {
                    weakSelf?.selectedIndexPaths.removeAll()
                    weakSelf?.collectionView.reloadData()
                }
                return cell
            }
        }
        return UICollectionReusableView()
    }
    
}

extension CS_ChooseConditionAlert: UICollectionViewDelegate {
    // 辅助方法：取消指定组内所有单元格的选中状态
    private func deselectAllItemsInSection(_ section: Int) {
        for indexPath in selectedIndexPaths {
            if indexPath.section == section {
                collectionView.deselectItem(at: indexPath, animated: false)
                if let index = selectedIndexPaths.firstIndex(of: indexPath) {
                    selectedIndexPaths.remove(at: index)
                }
            }
        }
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 获取当前选中单元格所在的组
        let section = indexPath.section
        
        // 取消之前选中的单元格
        isLoading = true
        deselectAllItemsInSection(section)
        isLoading = false
        // 选中当前单元格
        selectedIndexPaths.append(indexPath)
        
        // 处理选中的逻辑
        // FIXME: 刷新接口
        

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // 从选中的索引路径数组中移除取消选中的单元格
        if let index = selectedIndexPaths.firstIndex(of: indexPath) {
            selectedIndexPaths.remove(at: index)
        }
        
        // 处理取消选中的逻辑

    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        if let cell = collectionView.cellForItem(at: indexPath) ,
//        cell.isSelected == true {
//            collectionView.deselectItem(at: indexPath, animated: true)
//            // FIXME: 刷新接口
//
//            return false
//        }
//        return true
//    }
}


extension CS_ChooseConditionAlert: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 91, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 32)
    }
}


