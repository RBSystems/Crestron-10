using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public class SerialInputSignal : InputSignal
    {
        public SimplSharpString Value
        {
            get { return SerialValue; }
        }
        
        public SerialInputSignal() : base()
        {
        }

        public void SetValue(String _value)
        {
            SetSerialValue(_value);
        }
    
    }
}