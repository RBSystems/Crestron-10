using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public class Actuator
    {
        public event EventHandler Changed;

        public bool IsOn { get; protected set; }

        public virtual void On()
        {
        }

        public virtual void Off()
        {
        }

        public void Toggle()
        {
            if (IsOn) Off();
            else On();
        }

        protected virtual void OnChanged()
        {
            if (Changed != null) Changed(this, EventArgs.Empty);
        }
    }

    public class Relay : Actuator
    {
        private DigitalInputSignal _powerFBSignal;
        private DigitalOutputSignal _powerOnSignal;
        private DigitalOutputSignal _powerOffSignal;

        public Relay(DigitalInputSignal powerFBSignal, DigitalOutputSignal powerOnSignal, DigitalOutputSignal powerOffSignal)
        {
            _powerFBSignal = powerFBSignal;
            _powerOnSignal = powerOnSignal;
            _powerOffSignal = powerOffSignal;

            _powerFBSignal.ValueChanged += new EventHandler(PowerFBSignalChanged);
        }

        public override void On()
        {
            _powerOnSignal.Pulse();
        }

        public override void Off()
        {
            _powerOffSignal.Pulse();
        }

        private void PowerFBSignalChanged(object sender, EventArgs e)
        {
            IsOn = _powerFBSignal.Value;
            OnChanged();
        }

    }

    public class Dimmer : Actuator
    {
        private AnalogInputSignal _levelFBSignal;
        private AnalogOutputSignal _levelSignal;
        private DigitalOutputSignal _raiseSignal;
        private DigitalOutputSignal _lowerSignal;
        private ushort _maxLevel = ushort.MaxValue;

        public bool IsChanging { get; protected set; }
        public ushort Level { get; private set; }

        public Dimmer(AnalogInputSignal levelFBSignal, AnalogOutputSignal levelSignal, DigitalOutputSignal raiseSignal, DigitalOutputSignal lowerSignal)
        {
            _levelFBSignal = levelFBSignal;
            _levelSignal = levelSignal;
            _raiseSignal = raiseSignal;
            _lowerSignal = lowerSignal;

            _levelFBSignal.ValueChanged += new EventHandler(LevelFBSignalChanged);
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

        public void Raise()
        {
            if (IsChanging) return;

            IsChanging = true;
            _raiseSignal.SendValue(true);
        }

        public void Lower()
        {
            if (IsChanging) return;

            IsChanging = true;
            _lowerSignal.SendValue(true);
        }

        public void Stop()
        {
            if (!IsChanging) return;

            IsChanging = false;
            _raiseSignal.SendValue(false);
            _lowerSignal.SendValue(false);
        }

        private void LevelFBSignalChanged(object sender, EventArgs e)
        {
            IsOn = _levelFBSignal.ToDigital();
            Level = _levelFBSignal.Value;
            OnChanged();
        }

    }

}