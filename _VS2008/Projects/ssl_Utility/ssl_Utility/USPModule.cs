using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public class USPModule
    {
        public DigitalInputSignal DigitalInput_1 {get; private set;}
        public AnalogInputSignal AnalogInput_1 { get; private set; }
        public SerialInputSignal SerialInput_1 { get; private set; }

        public USPModule()
        {
            DigitalInput_1 = new DigitalInputSignal();
            AnalogInput_1 = new AnalogInputSignal();
            SerialInput_1 = new SerialInputSignal();
        }
    }
}