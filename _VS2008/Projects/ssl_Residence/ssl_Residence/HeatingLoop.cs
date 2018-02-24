using System;
using System.Text;
using Crestron.SimplSharp;
using ssl_Utility;

namespace ssl_Residence
{
    public delegate void DTurnHeatingLoopOn();
    public delegate void DTurnHeatingLoopOff();
    
    public class HeatingLoop
    {
        public static ushort COUNT = 64;
        
        public DTurnHeatingLoopOn TurnHeatingLoopOn { get; set; }
        public DTurnHeatingLoopOff TurnHeatingLoopOff { get; set; }
        
        public ushort Id { get; private set; }
        public ushort PowerState{ get; private set; } // 0 = Off, 1 = On

        public HeatingLoop()
        {
            Id = 0;
            PowerState = 0;
            DebugHelper.PrintTrace("Utworzono petle 0 (default)");
        }
        
        public HeatingLoop(ushort _id)
        {
            Id = _id;
            PowerState = 0;
            DebugHelper.PrintTrace("Utworzono petle ID = " + _id);
        }

        public void UpdatePowerState(ushort _powerState)
        {
            PowerState = _powerState;
            DebugHelper.PrintTrace("Petla ID = " + Id + " zaktualizowala swoj stan = " + _powerState);
        }

        public void PowerOn()
        {
            if (TurnHeatingLoopOn != null)
            {
                TurnHeatingLoopOn();
            }
        }

        public void PowerOff()
        {
            if (TurnHeatingLoopOff != null) TurnHeatingLoopOff();
        }

        public void PowerToggle()
        {
            if (PowerState == 0) PowerOn();
            else PowerOff();
        }
    }
}