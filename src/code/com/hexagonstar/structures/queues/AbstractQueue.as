/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.structures.queues{	import com.hexagonstar.exception.EmptyDataStructureException;	import com.hexagonstar.exception.IndexOutOfBoundsException;	import com.hexagonstar.exception.UnsupportedOperationException;	import com.hexagonstar.structures.AbstractCollection;		/**	 * Base class for queue implementations.	 */	public class AbstractQueue extends AbstractCollection	{		//-----------------------------------------------------------------------------------------		// Private Methods		//-----------------------------------------------------------------------------------------				/**		 * throws an UnsupportedOperation Exception.		 * @private		 */		protected function throwRemoveNotSupported():Boolean		{			throw new UnsupportedOperationException(toString()			+ " This Queue implementation does not allow the removal or retaining of elements!");			return false;		}						/**		 * throws an EmptyDataStructure Exception.		 * @private		 */		protected function throwEmptyDataStructureException():Boolean		{			throw new EmptyDataStructureException(toString()			+ " Tried to peek or dequeue an element from an empty Queue.");			return false;		}						/**		 * throws an IndexOutOfBounds Exception.		 * @private		 */		protected function throwIndexOutOfBoundsException(index:int):*		{			throw new IndexOutOfBoundsException(toString() + " Argument 'index' [" + index				+ "] is out of range, this is equal to or greater than the queue's size ["				+ _size + "].");			return null;		}	}}