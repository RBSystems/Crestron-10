using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;


namespace ssl_Utility
{
    public class PlusModule
    {
        public ActionUshortUshortUshortDelegate SendDigitalOutputDelegate { get; set; }
        public ActionUshortUshortUshortDelegate SendAnalogOutputDelegate { get; set; }
        public ActionUshortUshortStringDelegate SendStringOutputDelegate { get; set; }
        
        private ushort _digitalInputArrayCount;
        private ushort _analogInputArrayCount;
        private ushort _stringInputArrayCount;

        private ushort _digitalOutputArrayCount;
        private ushort _analogOutputArrayCount;
        private ushort _stringOutputArrayCount;

        private DigitalInputSignalArray[] _digitalInputArrays;
        private AnalogInputSignalArray[] _analogInputArrays;
        private StringInputSignalArray[] _stringInputArrays;

        private DigitalOutputSignalArray[] _digitalOutputArrays;
        private AnalogOutputSignalArray[] _analogOutputArrays;
        private StringOutputSignalArray[] _stringOutputArrays;        

        public PlusModule()
        {
        }

        #region Arrays Count Setters

        public void SetDigitalInputArrayCount(ushort count)
        {
            _digitalInputArrayCount = count;
            _digitalInputArrays = new DigitalInputSignalArray[count];

        }

        public void SetAnalogInputArrayCount(ushort count)
        {
            _analogInputArrayCount = count;
            _analogInputArrays = new AnalogInputSignalArray[count];

        }

        public void SetStringInputArrayCount(ushort count)
        {
            _stringInputArrayCount = count;
            _stringInputArrays = new StringInputSignalArray[count];

        }

        public void SetDigitalOutputArrayCount(ushort count)
        {
            _digitalOutputArrayCount = count;
            _digitalOutputArrays = new DigitalOutputSignalArray[count];

        }

        public void SetAnalogOutputArrayCount(ushort count)
        {
            _analogOutputArrayCount = count;
            _analogOutputArrays = new AnalogOutputSignalArray[count];

        }

        public void SetStringOutputArrayCount(ushort count)
        {
            _stringOutputArrayCount = count;
            _stringOutputArrays = new StringOutputSignalArray[count];

        }

        #endregion

        #region Array Creators

        public void CreateDigitalInputArray(ushort index, ushort signalCount)
        {
            try
            {
                _digitalInputArrays[index] = new DigitalInputSignalArray(this, index, signalCount);
            }
            catch (Exception ex)
            {
            }
        }

        public void CreateAnalogInputArray(ushort index, ushort signalCount)
        {
            try
            {
                _analogInputArrays[index] = new AnalogInputSignalArray(this, index, signalCount);
            }
            catch (Exception ex)
            {
            }
        }

        public void CreateStringInputArray(ushort index, ushort signalCount)
        {
            try
            {
                _stringInputArrays[index] = new StringInputSignalArray(this, index, signalCount);
            }
            catch (Exception ex)
            {
            }
        }

        public void CreateDigitalOutputArray(ushort index, ushort signalCount)
        {
            try
            {
                _digitalOutputArrays[index] = new DigitalOutputSignalArray(this, index, signalCount);
            }
            catch (Exception ex)
            {
            }
        }

        public void CreateAnalogOutputArray(ushort index, ushort signalCount)
        {
            try
            {
                _analogOutputArrays[index] = new AnalogOutputSignalArray(this, index, signalCount);
            }
            catch (Exception ex)
            {
            }
        }

        public void CreateStringOutputArray(ushort index, ushort signalCount)
        {
            try
            {
                _stringOutputArrays[index] = new StringOutputSignalArray(this, index, signalCount);
            }
            catch (Exception ex)
            {
            }
        }

        #endregion

        #region Inputs Updaters

        public void UpdateDigitalInput(ushort arrayIndex, ushort signalIndex, ushort value)
        {
            try
            {
                _digitalInputArrays[arrayIndex].Update(signalIndex, (value == 0 ? false : true));
            }
            catch (Exception ex)
            {
            }
        }

        public void UpdateAnalogInput(ushort arrayIndex, ushort signalIndex, ushort value)
        {
            try
            {
                _analogInputArrays[arrayIndex].Update(signalIndex, value);
            }
            catch (Exception ex)
            {
            }
        }

        public void UpdateStringInput(ushort arrayIndex, ushort signalIndex, String value)
        {
            try
            {
                _stringInputArrays[arrayIndex].Update(signalIndex, value);
            }
            catch (Exception ex)
            {
            }
        }

        #endregion

        #region Outputs senders

        public void SendDigitalOutput(DigitalOutputSignal signal)
        {
            if (SendDigitalOutputDelegate != null) SendDigitalOutputDelegate(signal.Array.Index, signal.Index, signal.ToAnalog());
        }

        public void SendAnalogOutput(AnalogOutputSignal signal)
        {
            if (SendAnalogOutputDelegate != null) SendAnalogOutputDelegate(signal.Array.Index, signal.Index, signal.Value);
        }

        public void SendStringOutput(StringOutputSignal signal)
        {
            if (SendStringOutputDelegate != null) SendStringOutputDelegate(signal.Array.Index, signal.Index, signal.Value);
        }

        #endregion

        #region Signal Getters

        public DigitalInputSignal GetDigitalInput(ushort arrayIndex, ushort signalIndex)
        {
            return _digitalInputArrays[arrayIndex].Signals[signalIndex];
        }

        public AnalogInputSignal GetAnalogInput(ushort arrayIndex, ushort signalIndex)
        {
            return _analogInputArrays[arrayIndex].Signals[signalIndex];
        }

        public StringInputSignal GetStringInput(ushort arrayIndex, ushort signalIndex)
        {
            return _stringInputArrays[arrayIndex].Signals[signalIndex];
        }

        public DigitalOutputSignal GetDigitalOutput(ushort arrayIndex, ushort signalIndex)
        {
            return _digitalOutputArrays[arrayIndex].Signals[signalIndex];
        }

        public AnalogOutputSignal GetAnalogOutput(ushort arrayIndex, ushort signalIndex)
        {
            return _analogOutputArrays[arrayIndex].Signals[signalIndex];
        }

        public StringOutputSignal GetStringOutput(ushort arrayIndex, ushort signalIndex)
        {
            return _stringOutputArrays[arrayIndex].Signals[signalIndex];
        }

        #endregion
    }
}
