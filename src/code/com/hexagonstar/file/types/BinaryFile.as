/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.file.types{	import com.hexagonstar.constants.Status;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.utils.ByteArray;	import flash.utils.getQualifiedClassName;			/**	 * Dispatched after the file's content has been loaded. This event is always	 * broadcasted after the file finished loading, regardless whether it's content data	 * could be parsed sucessfully or not. Use the <code>valid</code> property after the	 * file has been loaded to check if the content is available.	 * 	 * @eventType flash.events.Event.COMPLETE	 */	[Event(name="complete", type="flash.events.Event")]			/**	 * The BinaryFile is the base class for all other file type classes. It can be used to	 * load any type of file and provides the loaded file's content as a ByteArray only.	 * 	 * @see com.hexagonstar.file.types.IFile	 */	public class BinaryFile extends EventDispatcher implements IFile	{		//-----------------------------------------------------------------------------------------		// Properties		//-----------------------------------------------------------------------------------------				/** @private */		protected var _path:String;		/** @private */		protected var _id:String;		/** @private */		protected var _priority:Number;		/** @private */		protected var _weight:uint;		/** @private */		protected var _size:Number;		/** @private */		protected var _content:ByteArray;		/** @private */		protected var _valid:Boolean;		/** @private */		protected var _status:String;						//-----------------------------------------------------------------------------------------		// Constructor		//-----------------------------------------------------------------------------------------				/**		 * Creates a new instance of the file class.		 * 		 * @param path The path of the file that this file object is used for.		 * @param id An optional ID for the file.		 * @param priority An optional load priority for the file. Used for loading with the		 *            BulkLoader class.		 * @param weight An optional weight for the file. Used for weighted loading with the		 *            BulkLoader class.		 */		public function BinaryFile(path:String = null, id:String = null, priority:Number = NaN,			weight:uint = 1)		{			_path = path;			_id = id;			this.priority = priority;			this.weight = weight;			_size = 0;
			_valid = false;
			_status = Status.INIT;		}						//-----------------------------------------------------------------------------------------		// Public Methods		//-----------------------------------------------------------------------------------------				/**		 * @inheritDoc		 */		override public function toString():String		{			return "[" + getQualifiedClassName(this).match("[^:]*$")[0] + " path="				+ _path + ", id=" + _id + ", priority=" + _priority + ", size=" + _size				+ ", status=" + _status + "]";		}						//-----------------------------------------------------------------------------------------		// Getters & Setters		//-----------------------------------------------------------------------------------------				/**		 * @inheritDoc		 */		public function get fileTypeID():int		{			return FileTypeIndex.BINARY_FILE_ID;		}						/**		 * @inheritDoc		 */		public function get path():String		{			return _path;		}		public function set path(v:String):void		{			_path = v;		}						/**		 * @inheritDoc		 */		public function get id():String		{			return _id;		}		public function set id(v:String):void		{			_id = v;		}						/**		 * @inheritDoc		 */		public function get priority():Number		{			return _priority;		}		public function set priority(v:Number):void		{			_priority = (v < int.MIN_VALUE) ? int.MIN_VALUE : (v > int.MAX_VALUE) ? int.MAX_VALUE : v;		}						/**		 * @inheritDoc		 */		public function get weight():uint		{			return _weight;		}		public function set weight(v:uint):void		{			_weight = (v < 1) ? 1 : (v > uint.MAX_VALUE) ? uint.MAX_VALUE : v;		}						/**		 * @inheritDoc		 */		public function get size():Number		{			return _size;		}		public function set size(v:Number):void		{			_size = v;		}						/**		 * @inheritDoc		 */		public function get valid():Boolean		{			return _valid;		}						/**		 * @inheritDoc		 */		public function get status():String		{			return _status;		}						/**		 * @inheritDoc		 */		public function get content():*		{			return contentAsBytes;		}		public function set content(v:*):void		{			contentAsBytes = ByteArray(v);		}						/**		 * @inheritDoc		 */		public function get contentAsBytes():ByteArray		{			if (_content) _content.position = 0;			return _content;		}		public function set contentAsBytes(v:ByteArray):void		{			try			{				_content = new ByteArray();				_content.writeBytes(v);				_content.position = 0;				_valid = true;				_status = Status.OK;			}			catch (err:Error)			{				_valid = false;				_status = err.message;			}						dispatchEvent(new Event(Event.COMPLETE));		}	}}