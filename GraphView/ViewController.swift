//
//  ViewController.swift
//  GraphView
//
//  Created by winify on 5/12/16.
//  Copyright © 2016 Costraci Mihail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.backgroundColor = UIColor.grayColor();
		
		
		var graphView: GraphView = GraphView(frame: CGRectMake(50, 50, 225, 225))
		graphView.drawRect(CGRectMake(50, 50, 225, 225))
		self.view.addSubview(graphView)

	
	}
	

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

