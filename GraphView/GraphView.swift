//
//  GraphView.swift
//  GraphView
//
//  Created by winify on 5/12/16.
//  Copyright © 2016 Costraci Mihail. All rights reserved.
//

import UIKit


func RGBColor (hex: Int, alpha: Double = 1.0) -> UIColor {
	let red = Double((hex & 0xFF0000) >> 16) / 255.0
	let green = Double((hex & 0xFF00) >> 8) / 255.0
	let blue = Double((hex & 0xFF)) / 255.0
	let color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
	return color
}




class GraphView: UIView {

	//Weekly sample data
	var graphPoints:[Int] = [4, 2, 6, 4, 5, 8, 3]
	
	//1 - THE PROPERTIES FOR THE GRADIENT
	var startColor: UIColor = RGBColor(0xFEC59E, alpha: 1.0)
	var endColor: UIColor = RGBColor(0xF44106, alpha: 1.0)

	
	override init(frame: CGRect) {
		super.init(frame: frame)
	
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	override func drawRect(rect: CGRect) {
		super.drawRect(rect)
		
		let width = rect.width
		let height = rect.height
		
		self.layer.cornerRadius = 10

		
//		//set up background clipping area
//		var path = UIBezierPath(roundedRect: rect,
//		                        byRoundingCorners: UIRectCorner.AllCorners,
//		                        cornerRadii: CGSize(width: 8.0, height: 8.0))
//		path.addClip()
//		
		
		//2 - GET THE CURRENT CONTEXT
		let context = UIGraphicsGetCurrentContext()
		let colors = [startColor.CGColor, endColor.CGColor]
		
		//3 - SET UP THE COLOR SPACE
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		
		//4 - set up the color stops
		let colorLocations:[CGFloat] = [0.0, 1.0]
		
		//5 - CREATE THE GRADIENT
		let gradient = CGGradientCreateWithColors(colorSpace,
		                                          colors,
		                                          colorLocations)
		
		//6 - DRAW THE GRADIENT
		var startPoint = CGPoint.zero
		var endPoint = CGPoint(x:0, y:self.bounds.height)
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions(rawValue: 0))

		
		
		
		//CALCULATE THE X POINT
		
		let margin:CGFloat = 20.0
		var columnXPoint = { (column:Int) -> CGFloat in
			//Calculate gap between points
			let spacer = (width - margin*2 - 4) /
				CGFloat((self.graphPoints.count - 1))
			var x:CGFloat = CGFloat(column) * spacer
			x += margin + 2
			return x
		}
		
		// CALCULATE THE Y POINT
		
		let topBorder:CGFloat = 60
		let bottomBorder:CGFloat = 50
		let graphHeight = height - topBorder - bottomBorder
		let maxValue = graphPoints.maxElement()
		var columnYPoint = { (graphPoint:Int) -> CGFloat in
			var y:CGFloat = CGFloat(graphPoint) /
				CGFloat(maxValue!) * graphHeight
			y = graphHeight + topBorder - y // Flip the graph
			return y

		}
		
		
		// DRAW THE LINE GRAPH
		
		UIColor.whiteColor().setFill()
		UIColor.whiteColor().setStroke()
		
		//SET UP THE POINTS LINE
		var graphPath = UIBezierPath()
		//GO TO START OF LINE
		graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
			y:columnYPoint(graphPoints[0])))
		
		//ADD POINTS FOR EACH ITEM IN THE GRAPHPOINTS ARRAY
		//AT THE CORRECT (X, Y) FOR THE POINT
		for i in 1..<graphPoints.count {
			let nextPoint = CGPoint(x:columnXPoint(i),
			                        y:columnYPoint(graphPoints[i]))
			graphPath.addLineToPoint(nextPoint)
		}
		
		graphPath.stroke()
		
		
		//Create the clipping path for the graph gradient
		
		//1 - save the state of the context (commented out for now)
		//CGContextSaveGState(context)
		
		//2 - make a copy of the path
		var clippingPath = graphPath.copy() as! UIBezierPath
		
		//3 - add lines to the copied path to complete the clip area
		clippingPath.addLineToPoint(CGPoint(
			x: columnXPoint(graphPoints.count - 1),
			y:height))
		clippingPath.addLineToPoint(CGPoint(
			x:columnXPoint(0),
			y:height))
		clippingPath.closePath()
		
		//4 - add the clipping path to the context
		clippingPath.addClip()
		
		let highestYPoint = columnYPoint(maxValue!)
		startPoint = CGPoint(x:margin, y: highestYPoint)
		endPoint = CGPoint(x:margin, y:self.bounds.height)
		
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,  CGGradientDrawingOptions(rawValue: 0))
		//CGContextRestoreGState(context)
		
		
	
	
	}
}
