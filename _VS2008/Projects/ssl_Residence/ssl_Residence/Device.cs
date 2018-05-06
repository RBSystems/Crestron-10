using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;
using ssl_Utility;

namespace ssl_Residence
{

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

    public class Light : Device
    {
        public ushort Id { get; private set; }
        public bool IsOn {get; protected set;}

        public Light()
        {
        }
        
        public Light(ushort id)
        {
            Id = id;
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
    }

    public class SwitchLight : Light
    {
        private SwitchLoad _load;

        public SwitchLight()
        {
        }

        public SwitchLight(ushort id, SwitchLoad load)
            : base(id)
        {
            _load = load;
            _load.Changed += new EventHandler(LoadChanged);
        }

        private void LoadChanged(object sender, EventArgs e)
        {
            IsOn = _load.IsOn;
            //DebugHelper.PrintDebugTrace("SwitchLight nr " + Id + " (" + Name + ") is " + (IsOn?"ON":"OFF"));
        }
        
        public override void On()
        {
            _load.On();
        }

        public override void Off()
        {
            _load.Off();
        }
    }

    public class SwitchOutlet : SwitchLight
    {
        public SwitchOutlet()
        {
        }

        public SwitchOutlet(ushort id, SwitchLoad load)
            : base(id, load)
        {
        }
    }

    public class DimLight : Light
    {
        private DimLoad _load;
        private ushort _maxLevel = ushort.MaxValue;

        public ushort Level { get; private set; }

        public DimLight()
        {
        }

        public DimLight(ushort id, DimLoad load)
            : base(id)
        {
            _load = load;

            _load.Changed += new EventHandler(LoadChanged);
        }

        private void LoadChanged(object sender, EventArgs e)
        {
            IsOn = _load.IsOn;
            Level = _load.Level;
        }

        public void SetMaxLevel(ushort maxLevel)
        {
            _maxLevel = maxLevel;
        }

        public override void On()
        {
            _load.On();
        }

        public override void Off()
        {
            _load.Off();
        }

        public void SetLevel(ushort level)
        {
            _load.SetLevel(level);
        }

        public void Raise()
        {
            _load.Raise();
        }

        public void Lower()
        {
            _load.Lower();
        }

        public void Stop()
        {
            _load.Stop();
        }
    }
}