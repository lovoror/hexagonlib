/*
 * hexagonlib - Multi-Purpose ActionScript 3 Library.
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/  LIBRARY _/
 *            \__/  \__/
 *
 * Licensed under the MIT License
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package com.hexagonstar.display.shape
{
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	
	/**
	 * RectangleGradientShape is a rectangle shape filled with a color gradient.
	 */
	public class RectangleGradientShape extends Shape
	{
		//-----------------------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Creates a new RectangleGradientShape instance.
		 * 
		 * @param width The width of the rectangle.
		 * @param height The height of the rectangle.
		 * @param rotation The rotation of the gradient.
		 * @param colors The color values for the gradient. The default is [0x000000, 0xFFFFFF].
		 * @param alphas The alpha values for the gradient. The default is [1.0, 1.0].
		 * @param ratios The ratio values for the gradient. The default is [0, 255].
		 */
		public function RectangleGradientShape(width:int = 0, height:int = 0, rotation:Number = -90,
			colors:Array = null, alphas:Array = null, ratios:Array = null)
		{
			if (width > 0 && height > 0) draw(width, height, rotation, colors, alphas, ratios);
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Public Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Draws the RectangleShape.
		 * 
		 * @param width The width of the rectangle.
		 * @param height The height of the rectangle.
		 * @param rotation The rotation of the gradient.
		 * @param colors The color values for the gradient. The default is [0x000000, 0xFFFFFF].
		 * @param alphas The alpha values for the gradient. The default is [1.0, 1.0].
		 * @param ratios The ratio values for the gradient. The default is [0, 255].
		 */
		public function draw(width:int = 0, height:int = 0, rotation:Number = -90,
			colors:Array = null, alphas:Array = null, ratios:Array = null):void
		{
			if (!colors) colors = [0x000000, 0xFFFFFF];
			if (!alphas) alphas = [1.0, 1.0];
			if (!ratios) ratios = [0, 255];
			
			var m:Matrix = new Matrix();
			m.createGradientBox(width, height, (rotation * Math.PI / 180));
			
			graphics.clear();
			graphics.lineStyle();
			graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, m,
				SpreadMethod.PAD, InterpolationMethod.RGB);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}
