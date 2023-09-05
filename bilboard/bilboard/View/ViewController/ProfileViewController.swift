//
//  ProfileViewController.swift
//  bilboard
//
//  Created by 박유경 on 2023/09/04.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // dummy data for history
    var historyData = [history1, history2]

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    private func registerXib(){
            let collectionNib = UINib(nibName: BoardCollectionTableViewCell.identifier, bundle: nil)
        tableView.register(collectionNib, forCellReuseIdentifier: BoardCollectionTableViewCell.identifier)
            **let storyCell = UINib(nibName: StoryTableViewCell.identifier, bundle: nil)
            feedTableView.register(storyCell, forCellReuseIdentifier: StoryTableViewCell.identifier)**
        }
    private func registerXib(){
        let collectionNib = UINib(nibName: BoardCollectionTableViewCell.identifier, bundle: nil)
        collectionView.register(collectionNib, forCellWithReuseIdentifier: BoardCollectionTableViewCell.identifier)
    }
    
    private func registerDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 2: return historyData.count
            default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell =
        switch section {
            case 0: return 1
            case 1: return 1
            case 2: return
            default: return 1
        }
    }

}
