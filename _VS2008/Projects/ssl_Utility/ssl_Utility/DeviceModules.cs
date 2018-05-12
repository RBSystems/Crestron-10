using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{

    public class LoadsModule : PlusModule
    {
        public virtual void SetNumberOfLoads(ushort numberOfLoads)
        {
        }

        public virtual void AddLoad(ushort signalIndex, ushort loadId, ushort loadType, String name)
        {
        }
    }

    public class SwitchLoadsModule : LoadsModule
    {
        private const ushort FB_INPUT = 0;
        private const ushort ON_OUTPUT = 0;
        private const ushort OFF_OUTPUT = 1;

        public SwitchLoadsModule()
        {
            SetDigitalInputArrayCount(1);
            SetDigitalOutputArrayCount(2);
        }

        public override void SetNumberOfLoads(ushort numberOfLoads)
        {
            CreateDigitalInputArray(FB_INPUT, numberOfLoads);

            CreateDigitalOutputArray(ON_OUTPUT, numberOfLoads);
            CreateDigitalOutputArray(OFF_OUTPUT, numberOfLoads);
        }

        public override void AddLoad(ushort signalIndex, ushort loadId, ushort loadType, String name)
        {
            try
            {
                Relay relay = new Relay(GetDigitalInput(FB_INPUT, signalIndex), GetDigitalOutput(ON_OUTPUT, signalIndex), GetDigitalOutput(OFF_OUTPUT, signalIndex));
                SwitchLoad switchLoad = new SwitchLoad(loadId, (eLoadType)loadType, relay);
                switchLoad.SetName(name);
                SimplSystem.SwitchLoads.Add(loadId, switchLoad);
            }
            catch (Exception ex)
            {
            }
        }
    }

    public class DimLoadsModule : LoadsModule
    {
        private const ushort LEVEL_INPUT = 0;

        private const ushort RAISE_OUTPUT = 0;
        private const ushort LOWER_OUTPUT = 1;
        private const ushort LEVEL_OUTPUT = 0;


        public DimLoadsModule()
        {
            SetAnalogInputArrayCount(1);

            SetDigitalOutputArrayCount(2);
            SetAnalogOutputArrayCount(1);
        }

        public override void SetNumberOfLoads(ushort numberOfLoads)
        {
            CreateAnalogInputArray(LEVEL_INPUT, numberOfLoads);

            CreateDigitalOutputArray(RAISE_OUTPUT, numberOfLoads);
            CreateDigitalOutputArray(LOWER_OUTPUT, numberOfLoads);
            CreateAnalogOutputArray(LEVEL_OUTPUT, numberOfLoads);
        }

        public override void AddLoad(ushort signalIndex, ushort loadId, ushort loadType, String name)
        {
            try
            {
                Dimmer dimmer = new Dimmer(GetAnalogInput(LEVEL_INPUT, signalIndex),
                                            GetAnalogOutput(LEVEL_OUTPUT, signalIndex),
                                            GetDigitalOutput(RAISE_OUTPUT, signalIndex),
                                            GetDigitalOutput(LOWER_OUTPUT, signalIndex));

                DimLoad dimLight = new DimLoad(loadId, (eLoadType)loadType, dimmer);
                dimLight.SetName(name);
                SimplSystem.DimLoads.Add(loadId, dimLight);
            }
            catch (Exception ex)
            {
            }
        }
    }
    

}