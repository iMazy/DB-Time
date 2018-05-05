//
//  DBMovieCardView.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/4.
//  Copyright © 2018 Mazy. All rights reserved.
// 

import UIKit

class DBMovieCardView: UIView {

    @IBOutlet weak var coverImageView: UIImageView!
    var cardMovie: DBMovieSubject?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setupWithUser(movie: DBMovieSubject) {
        cardMovie = movie
        coverImageView.setImage(with: URL(string: movie.images.medium))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.y")
//        rotateAnimation.values = [0, Double.pi * 2]
//        rotateAnimation.duration = 2
//        rotateAnimation.keyTimes = [0, 2]
//        rotateAnimation.repeatCount = 1
//        rotateAnimation.autoreverses = false
//        rotateAnimation.delegate = self
//        self.layer.add(rotateAnimation, forKey: "transform.rotation.y")
    }
    
    func setup() {
        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        // Corner Radius
        layer.cornerRadius = 10.0
    }

}

extension DBMovieCardView: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        print("animation Did Start")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.coverImageView.image = #imageLiteral(resourceName: "background_image")
        }
    }
}
