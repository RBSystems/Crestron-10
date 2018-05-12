using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public class Area
    {
        public ushort Id { get; protected set; }
        public String Name { get; protected set; }

        public Area()
        {
        }

        public void SetId(ushort id)
        {
            Id = id;
        }

        public void SetName(String name)
        {
            Name = name;
        }
    }

    public class Zone : Area
    {
        public List<SwitchLoad> SwitchLoads { get; private set; }
        public List<DimLoad> DimLoads { get; private set; }

        public Zone()
        {
            SwitchLoads = new List<SwitchLoad>();
            DimLoads = new List<DimLoad>();
        }

        #region Adding elements

        public void AddSwitchLoad(ushort switchLoadId)
        {
            try
            {
                if (!SwitchLoads.Contains(SimplSystem.SwitchLoads[switchLoadId]))
                {
                    SwitchLoads.Add(SimplSystem.SwitchLoads[switchLoadId]);
                }
            }
            catch (Exception ex)
            {
            }
        }


        public void AddDimLoad(ushort dimLoadId)
        {
            try
            {
                if (!DimLoads.Contains(SimplSystem.DimLoads[dimLoadId]))
                {
                    DimLoads.Add(SimplSystem.DimLoads[dimLoadId]);
                }
            }
            catch (Exception ex)
            {
            }
        }

        #endregion

        #region All On/Off

        public void AllSwitchLoadsOn()
        {
            foreach (SwitchLoad switchLoad in SwitchLoads) switchLoad.On();
        }

        public void AllDimLoadsOn()
        {
            foreach (DimLoad dimLoad in DimLoads) dimLoad.On();
        }

        public void AllLoadsOn()
        {
            AllSwitchLoadsOn();
            AllDimLoadsOn();
        }


        public void AllSwitchLoadsOff()
        {
            foreach (SwitchLoad switchLoad in SwitchLoads) switchLoad.Off();
        }

        public void AllDimLoadsOff()
        {
            foreach (DimLoad dimLoad in DimLoads) dimLoad.Off();
        }

        public void AllLoadsOff()
        {
            AllSwitchLoadsOff();
            AllDimLoadsOff();
        }

        #endregion

    }

    public class ZoneGroup : Area
    {
        public List<Zone> Zones { get; private set; }

        public ZoneGroup()
        {
            Zones = new List<Zone>();
        }
    }

}