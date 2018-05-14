using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public enum eLoadType : ushort { LIGHT = 0, OUTLET, OTHER };

    public class Device
    {
        public String Name { get; protected set; }

        public Device()
        {
            Name = "";
        }

        public void SetName(String name)
        {
            Name = name;
        }
    }

    public class Load : Device
    {
        public event EventHandler Changed;

        public eLoadType LoadType { get; private set; }

        public ushort Id { get; private set; }
        public bool IsOn {get; protected set;}

        public Load()
        {
        }
        
        public Load(ushort id, eLoadType loadType)
        {
            Id = id;
            LoadType = loadType;
            IsOn = false;
        }

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

    public class SwitchLoad : Load
    {
        private Relay _relay;

        public SwitchLoad(ushort id, eLoadType loadType, Relay relay)
            : base(id, loadType)
        {
            _relay = relay;
            _relay.Changed += new EventHandler(RelayChangedHandler);
        }

        private void RelayChangedHandler(object sender, EventArgs e)
        {
            IsOn = _relay.IsOn;
            OnChanged();
        }
        
        public override void On()
        {
            _relay.On();
        }

        public override void Off()
        {
            _relay.Off();
        }
    }

    public class DimLoad : Load
    {
        private Dimmer _dimmer;
        private ushort _maxLevel = ushort.MaxValue;

        public ushort Level { get; private set; }

        public ushort Percent
        {
            get
            {
                return (ushort) ( (100 * (int)Level) / _maxLevel );
            }
        }

        public DimLoad()
        {
        }

        public DimLoad(ushort id, eLoadType loadType, Dimmer dimmer)
            : base(id, loadType)
        {
            _dimmer = dimmer;
            _dimmer.Changed += new EventHandler(DimmerChangedHandler);
        }

        private void DimmerChangedHandler(object sender, EventArgs e)
        {
            IsOn = _dimmer.IsOn;
            Level = _dimmer.Level;
            OnChanged();
        }

        public void SetMaxLevel(ushort maxLevel)
        {
            _maxLevel = maxLevel;
        }

        public override void On()
        {
            _dimmer.On();
        }

        public override void Off()
        {
            _dimmer.Off();
        }

        public void SetLevel(ushort level)
        {
            _dimmer.SetLevel(level);
        }

        public void Raise()
        {
            _dimmer.Raise();
        }

        public void Lower()
        {
            _dimmer.Lower();
        }

        public void Stop()
        {
            _dimmer.Stop();
        }
    }

}