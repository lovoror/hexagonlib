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
	public class DeluxeSignal extends Signal implements IPrioritySignal
	{
		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------
		
		protected var _target:Object;
		
		
		//-----------------------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Creates a DeluxeSignal instance to dispatch events on behalf of a target
		 * object.
		 * 
		 * @param target The object the signal is dispatching events on behalf of.
		 * @param valueClasses Any number of class references that enable type checks in
		 *            dispatch(). For example, new DeluxeSignal(this, String, uint) would
		 *            allow: signal.dispatch("the Answer", 42) but not:
		 *            signal.dispatch(true, 42.5) nor: signal.dispatch()
		 * 
		 *            NOTE: Subclasses cannot call super.apply(null, valueClasses), but
		 *            this constructor has logic to support super(valueClasses).
		 */
		public function DeluxeSignal(target:Object = null, ...valueClasses)
		{
			_target = target;
			
			// Cannot use super.apply(null, valueClasses), so allow the subclass to
			// call super(valueClasses).
			valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array)
				? valueClasses[0]
				: valueClasses;
			super(valueClasses);
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Public Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function add(listener:Function):ISignalBinding
		{
			return addWithPriority(listener);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function addOnce(listener:Function):ISignalBinding
		{
			return addOnceWithPriority(listener);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function addWithPriority(listener:Function, priority:int = 0):ISignalBinding
		{
			return registerListenerWithPriority(listener, false, priority);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function addOnceWithPriority(listener:Function, priority:int = 0):ISignalBinding
		{
			return registerListenerWithPriority(listener, true, priority);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function dispatch(...valueObjects):void
		{
			// Validate value objects against pre-defined value classes.
			var valueObject:Object;
			var valueClass:Class;

			const numValueClasses:int = _valueClasses.length;
			const numValueObjects:int = valueObjects.length;

			if (numValueObjects < numValueClasses)
			{
				throw new ArgumentError('Incorrect number of arguments. ' + 'Expected at least ' + numValueClasses + ' but received ' + numValueObjects + '.');
			}

			for (var i:int = 0; i < numValueClasses; i++)
			{
				valueObject = valueObjects[i];
				valueClass = _valueClasses[i];

				if (valueObject === null || valueObject is valueClass) continue;

				throw new ArgumentError('Value object <' + valueObject + '> is not an instance of <' + valueClass + '>.');
			}

			// Extract and clone event object if necessary.
			var event:IEvent = valueObjects[0] as IEvent;

			if (event)
			{
				if (event.target)
				{
					event = event.clone();
					valueObjects[0] = event;
				}

				event.target = target;
				event.currentTarget = target;
				event.signal = this;
			}

			// Broadcast to listeners.
			var bindingsToProcess:SignalBindingList = _bindings;
			while (bindingsToProcess.nonEmpty)
			{
				bindingsToProcess.head.execute(valueObjects);
				bindingsToProcess = bindingsToProcess.tail;
			}

			// Bubble the event as far as possible.
			if (!event || !event.bubbles) return;
			var currentTarget:Object = target;

			while (currentTarget && currentTarget.hasOwnProperty("parent") && (currentTarget = currentTarget["parent"]))
			{
				if (currentTarget is IBubbleEventHandler)
				{
					// onEventBubbled() can stop the bubbling by returning false.
					if (!IBubbleEventHandler(event.currentTarget = currentTarget).onEventBubbled(event))
						break;
				}
			}
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Getters & Setters
		//-----------------------------------------------------------------------------------------
		
		public function get target():Object
		{
			return _target;
		}
		public function set target(v:Object):void
		{
			if (v == _target) return;
			removeAll();
			_target = v;
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Private Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function registerListener(listener:Function, once:Boolean = false):ISignalBinding
		{
			return registerListenerWithPriority(listener, once);
		}
		
		
		/**
		 * @private
		 */
		protected function registerListenerWithPriority(listener:Function, once:Boolean = false, priority:int = 0):ISignalBinding
		{
			if (isRegistrationPossible(listener, once))
			{
				const binding:ISignalBinding = new SignalBinding(listener, this, once, priority);
				_bindings = _bindings.insertWithPriority(binding);
				return binding;
			}
			return _bindings.find(listener);
		}
	}
}
