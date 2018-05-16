using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public static class SimplSystem
    {
        private static bool _switchLoadsInitialized;
        private static bool _dimLoadsInitialized;
        private static bool _devicesInitialized;

        public static event EventHandler ResidenceInitialized;
        public static event EventHandler DevicesInitialized;

        public static ushort IsInitialized { get; private set; }

        public static Dictionary<ushort, Zone> Zones { get; private set; }
        public static Dictionary<ushort, ZoneGroup> ZoneGroups { get; private set; }

        public static Dictionary<ushort, SwitchLoad> SwitchLoads { get; private set; }
        public static Dictionary<ushort, DimLoad> DimLoads { get; private set; }

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

            SwitchLoads = new Dictionary<ushort, SwitchLoad>();
            DimLoads = new Dictionary<ushort, DimLoad>();

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
                ErrorLog.Notice("S#: SimplSystem - Added Zone nr " + zone.Id);
            }
            catch (Exception ex)
            {
            }
        }

        public static void SwitchLoadsInitialized()
        {
            _switchLoadsInitialized = true;
            CheckDevicesInitialized();
        }

        public static void DimLoadsInitialized()
        {
            _dimLoadsInitialized = true;
            CheckDevicesInitialized();
        }

        private static void CheckDevicesInitialized()
        {
            if (_devicesInitialized) return;

            if (_switchLoadsInitialized && _dimLoadsInitialized)
            {
                _devicesInitialized = true;
                OnDevicesInitialized();
            }
        }


    }
}