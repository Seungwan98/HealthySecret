//
//  CALayer+.swift
//  HealthySecret
//
//  Created by 양승완 on 4/6/24.
//

import Foundation
import QuartzCore
import UIKit

extension CALayer {

    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {

        for edge in arr_edge {

            let border = CALayer()

            switch edge {

            case UIRectEdge.top:
  
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)

            case UIRectEdge.bottom:
                
                
                
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                

            case UIRectEdge.left:
                
                
                
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)

            case UIRectEdge.right:
                
                
                
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)

            default:

                break

            }

            border.backgroundColor = color.cgColor

            self.addSublayer(border)

            
        }

    }

}
