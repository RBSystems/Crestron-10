using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{

    public class TestModule
    {
        public DigitalIn SingleDigitalInput_01 { get; set; }
        public AnalogIn SingleAnalogInput_01 { get; set; }
        public StringIn SingleStringInput_01 { get; set; }

        public DigitalInArray DigitalInputArray_01 { get; set; }

        public DigitalOut SingleDigitalOutput_01 { get; set; }
        public AnalogOut SingleAnalogOutput_01 { get; set; }
        public StringOut SingleStringOutput_01 { get; set; }
        
        public TestModule()
        {
            SingleDigitalInput_01 = new DigitalIn();
            SingleAnalogInput_01 = new AnalogIn();
            SingleStringInput_01 = new StringIn();

            DigitalInputArray_01 = new DigitalInArray(20);

            SingleDigitalOutput_01 = new DigitalOut();
            SingleAnalogOutput_01 = new AnalogOut();
            SingleStringOutput_01 = new StringOut();

            SingleDigitalInput_01.DigitalValueChanged += DigitalOutTest;
            SingleAnalogInput_01.AnalogValueChanged += AnalogOutTest;
            SingleStringInput_01.StringValueChanged += StringOutTest;
        }

        private void DigitalOutTest(Object o, EventArgs e)
        {
            DebugHelper.PrintTrace("DigitalOutTest: 0-1-0-0-1");
            SingleDigitalOutput_01.DigitalValue = false;
            SingleDigitalOutput_01.DigitalValue = true;
            SingleDigitalOutput_01.DigitalValue = false;
            SingleDigitalOutput_01.DigitalValue = false;
            SingleDigitalOutput_01.DigitalValue = true;

        }

        private void AnalogOutTest(Object o, EventArgs e)
        {
            DebugHelper.PrintTrace("AnalogOutTest: 0-10-50-100-100-0-50");
            SingleAnalogOutput_01.AnalogValue = 0;
            SingleAnalogOutput_01.AnalogValue = 10;
            SingleAnalogOutput_01.AnalogValue = 50;
            SingleAnalogOutput_01.AnalogValue = 100;
            SingleAnalogOutput_01.AnalogValue = 100;
            SingleAnalogOutput_01.AnalogValue = 0;
            SingleAnalogOutput_01.AnalogValue = 50;
        }

        private void StringOutTest(Object o, EventArgs e)
        {
            DebugHelper.PrintTrace("StringOutTest: 0-Ala-Ma-Ma-0-Kota");
            SingleStringOutput_01.StringValue = "";
            SingleStringOutput_01.StringValue = "Ala";
            SingleStringOutput_01.StringValue = "Ma";
            SingleStringOutput_01.StringValue = "Ma";
            SingleStringOutput_01.StringValue = "";
            SingleStringOutput_01.StringValue = "Kota";
        }
    }

    #region Inputs

    public class DigitalIn
    {
        public event EventHandler DigitalValueChanged;
        
        private bool digitalValue;

        public bool DigitalValue { get { return digitalValue; } }

        public DigitalIn()
        {
        }

        private void OnDigitalValueChanged()
        {
            if (DigitalValueChanged != null) DigitalValueChanged(this, EventArgs.Empty);

            DebugHelper.PrintTrace("DigitalValueChanged: " + digitalValue.ToString());
        }

        public void SetDigitalValue(ushort _digitalValue)
        {
            bool tmpVal = (_digitalValue == 0 ? false : true);

            if (digitalValue != tmpVal)
            {
                digitalValue = tmpVal;
                OnDigitalValueChanged();
            }
        }
    }

    public class AnalogIn
    {
        public event EventHandler AnalogValueChanged;
        
        private ushort analogValue;

        public ushort AnalogValue { get { return analogValue; } }
        // TODO Conversion to signed (short)

        public AnalogIn()
        {
        }

        private void OnAnalogValueChanged()
        {
            if (AnalogValueChanged != null) AnalogValueChanged(this, EventArgs.Empty);

            DebugHelper.PrintTrace("AnalogValueChanged (ushort): " + analogValue.ToString());
        }

        public void SetAnalogValue(ushort _analogValue)
        {
            if (analogValue != _analogValue)
            {
                analogValue = _analogValue;
                OnAnalogValueChanged();
            }
        }
    }

    public class StringIn
    {
        public event EventHandler StringValueChanged;

        private String stringValue;

        public String StringValue { get { return stringValue; } }

        public StringIn()
        {
            stringValue = "";
        }

        private void OnStringValueChanged()
        {
            if (StringValueChanged != null) StringValueChanged(this, EventArgs.Empty);

            DebugHelper.PrintTrace("StringValueChanged: " + stringValue);
        }

        public void SetStringValue(String _stringValue)
        {
            if (stringValue != _stringValue)
            {
                stringValue = _stringValue;
                OnStringValueChanged();
            }
        }
    }

    public class DigitalInArray
    {
        public event EventHandler DigitalInputChanged;
        
        private ushort inputCount;
        private ushort lastModifiedArrayIndex;

        public DigitalIn[] DigitalInputs { get; set; }

        public ushort LastModifiedArrayIndex
        {
            get { return lastModifiedArrayIndex; }
            set
            {
                lastModifiedArrayIndex = value;
                OnDigitalInputChanged();
            }
        }

        public DigitalInArray()
        {
        }

        public DigitalInArray(ushort _inputCount)
        {
            inputCount = _inputCount;
            DigitalInputs = new DigitalIn[inputCount + 1];

            for (ushort i = 1; i <= inputCount; i++)
            {
                DigitalInputs[i] = new DigitalIn();
            }
        }

        public void SetDigitalValue(ushort _index, ushort _digitalValue)
        {
            if (DigitalInputs == null || _index == 0) return;

            bool tmpVal = _digitalValue == 0 ? false : true;

            if (DigitalInputs[_index].DigitalValue != tmpVal)
            {
                DigitalInputs[_index].SetDigitalValue(_digitalValue);
                LastModifiedArrayIndex = _index;
            }
        }

        public void OnDigitalInputChanged()
        {
            if (DigitalInputChanged != null) DigitalInputChanged(this, EventArgs.Empty);

            DebugHelper.PrintTrace("DigitalInputArray Changed at index = " + this.LastModifiedArrayIndex);
        }
    }

    #endregion

    #region Outputs

    public class DigitalOut
    {
        public IntegerActionDelegate SendDigitalValueDelegate { get; set; }
        public event EventHandler DigitalValueChanged;
        
        private bool digitalValue;

        public bool DigitalValue
        {
            get { return digitalValue; }
            set
            {
                if (value != digitalValue)
                {
                    digitalValue = value;
                    OnDigitalValueChanged();
                }

                if (SendDigitalValueDelegate != null) SendDigitalValueDelegate((ushort)(value ? 1 : 0));
            }
        }

        public DigitalOut()
        {
        }

        private void OnDigitalValueChanged()
        {
            if (DigitalValueChanged != null) DigitalValueChanged(this, EventArgs.Empty);
        }

    }

    public class AnalogOut
    {
        public IntegerActionDelegate SendAnalogValueDelegate { get; set; }
        public event EventHandler AnalogValueChanged;

        private ushort analogValue;

        public ushort AnalogValue
        {
            get { return analogValue; }
            set
            {
                if (value != analogValue)
                {
                    analogValue = value;
                    OnAnalogValueChanged();
                }

                if (SendAnalogValueDelegate != null) SendAnalogValueDelegate(value);
            }
        }

        public AnalogOut()
        {
        }

        private void OnAnalogValueChanged()
        {
            if (AnalogValueChanged != null) AnalogValueChanged(this, EventArgs.Empty);
        }

    }

    public class StringOut
    {
        public StringActionDelegate SendStringValueDelegate { get; set; }
        public event EventHandler StringValueChanged;

        private String stringValue;

        public String StringValue
        {
            get { return stringValue; }
            set
            {
                if (value != stringValue)
                {
                    stringValue = value;
                    OnStringValueChanged();
                }

                if (SendStringValueDelegate != null) SendStringValueDelegate(value);
            }
        }

        public StringOut()
        {
            stringValue = "";
        }

        private void OnStringValueChanged()
        {
            if (StringValueChanged != null) StringValueChanged(this, EventArgs.Empty);
        }

    }

    #endregion

}