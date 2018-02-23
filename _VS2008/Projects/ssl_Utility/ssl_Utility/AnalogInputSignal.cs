using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public class AnalogInputSignal : InputSignal
    {
        public ushort Value
        {
            get { return AnalogValue; }
        }
        
        public AnalogInputSignal() : base()
        {
        }

        public void SetValue(ushort _value)
        {
            SetAnalogValue(_value);
        }
    
    }
}