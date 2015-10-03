//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

public class MaterialButton : UIButton {
	/**
		:name:	spotlight
	*/
	public lazy var spotlight: Bool = false
	
	/**
		:name:	visualLayer
	*/
	public private(set) lazy var visualLayer: MaterialLayer = MaterialLayer()
	
	/**
		:name:	pulseLayer
	*/
	public private(set) lazy var pulseLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	pulseColorOpacity
	*/
	public var pulseColorOpacity: CGFloat! {
		didSet {
			pulseColorOpacity = nil == pulseColorOpacity ? 0.25 : pulseColorOpacity!
			preparePulseLayer()
		}
	}
	
	/**
		:name:	pulseColor
	*/
	public var pulseColor: UIColor? {
		didSet {
			preparePulseLayer()
		}
	}
	
	/**
		:name:	backgroundColor
	*/
	public override var backgroundColor: UIColor? {
		get {
			return nil == layer.backgroundColor ? nil : UIColor(CGColor: layer.backgroundColor!)
		}
		set(value) {
			layer.backgroundColor = value?.CGColor
		}
	}
	
	/**
		:name:	x
	*/
	public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/**
		:name:	y
	*/
	public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
		}
	}
	
	/**
		:name:	width
	*/
	public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
			if nil != shape {
				layer.frame.size.height = value
			}
		}
	}
	
	/**
		:name:	height
	*/
	public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
			if nil != shape {
				layer.frame.size.width = value
			}
		}
	}
	
	/**
		:name:	shadowColor
	*/
	public var shadowColor: UIColor! {
		didSet {
			layer.shadowColor = nil == shadowColor ? MaterialColor.clear.CGColor : shadowColor!.CGColor
		}
	}
	
	/**
		:name:	shadowOffset
	*/
	public var shadowOffset: CGSize! {
		didSet {
			layer.shadowOffset = nil == shadowOffset ? CGSizeMake(0, 0) : shadowOffset!
		}
	}
	
	/**
		:name:	shadowOpacity
	*/
	public var shadowOpacity: Float! {
		didSet {
			layer.shadowOpacity = nil == shadowOpacity ? 0 : shadowOpacity!
		}
	}
	
	/**
		:name:	shadowRadius
	*/
	public var shadowRadius: CGFloat! {
		didSet {
			layer.shadowRadius = nil == shadowRadius ? 0 : shadowRadius!
		}
	}
	
	/**
		:name:	masksToBounds
	*/
	public var masksToBounds: Bool! {
		didSet {
			visualLayer.masksToBounds = nil == masksToBounds ? false : masksToBounds!
		}
	}
	
	/**
		:name:	cornerRadius
	*/
	public var cornerRadius: MaterialRadius! {
		didSet {
			layer.cornerRadius = MaterialRadiusToValue(nil == cornerRadius ? .None : cornerRadius!)
			if .Circle == shape {
				shape = nil
			}
		}
	}
	
	/**
		:name:	shape
	*/
	public var shape: MaterialShape? {
		didSet {
			if nil != shape {
				if width < height {
					layer.frame.size.width = height
				} else {
					layer.frame.size.height = width
				}
			}
		}
	}
	
	/**
		:name:	borderWidth
	*/
	public var borderWidth: MaterialBorder! {
		didSet {
			layer.borderWidth = MaterialBorderToValue(nil == borderWidth ? .None : borderWidth!)
		}
	}
	
	/**
		:name:	borderColor
	*/
	public var borderColor: UIColor! {
		didSet {
			layer.borderColor = nil == borderColor ? MaterialColor.clear.CGColor : borderColor!.CGColor
		}
	}
	
	/**
		:name:	shadowDepth
	*/
	public var shadowDepth: MaterialDepth! {
		didSet {
			let value: MaterialDepthType = MaterialDepthToValue(nil == shadowDepth ? .None : shadowDepth!)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
		}
	}
	
	/**
		:name:	position
	*/
	public var position: CGPoint {
		get {
			return layer.position
		}
		set(value) {
			layer.position = value
		}
	}
	
	/**
		:name:	zPosition
	*/
	public var zPosition: CGFloat! {
		didSet {
			layer.zPosition = zPosition
		}
	}
	
	/**
		:name:	contentInsets
	*/
	public var contentInsets: MaterialInsets! {
		didSet {
			let value: MaterialInsetsType = MaterialInsetsToValue(nil == contentInsets ? .None : contentInsets)
			contentEdgeInsets = UIEdgeInsetsMake(value.top, value.left, value.bottom, value.right)
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}

	/**
		:name:	layerClass
	*/
	public override class func layerClass() -> AnyClass {
		return MaterialLayer.self
	}
	
	/**
		:name:	layoutSubviews
	*/
	public override func layoutSubviews() {
		super.layoutSubviews()
		prepareShape()
		
		visualLayer.frame = bounds
		visualLayer.cornerRadius = layer.cornerRadius
	}
	
	/**
		:name:	animation
	*/
	public func animation(animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == layer.presentationLayer() ? layer : layer.presentationLayer() as! CALayer).valueForKeyPath(a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			layer.addAnimation(a, forKey: a.keyPath!)
			if true == filterAnimations(a) {
				visualLayer.addAnimation(a, forKey: a.keyPath!)
			}
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			layer.addAnimation(a, forKey: nil)
			filterAnimations(a)
			visualLayer.addAnimation(a, forKey: nil)
		}
	}
	
	/**
		:name:	animationDidStart
		public override func animationDidStart(anim: CAAnimation) {}
	*/
	
	/**
		:name:	animationDidStop
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				CATransaction.begin()
				CATransaction.setDisableActions(true)
				layer.setValue(nil == b.toValue ? b.byValue : b.toValue, forKey: b.keyPath!)
				CATransaction.commit()
			}
			layer.removeAnimationForKey(a.keyPath!)
			visualLayer.removeAnimationForKey(a.keyPath!)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
	}
	
	//
	//	:name:	filterAnimations
	//
	internal func filterAnimations(animation: CAAnimation) -> Bool? {
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			return "position" != a.keyPath && "transform" != a.keyPath && "backgroundColor" != a.keyPath
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			for var i: Int = a.animations!.count - 1; 0 <= i; --i {
				if let b: CAPropertyAnimation = a.animations![i] as? CAPropertyAnimation {
					if false == filterAnimations(b) {
						a.animations!.removeAtIndex(i)
					}
				}
			}
		}
		return nil
	}
	
	/**
		:name:	touchesBegan
	*/
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		let point: CGPoint = layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer)
		if true == layer.containsPoint(point) {
			let s: CGFloat = (width < height ? height : width) / 2
			let f: CGFloat = 3
			var v: CGFloat = s / f
			MaterialAnimation.animationDisabled({
				self.pulseLayer.hidden = false
				self.pulseLayer.bounds = CGRectMake(0, 0, v, v)
				self.pulseLayer.position = point
				self.pulseLayer.cornerRadius = s / 6
			})
			
			v = 2 * f
			MaterialAnimation.animationWithDuration(0.4, animations: {
				self.pulseLayer.transform = CATransform3DMakeScale(v, v, v)
			})
			
			MaterialAnimation.animationWithDuration(0.25, animations: {
				self.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1.05)
			})
		}
	}
	
	/**
		:name:	touchesMoved
	*/
	public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
		if spotlight {
			let point: CGPoint = layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer)
			if true == layer.containsPoint(point) {
				MaterialAnimation.animationDisabled({
					self.pulseLayer.position = point
				})
			}
		}
	}
	
	/**
		:name:	touchesEnded
	*/
	public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
		shrink()
	}
	
	/**
		:name:	touchesCancelled
	*/
	public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
		shrink()
	}
	
	/**
		:name:	actionForLayer
	*/
	public override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
		return nil // returning nil enables the animations for the layer property that are normally disabled.
	}
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		// visualLayer
		visualLayer.zPosition = -1
		layer.addSublayer(visualLayer)
		
		// pulseLayer
		pulseLayer.hidden = true
		pulseLayer.zPosition = 1
		visualLayer.addSublayer(pulseLayer)
	}
	
	//
	//	:name:	prepareShape
	//
	internal func prepareShape() {
		if .Circle == shape {
			layer.cornerRadius = width / 2
		}
	}
	
	//
	//	:name:	preparePulseLayer
	//
	internal func preparePulseLayer() {
		pulseLayer.backgroundColor = pulseColor?.colorWithAlphaComponent(pulseColorOpacity!).CGColor
	}
	
	//
	//	:name:	shrink
	//
	internal func shrink() {
		MaterialAnimation.animationWithDuration(0.25, animations: {
			self.pulseLayer.hidden = true
			self.pulseLayer.transform = CATransform3DIdentity
			self.layer.transform = CATransform3DIdentity
		})
	}
}