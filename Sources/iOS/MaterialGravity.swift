/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit

@objc(MaterialGravity)
public enum MaterialGravity: Int {
	case Center
	case Top
	case Bottom
	case Left
	case Right
	case TopLeft
	case TopRight
	case BottomLeft
	case BottomRight
	case Resize
	case ResizeAspect
	case ResizeAspectFill
}

/// Converts the MaterialGravity enum to a String value.
public func MaterialGravityToValue(gravity: MaterialGravity) -> String {
	switch gravity {
	case .Center:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.center)
	case .Top:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.top)
	case .Bottom:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.bottom)
	case .Left:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.left)
	case .Right:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.right)
	case .TopLeft:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.bottomLeft)
	case .TopRight:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.bottomRight)
	case .BottomLeft:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.topLeft)
	case .BottomRight:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.topRight)
	case .Resize:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.resize)
	case .ResizeAspect:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.resizeAspect)
	case .ResizeAspectFill:
		return convertFromCALayerContentsGravity(CALayerContentsGravity.resizeAspectFill)
	}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCALayerContentsGravity(_ input: CALayerContentsGravity) -> String {
	return input.rawValue
}
