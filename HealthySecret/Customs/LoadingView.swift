//
//  LoadingView.swift
//  HealthySecret
//
//  Created by 양승완 on 5/8/24.
//

import Foundation
import UIKit

final class MyLoadingView: UIView {
  private let contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.alpha = 0
    return view
  }()
  private let loadingView: AnimationView = {
    let view = AnimationView(name: "loading_ball")
    view.loopMode = .loop
    return view
  }()
}
