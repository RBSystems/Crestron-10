using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{   
    public class InputSignal
    {
        private const bool DEBUGMODE = true;
        
        private const ushort MIN_ANALOG_VALUE = 0;
        private const ushort MAX_ANALOG_VALUE = 65535;

        //private const String OFF_STRING = "OFF";
        //private const String ON_STRING = "ON";

        protected bool DigitalValue { get; private set; }
        protected ushort AnalogValue { get; private set; }
        protected String SerialValue { get; private set; }

        public bool IsInitialized { get; protected set; }

        public event EventHandler InitializedEventHandler;
        public event EventHandler ValueChangedEventHandler;

        public InputSignal()
        {
            IsInitialized = false;
            DigitalValue = false;
            ParseDigitalValue();
        }

        private void OnInitialized()
        {
            if (InitializedEventHandler != null) InitializedEventHandler(this, EventArgs.Empty);

            IsInitialized = true;

            if (DEBUGMODE)
            {
                MessagePrinter.PrintAsTrace("Base : Signal initialized");
            }
        }

        private void OnValueChanged()
        {
            if (ValueChangedEventHandler != null) ValueChangedEventHandler(this, EventArgs.Empty);

            if (DEBUGMODE)
            {
                MessagePrinter.PrintAsTrace("Base : Signal changed");
                MessagePrinter.PrintAsTrace("Base : Signal digital value = " + this.DigitalValue.ToString());
                MessagePrinter.PrintAsTrace("Base : Signal analog value = " + this.AnalogValue.ToString());
                MessagePrinter.PrintAsTrace("Base : Signal serial value = " + this.SerialValue);
            }
        }

        protected void SetDigitalValue(ushort _value)
        {
            if (!IsInitialized) OnInitialized();

            bool tempValue = (_value > MIN_ANALOG_VALUE);

            if (tempValue != DigitalValue)
            {
                DigitalValue = tempValue;
                ParseDigitalValue();
                OnValueChanged();
            }
        }

        protected void SetAnalogValue(ushort _value)
        {
            if (!IsInitialized) OnInitialized();

            if (_value != AnalogValue)
            {
                AnalogValue = _value;
                ParseAnalogValue();
                OnValueChanged();
            }
        }

        protected void SetSerialValue(SimplSharpString _value)
        {
            if (!IsInitialized) OnInitialized();

            if (_value.ToString() != SerialValue)
            {
                SerialValue = _value.ToString();
                ParseSerialValue();
                OnValueChanged();
            }
        }

        private void ParseDigitalValue()
        {
            AnalogValue = DigitalValue ? MAX_ANALOG_VALUE : MIN_ANALOG_VALUE;
            SerialValue = DigitalValue.ToString();
        }

        private void ParseAnalogValue()
        {
            DigitalValue = (AnalogValue > MIN_ANALOG_VALUE);
            SerialValue = AnalogValue.ToString();
        }

        private void ParseSerialValue()
        {
            AnalogValue = (ushort)SerialValue.ToString().Length;
            DigitalValue = (AnalogValue > MIN_ANALOG_VALUE);
        }
    }
}