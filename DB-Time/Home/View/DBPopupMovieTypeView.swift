//
//  DBPopupMovieTypeView.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/6.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DBPopupMovieTypeView: UIView, TableViewAnimationProtocol {

    let disposeBag = DisposeBag()
    var tableView: UITableView!
    var isShowing: Bool = false
    var backClosure: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 40
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = true
        addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 140, height: 40 * 6))
        })
        let items = Observable.just(["正在热映", "即将上映", "Top250", "口碑榜", "北美票房榜", "新片榜"])
        
        items.bind(to: tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(with: UITableViewCell.self)
            cell.textLabel?.text = element
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.backClosure?(indexPath.row)
            self?.dismiss()
        }).disposed(by: disposeBag)
        
//        let tapGesture = UITapGestureRecognizer()
//        addGestureRecognizer(tapGesture)
//        tapGesture.rx.event.bind { _ in
//            self.dismiss()
//        }.disposed(by: disposeBag)
    }
    
    func popupIfNeed() {
        if isShowing {
            dismiss()
        } else {
            show()
        }
    }
    
    func show() {
        showAnimation(with: .layDown, tableView: tableView)
        isShowing = true
    }
    
    func dismiss() {
        showAnimation(with: .layDownBack, tableView: tableView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
            self.removeFromSuperview()
            self.isShowing = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
