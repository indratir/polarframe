//
//  Square.swift
//  PolarFrame
//
//  Created by Indra Tirta Nugraha on 03/10/20.
//  Copyright © 2020 Indra Tirta Nugraha. All rights reserved.
//

import UIKit

class Square: UIView {

    @IBOutlet var canvasView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func create(selectedImage: UIImage?, size: CGSize) -> UIImage? {
        let canvas = Square(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        canvas.selectedImage = selectedImage
        canvas.commonInit()
        
        let image = canvas.image()
        
        return image
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Square", owner: self, options: nil)
        canvasView.frame = self.frame
        self.addSubview(canvasView)
        
        imageView.image = selectedImage
        
        self.layoutIfNeeded()
    }
    
    private func image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        
        return nil
    }
}
