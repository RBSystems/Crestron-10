using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;



namespace ssl_Utility
{

    public class Signal
    {
        public event EventHandler ValueChanged;

        protected ushort _index;

        public ushort Index { get { return _index; } }

        public Signal(ushort index)
        {
            _index = index;
        }

        protected virtual void OnValueChanged()
        {
            if (ValueChanged != null) ValueChanged(this, EventArgs.Empty);
            DebugHelper.PrintDebugTrace("Signal changed: Type = " + this.GetType().ToString() + " | Index = " + this.Index );
        }
    }

    public class DigitalSignal : Signal
    {
        protected bool _value;

        public bool Value { get { return _value; } }

        public DigitalSignal(ushort index)
            : base(index)
        {
        }

        public ushort ToAnalog()
        {
            return (ushort)(_value ? 1 : 0);
        }

        public override String ToString()
        {
            return _value.ToString();
        }

        protected override void OnValueChanged()
        {
            base.OnValueChanged();
            DebugHelper.PrintDebugTrace("DigitalSignal changed: Type = " + this.GetType().ToString() + " | Value = " + this.Value);
        }
    }

    public class DigitalInputSignal : DigitalSignal
    {
        private DigitalInputSignalArray _array;

        public DigitalInputSignalArray Array { get { return _array; } }

        public DigitalInputSignal(DigitalInputSignalArray array, ushort index)
            : base(index)
        {
            _array = array;
        }

        public void UpdateValue(bool value)
        {
            if (_value == value) return;

            _value = value;
            OnValueChanged();
        }

        protected override void OnValueChanged()
        {
            base.OnValueChanged();
            DebugHelper.PrintDebugTrace("DigitalInputSignal changed: Type = " + this.GetType().ToString() + " | ArrayId = " + this.Array.Index);
        }
    }

    public class DigitalOutputSignal : DigitalSignal
    {
        private DigitalOutputSignalArray _array;

        public DigitalOutputSignalArray Array { get { return _array; } }

        public DigitalOutputSignal(DigitalOutputSignalArray array, ushort index)
            : base(index)
        {
            _array = array;
        }

        public void SendValue(bool value)
        {
            _value = value;
            _array.Send(this);
        }
    }


    public class AnalogSignal : Signal
    {
        protected ushort _value;

        public ushort Value { get { return _value; } }

        public AnalogSignal(ushort index)
            : base(index)
        {
        }

        public bool ToDigital()
        {
            return (_value == 0 ? false : true);
        }

        public override String ToString()
        {
            return _value.ToString();
        }
    }


    public class AnalogInputSignal : AnalogSignal
    {
        private AnalogInputSignalArray _array;

        public AnalogInputSignalArray Array { get { return _array; } }

        public AnalogInputSignal(AnalogInputSignalArray array, ushort index)
            : base(index)
        {
            _array = array;
        }

        public void UpdateValue(ushort value)
        {
            if (_value == value) return;

            _value = value;
            OnValueChanged();
        }
    }

    public class AnalogOutputSignal : AnalogSignal
    {
        private AnalogOutputSignalArray _array;

        public AnalogOutputSignalArray Array { get { return _array; } }

        public AnalogOutputSignal(AnalogOutputSignalArray array, ushort index)
            : base(index)
        {
            _array = array;
        }

        public void SendValue(ushort value)
        {
            _value = value;
            _array.Send(this);
        }
    }


    public class StringSignal : Signal
    {
        protected String _value = "";

        public String Value { get { return _value; } }

        public StringSignal(ushort index)
            : base(index)
        {
        }

        public bool ToDigital()
        {
            return (_value.Length == 0 ? false : true);
        }

        public ushort ToAnalog()
        {
            return (ushort)_value.Length;
        }
    }


    public class StringInputSignal : StringSignal
    {
        private StringInputSignalArray _array;

        public StringInputSignalArray Array { get { return _array; } }

        public StringInputSignal(StringInputSignalArray array, ushort index)
            : base(index)
        {
            _array = array;
        }

        public void UpdateValue(String value)
        {
            if (_value == value) return;

            _value = value;
            OnValueChanged();
        }
    }

    public class StringOutputSignal : StringSignal
    {
        private StringOutputSignalArray _array;

        public StringOutputSignalArray Array { get { return _array; } }

        public StringOutputSignal(StringOutputSignalArray array, ushort index)
            : base(index)
        {
            _array = array;
        }

        public void SendValue(String value)
        {
            _value = value;
            _array.Send(this);
        }
    }

}   