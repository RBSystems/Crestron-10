using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public class ZoneSwitchLoadsBufferModule : PlusModule
    {
        public Zone SelectedZone { get; private set; }


        public ZoneSwitchLoadsBufferModule()
        {
            SetDigitalInputArrayCount(1);
            SetAnalogInputArrayCount(1);

            SetDigitalOutputArrayCount(1);
            SetAnalogOutputArrayCount(2);
            SetStringOutputArrayCount(1);
        }

        public void SetPlusModule(ushort moduleId)
        {

            
        }

        public void SetNumberOfLoads(ushort numberOfLoads)
        {
            CreateDigitalInputArray(0, numberOfLoads); // TOG[]

            CreateAnalogInputArray(0, 1); // zoneID#

            // =================================================================

            CreateDigitalOutputArray(0, numberOfLoads); // On_FB[]

            CreateAnalogOutputArray(0, 2); // zoneID#_FB, loadCount#_FB
            CreateAnalogOutputArray(1, numberOfLoads); // loadType#_FB[]

            CreateStringOutputArray(0, numberOfLoads); // loadName$[]
        }

    }
}