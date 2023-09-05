//
//  BoardCollectionTableViewCell.swift
//  bilboard
//
//  Created by t2023-m0055 on 2023/09/05.
//

import UIKit

class BoardCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // dummy data
    var boardData = [boardInfo1, boardInfo2]
    
    @IBOutlet var collectionView: UICollectionView!
    
    static let identifier = "boardCollection"
        
        override func awakeFromNib() {
            super.awakeFromNib()
            registerXib()
            registerDelegate()
        }
        
        private func registerXib(){
            let nib = UINib(nibName: ProfileCollectionViewCell.identifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        }
        
        private func registerDelegate(){
            collectionView.delegate = self
            collectionView.dataSource = self
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {boardData.count}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
       
        cell.setData(boardData[indexPath.item])
        
       return cell
    }
    

}
