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

        public const ushort MAX_SIGNAL_COUNT = 256;
    }

    public class Signal
    {
        protected ushort Id { get; private set; }

        protected bool DigitalValue { get; set; }
        protected ushort AnalogValue { get; set; }
        protected String SerialValue { get; set; }

        public String Name { get; set; }

        public event EventHandler ValueChangedEventHandler;

        public Signal()
        {
            Id = 0;
            DigitalValue = false;
            ParseDigitalValue();
            Name = "Empty";
        }

        public Signal(ushort _id) : this()
        {
            Id = _id;
            Name = "ID_" + _id;
        }

        private void OnValueChanged()
        {
            if (ValueChangedEventHandler != null) ValueChangedEventHandler(this, EventArgs.Empty);

            if (SignalHelper.DEBUGMODE)
            {
                DebugHelper.PrintTrace("Signal : Signal named " + Name + " changed");
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

            bool changedFlag = (DigitalValue != tempValue);

            DigitalValue = tempValue;
            ParseDigitalValue();

            if (changedFlag) OnValueChanged();
        }

        protected virtual void SetAnalogValue(ushort _value)
        {
            bool changedFlag = (_value != AnalogValue);

            AnalogValue = _value;
            ParseAnalogValue();

            if (changedFlag) OnValueChanged();
        }

        protected virtual void SetSerialValue(SimplSharpString _value)
        {
            bool changedFlag = (_value.ToString() != SerialValue);

            SerialValue = _value.ToString();
            ParseSerialValue();

            if (changedFlag) OnValueChanged();
        }
    }

    #region Input signals

    public class InputSignal : Signal
    {
        public bool IsInitialized { get; protected set; }

        public EmptyActionDelegate PollValueCallback {get; set;}

        public event EventHandler InitializedEventHandler;

        public InputSignal()
            : base()
        {
            IsInitialized = false;
        }

        public InputSignal(ushort _id)
            : base(_id)
        {
            IsInitialized = false;
        }

        public void PollValue()
        {
            if (PollValueCallback != null) PollValueCallback();
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

        public DigitalInputSignal(ushort _id)
            : base(_id)
        {
        }

        public void UpdateValue(ushort _value)
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

        public AnalogInputSignal(ushort _id)
            : base(_id)
        {
        }

        public void UpdateValue(ushort _value)
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

        public SerialInputSignal(ushort _id)
            : base(_id)
        {
        }

        public void UpdateValue(String _value)
        {
            SetSerialValue(_value);
        }
    }

    #endregion

    #region Output signals

    public class OutputSignal : Signal
    {
        public IdIntegerActionDelegate SendDigitalValueDelegate { get; set; }
        public IdIntegerActionDelegate SendAnalogValueDelegate { get; set; }
        public IdStringActionDelegate SendSerialValueDelegate { get; set; }

        public OutputSignal()
            : base()
        {
        }

        public OutputSignal(ushort _id)
            : base(_id)
        {
        }

        protected override void SetDigitalValue(ushort _value)
        {
            if (SendDigitalValueDelegate != null) SendDigitalValueDelegate(Id, _value);

            base.SetDigitalValue(_value);
        }

        protected override void SetAnalogValue(ushort _value)
        {
            if (SendAnalogValueDelegate != null) SendAnalogValueDelegate(Id, _value);

            base.SetAnalogValue(_value);
        }

        protected override void SetSerialValue(SimplSharpString _value)
        {
            if (SendSerialValueDelegate != null) SendSerialValueDelegate(Id, _value);

            base.SetSerialValue(_value);
        }
    }

    public class DigitalOutputSignal : OutputSignal
    {
        public DigitalOutputSignal()
            : base()
        {
        }

        public DigitalOutputSignal(ushort _id)
            : base(_id)
        {
        }

        public void SendValue(ushort _value)
        {
            SetDigitalValue(_value);
        }
    }

    public class AnalogOutputSignal : OutputSignal
    {
        public AnalogOutputSignal()
            : base()
        {
        }

        public AnalogOutputSignal(ushort _id)
            : base(_id)
        {
        }

        public void SendValue(ushort _value)
        {
            SetAnalogValue(_value);
        }
    }

    public class SerialOutputSignal : OutputSignal
    {
        public SerialOutputSignal()
            : base()
        {
        }

        public SerialOutputSignal(ushort _id)
            : base(_id)
        {
        }

        public void SendValue(SimplSharpString _value)
        {
            SetSerialValue(_value);
        }
    }

    #endregion

}