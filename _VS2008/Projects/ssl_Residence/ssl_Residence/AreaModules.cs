using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;
using ssl_Utility;

namespace ssl_Residence
{
    public class ZoneModule : PlusModule
    {
        private Zone _zone;
        private List<ushort> _lightsIdList = new List<ushort>();
        
        public ZoneModule()
            : base()
        {
        }

        public void CreateZone(ushort id, String name)
        {
            try
            {
                _zone = new Zone(id, name);
                Residence.Zones.Add(id, _zone);
            }
            catch (Exception ex)
            {
            }
        }

    }
}