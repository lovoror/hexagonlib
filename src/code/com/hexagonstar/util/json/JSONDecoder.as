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
package com.hexagonstar.util.json
{
	public class JSONDecoder
	{
		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Flag indicating if the parser should be strict about the format
		 * of the JSON string it is attempting to decode.
		 * @private
		 */
		private var _strict:Boolean;
		
		/**
		 * The value that will get parsed from the JSON string.
		 * @private
		 */
		private var _object:*;
		
		/**
		 * The tokenizer designated to read the JSON string.
		 * @private
		 */
		private var _tokenizer:JSONTokenizer;
		
		/**
		 * The current token from the tokenizer.
		 * @private
		 */
		private var _token:JSONToken;
		
		
		//-----------------------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Constructs a new JSONDecoder to parse a JSON string into a native object.
		 * 
		 * @param s The JSON string to be converted into a native object.
		 * @param strict Flag indicating if the JSON string needs to strictly match the
		 *        JSON standard or not.
		 */
		public function JSONDecoder(s:String, strict:Boolean)
		{
			_strict = strict;
			_tokenizer = new JSONTokenizer(s, strict);
			
			nextToken();
			_object = parseValue();
			
			/* Make sure the input stream is empty. */
			if (strict && nextToken() != null)
			{
				_tokenizer.parseError("Unexpected characters left in input stream.");
			}
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Getters & Setters
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Gets the internal object that was created by parsing the JSON string passed to
		 * the constructor.
		 *
		 * @return The internal object representation of the JSON string that was passed
		 *         to the constructor.
		 */
		public function get object():*
		{
			return _object;
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Private Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Returns the next token from the tokenzier reading the JSON string.
		 * 
		 * @private
		 */
		private final function nextToken():JSONToken
		{
			return _token = _tokenizer.getNextToken();
		}
		
		
		/**
		 * Returns the next token from the tokenizer reading the JSON string and verifies
		 * that the token is valid.
		 * 
		 * @private
		 */
		private final function nextValidToken():JSONToken
		{
			_token = _tokenizer.getNextToken();
			checkValidToken();
			return _token;
		}
		
		
		/**
		 * Verifies that the token is valid.
		 * 
		 * @private
		 */
		private final function checkValidToken():void
		{
			/* Catch errors when the input stream ends abruptly. */
			if (_token == null)
			{
				_tokenizer.parseError("Unexpected end of input.");
			}
		}
		
		
		/**
		 * Attempt to parse an array.
		 * 
		 * @private
		 */
		private final function parseArray():Array
		{
			// create an array internally that we're going to attempt
			// to parse from the tokenizer
			var a:Array = new Array();
			
			// grab the next token from the tokenizer to move
			// past the opening [
			nextValidToken();
			
			// check to see if we have an empty array
			if ( _token.type == JSONTokenType.RIGHT_BRACKET )
			{
				// we're done reading the array, so return it
				return a;
			}
			
			// in non-strict mode an empty array is also a comma
			// followed by a right bracket
			else if ( !_strict && _token.type == JSONTokenType.COMMA )
			{
				// move past the comma
				nextValidToken();

				// check to see if we're reached the end of the array
				if ( _token.type == JSONTokenType.RIGHT_BRACKET )
				{
					return a;
				}
				else
				{
					_tokenizer.parseError("Leading commas are not supported. Expecting ']' but found " + _token.value);
				}
			}
			
			// deal with elements of the array, and use an "infinite"
			// loop because we could have any amount of elements
			while (true)
			{
				// read in the value and add it to the array
				a.push(parseValue());
				
				// after the value there should be a ] or a ,
				nextValidToken();
				
				if ( _token.type == JSONTokenType.RIGHT_BRACKET )
				{
					// we're done reading the array, so return it
					return a;
				}
				else if ( _token.type == JSONTokenType.COMMA )
				{
					// move past the comma and read another value
					nextToken();

					// Allow arrays to have a comma after the last element
					// if the decoder is not in strict mode
					if ( !_strict )
					{
						checkValidToken();

						// Reached ",]" as the end of the array, so return it
						if ( _token.type == JSONTokenType.RIGHT_BRACKET )
						{
							return a;
						}
					}
				}
				else
				{
					_tokenizer.parseError("Expecting ] or , but found " + _token.value);
				}
			}
			
			return null;
		}
		
		
		/**
		 * Attempt to parse an object.
		 * 
		 * @private
		 */
		private final function parseObject():Object
		{
			// create the object internally that we're going to
			// attempt to parse from the tokenizer
			var o:Object = new Object();
			
			// store the string part of an object member so
			// that we can assign it a value in the object
			var key:String;
			
			// grab the next token from the tokenizer
			nextValidToken();
			
			// check to see if we have an empty object
			if ( _token.type == JSONTokenType.RIGHT_BRACE )
			{
				// we're done reading the object, so return it
				return o;
			}
			
			// in non-strict mode an empty object is also a comma
			// followed by a right bracket
			else if ( !_strict && _token.type == JSONTokenType.COMMA )
			{
				// move past the comma
				nextValidToken();

				// check to see if we're reached the end of the object
				if ( _token.type == JSONTokenType.RIGHT_BRACE )
				{
					return o;
				}
				else
				{
					_tokenizer.parseError("Leading commas are not supported.  Expecting '}' but found " + _token.value);
				}
			}
			
			// deal with members of the object, and use an "infinite"
			// loop because we could have any amount of members
			while ( true )
			{
				if ( _token.type == JSONTokenType.STRING )
				{
					// the string value we read is the key for the object
					key = String(_token.value);

					// move past the string to see what's next
					nextValidToken();

					// after the string there should be a :
					if ( _token.type == JSONTokenType.COLON )
					{
						// move past the : and read/assign a value for the key
						nextToken();
						o[ key ] = parseValue();

						// move past the value to see what's next
						nextValidToken();

						// after the value there's either a } or a ,
						if ( _token.type == JSONTokenType.RIGHT_BRACE )
						{
							// we're done reading the object, so return it
							return o;
						}
						else if ( _token.type == JSONTokenType.COMMA )
						{
							// skip past the comma and read another member
							nextToken();

							// Allow objects to have a comma after the last member
							// if the decoder is not in strict mode
							if ( !_strict )
							{
								checkValidToken();

								// Reached ",}" as the end of the object, so return it
								if ( _token.type == JSONTokenType.RIGHT_BRACE )
								{
									return o;
								}
							}
						}
						else
						{
							_tokenizer.parseError("Expecting } or , but found " + _token.value);
						}
					}
					else
					{
						_tokenizer.parseError("Expecting : but found " + _token.value);
					}
				}
				else
				{
					_tokenizer.parseError("Expecting string but found " + _token.value);
				}
			}
			return null;
		}
		
		
		/**
		 * Attempt to parse a value.
		 * 
		 * @private
		 */
		private final function parseValue():Object
		{
			checkValidToken();
			
			switch ( _token.type )
			{
				case JSONTokenType.LEFT_BRACE:
					return parseObject();
				case JSONTokenType.LEFT_BRACKET:
					return parseArray();
				case JSONTokenType.STRING:
				case JSONTokenType.NUMBER:
				case JSONTokenType.TRUE:
				case JSONTokenType.FALSE:
				case JSONTokenType.NULL:
					return _token.value;
				case JSONTokenType.NAN:
					if ( !_strict )
					{
						return _token.value;
					}
					else
					{
						_tokenizer.parseError("Unexpected " + _token.value);
					}
				default:
					_tokenizer.parseError("Unexpected " + _token.value);
			}
			
			return null;
		}
	}
}
