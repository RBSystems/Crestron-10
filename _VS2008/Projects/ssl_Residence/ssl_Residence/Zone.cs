using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Residence
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
        protected List<SwitchLight> _switchLights;
        protected List<SwitchOutlet> _switchOutlets;
        protected List<DimLight> _dimLights;

        public SwitchLight[] SwitchLightsArray { get { return _switchLights.ToArray(); } }
        public SwitchOutlet[] SwitchOutletsArray { get { return _switchOutlets.ToArray(); } }
        public DimLight[] DimLightsArray { get { return _dimLights.ToArray(); } }

        public ushort SwitchLightsCount { get { return (ushort)_switchLights.Count; } }
        public ushort SwitchOutletsCount { get { return (ushort)_switchOutlets.Count; } }
        public ushort DimLightsCount { get { return (ushort)_dimLights.Count; } }
        
        public Zone()
        {
            _switchLights = new List<SwitchLight>();
            _switchOutlets = new List<SwitchOutlet>();
            _dimLights = new List<DimLight>();
        }

        #region Adding elements

        public void AddSwitchLight(ushort switchLightId)
        {
            try
            {
                if (!_switchLights.Contains(Residence.SwitchLights[switchLightId])) _switchLights.Add(Residence.SwitchLights[switchLightId]);
            }
            catch (Exception ex)
            {
            }
        }

        public void AddSwitchOutlet(ushort switchOutletId)
        {
            try
            {
                if (!_switchOutlets.Contains(Residence.SwitchOutlets[switchOutletId])) _switchOutlets.Add(Residence.SwitchOutlets[switchOutletId]);
            }
            catch (Exception ex)
            {
            }
        }

        public void AddDimLight(ushort dimLightId)
        {
            try
            {
                if (!_dimLights.Contains(Residence.DimLights[dimLightId])) _dimLights.Add(Residence.DimLights[dimLightId]);
            }
            catch (Exception ex)
            {
            }
        }

        #endregion

        #region All On/Off

        public void AllSwitchLightsOn()
        {
            foreach (SwitchLight switchLight in _switchLights) switchLight.On();
        }

        public void AllSwitchOutletsOn()
        {
            foreach (SwitchOutlet switchOutlet in _switchOutlets) switchOutlet.On();
        }

        public void AllDimLightsOn()
        {
            foreach (DimLight dimLight in _dimLights) dimLight.On();
        }

        public void AllOn()
        {
            AllSwitchLightsOn();
            AllSwitchOutletsOn();
            AllDimLightsOn();
        }


        public void AllSwitchLightsOff()
        {
            foreach (SwitchLight switchLight in _switchLights) switchLight.Off();
        }

        public void AllSwitchOutletsOff()
        {
            foreach (SwitchOutlet switchOutlet in _switchOutlets) switchOutlet.Off();
        }

        public void AllDimLightsOff()
        {
            foreach (DimLight dimLight in _dimLights) dimLight.Off();
        }

        public void AllOff()
        {
            AllSwitchLightsOff();
            AllSwitchOutletsOff();
            AllDimLightsOff();
        }

        #endregion

        public ushort TryCloneById(ushort zoneId)
        {
            if (!Residence.Zones.ContainsKey(zoneId)) return 0;

            this.Id = Residence.Zones[zoneId].Id;
            this.Name = Residence.Zones[zoneId].Name;
            this._switchLights = Residence.Zones[zoneId]._switchLights;
            this._switchOutlets = Residence.Zones[zoneId]._switchOutlets;
            this._dimLights = Residence.Zones[zoneId]._dimLights;

            return 1;
        }
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