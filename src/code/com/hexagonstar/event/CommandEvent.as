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
package com.hexagonstar.event
{
	import com.hexagonstar.pattern.cmd.BaseCommand;

	import flash.events.Event;

	
	/**
	 * An event that is used to be broadcast from commands to indicate the state of the
	 * command.
	 * 
	 * @see com.hexagonstar.pattern.cmd.Command
	 * @see com.hexagonstar.pattern.cmd.CompositeCommand
	 * @see com.hexagonstar.pattern.cmd.PausableCommand
	 * @see com.hexagonstar.pattern.cmd.ICommandListener
	 */
	public class CommandEvent extends Event
	{
		//-----------------------------------------------------------------------------------------
		// Constants
		//-----------------------------------------------------------------------------------------
		
		/**
		 * A constant for command events which signals that the command has completed
		 * execution.
		 */
		public static const COMPLETE:String = "commandComplete";
		
		/**
		 * A constant for command events which signals that the command is progressing.
		 */
		public static const PROGRESS:String = "commandProgress";
		
		/**
		 * A constant for command events which signals that the command has been aborted.
		 */
		public static const ABORT:String = "commandAbort";
		
		/**
		 * A constant for command events which signals that an error occured during the the
		 * command execution.
		 */
		public static const ERROR:String = "commandError";
		
		
		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------
		
		/** @private */
		protected var _command:BaseCommand;
		/** @private */
		protected var _message:String;
		/** @private */
		protected var _progress:int;
		
		
		//-----------------------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Creates a new CommandEvent instance.
		 * 
		 * @param type The type string for the event.
		 * @param command The command this event is fired from.
		 * @param message The progress message of the command.
		 * @param progress The progress value of the command.
		 */
		public function CommandEvent(type:String, command:BaseCommand, message:String = null,
			progress:int = -1)
		{
			super(type);
			
			_command = command;
			_message = message;
			_progress = progress;
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Public Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Clones the event.
		 */
		override public function clone():Event
		{
			return new CommandEvent(type, _command, _message, _progress);
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Getters & Setters
		//-----------------------------------------------------------------------------------------
		
		/**
		 * The command that broadcasted the event.
		 */
		public function get command():BaseCommand
		{
			return _command;
		}
		
		
		/**
		 * For an error event the error message and for a progress event the message string
		 * associated with the command progress.
		 */
		public function get message():String
		{
			return _message;
		}
		
		
		/**
		 * The progress value of the command.
		 */
		public function get progress():int
		{
			return _progress;
		}
	}
}
