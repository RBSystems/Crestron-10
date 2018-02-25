using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public static class ModuleHelper
    {
        public const ushort MAX_MODULES_COUNT = 101;
    }
    
    public class UniversalModule
    {
        public ushort Id { get; private set; }

        public DigitalInputSignal[] DigitalInputArray = new DigitalInputSignal[SignalHelper.MAX_SIGNAL_COUNT];
        public AnalogInputSignal[] AnalogInputArray = new AnalogInputSignal[SignalHelper.MAX_SIGNAL_COUNT];
        public SerialInputSignal[] SerialInputArray = new SerialInputSignal[SignalHelper.MAX_SIGNAL_COUNT];

        public DigitalOutputSignal[] DigitalOutputArray = new DigitalOutputSignal[SignalHelper.MAX_SIGNAL_COUNT];
        public AnalogOutputSignal[] AnalogOutputArray = new AnalogOutputSignal[SignalHelper.MAX_SIGNAL_COUNT];
        public SerialOutputSignal[] SerialOutputArray = new SerialOutputSignal[SignalHelper.MAX_SIGNAL_COUNT];

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

    public static class ModuleContainer
    {
        public static event EventHandler InitializedEvent;

        public static ushort IsInitialized { get; private set; }
        
        public static UniversalModule[] UniversalModuleArray = new UniversalModule[ModuleHelper.MAX_MODULES_COUNT];

        public static void Initialize()
        {
            DebugHelper.PrintTrace("ModuleContainer - Start initializing");
            
            for (ushort i = 0; i < ModuleHelper.MAX_MODULES_COUNT; i++)
            {
                UniversalModuleArray[i] = new UniversalModule();
                UniversalModuleArray[i].SetId(i);
            }
            
            IsInitialized = 1;
            OnInitialized();
        }

        private static void OnInitialized()
        {
            DebugHelper.PrintTrace("ModuleContainer - OnInitialized");
            if (InitializedEvent != null) InitializedEvent(new Dummy(), EventArgs.Empty);
        }

        public static void Test_01()
        {
            UniversalModuleArray[1].DigitalOutputArray[1].SendValue(1);
            UniversalModuleArray[1].AnalogOutputArray[2].SendValue(100);
            UniversalModuleArray[1].AnalogOutputArray[2].SendValue(1000);
            UniversalModuleArray[1].AnalogOutputArray[2].SendValue(10000);
            UniversalModuleArray[1].SerialOutputArray[3].SendValue("Test_01");
        }

        public static void Test_02()
        {
            UniversalModuleArray[2].DigitalOutputArray[3].SendValue(1);
            UniversalModuleArray[2].DigitalOutputArray[3].SendValue(0);
            UniversalModuleArray[2].DigitalOutputArray[3].SendValue(1);
            UniversalModuleArray[2].DigitalOutputArray[3].SendValue(0);
            UniversalModuleArray[2].AnalogOutputArray[1].SendValue(2014);
            UniversalModuleArray[2].SerialOutputArray[2].SendValue("Test_02");
        }

    }
}