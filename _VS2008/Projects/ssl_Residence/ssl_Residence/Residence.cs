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

        public static Dictionary<ushort, ElectricalOutlet> ElectricalOutlets { get; private set; }
        public static Dictionary<ushort, SwitchLight> SwitchLights { get; private set; }
        public static Dictionary<ushort, DimLight> DimLights { get; private set; }

        private static void OnResidenceInitialized()
        {
            if (ResidenceInitialized != null) ResidenceInitialized(new Dummy(), EventArgs.Empty);
        }

        public static void Initialize()
        {
            if (IsInitialized == 1) return;

            Zones = new Dictionary<ushort, Zone>();
            ZoneGroups = new List<ZoneGroup>();
            ElectricalOutlets = new Dictionary<ushort, ElectricalOutlet>();
            SwitchLights = new Dictionary<ushort, SwitchLight>();
            DimLights = new Dictionary<ushort, DimLight>();

            IsInitialized = 1;
            OnResidenceInitialized();
        }

        public static void Test_01()
        {
            DimLights[3].On();
            DimLights[6].On();
            DimLights[9].On();
        }

        public static void Test_02()
        {
            DimLights[3].Off();
            DimLights[6].Off();
            DimLights[9].Off();
        }

        public static void Test_03()
        {
            DimLights[3].SetLevel(32000);
            DimLights[6].SetLevel(16000);
            DimLights[9].SetLevel(8000);
        }

        public static void Test_04()
        {
            DimLights[3].Raise();
            DimLights[6].Raise();
            DimLights[9].Raise();
        }

        public static void Test_05()
        {
            DimLights[3].Lower();
            DimLights[6].Lower();
            DimLights[9].Lower();
        }

        public static void Test_06()
        {
            DimLights[3].Stop();
            DimLights[6].Stop();
            DimLights[9].Stop();
        }
        
        /*
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

        public static void Test_04()
        {
            ElectricalOutlets[2].On();
            ElectricalOutlets[4].On();
            ElectricalOutlets[6].On();
        }

        public static void Test_05()
        {
            ElectricalOutlets[2].Off();
            ElectricalOutlets[4].Off();
            ElectricalOutlets[6].Off();
        }

        public static void Test_06()
        {
            ElectricalOutlets[1].Toggle();
            ElectricalOutlets[3].Toggle();
            ElectricalOutlets[5].Toggle();
        }
        */

    }
}
