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

        public virtual void AddLoad(ushort id, ushort loadType, String name)
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

        public override void AddLoad(ushort id, ushort loadType, String name)
        {
            try
            {
                Relay relay = new Relay(GetDigitalInput(FB_INPUT, id), GetDigitalOutput(ON_OUTPUT, id), GetDigitalOutput(OFF_OUTPUT, id));
                SwitchLoad switchLoad = new SwitchLoad(id, (eLoadType)loadType, relay);
                switchLoad.SetName(name);
                SimplSystem.SwitchLoads.Add(id, switchLoad);
                ErrorLog.Notice("S#: SimplSystem - Added SwitchLoad nr " + id);
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

        public override void AddLoad(ushort id, ushort loadType, String name)
        {
            try
            {
                Dimmer dimmer = new Dimmer(GetAnalogInput(LEVEL_INPUT, id),
                                            GetAnalogOutput(LEVEL_OUTPUT, id),
                                            GetDigitalOutput(RAISE_OUTPUT, id),
                                            GetDigitalOutput(LOWER_OUTPUT, id));

                DimLoad dimLight = new DimLoad(id, (eLoadType)loadType, dimmer);
                dimLight.SetName(name);
                SimplSystem.DimLoads.Add(id, dimLight);
                ErrorLog.Notice("S#: SimplSystem - Added DimLoad nr " + id);
            }
            catch (Exception ex)
            {
            }
        }
    }
    

}