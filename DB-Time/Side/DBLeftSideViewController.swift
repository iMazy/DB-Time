//
//  DBLeftSideViewController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/3.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DBLeftSideViewController: DBBaseViewController {

    var disposeBag = DisposeBag()
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImageView = UIImageView(image: #imageLiteral(resourceName: "background_image"))
        bgImageView.frame = view.bounds
        bgImageView.contentMode = .scaleAspectFill
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgImageView.addSubview(blurEffectView)
        
        view.addSubview(bgImageView)
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.registerNib(DBLeftTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        view.addSubview(tableView)
        
        let headerView = UIView.loadFromNibAndClass(DBLeftHeaderView.self)
        headerView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
        headerView?.backgroundColor = .clear
        tableView.tableHeaderView = headerView
        
        let items = Observable.just(["电影", "读书", "音乐", "FM", "小组"])
        
        items.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(with: DBLeftTableViewCell.self)
            cell.typeTitleLabel.text = element
            cell.backgroundColor = .clear
            return cell
        }.disposed(by: disposeBag)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
