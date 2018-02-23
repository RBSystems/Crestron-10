using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public class DigitalInputSignal : InputSignal
    {
        public bool Value
        {
            get { return DigitalValue; }
        }
        
        public DigitalInputSignal() : base()
        {
        }

        public void SetValue(ushort _value)
        {
            SetDigitalValue(_value);
        }
    }
}