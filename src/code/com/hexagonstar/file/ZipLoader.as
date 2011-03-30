/*
	{
		//-----------------------------------------------------------------------------------------
		/** @private */
		
		{
			if (!_opened || _state != ZipLoader.OPENED) return false;
			if (e.compressionMethod != ZipConstants.DEFLATE
		{
			return _zipFile.nativePath;
		{
			if (_state != ZipLoader.OPENED)
				_state = ZipLoader.OPENED;
				_opened = true;
		 * @private
		 */
		protected function init():void
		{
			_state = ZipLoader.READ_END;
				error("Could not find END header of zip file <" + _zipFile.nativePath + ">.");
				{
					error("Missing zip entry file path in zip file <" + _zipFile.nativePath + ">.");
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
	}