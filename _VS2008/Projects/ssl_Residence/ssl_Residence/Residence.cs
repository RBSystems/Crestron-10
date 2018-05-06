using System;
using System.Collections.Generic;
using System.Text;
using Crestron.SimplSharp;
using ssl_Utility;

namespace ssl_Residence
{
    public static class Residence
    {
        private static bool _switchLightsInitialized;
        private static bool _switchOutletsInitialized;
        private static bool _dimLightsInitialized;
        private static bool _devicesInitialized;
        
        public static event EventHandler ResidenceInitialized;
        public static event EventHandler DevicesInitialized;
        
        public static ushort IsInitialized { get; private set; }

        public static Dictionary<ushort, Zone> Zones { get; private set; }
        public static Dictionary<ushort, ZoneGroup> ZoneGroups { get; private set; }

        public static Dictionary<ushort, SwitchOutlet> SwitchOutlets { get; private set; }
        public static Dictionary<ushort, SwitchLight> SwitchLights { get; private set; }
        public static Dictionary<ushort, DimLight> DimLights { get; private set; }

        private static void OnResidenceInitialized()
        {
            if (ResidenceInitialized != null) ResidenceInitialized(new Dummy(), EventArgs.Empty);
        }

        private static void OnDevicesInitialized()
        {
            if (DevicesInitialized != null) DevicesInitialized(new Dummy(), EventArgs.Empty);
        }

        public static void Initialize()
        {
            if (IsInitialized == 1) return;

            SwitchLights = new Dictionary<ushort, SwitchLight>();
            SwitchOutlets = new Dictionary<ushort, SwitchOutlet>();
            DimLights = new Dictionary<ushort, DimLight>();

            Zones = new Dictionary<ushort, Zone>();
            ZoneGroups = new Dictionary<ushort, ZoneGroup>();

            IsInitialized = 1;
            OnResidenceInitialized();
        }

        public static void AddZone(Zone zone)
        {
            try
            {
                Zones.Add(zone.Id, zone);
            }
            catch (Exception ex)
            {
            }
        }

        public static void SwitchLightsInitialized()
        {
            _switchLightsInitialized = true;
            CheckDevicesInitialized();
        }

        public static void SwitchOutletsInitialized()
        {
            _switchOutletsInitialized = true;
            CheckDevicesInitialized();
        }

        public static void DimLightsInitialized()
        {
            _dimLightsInitialized = true;
            CheckDevicesInitialized();
        }

        private static void CheckDevicesInitialized()
        {
            if (_devicesInitialized) return;

            if (_switchLightsInitialized && _switchOutletsInitialized && _dimLightsInitialized)
            {
                _devicesInitialized = true;
                OnDevicesInitialized();
            }
        }

        /*
        public static ushort IsZoneExisting(ushort zoneId)
        {
            return (ushort)(Zones.ContainsKey(zoneId)?1:0);
        }
        */



        public static void Test_01()
        {
            Zones[1].AllOn();
        }

        public static void Test_02()
        {
            Zones[1].AllOff();
        }

        public static void Test_03()
        {
            Zones[2].AllOn();
        }

        public static void Test_04()
        {
            Zones[2].AllOff();
        }

        public static void Test_05()
        {
            Zones[3].AllOn();
        }

        public static void Test_06()
        {
            Zones[3].AllOff();
        }
        
       

    }
}
