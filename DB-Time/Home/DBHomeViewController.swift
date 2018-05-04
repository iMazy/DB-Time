//
//  DBHomeViewController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/3.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import SnapKit

class DBHomeViewController: DBBaseViewController {
    
    var swipeableView: ZLSwipeableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationItem.title = "电影"
        
        let leftBarItemButton = UIButton(type: .system)
        leftBarItemButton.frame.size = CGSize(width: 50, height: 30)
        leftBarItemButton.setImage(#imageLiteral(resourceName: "Category"), for: .normal)
        leftBarItemButton.imageView?.contentMode = .scaleAspectFit
        leftBarItemButton.addTarget(self, action: #selector(leftBarButtonItemDidTap), for: .touchUpInside)
        leftBarItemButton.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarItemButton)
        
        swipeableView = ZLSwipeableView()
        view.addSubview(swipeableView)
        swipeableView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-50)
        })
        
        swipeableView.allowedDirection = [.horizontal, .up]
        swipeableView.numberOfActiveView = 3
        swipeableView.onlySwipeTopCard = true
        
//        setupSwipeableViewDelegate()
        
        swipeableView.didStart = {view, location in
            print("Did start swiping view at location: \(location)")
        }
        swipeableView.swiping = {view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        swipeableView.didSwipe = {view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        swipeableView.didCancel = {view in
            print("Did cancel swiping view")
        }
        swipeableView.didTap = {view, location in
            print("Did tap at location \(location)")
        }
        swipeableView.didDisappear = { view in
            print("Did disappear swiping view")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.nextView = {
            return self.nextCardView()
        }
    }
    
    @objc func leftBarButtonItemDidTap() {
        if self.menuContainerViewController.sideMenuState == .leftMenuOpen {
            self.menuContainerViewController.setSideMenuState(state: .closed)
        } else {
            self.menuContainerViewController.setSideMenuState(state: .leftMenuOpen)
        }
    }
    
    // MARK: ()
    func nextCardView() -> UIView? {
  
        let cardView = DBCardView(frame: swipeableView.bounds)
        cardView.backgroundColor = UIColor.random()
        return cardView
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


// MARK: - SwipeableViewDelegate
/*
extension DBHomeViewController {
    func setupSwipeableViewDelegate()  {
        
        /// Swiping at view location
        swipeableView.swiping = { view, location, translation in
            let cellView = view as! HHDatingCardContainer
            let limit: CGFloat = 30.0
            if (translation.y < -limit * CGFloat(3)) {
                if (translation.x < -limit * CGFloat(2)) {
                    let alpha = min(1.0, (abs(translation.x) - limit * CGFloat(2)) / limit)
                    cellView.swipeToLeft(withAlpha: alpha)
                } else if (translation.x > limit * CGFloat(2)) {
                    let alpha = min(1.0, (abs(translation.x) - limit * CGFloat(2)) / limit)
                    cellView.swipeToRight(withAlpha: alpha)
                } else {
                    let alpha = min(1.0, (abs(translation.y) - limit * CGFloat(3)) / limit)
                    cellView.swipeToUp(withAlpha: alpha)
                }
            } else {
                cellView.swipeToUp(withAlpha: 0.0)
                if (translation.x < -limit) {
                    let alpha = min(1.0, (abs(translation.x) - limit) / limit)
                    cellView.swipeToLeft(withAlpha: alpha)
                } else if (translation.x > limit) {
                    let alpha = min(1.0, (abs(translation.x) - limit) / limit)
                    cellView.swipeToRight(withAlpha: alpha)
                }
            }
            
            if (translation.y < 0 && abs(translation.x) < limit * CGFloat(2)) {
                let scaleY = 1.0 + min(abs(translation.y), 100) * 0.002
                UIView.animate(withDuration: 0.25, animations: {
                    self.superLikeButton.transform = CGAffineTransform(scaleX: scaleY, y: scaleY)
                    self.likeButton.transform = .identity
                    self.passButton.transform = .identity
                })
            } else {
                let scaleX = 1.0 + min(abs(translation.x), 100) * 0.002;
                UIView.animate(withDuration: 0.25, animations: {
                    if translation.x > 0 {
                        self.likeButton.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
                    } else {
                        self.passButton.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
                    }
                    self.superLikeButton.transform = .identity
                })
            }
            self.translation = translation
        }
        
        /// Did end swiping view at location:
        swipeableView.didEnd = {view, location in
            if (!self.didSwipe) {
                if (self.translation.x <= -(UIScreen.main.bounds.width * 0.4)) {
                    self.swipeableView.swipeTopView(inDirection: .left)
                }
                
                if (self.translation.x >= (UIScreen.main.bounds.width * 0.4)) {
                    self.swipeableView.swipeTopView(inDirection: .right)
                }
                
                let limit: CGFloat = 30.0
                if (self.translation.y < -limit * CGFloat(3) && (self.translation.x >= -limit * CGFloat(2)) && self.translation.x <= limit * CGFloat(2)) {
                    self.swipeableView.swipeTopView(inDirection: .up)
                }
            }
            
            self.didSwipe = false
        }
        // Did swipe view in direction:  vector:
        swipeableView.didSwipe = {view, direction, vector in
            
            let cellView = view as! HHDatingCardContainer
            
            guard let user = cellView.card?.user else {
                self.rollback()
                return
            }
            self.didSwipe = true
            
            switch direction {
            case .left:
                self.passWithUserID(user.id)
            case .right:
                self.likeWithUserID(user)
            case .up:
                if !self.isSuperLike {
                    self.rollback()
                    let coverView: HHSuperLikeCoverView = HHSuperLikeCoverView.coverView()
                    coverView.updateUI(user: user, iconImage: cellView.card?.pictureImageView.image)
                    coverView.outOfBalance = { [weak self] in
                        let pGoldVC = R.storyboard.mine.hhPurchaseGoldViewController()!
                        self?.navigationController?.pushViewController(pGoldVC, animated: true)
                    }
                    coverView.sendBarSuccess = { [weak self] model, count, outOfChance in
                        cellView.card?.updateUIWithSuperLike()
                        self?.startSuperLikeStarAnimation()
                        executeAfterDelay(1, closure: {
                            self?.isSuperLike = true
                            self?.swipeableView.swipeTopView(inDirection: .up)
                            if model?.isMatched == true {
                                let matchedView = HHMatchSuccessView.matchView()
                                matchedView.showWithUser(user)
                                matchedView.beginChatClosure = {
                                    self?.startConversation(with: user)
                                }
                                return
                            }
                            if outOfChance {
                                executeAfterDelay(1, closure: {
                                    self?.showOutOfChancesView()
                                })
                            }
                        })
                    }
                    coverView.coverViewDismissed = {
                        cellView.swipeToUp(withAlpha: 0)
                    }
                    coverView.show()
                }
                self.isSuperLike = false
            default:
                break
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.superLikeButton.transform = .identity
                self.likeButton.transform = .identity
                self.passButton.transform = .identity
            })
            
            self.currentIndex = 0
            if self.swipeableView.activeViews().count <= 0 {
                log.debug("重新请求数据")
                self.checkAndGetLocation()
            }
        }
        /// Did cancel swiping view
        swipeableView.didCancel = {view in
            //print("Did cancel swiping view")
            let cellView = view as! HHDatingCardContainer
            cellView.reset()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.superLikeButton.transform  = .identity
                self.likeButton.transform       = .identity
                self.passButton.transform       = .identity
            })
        }
        
        /// Did tap at location
        swipeableView.didTap = {view, location in
            
            let cellView = view as! HHDatingCardContainer
            guard let userModel = cellView.card?.user else {
                return
            }
            
            let infoVC = R.storyboard.home.hhUserInfoViewController()!
            infoVC.profileModel = userModel
            let navi = HHBaseNavigationController(rootViewController: infoVC)
            navi.hero.isEnabled = true
            infoVC.prevType = .other
            infoVC.backClosure = { index in
                if self.currentIndex == index { return }
                self.currentIndex = index
                if let cardContainer = self.swipeableView.topView() as? HHDatingCardContainer, let topView = cardContainer.card {
                    let medias = userModel.profileMedias
                    if index < medias.count {
                        topView.updateMediaImageView(media: medias[index])
                    }
                }
            }
            
            infoVC.reloadActiveViewsClosure = {
                self.reloadActiveViewsData()
            }
            
            infoVC.backClosureWithAction = { [weak self] matchModel, direction, outOfChance in
                switch direction {
                case .left:
                    self?.bottomButtonClickAction((self?.passButton)!)
                case .right:
                    self?.bottomButtonClickAction((self?.likeButton)!)
                case .up:
                    cellView.card?.updateUIWithSuperLike()
                    self?.startSuperLikeStarAnimation()
                    if matchModel?.isMatched == true {
                        let matchedView = HHMatchSuccessView.matchView()
                        matchedView.showWithUser(userModel)
                        matchedView.beginChatClosure = {
                            self?.startConversation(with: userModel)
                        }
                        return
                    }
                    executeAfterDelay(1, closure: {
                        self?.isSuperLike = true
                        self?.swipeableView.swipeTopView(inDirection: .up)
                        
                        if outOfChance {
                            executeAfterDelay(1, closure: {
                                self?.showOutOfChancesView()
                            })
                        }
                    })
                default:
                    break
                }
            }
            infoVC.currentIndex = self.currentIndex
            self.present(navi, animated: true, completion: nil)
        }
    }
    
    // 回滚
    func rollback() {
        self.swipeableView.rewind()
        let cellView = (self.swipeableView.topView() as! HHDatingCardContainer).card
        cellView?.swipeToLeft(withAlpha: 0)
        cellView?.swipeToRight(withAlpha: 0)
        cellView?.swipeToUp(withAlpha: 1)
    }
}
 */
