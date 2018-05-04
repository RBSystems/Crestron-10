using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Residence
{
    public class Area
    {
        public String Name { get; protected set; }

        public Area(String name)
        {
            Name = name;
        }
    }
    
    public class Zone : Area
    {
        public ushort Id { get; protected set; }
        public List<ZoneGroup> Groups { get; protected set; }
        public List<Device> Devices { get; protected set; }

        public Zone(ushort id, String name)
            : base(name)
        {
            Id = id;
            Groups = new List<ZoneGroup>();
            Devices = new List<Device>();
        }
    }

    public class ZoneGroup : Area
    {
        public List<Zone> Zones { get; protected set; }

        public ZoneGroup(String name)
            : base(name)
        {
            Zones = new List<Zone>();
        }
    }
}