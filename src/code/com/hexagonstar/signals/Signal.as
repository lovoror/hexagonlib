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
package com.hexagonstar.signals
{
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;

	/**
	 * Signal dispatches events to multiple listeners. It is inspired by C# events and
	 * delegates, and by signals and slots in Qt. A Signal adds event dispatching
	 * functionality through composition and interfaces, rather than inheriting from a
	 * dispatcher.
	 */
	public class Signal implements ISignal
	{
		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------
		
		protected var _valueClasses:Array;
		protected var _strict:Boolean = true;
		protected var _bindings:SignalBindingList = SignalBindingList.NIL;


		/**
		 * Creates a Signal instance to dispatch value objects.
		 * 
		 * @param valueClasses Any number of class references that enable type checks in
		 *            dispatch(). For example, new Signal(String, uint) would allow:
		 *            signal.dispatch("the Answer", 42) but not: signal.dispatch(true,
		 *            42.5) nor: signal.dispatch()
		 * 
		 *            NOTE: In AS3, subclasses cannot call super.apply(null,
		 *            valueClasses), but this constructor has logic to support
		 *            super(valueClasses).
		 */
		public function Signal(...valueClasses)
		{
			/* Cannot use super.apply(null, valueClasses), so allow the subclass to
			 * call super(valueClasses). */
			this.valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array)
				? valueClasses[0]
				: valueClasses;
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Public Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function add(listener:Function):ISignalBinding
		{
			return registerListener(listener);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function addOnce(listener:Function):ISignalBinding
		{
			return registerListener(listener, true);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function remove(listener:Function):ISignalBinding
		{
			const binding:ISignalBinding = _bindings.find(listener);
			if (!binding) return null;
			_bindings = _bindings.filterNot(listener);
			return binding;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function removeAll():void
		{
			_bindings = SignalBindingList.NIL;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function dispatch(...valueObjects):void
		{
			// Validate value objects against pre-defined value classes.
			var valueObject:Object;
			var valueClass:Class;
			
			// If valueClasses is empty, value objects are not type-checked.
			const numValueClasses:int = _valueClasses.length;
			const numValueObjects:int = valueObjects.length;
			
			if (numValueObjects < numValueClasses)
			{
				throw new ArgumentError('Incorrect number of arguments. ' + 'Expected at least '
					+ numValueClasses + ' but received ' + numValueObjects + '.');
			}

			for (var i:int = 0; i < numValueClasses; ++i)
			{
				valueObject = valueObjects[i];
				valueClass = _valueClasses[i];
				if (valueObject === null || valueObject is valueClass) continue;
				throw new ArgumentError('Value object <' + valueObject
					+ '> is not an instance of <' + valueClass + '>.');
			}
			
			// Broadcast to listeners.
			var bindingsToProcess:SignalBindingList = _bindings;
			if (bindingsToProcess.nonEmpty)
			{
				while (bindingsToProcess.nonEmpty)
				{
					bindingsToProcess.head.execute(valueObjects);
					bindingsToProcess = bindingsToProcess.tail;
				}
			}
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Getters & Setters
		//-----------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get valueClasses():Array
		{
			return _valueClasses;
		}
		public function set valueClasses(v:Array):void
		{
			/* Clone so the Array cannot be affected from outside. */
			_valueClasses = v ? v.slice() : [];
			for (var i:int = _valueClasses.length; i--;)
			{
				if (!(_valueClasses[i] is Class))
				{
					throw new ArgumentError('Invalid valueClasses argument: '
						+ 'item at index ' + i + ' should be a Class but was: <'
						+ _valueClasses[i] + '>.' + getQualifiedClassName(_valueClasses[i]));
				}
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get strict():Boolean
		{
			return _strict;
		}
		public function set strict(v:Boolean):void
		{
			_strict = v;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get numListeners():uint
		{
			return _bindings.length;
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Private Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected function registerListener(listener:Function, once:Boolean = false):ISignalBinding
		{
			if (isRegistrationPossible(listener, once))
			{
				const newBinding:ISignalBinding = new SignalBinding(listener, this, once);
				_bindings = _bindings.prepend(newBinding);
				return newBinding;
			}
			return _bindings.find(listener);
		}
		
		
		/**
		 * @private
		 */
		protected function isRegistrationPossible(listener:Function, once:Boolean):Boolean
		{
			if (!_bindings.nonEmpty) return true;

			const existingBinding:ISignalBinding = _bindings.find(listener);
			if (!existingBinding) return true;

			if (existingBinding.once != once)
			{
				// If the listener was previously added, definitely don't add it again.
				// But throw an exception if their once values differ.
				throw new IllegalOperationError("You cannot addOnce() then add() the same"
					+ " listener without removing the relationship first.");
			}
			
			// Listener was already registered.
			return false;
		}
	}
}
