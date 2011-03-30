/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.util.debug{	/**	 * A logger implementation that delegates logging outputs made in hexagonlib classes	 * to an external logger that registered as a logger with this class.	 */	public class HLog	{		//-----------------------------------------------------------------------------------------		// Properties		//-----------------------------------------------------------------------------------------				/** @private */		private static var _externalLogger:Class;						//-----------------------------------------------------------------------------------------		// Public Methods		//-----------------------------------------------------------------------------------------				/**		 * Registers a static external logging class for HLog to forward logging output to.		 * The static logger must implement a static method called <code>logByLevel</code>		 * that uses the following signature: <code>logByLevel(level:int, data:*):void</code>.		 * The external logger needs to take care from there on to redirect the logging		 * output correctly.		 * 		 * @param logger The static, external logging class.		 * @see #LogLevel		 */		public static function registerExternalLogger(logger:Class):void		{			_externalLogger = logger;		}						/**		 * Forwards logging data with a logging level that equals LogLevel.TRACE to a		 * registered external logger.		 * 		 * @param data The logging data to forward.		 * @see #LogLevel		 */		public static function trace(data:*):void		{			if (_externalLogger) _externalLogger["logByLevel"](LogLevel.TRACE, data);		}						/**		 * Forwards logging data with a logging level that equals LogLevel.DEBUG to a		 * registered external logger.		 * 		 * @param data The logging data to forward.		 * @see #LogLevel		 */		public static function debug(data:*):void		{			if (_externalLogger) _externalLogger["logByLevel"](LogLevel.DEBUG, data);		}				/**		 * Forwards logging data with a logging level that equals LogLevel.INFO to a		 * registered external logger.		 * 		 * @param data The logging data to forward.		 * @see #LogLevel		 */		public static function info(data:*):void		{			if (_externalLogger) _externalLogger["logByLevel"](LogLevel.INFO, data);		}				/**		 * Forwards logging data with a logging level that equals LogLevel.WARN to a		 * registered external logger.		 * 		 * @param data The logging data to forward.		 * @see #LogLevel		 */		public static function warn(data:*):void		{			if (_externalLogger) _externalLogger["logByLevel"](LogLevel.WARN, data);		}				/**		 * Forwards logging data with a logging level that equals LogLevel.ERROR to a		 * registered external logger.		 * 		 * @param data The logging data to forward.		 * @see #LogLevel		 */		public static function error(data:*):void		{			if (_externalLogger) _externalLogger["logByLevel"](LogLevel.ERROR, data);		}				/**		 * Forwards logging data with a logging level that equals LogLevel.FATAL to a		 * registered external logger.		 * 		 * @param data The logging data to forward.		 * @see #LogLevel		 */		public static function fatal(data:*):void		{			if (_externalLogger) _externalLogger["logByLevel"](LogLevel.FATAL, data);		}	}}