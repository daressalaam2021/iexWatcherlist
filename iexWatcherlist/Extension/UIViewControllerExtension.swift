//
//  UIViewControllerExtension.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/5/21.
//

import Foundation
import UIKit

extension UIViewController {
    var topBarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0
        if let nav = self as? UINavigationController {
            top = nav.navigationBar.frame.height
        }
        top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return top
    }
}
