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
package com.hexagonstar.display.shape{	import flash.display.JointStyle;	import flash.display.LineScaleMode;	import flash.display.Shape;
	
		/**	 * RectangleShape represents a rectangular shape that is drawn with	 * the ActionScript Drawing API.	 */	public class RectangleShape extends Shape	{		//-----------------------------------------------------------------------------------------		// Constructor		//-----------------------------------------------------------------------------------------				/**		 * Creates a new RectangleShape instance.		 * 		 * @param width The width of the rectangle.		 * @param height The height of the rectangle.		 * @param fillColor The fill color for the rectangle.		 * @param fillAlpha The fill alpha for the rectangle.		 * @param lineThickness Determines the thickness of the border line.		 * @param lineColor The line color for the rectangle.		 * @param lineAlpha The line alpha for the rectangle.		 */		public function RectangleShape(width:int = 0, height:int = 0, fillColor:uint = 0xFF00FF,			fillAlpha:Number = 1.0, lineThickness:Number = NaN, lineColor:uint = 0x000000,			lineAlpha:Number = 1.0)		{			if (width > 0 && height > 0)				draw(width, height, fillColor, fillAlpha, lineThickness, lineColor, lineAlpha);		}						//-----------------------------------------------------------------------------------------		// Public Methods		//-----------------------------------------------------------------------------------------				/**		 * Draws the RectangleShape.		 * 		 * @param width The width of the rectangle.		 * @param height The height of the rectangle.		 * @param fillColor The fill color for the rectangle.		 * @param fillAlpha The fill alpha for the rectangle.		 * @param lineThickness Determines the thickness of the border line.		 * @param lineColor The line color for the rectangle.		 * @param lineAlpha The line alpha for the rectangle.		 */		public function draw(width:int, height:int, fillColor:uint = 0xFF00FF, fillAlpha:Number = 1.0,			lineThickness:Number = NaN, lineColor:uint = 0x000000, lineAlpha:Number = 1.0):void		{			graphics.clear();			graphics.lineStyle(lineThickness, lineColor, lineAlpha, true, LineScaleMode.NORMAL,				null, JointStyle.MITER);			graphics.beginFill(fillColor, fillAlpha);			graphics.drawRect(0, 0, width, height);			graphics.endFill();		}	}}