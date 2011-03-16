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
package com.hexagonstar.data.types
{
	import flash.geom.ColorTransform;
	
	
	/**
	 * RGB Data type used to store RGB value and convert them from/to hex etc.
	 */
	public class RGB
	{
		// -----------------------------------------------------------------------------------------
		// Properties
		// -----------------------------------------------------------------------------------------
		
		/**
		 * Red channel.
		 */
		public var r:uint;
		
		/**
		 * Green channel.
		 */
		public var g:uint;
		
		/**
		 * Blue channel.
		 */
		public var b:uint;
		
		/** @private */
		protected var _ct:ColorTransform;
		
		
		// -----------------------------------------------------------------------------------------
		// Constructor
		// -----------------------------------------------------------------------------------------
		/**
		 * Creates a new instance of the class.
		 * 
		 * @param r
		 * @param g
		 * @param b
		 */
		public function RGB(r:uint = 0, g:uint = 0, b:uint = 0)
		{
			this.r = r;
			this.g = g;
			this.b = b;
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Public Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Utility method to convert a uint color value to a six character hex string.
		 * 
		 * @param value RGB hex/oct value as uint.
		 * @return A 6 character string representing the RGB hex/oct value.
		 */
		public static function uintToHex(value:uint):String
		{
			var ct:ColorTransform = new ColorTransform();
			ct.color = value;
			return new RGB(ct.redOffset, ct.greenOffset, ct.blueOffset).hexString;
		}
		
		
		/**
		 * Utility method to convert a hex color string to a uint color value.
		 * 
		 * @param value Hexadecimal color string. The string may start with #, 0x
		 *        or the value itself, e.g. #FF00FF, 0xFF00FF or FF00FF.
		 * @return A uint with the RGB color value.
		 */
		public static function hexToUint(value:String):uint
		{
			var rgb:RGB = new RGB();
			rgb.hexString = value;
			return rgb.value;
		}
		
		
		// -----------------------------------------------------------------------------------------
		// Getters & Setters
		// -----------------------------------------------------------------------------------------
		
		/**
		 * The RGB value based on a hex/oct value hex as string.
		 */
		public function get hexString():String
		{
			var s:String = RGB.convertChannelToHexString(r)
				+ RGB.convertChannelToHexString(g)
				+ RGB.convertChannelToHexString(b);
			var l:uint = s.length;
			if (l < 6)
			{
				for (var i:uint; i < (6 - l); i++)
					s += "0";
			}
			return s.toUpperCase();
		}
		public function set hexString(v:String):void
		{
			if (v.substr(0, 1) == "#") v = v.substr(1);
			else if (v.substr(0, 2).toLowerCase() == "0x") v = v.substr(2);
			var ct:ColorTransform = getColorTransform();
			ct.color = uint(v);
			r = ct.redOffset;
			g = ct.greenOffset;
			b = ct.blueOffset;
		}
		
		
		/**
		 * Gets the octal value of the RGB object as a string.
		 */
		public function get octalString():String
		{
			return "0x" + hexString;
		}
		
		
		/**
		 * Gets the hex/oct value of the RGB object as uint.
		 */
		public function get value():uint
		{
			var ct:ColorTransform = getColorTransform();
			ct.redOffset = r;
			ct.greenOffset = g;
			ct.blueOffset = b;
			return ct.color;
		}
		public function set value(v:uint):void
		{
			var ct:ColorTransform = getColorTransform();
			ct.color = v;
			r = ct.redOffset;
			g = ct.greenOffset;
			b = ct.blueOffset;
		}
		
		
		// -----------------------------------------------------------------------------------------
		// Private Methods
		// -----------------------------------------------------------------------------------------
		
		/**
		 * Lazy ColorTransform producer.
		 */
		protected function getColorTransform():ColorTransform
		{
			if (!_ct) _ct = new ColorTransform();
			return _ct;
		}
		
		
		/**
		 * Converts the uint chanel representation of a color to a hex string.
		 * 
		 * @param v Hex value.
		 * @return the string representation of the hex, this does not return the RGB
		 *         format of a hex like 00FF00 use uintToRGBHex getting a string that is
		 *         always 6 characters long.
		 */
		protected static function convertChannelToHexString(v:uint):String
		{
			if (v > 255) v = 255;
			var s:String = v.toString(16);
			if (s.length < 2) s = "0" + s;
			return s;
		}
	}
}
