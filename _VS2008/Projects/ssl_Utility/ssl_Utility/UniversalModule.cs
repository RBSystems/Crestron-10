using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public class UniversalModule
    {
        public ushort Id { get; private set; }
        
        public DigitalInputSignal[] DigitalInputArray;
        public AnalogInputSignal[] AnalogInputArray;
        public SerialInputSignal[] SerialInputArray;

        public DigitalOutputSignal[] DigitalOutputArray;
        public AnalogOutputSignal[] AnalogOutputArray;
        public SerialOutputSignal[] SerialOutputArray;

        public IdIntegerActionDelegate SendDigitalOutputDelegate { get; set; }
        public IdIntegerActionDelegate SendAnalogOutputDelegate { get; set; }
        public IdStringActionDelegate SendSerialOutputDelegate { get; set; }

        public UniversalModule()
        {
            Id = 0;
            InitializeSignals();
        }

        private void InitializeSignals()
        {
            DigitalInputArray = new DigitalInputSignal[SignalHelper.MAX_SIGNAL_COUNT];
            AnalogInputArray = new AnalogInputSignal[SignalHelper.MAX_SIGNAL_COUNT];
            SerialInputArray = new SerialInputSignal[SignalHelper.MAX_SIGNAL_COUNT];

            DigitalOutputArray = new DigitalOutputSignal[SignalHelper.MAX_SIGNAL_COUNT];
            AnalogOutputArray = new AnalogOutputSignal[SignalHelper.MAX_SIGNAL_COUNT];
            SerialOutputArray = new SerialOutputSignal[SignalHelper.MAX_SIGNAL_COUNT];
            
            for (ushort i = 0; i < SignalHelper.MAX_SIGNAL_COUNT; i++)
            {
                DigitalInputArray[i] = new DigitalInputSignal(i);
                AnalogInputArray[i] = new AnalogInputSignal(i);
                SerialInputArray[i] = new SerialInputSignal(i);

                DigitalOutputArray[i] = new DigitalOutputSignal(i);
                AnalogOutputArray[i] = new AnalogOutputSignal(i);
                SerialOutputArray[i] = new SerialOutputSignal(i);

                DigitalOutputArray[i].SendDigitalValueDelegate = SendDigitalValueCallback;
                AnalogOutputArray[i].SendAnalogValueDelegate = SendAnalogValueCallback;
                SerialOutputArray[i].SendSerialValueDelegate = SendSerialValueCallback;
            }
        }

        public void SetId(ushort _id)
        {
            Id = _id;
        }

        public void UpdateDigitalInput(ushort _id, ushort _value)
        {
            if (_id != 0) DigitalInputArray[_id].UpdateValue(_value);
        }

        public void UpdateAnalogInput(ushort _id, ushort _value)
        {
            if (_id != 0) AnalogInputArray[_id].UpdateValue(_value);
        }

        public void UpdateSerialInput(ushort _id, String _value)
        {
            if (_id != 0) SerialInputArray[_id].UpdateValue(_value);
        }

        private void SendDigitalValueCallback(ushort _id, ushort _value)
        {
            if (SendDigitalOutputDelegate != null) SendDigitalOutputDelegate(_id, _value);
        }

        private void SendAnalogValueCallback(ushort _id, ushort _value)
        {
            if (SendAnalogOutputDelegate != null) SendAnalogOutputDelegate(_id, _value);
        }

        private void SendSerialValueCallback(ushort _id, SimplSharpString _value)
        {
            if (SendSerialOutputDelegate != null) SendSerialOutputDelegate(_id, _value);
        }

    }
}