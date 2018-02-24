using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{

    public static class SignalHelper
    {
        public const bool DEBUGMODE = true;

        public const ushort MIN_ANALOG_VALUE = 0;
        public const ushort MAX_ANALOG_VALUE = 65535;
    }

    public class Signal
    {
        protected bool DigitalValue { get; set; }
        protected ushort AnalogValue { get; set; }
        protected String SerialValue { get; set; }

        public event EventHandler ValueChangedEventHandler;

        public Signal()
        {
            DigitalValue = false;
            ParseDigitalValue();
        }

        private void OnValueChanged()
        {
            if (ValueChangedEventHandler != null) ValueChangedEventHandler(this, EventArgs.Empty);

            if (SignalHelper.DEBUGMODE)
            {
                DebugHelper.PrintTrace("Signal : Signal changed");
                DebugHelper.PrintTrace("Signal : Signal digital value = " + this.DigitalValue.ToString());
                DebugHelper.PrintTrace("Signal : Signal analog value = " + this.AnalogValue.ToString());
                DebugHelper.PrintTrace("Signal : Signal serial value = " + this.SerialValue);
            }
        }

        protected void ParseDigitalValue()
        {
            AnalogValue = DigitalValue ? SignalHelper.MAX_ANALOG_VALUE : SignalHelper.MIN_ANALOG_VALUE;
            SerialValue = DigitalValue.ToString();
        }

        protected void ParseAnalogValue()
        {
            DigitalValue = (AnalogValue > SignalHelper.MIN_ANALOG_VALUE);
            SerialValue = AnalogValue.ToString();
        }

        protected void ParseSerialValue()
        {
            AnalogValue = (ushort)SerialValue.ToString().Length;
            DigitalValue = (AnalogValue > SignalHelper.MIN_ANALOG_VALUE);
        }

        protected virtual void SetDigitalValue(ushort _value)
        {
            bool tempValue = _value > SignalHelper.MIN_ANALOG_VALUE;

            if (tempValue != DigitalValue)
            {
                OnValueChanged();
            }

            DigitalValue = tempValue;
            ParseDigitalValue();
        }

        protected virtual void SetAnalogValue(ushort _value)
        {
            if (_value != AnalogValue)
            {

                OnValueChanged();
            }

            AnalogValue = _value;
            ParseAnalogValue();
        }

        protected virtual void SetSerialValue(SimplSharpString _value)
        {
            if (_value.ToString() != SerialValue)
            {
                OnValueChanged();
            }

            SerialValue = _value.ToString();
            ParseSerialValue();
        }
    }

    #region Input signals

    public class InputSignal : Signal
    {
        public bool IsInitialized { get; protected set; }

        public event EventHandler InitializedEventHandler;

        public InputSignal()
            : base()
        {
            IsInitialized = false;
        }

        private void OnInitialized()
        {
            if (InitializedEventHandler != null) InitializedEventHandler(this, EventArgs.Empty);

            IsInitialized = true;

            if (SignalHelper.DEBUGMODE)
            {
                DebugHelper.PrintTrace("InputSignal : Signal initialized");
            }
        }

        protected override void SetDigitalValue(ushort _value)
        {
            if (!IsInitialized) OnInitialized();

            base.SetDigitalValue(_value);
        }

        protected override void SetAnalogValue(ushort _value)
        {
            if (!IsInitialized) OnInitialized();

            base.SetAnalogValue(_value);
        }

        protected override void SetSerialValue(SimplSharpString _value)
        {
            if (!IsInitialized) OnInitialized();

            base.SetSerialValue(_value);
        }


    }

    public class DigitalInputSignal : InputSignal
    {
        public bool Value
        {
            get { return DigitalValue; }
        }

        public DigitalInputSignal()
            : base()
        {
        }

        public void SetValue(ushort _value)
        {
            SetDigitalValue(_value);
        }
    }

    public class AnalogInputSignal : InputSignal
    {
        public ushort Value
        {
            get { return AnalogValue; }
        }

        public AnalogInputSignal()
            : base()
        {
        }

        public void SetValue(ushort _value)
        {
            SetAnalogValue(_value);
        }
    }

    public class SerialInputSignal : InputSignal
    {
        public SimplSharpString Value
        {
            get { return SerialValue; }
        }

        public SerialInputSignal()
            : base()
        {
        }

        public void SetValue(String _value)
        {
            SetSerialValue(_value);
        }
    }

    #endregion

    #region Output signals

    public class OutputSignal : Signal
    {
        public IntegerActionDelegate SetDigitalValueCallback { get; set; }
        public IntegerActionDelegate SetAnalogValueCallback { get; set; }
        public StringActionDelegate SetSerialValueCallback { get; set; }

        public OutputSignal()
            : base()
        {

        }

        protected override void SetDigitalValue(ushort _value)
        {
            if (SetDigitalValueCallback != null) SetDigitalValueCallback(_value);

            base.SetDigitalValue(_value);
        }

        protected override void SetAnalogValue(ushort _value)
        {
            if (SetAnalogValueCallback != null) SetAnalogValueCallback(_value);

            base.SetAnalogValue(_value);
        }

        protected override void SetSerialValue(SimplSharpString _value)
        {
            if (SetSerialValueCallback != null) SetSerialValueCallback(_value);

            base.SetSerialValue(_value);
        }
    }



    #endregion

}