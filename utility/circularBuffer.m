classdef circularBuffer
% circularBuffer provides full functionality  of a circular buffer. It's not super efficient but works fine
  properties
    buffer;
    bufferSize;
    currentIndex; %points to the last added element
  end
  methods
    function obj = circularBuffer(bufferSize)
      %Initialize the buffer given a size
      if nargin > 0
        obj.buffer(1:bufferSize+1) = 0.0;
        obj.bufferSize = bufferSize+1;
        obj.currentIndex = 0;
      end
    end

    function val = getValue(obj,idx)
      %Get the value at an arbitrary index in reference to the last added element
      index = obj.currentIndex - idx;
      while index < 1
        index = index + obj.bufferSize;
      end
      val = obj.buffer(index);
    end

    function obj = push(obj,value)
      %push a value into the buffer, will overwrite previous values
      obj.currentIndex = obj.currentIndex + 1;
      if (obj.currentIndex == obj.bufferSize)
        obj.buffer(obj.currentIndex) = value;
        obj.currentIndex = 1;
      else
        obj.buffer(obj.currentIndex) = value;
      end
    end
  end
end
