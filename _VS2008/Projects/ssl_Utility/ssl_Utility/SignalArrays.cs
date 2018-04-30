using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;


namespace ssl_Utility
{
    public class SignalArray
    {
        protected Module _module;
        protected ushort _index;

        public Module Module { get { return _module; } }
        public ushort Index { get { return _index; } }

        public SignalArray(Module module, ushort index)
        {
            _module = module;
            _index = index;
        }
    }


    public class DigitalInputSignalArray : SignalArray
    {
        private DigitalInputSignal[] _signals;

        public DigitalInputSignalArray(Module module, ushort index, ushort signalCount)
            : base(module, index)
        {
            _signals = new DigitalInputSignal[signalCount + 1];

            for (ushort i = 1; i <= signalCount; i++) _signals[i] = new DigitalInputSignal(this, i);
        }

        public void Update(ushort signalIndex, bool value)
        {
            try
            {
                _signals[signalIndex].UpdateValue(value);
            }
            catch (Exception ex)
            {
            }
        }
    }

    public class DigitalOutputSignalArray : SignalArray
    {
        private DigitalOutputSignal[] _signals;

        public DigitalOutputSignalArray(Module module, ushort index, ushort signalCount)
            : base(module, index)
        {
            _signals = new DigitalOutputSignal[signalCount + 1];

            for (ushort i = 1; i <= signalCount; i++) _signals[i] = new DigitalOutputSignal(this, i);
        }

        public void Send(DigitalOutputSignal signal)
        {
            _module.SendDigitalOutput(signal);
        }
    }

    public class AnalogInputSignalArray : SignalArray
    {
        private AnalogInputSignal[] _signals;

        public AnalogInputSignalArray(Module module, ushort index, ushort signalCount)
            : base(module, index)
        {
            _signals = new AnalogInputSignal[signalCount + 1];

            for (ushort i = 1; i <= signalCount; i++) _signals[i] = new AnalogInputSignal(this, i);
        }

        public virtual void Update(ushort signalIndex, ushort value)
        {
            try
            {
                _signals[signalIndex].UpdateValue(value);
            }
            catch (Exception ex)
            {
            }
        }
    }

    public class AnalogOutputSignalArray : SignalArray
    {
        private AnalogOutputSignal[] _signals;

        public AnalogOutputSignalArray(Module module, ushort index, ushort signalCount)
            : base(module, index)
        {
            _signals = new AnalogOutputSignal[signalCount + 1];

            for (ushort i = 1; i <= signalCount; i++) _signals[i] = new AnalogOutputSignal(this, i);
        }

        public void Send(AnalogOutputSignal signal)
        {
            _module.SendAnalogOutput(signal);
        }
    }

    public class StringInputSignalArray : SignalArray
    {
        private StringInputSignal[] _signals;

        public StringInputSignalArray(Module module, ushort index, ushort signalCount)
            : base(module, index)
        {
            _signals = new StringInputSignal[signalCount + 1];

            for (ushort i = 1; i <= signalCount; i++) _signals[i] = new StringInputSignal(this, i);
        }

        public virtual void Update(ushort signalIndex, String value)
        {
            try
            {
                _signals[signalIndex].UpdateValue(value);
            }
            catch (Exception ex)
            {
            }
        }
    }

    public class StringOutputSignalArray : SignalArray
    {
        private StringOutputSignal[] _signals;

        public StringOutputSignalArray(Module module, ushort index, ushort signalCount)
            : base(module, index)
        {
            _signals = new StringOutputSignal[signalCount + 1];

            for (ushort i = 1; i <= signalCount; i++) _signals[i] = new StringOutputSignal(this, i);
        }

        public void Send(StringOutputSignal signal)
        {
            _module.SendStringOutput(signal);
        }
    }
}
