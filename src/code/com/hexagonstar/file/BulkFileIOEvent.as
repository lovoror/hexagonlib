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

	import flash.events.Event;
	
	
	/**
	 * An event used for file operations. It defines constant event identifiers for file
	 * IO events. It also stores the HTTP Status value for HTTPStatus Events so that
	 * they can be traced back after the original event has already been removed.
	 */
	public class BulkFileIOEvent extends FileIOEvent
	{
		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------
		
		/** @private */
		protected var _bytesTotalCurrent:uint;
		/** @private */
		protected var _filesLoaded:uint;
		/** @private */
		protected var _filesTotal:uint;
		/** @private */
		protected var _ratioLoaded:Number;
		/** @private */
		protected var _weightedPercentage:Number;
		/** @private */
		protected var _bulkFile:IBulkFile;
		
		
		//-----------------------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Creates a new FileIOEvent instance.
		 * 
		 * @param type
		 * @param bulkFile
		 * @param text
		 * @param httpStatus
		 * @param bytesLoaded
		 * @param bytesTotal
		 * @param bytesTotalCurrent
		 * @param filesLoaded
		 * @param filesTotal
		 * @param weightedPercentage
		 */
		public function BulkFileIOEvent(type:String, bulkFile:IBulkFile = null, text:String = null,
			httpStatus:int = 0, bytesLoaded:uint = 0, bytesTotal:uint = 0, bytesTotalCurrent:uint = 0,
			filesLoaded:uint = 0, filesTotal:uint = 0, weightedPercentage:Number = 0)
		{
			super(type);
			
			_bulkFile = bulkFile;
			_text = text;
			_httpStatus = httpStatus;
			
			/* No need to waste time setting these for non-progress type events! */
			if (type == FileIOEvent.PROGRESS)
			{
				_bytesLoaded = bytesLoaded;
				_bytesTotal = bytesTotal;
				_bytesTotalCurrent = bytesTotalCurrent;
				_filesLoaded = filesLoaded;
				_filesTotal = filesTotal;
				_weightedPercentage = (isNaN(weightedPercentage) || !isFinite(weightedPercentage)) ? 0 : weightedPercentage;
				_percentage = _bytesTotal > 0 ? ((_bytesLoaded / _bytesTotal) * 100) : 0;
				if (!isFinite(_percentage)) _percentage = 0;
				_ratioLoaded = _filesTotal == 0 ? 0 : _filesLoaded / _filesTotal;
				if (!isFinite(_ratioLoaded)) _ratioLoaded = 0;
			}
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Public Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Clones the event.
		 */
		override public function clone():Event
		{
			return new BulkFileIOEvent(type, _bulkFile, _text, _httpStatus, _bytesLoaded,
				_bytesTotal, _bytesTotalCurrent, _filesLoaded, _filesTotal, _weightedPercentage);
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Getters & Setters
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Gets the bulkfile. Only for use with BulkFiles and the BulkLoader.
		 */
		internal function get bulkFile():IBulkFile
		{
			return _bulkFile;
		}
		
		
		/**
		 * A reference to the last loaded file.
		 */
		override public function get file():IFile
		{
			return _bulkFile.file;
		}
		
		
		public function get filesLoaded():uint
		{
			return _filesLoaded;
		}
		
		
		public function get filesTotal():uint
		{
			return _filesTotal;
		}
		
		
		public function get ratioLoaded():Number
		{
			return _ratioLoaded;
		}
		
		
		public function get weightedPercentage():Number
		{
			return _weightedPercentage;
		}
		
		
		public function get currentFileBytesLoaded():uint
		{
			return _bulkFile.bytesLoaded;
		}
		
		
		public function get currentFileBytesTotal():uint
		{
			return _bulkFile.bytesTotal;
		}
	}
}
