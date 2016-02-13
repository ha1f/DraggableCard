//
//  ViewController.swift
//  draggableCard
//
//  Created by 山口智生 on 2016/02/13.
//  Copyright © 2016年 ha1f. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let field = DraggableImageViewField(frame: CGRectMake(0, 0, 300, 300))
        field.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(field)
        
        
        let imageView = DraggableImageView()
        imageView.backgroundColor = UIColor.redColor()
        imageView.frame = CGRectMake(100, 50, 125, 100)
        imageView.userInteractionEnabled = false
        field.addCard(imageView)
        
        let imageView2 = DraggableImageView()
        imageView2.backgroundColor = UIColor.redColor()
        imageView2.frame = CGRectMake(50, 150, 125, 100)
        imageView2.userInteractionEnabled = false
        field.addCard(imageView2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

