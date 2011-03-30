/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.structures.maps{	import com.hexagonstar.exception.IllegalArgumentException;	import com.hexagonstar.exception.UnsupportedOperationException;	import com.hexagonstar.structures.ICollection;	import com.hexagonstar.structures.IIterator;	import flash.utils.Dictionary;			/**	 * A hash map using direct lookup (perfect hashing). Each key can only map one value	 * at a time and multiple keys can map the same value. The HashMap is preallocated	 * according to an initial size, but afterwards automatically resized if the number	 * of key-value pairs exceeds the predefined size.	 */	public class HashMap extends AbstractMap implements IMap	{		//-----------------------------------------------------------------------------------------		// Properties		//-----------------------------------------------------------------------------------------				/** @private */		protected var _keyMap:Dictionary;		/** @private */		protected var _dupMap:Dictionary;		/** @private */		protected var _initSize:int;		/** @private */		protected var _maxSize:int;		/** @private */		protected var _node:Node;		/** @private */		protected var _first:Node;		/** @private */		protected var _last:Node;						//-----------------------------------------------------------------------------------------		// Constructor		//-----------------------------------------------------------------------------------------				/**		 * Creates a new HashMap instance.		 * 		 * @param size The initial size of the map.		 */		public function HashMap(size:int = 100)		{			_initSize = _maxSize = Math.max(10, size);						_keyMap = new Dictionary(true);			_dupMap = new Dictionary(true);			_size = 0;						var n:Node = new Node();			_first = _last = n;						var l:int = _initSize + 1;			for (var i:int = 0; i < l; i++)			{				n.next = new Node();				n = n.next;			}						_last = n;		}						//-----------------------------------------------------------------------------------------		// Query Operations		//-----------------------------------------------------------------------------------------				/**		 * The init size of the map. This is not the real size but the size that		 * is specified when creating a new map.		 */		public function get initSize():int		{			return _initSize;		}						/**		 * The calculated maximum size of the map.		 */		public function get maxSize():int		{			return _maxSize;		}						/**		 * @inheritDoc		 */		public function equals(collection:ICollection):Boolean		{			if (collection is HashMap)			{				var m:HashMap = HashMap(collection);				if (m.size != _size) return false;								var a1:Array = toMappedArray(true);				var a2:Array = m.toMappedArray(true);				var l:int = a1.length;								if (l != a2.length) return false;								for (var i:int = 0; i < l; i++)				{					if (a1[i]["key"] != a2[i]["key"]) return false;					if (a1[i]["value"] != a2[i]["value"]) return false;				}								return true;			}			return false;		}						/**		 * @inheritDoc		 */		override public function contains(value:*):Boolean		{			return _dupMap[value] > 0;		}						/**		 * @inheritDoc		 */		public function containsKey(key:*):Boolean		{			return _keyMap[key] != null;		}						/**		 * @inheritDoc		 */		public function getValue(key:*):*		{			var n:Node = _keyMap[key];			if (n) return n.val;			return null;		}						/**		 * Returns an iterator that can be used to iterate over elements of the		 * HashMap. NOTE: The HashMap iterator's next() operation returns an Array		 * instead of a mapped value! The returned Array contains two fields where		 * the first contains the mapped key and the second contains the mapped value.		 * 		 * @return A HashMap iterator.		 */		public function get iterator():IIterator		{			return new HashMapIterator(_node);		}						/**		 * @inheritDoc		 */		public function clone():*		{			var a:Array = toMappedArray(false);			var l:int = a.length;			var m:HashMap = new HashMap(_initSize);						for (var i:int = 0; i < l; i++)			{				m.put(a[i]["key"], a[i]["value"]);			}						return m;		}						/**		 * Returns an array that contains all values that are mapped.		 * 		 * @return An array that contains all values that are mapped.		 */		public function toArray():Array		{			var a:Array = new Array(_size);			var i:int = 0;						for each (var n:Node in _keyMap)			{				a[i++] = n.val;			}						return a;		}						/**		 * Returns an array that contains all keys that are mapped.		 * 		 * @param sort If true the resulting array will be sorted.		 * @return An array that contains all keys that are mapped.		 */		public function toKeyArray(sort:Boolean = false):Array		{			var a:Array = new Array(_size);			var i:int = 0;						for each (var n:Node in _keyMap)			{				a[i++] = n.key;			}						if (sort) a.sort(Array.NUMERIC);			return a;		}						/**		 * Returns an associative array that contains all key-value pairs that are mapped.		 * 		 * @param sort If true the resulting array will be sorted on it's keys.		 * @return An associative array that contains all key-value pairs that are mapped.		 *         The resulting array contains fields named 'key' and 'value'.		 */		public function toMappedArray(sort:Boolean = false):Array		{			var a:Array = new Array(_size);			var i:int = 0;						for each (var n:Node in _keyMap)			{				a[i++] = {key: n.key, value: n.val};			}						if (sort) a.sortOn("key", Array.NUMERIC);			return a;		}						/**		 * @inheritDoc		 */		public function dump():String		{			var s:String = toString();			for each (var n:Node in _keyMap)			{				s += "\n[" + n.key + ": " + n.val + "]";			}			return s;		}						//-----------------------------------------------------------------------------------------		// Modification Operations		//-----------------------------------------------------------------------------------------				/**		 * The add method is not supported by the HashMap. Use put() instead! This		 * method only exists to adhere to the Collection interface.		 * 		 * @throws com.hexagonstar.exception.UnsupportedOperationException		 */		public function add(element:*):Boolean		{			throw new UnsupportedOperationException(toString()				+ " The operation add() is not supported by this HashMap! Use put() instead!");			return false;		}						/**		 * @inheritDoc		 */		public function put(key:*, value:*):Boolean		{			if (key == null || _keyMap[key]) return false;						if (_size++ == _maxSize)			{				var l:int = (_maxSize += _initSize) + 1;				for (var i:int = 0; i < l; i++)				{					_last.next = new Node();					_last = _last.next;				}			}						var n:Node = _first;			_first = _first.next;			n.key = key;			n.val = value;						n.next = _node;						if (_node)			{				_node.prev = n;			}			_node = n;						_keyMap[key] = n;			_dupMap[value] ? _dupMap[value]++ : _dupMap[value] = 1;						return true;		}						/**		 * @inheritDoc		 */		public function remove(key:*):*		{			var n:Node = _keyMap[key];						if (n)			{				var v:* = n.val;				delete _keyMap[key];								if (n.prev) n.prev.next = n.next;				if (n.next) n.next.prev = n.prev;				if (n == _node) _node = n.next;								n.prev = null;				n.next = null;				_last.next = n;				_last = n;								if (--_dupMap[v] <= 0) delete _dupMap[v];								if (--_size <= (_maxSize - _initSize))				{					var l:int = (_maxSize -= _initSize) + 1;					for (var i:int = 0; i < l; i++)					{						_first = _first.next;					}				}								return v;			}						return null;		}						//-----------------------------------------------------------------------------------------		// Bulk Operations		//-----------------------------------------------------------------------------------------				/**		 * Operation not supported in HashMap, use putAll() instead!		 * 		 * @throws com.hexagonstar.exception.UnsupportedOperationException as the		 *          HashMap does not support this operation.		 */		public function addAll(collection:ICollection):Boolean		{			return throwUnsupportedOperationException("addAll()");		}						/**		 * Puts all elements from the specified hashmap into this map.		 * 		 * @param map The map with elements to put into this map.		 * @return true if elements were added successfully, false if not.		 */		public function putAll(map:HashMap):Boolean		{			var i:IIterator = map.iterator;			while (i.hasNext)			{				var n:Array = i.next;				if (!put(n[0], n[1])) return false;			}			return true;		}						/**		 * Unmaps all elements from this HashMap that are in the specified collection.		 * The specified collection must be of type HashMap or the operation will fail!		 * 		 * @param collection The collection with elements to remove from this HashMap.		 * @return true if operation succeeded or false if the specified collection		 *         is not a HashMap.		 * @throws com.hexagonstar.exception.IllegalArgumentException if the specified		 *         collection is not a HashMap.		 */		public function removeAll(collection:ICollection):Boolean		{			if (!(collection is HashMap))			{				throw new IllegalArgumentException(toString() + " The operation removeAll()"					+ " can only be used with collections of type HashMap.");				return false;			}						var i:IIterator = collection.iterator;			while (i.hasNext)			{				var n:Array = i.next;				remove(n[0]);			}			return true;		}						/**		 * Retains only the elements in the map that are contained in the specified		 * collection. In other words, removes all elements from the map that are not		 * contained in the specified collection.		 * The specified collection must be of type HashMap or the operation will fail!		 * 		 * @param collection The collection with elements that should be retained in the		 *            map.		 * @return true if any elements were removed from the map, false if not or if the		 *         operation failed.		 * @throws com.hexagonstar.exception.IllegalArgumentException if the specified		 *         collection is not a HashMap.		 */		public function retainAll(collection:ICollection):Boolean		{			// TODO Method needs testing!						if (!(collection is HashMap))			{				throw new IllegalArgumentException(toString() + " The operation retainAll()"					+ " can only be used with collections of type HashMap.");				return false;			}						var oldSize:int = _size;			var i:IIterator = collection.iterator;			while (i.hasNext)			{				var n:Array = i.next;				var v:* = getValue(n[0]);				if (v == n[1]) continue;				remove(n[0]);			}			return (_size < oldSize);		}						/**		 * @inheritDoc		 */		override public function containsAll(collection:ICollection):Boolean		{			if (collection)			{				var i:IIterator = collection.iterator;								/* HashMap collections get a special treatment due to their iterator! */				if (collection is HashMap)				{					while (i.hasNext)					{						if (!contains((i.next as Array)[1])) return false;					}					return true;				}				else				{					while (i.hasNext)					{						if (!contains(i.next)) return false;					}					return true;				}			}			else			{				return throwNullReferenceException();			}		}						/**		 * @inheritDoc		 */		public function clear():void		{			_keyMap = new Dictionary(true);			_dupMap = new Dictionary(true);						var t:Node;			var n:Node = _node;						while (n)			{				t = n.next;								n.next = n.prev = null;				n.key = null;				n.val = null;				_last.next = n;				_last = _last.next;				n = t;			}						_node = null;			_size = 0;		}	}}// ------------------------------------------------------------------------------------------------import com.hexagonstar.exception.UnsupportedOperationException;import com.hexagonstar.structures.IIterator;/** * @private */final class Node{	public var key:*;	public var val:*;	public var prev:Node;	public var next:Node;}// ------------------------------------------------------------------------------------------------/** * @private */final class HashMapIterator implements IIterator{	private var _node:Node;	private var _walker:Node;		public function HashMapIterator(node:Node)	{		_node = _walker = node;	}			public function remove():*	{		// TODO Add remove operation to HashMapIterator!		throw new UnsupportedOperationException("[HashMapIterator] removing is not supported yet.");		return null;	}			public function reset():void	{		_walker = _node;	}			public function get hasNext():Boolean	{		return _walker != null;	}			/**	 * For the HashMap this operation returns an Array with two fields, the first	 * for the mapped key and the second for the mapped value.	 */	public function get next():*	{		var a:Array = new Array(2);		a[0] = _walker.key;		a[1] = _walker.val;		_walker = _walker.next;		return a;	}		public function get data():*	{		return _walker.val;	}	public function set data(v:*):void	{		_walker.val = v;	}}