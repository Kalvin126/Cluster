//
//  ClusterView.swift
//  Cluster
//
//  Created by Kalvin Loc on 4/26/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

class ClusterView: UIView {

    @IBOutlet weak var rpmBar: UIView!
    @IBOutlet weak var rpmWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var speedometerLabel: UILabel!
    @IBOutlet weak var speedometerUnitLabel: UILabel!

    @IBOutlet weak var leftSideBarView: UIView!
    @IBOutlet weak var gearLabel: UILabel!
    @IBOutlet weak var engineTempLabel: UILabel!
    @IBOutlet weak var engineTempImageView: UIImageView!
    @IBOutlet weak var gasLevelLabel: UILabel!
    @IBOutlet weak var fuelImageView: UIImageView!
    
    @IBOutlet weak var rightSideBarView: UIView!
    @IBOutlet weak var instantMPGLabel: UILabel!
    @IBOutlet weak var instantMPGImageView: UIImageView!
    @IBOutlet weak var avgMPGLabel: UILabel!
    @IBOutlet weak var tpsLabel: UILabel!
    @IBOutlet weak var tpsImageView: UIImageView!
    
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var distanceTraveledLabel: UILabel!
    
    @IBOutlet var tachLetterConsts: [NSLayoutConstraint]!

    
    let animationSpeed = 0.1
    let blinkSpeed = 0.3
    
    var darkTheme = false {
        didSet {
            if darkTheme {
                speedometerLabel.textColor     = UIColor.white
                speedometerUnitLabel.textColor = UIColor.white
            }
            else {
                speedometerLabel.textColor     = UIColor.black
                speedometerUnitLabel.textColor = UIColor.black
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Helper func
    
    func setup() {
        backgroundColor = .black
//        engineTempImageView.clipsToBounds = false
//        fuelImageView.clipsToBounds       = false
//        instantMPGImageView.clipsToBounds = false
//        tpsImageView.clipsToBounds        = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//
//        let raddii = CGSize(width: 10.0, height: 10.0)
//        
//        let leftMaskPath = UIBezierPath(roundedRect: leftSideBarView.bounds,
//                                        byRoundingCorners: .BottomRight,
//                                        cornerRadii: raddii)
//        let leftShape = CAShapeLayer()
//        leftShape.path = leftMaskPath.CGPath
//        leftSideBarView.layer.mask = leftShape
//        
//        let rightMaskPath = UIBezierPath(roundedRect: rightSideBarView.bounds,
//                                         byRoundingCorners: .BottomLeft,
//                                         cornerRadii: raddii)
//        let rightShape = CAShapeLayer()
//        rightShape.path = rightMaskPath.CGPath
//        rightSideBarView.layer.mask = rightShape
//        
        engineTempImageView.layer.cornerRadius = engineTempImageView.frame.height/2
        fuelImageView.layer.cornerRadius       = fuelImageView.frame.height/2
        instantMPGImageView.layer.cornerRadius = instantMPGImageView.frame.height/2
        tpsImageView.layer.cornerRadius        = tpsImageView.frame.height/2
        
        layoutTachNumbers()
    }

    func horizontalOffsetFromDirection(_ dir: String, by percent: Double) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let offset = screenWidth * CGFloat(percent)
        
        return (dir == "right" ? screenWidth - offset : offset)
    }
    
    // MARK: RPM View
    
    fileprivate func layoutTachNumbers() {
        tachLetterConsts.forEach {
            let letterLabel = $0.firstItem as? UILabel ?? $0.secondItem as! UILabel
            
            let percent = (Double(letterLabel.text!)! * 1000.0)/Double(Konstants.RPM.max)
            $0.constant = horizontalOffsetFromDirection("left", by: percent) - letterLabel.frame.size.width/2
        }
    }

    func updateRPMBarWithRPM(_ rpm: Int, and status: FuelSystemStatus) {
        rpmWidthConstraint.constant = horizontalOffsetFromDirection("right", by: Double(rpm)/Double(Konstants.RPM.max))
        
        var color = UIColor.white
        
        if status == .OpenLoopDrive {
            color = .green
        } else if rpm >= Konstants.RPM.warning {
            color = .red
        }
        
        UIView.animate(withDuration: animationSpeed) {
            self.layoutIfNeeded()
            
            self.rpmBar.backgroundColor = color
        }
    }
    
    // MARK: Engine Coolant
    
    func updateCoolantStatusWithTemperature(_ Temperature: Double) {
        var color = UIColor.clear
        
        switch Temperature {
        case 1..<Konstants.EngineCoolant.warmTemp:
            color = UIColor.blue
        case Konstants.EngineCoolant.hotTemp...300.0:
            color = UIColor.red
        default:
            break
        }
        
        if color != UIColor.clear {
            UIView.animate(withDuration: blinkSpeed, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                self.engineTempImageView.backgroundColor = color
            }, completion: nil)
        }
        else {
            // Reset View
            engineTempImageView.layer.removeAllAnimations()
            engineTempImageView.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: Fuel 
    
    func updateFuelLevel( level: Double) {
        fuelImageView.backgroundColor = (level > Konstants.Fuel.low ? UIColor.clear : UIColor.red)
    }

    // MARK: TPS
    
    func setTPSStatus(forPosition pos: Double) {
        if pos >= Konstants.tpsWarn {
            UIView.animate(withDuration: blinkSpeed, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                self.tpsImageView.backgroundColor = UIColor.yellow
            }, completion: nil)
        }
        else {
            // Reset View
            tpsImageView.layer.removeAllAnimations()
            tpsImageView.backgroundColor = UIColor.clear
        }
    }
}
