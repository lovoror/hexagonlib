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
package com.hexagonstar.file
{
	import com.hexagonstar.file.types.IFile;
	import com.hexagonstar.signals.Signal;
	
	
	public class FileIOSignal extends Signal
	{
		//-----------------------------------------------------------------------------------------
		// Constants
		//-----------------------------------------------------------------------------------------
		
		public static const OPEN:String					= "fileIOOpen";
		public static const PROGRESS:String				= "fileIOProgress";
		public static const FILE_COMPLETE:String		= "fileIOFileComplete";
		public static const ALL_COMPLETE:String			= "fileIOAllComplete";
		public static const ABORT:String				= "fileIOAbort";
		public static const PAUSE:String				= "fileIOPause";
		public static const UNPAUSE:String				= "fileIOUnpause";
		public static const HTTP_STATUS:String			= "fileIOHTTPStatus";
		public static const IO_ERROR:String				= "fileIOIOError";
		public static const SECURITY_ERROR:String		= "fileIOSecurityError";
		
		
		//-----------------------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Creates a new FileIOEvent instance.
		 */
		public function FileIOSignal()
		{
			super(IFile);
		}
	}
}
