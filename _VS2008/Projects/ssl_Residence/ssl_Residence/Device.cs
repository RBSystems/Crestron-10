using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;
using ssl_Utility;

namespace ssl_Residence
{
    public interface IPowerable
    {
        bool IsOn { get; }

        void On();
        void Off();
        void Toggle();
    }

    public class Device
    {
        public String Name { get; protected set; }
        public Zone Location { get; protected set; }

        public Device()
        {
            Name = "";
        }

        public void SetLocation(Zone location)
        {
            Location = location;
        }

        public void SetName(String name)
        {
            Name = name;
        }
    }

    public class Light : Device, IPowerable
    {
        protected bool _isOn;
        
        public ushort Id { get; private set; }
        public bool IsOn { get { return _isOn; } }

        public Light(ushort id)
        {
            Id = id;
            _isOn = false;
        }

        public virtual void On()
        {
        }

        public virtual void Off()
        {
        }

        public void Toggle()
        {
            if (_isOn) Off();
            else On();
        }
    }

    public class SwitchLight : Light
    {
        private DigitalInputSignal _powerFBSignal;
        private DigitalOutputSignal _powerOnSignal;
        private DigitalOutputSignal _powerOffSignal;

        public SwitchLight(ushort id, DigitalInputSignal powerFBSignal, DigitalOutputSignal powerOnSignal, DigitalOutputSignal powerOffSignal)
            : base(id)
        {
            _powerFBSignal = powerFBSignal;
            _powerOnSignal = powerOnSignal;
            _powerOffSignal = powerOffSignal;

            _powerFBSignal.ValueChanged += new EventHandler(PowerFBSignalChanged);
        }

        private void PowerFBSignalChanged(object sender, EventArgs e)
        {
            _isOn = _powerFBSignal.Value;
            DebugHelper.PrintDebugTrace("SwitchLight nr " + Id + " is " + (_isOn?"ON":"OFF"));
        }
        
        public override void On()
        {
            _powerOnSignal.Pulse();
        }

        public override void Off()
        {
            _powerOffSignal.Pulse();
        }
    }

    public class DimLight : Light
    {
        private AnalogInputSignal _levelFBSignal;
        private AnalogOutputSignal _levelSignal;
        private ushort _maxLevel = ushort.MaxValue;

        public ushort Level { get; private set; }
        
        public DimLight(ushort id, AnalogInputSignal levelFBSignal, AnalogOutputSignal levelSignal)
            : base(id)
        {
            _levelFBSignal = levelFBSignal;
            _levelSignal = levelSignal;

            _levelFBSignal.ValueChanged += new EventHandler(LevelFBSignalChanged);
        }

        void LevelFBSignalChanged(object sender, EventArgs e)
        {
            _isOn = _levelFBSignal.ToDigital();
            Level = _levelFBSignal.Value;
        }

        public void SetMaxLevel(ushort maxLevel)
        {
            _maxLevel = maxLevel;
        }

        public override void On()
        {
            _levelSignal.SendValue(_maxLevel);
        }

        public override void Off()
        {
            _levelSignal.SendValue(0);
        }

        public void SetLevel(ushort level)
        {
            if (level > _maxLevel) _levelSignal.SendValue(_maxLevel);
            else _levelSignal.SendValue(level);
        }
    }
}