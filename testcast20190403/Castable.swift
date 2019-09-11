//
//  Castable.swift
//  testcast20190326
//
//  Created by Maximus Peters on 3/28/19.
//  Copyright © 2019 Maximus Peters. All rights reserved.
//

import Foundation
import GoogleCast

protocol Castable {
    var googleCastBarButton: UIBarButtonItem! { get }
}

extension Castable where Self:UIViewController {
    var googleCastBarButton: UIBarButtonItem! {
        let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        castButton.tintColor = .purple
        return UIBarButtonItem(customView: castButton)
    }
}
