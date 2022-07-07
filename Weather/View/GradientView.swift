//
//  GradientView.swift
//  Weather
//
//  Created by Steven Sullivan on 7/1/22.
//

import UIKit

class GradientView: UIView {

    lazy var colorSelection = blueGradient
    
    @IBAction func colorBtnTapped(_ sender: Any) {
        switch colorSelection {
        case blueGradient:
            colorSelection = greenGradient
        case greenGradient:
            colorSelection = redGradient
        case redGradient:
            colorSelection = blueGradient
        default:
            colorSelection = redGradient
        }
        initGradient()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.initGradient()
         }
    }
    
    var redGradient: [CGColor] { [ #colorLiteral(red: 0.8952698708, green: 0.6801822782, blue: 0.4841313362, alpha: 1).cgColor, #colorLiteral(red: 0.7562651038, green: 0.3155059218, blue: 0.4367308319, alpha: 1).cgColor ] }
    var blueGradient: [CGColor] { [ #colorLiteral(red: 0.4388540089, green: 0.6567905545, blue: 0.7945474982, alpha: 1).cgColor, #colorLiteral(red: 0.2357676029, green: 0.2999535799, blue: 0.5365664363, alpha: 1).cgColor ] }
    var greenGradient: [CGColor] { [ #colorLiteral(red: 0.7759577632, green: 0.8280290365, blue: 0.504925549, alpha: 1).cgColor, #colorLiteral(red: 0.4166629314, green: 0.5409178138, blue: 0.2852984071, alpha: 1).cgColor ] }
    
    func initGradient() {
        let gradientLayer = CAGradientLayer()
    
        gradientLayer.startPoint = CGPoint(x: 0.30, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.70, y: 1)
        gradientLayer.frame = superview!.bounds
        gradientLayer.colors = colorSelection
        gradientLayer.shouldRasterize = true
        self.layer.addSublayer(gradientLayer)
    }

}
