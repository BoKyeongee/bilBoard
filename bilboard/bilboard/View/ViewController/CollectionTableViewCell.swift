//
//  CollectionTableViewCell.swift
//  bilboard
//
//  Created by 보경 on 2023/09/05.
//

import UIKit

class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UpdateData {
    
    func updateData(_ newBoardInfo: BoardInfo) {
        let boardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "boardCell", for: IndexPath()) as! CollectionViewCell
        boardCell.setNeedsDisplay()
        
        boardCell.setData(newBoardInfo)
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.contentInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {flowlayout.estimatedItemSize = .zero}
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // cell item 선택 시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.item, forKey: "current")
    }
    
    // collectionViewCell 레이아웃
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {20}
    
    // collectionViewCell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.reloadData()
        return profile.bilBoardInfos?.count ?? 1
    }
    
    // collectionViewCell 반환
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let boardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "boardCell", for: indexPath) as! CollectionViewCell
        boardCell.setNeedsDisplay()
        
        boardCell.setData(profile.bilBoardInfos![indexPath.item])
        boardCell.idLabel.textColor = .white
        boardCell.addressLabel.textColor = .white
        boardCell.typeWrap.backgroundColor = UIColor(named: "MildPurple")
        boardCell.typeWrap.layer.cornerRadius = 12
        
        collectionCell(boardCell.contentView)

        return boardCell
    }
    
    func collectionCell(_ view: UIView){
        view.backgroundColor = UIColor(named: "MainColor")
        view.backgroundColor?.withAlphaComponent(0.7)
        view.layer.cornerRadius = 20
    }
    
}
