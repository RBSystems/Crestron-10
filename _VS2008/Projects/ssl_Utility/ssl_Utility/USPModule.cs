using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public class USPModule
    {
        public DigitalInputSignal DigitalInput_1 { get; private set; }
        public AnalogInputSignal AnalogInput_1 { get; private set; }
        public SerialInputSignal SerialInput_1 { get; private set; }

        public DigitalOutputSignal DigitalOutput_1 { get; private set; }
        public AnalogOutputSignal AnalogOutput_1 { get; private set; }
        public SerialOutputSignal SerialOutput_1 { get; private set; }

        public USPModule()
        {
            DigitalInput_1 = new DigitalInputSignal();
            AnalogInput_1 = new AnalogInputSignal();
            SerialInput_1 = new SerialInputSignal();

            DigitalInput_1.Name = "DIG_IN_1";
            AnalogInput_1.Name = "ANA_IN_1";
            SerialInput_1.Name = "SER_IN_1";

            DigitalOutput_1 = new DigitalOutputSignal();
            AnalogOutput_1 = new AnalogOutputSignal();
            SerialOutput_1 = new SerialOutputSignal();

            DigitalOutput_1.Name = "DIG_OUT_1";
            AnalogOutput_1.Name = "ANA_OUT_1";
            SerialOutput_1.Name = "SER_OUT_1";
        }

        public void Test_01()
        {
            DigitalOutput_1.SendValue(1);
            AnalogOutput_1.SendValue(997);
            SerialOutput_1.SendValue("Policja");
        }

        public void Test_02()
        {
            DigitalOutput_1.SendValue(0);
            AnalogOutput_1.SendValue(998);
            SerialOutput_1.SendValue("Straz");
        }

        public void Test_03()
        {
            DigitalOutput_1.SendValue(1);
            AnalogOutput_1.SendValue(999);
            DigitalOutput_1.SendValue(0);
            SerialOutput_1.SendValue("Pogotowie");
            DigitalOutput_1.SendValue(1);
            SerialOutput_1.SendValue("io io io");
            AnalogOutput_1.SendValue(112);
            DigitalOutput_1.SendValue(0);
            AnalogOutput_1.SendValue(0);
            SerialOutput_1.SendValue("");
        }
    }
}