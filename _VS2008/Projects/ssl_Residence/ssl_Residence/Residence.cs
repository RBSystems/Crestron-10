using System;
using System.Collections.Generic;
using System.Text;
using Crestron.SimplSharp;
using ssl_Utility;

namespace ssl_Residence
{
    public static class Residence
    {
        public static event EventHandler ResidenceInitialized;
        
        public static ushort IsInitialized { get; private set; }

        public static Dictionary<ushort, Zone> Zones { get; private set; }
        public static List<ZoneGroup> ZoneGroups { get; private set; }

        public static Dictionary<ushort, SwitchLight> SwitchLights { get; private set; }

        private static void OnResidenceInitialized()
        {
            if (ResidenceInitialized != null) ResidenceInitialized(new Dummy(), EventArgs.Empty);
        }

        public static void Initialize()
        {
            if (IsInitialized == 1) return;

            Zones = new Dictionary<ushort, Zone>();
            ZoneGroups = new List<ZoneGroup>();
            SwitchLights = new Dictionary<ushort, SwitchLight>();

            IsInitialized = 1;
            OnResidenceInitialized();
        }



        
        public static  void Test_01()
        {
            SwitchLights[2].On();
            SwitchLights[4].On();
            SwitchLights[6].On();
        }

        public static void Test_02()
        {
            SwitchLights[2].Off();
            SwitchLights[4].Off();
            SwitchLights[6].Off();
        }

        public static void Test_03()
        {
            SwitchLights[1].Toggle();
            SwitchLights[3].Toggle();
            SwitchLights[5].Toggle();
        }

    }
}
