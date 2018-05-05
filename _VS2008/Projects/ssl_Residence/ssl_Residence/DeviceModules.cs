using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;
using ssl_Utility;

namespace ssl_Residence
{

    public class SwitchLoadsModule
    {
        private PlusModule _plusModule;
        
        private const ushort fbArrayIndex = 0;
        private const ushort onArrayIndex = 0;
        private const ushort offArrayIndex = 1;
        
        public SwitchLoadsModule()
        {
        }

        public void SetPlusModule(ushort moduleId)
        {
            _plusModule = PlusContainer.GetModule(moduleId);
            _plusModule.SetDigitalInputArrayCount(1);
            _plusModule.SetDigitalOutputArrayCount(2);
        }

        public void SetNumberOfLoads(ushort numberOfLoads)
        {
            _plusModule.CreateDigitalInputArray(fbArrayIndex, numberOfLoads);

            _plusModule.CreateDigitalOutputArray(onArrayIndex, numberOfLoads);
            _plusModule.CreateDigitalOutputArray(offArrayIndex, numberOfLoads);
        }

        public void AddLight(ushort signalIndex, ushort loadId, String name)
        {
            try
            {
                SwitchLight switchLight = new SwitchLight(loadId, new SwitchLoad(_plusModule.GetDigitalInput(fbArrayIndex, signalIndex), _plusModule.GetDigitalOutput(onArrayIndex, signalIndex), _plusModule.GetDigitalOutput(offArrayIndex, signalIndex)));
                switchLight.SetName(name);
                Residence.SwitchLights.Add(loadId, switchLight);
            }
            catch (Exception ex)
            {
            }
        }

        public void AddElectricalOutlet(ushort signalIndex, ushort lightId, String name)
        {
            try
            {
                ElectricalOutlet electricalOutlet = new ElectricalOutlet(lightId, new SwitchLoad(_plusModule.GetDigitalInput(fbArrayIndex, signalIndex), _plusModule.GetDigitalOutput(onArrayIndex, signalIndex), _plusModule.GetDigitalOutput(offArrayIndex, signalIndex)));
                electricalOutlet.SetName(name);
                Residence.ElectricalOutlets.Add(lightId, electricalOutlet);
            }
            catch (Exception ex)
            {
            }
        }
    }

    public class DimLoadsModule
    {
        private PlusModule _plusModule;

        private const ushort levelFbArrayIndex = 0;

        private const ushort raiseArrayIndex = 0;
        private const ushort lowerArrayIndex = 1;
        private const ushort levelArrayIndex = 0;

        public DimLoadsModule()
        {
        }

        public void SetPlusModule(ushort moduleId)
        {
            _plusModule = PlusContainer.GetModule(moduleId);

            _plusModule.SetAnalogInputArrayCount(1);

            _plusModule.SetDigitalOutputArrayCount(2);
            _plusModule.SetAnalogOutputArrayCount(1);
        }

        public void SetNumberOfLoads(ushort numberOfLoads)
        {
            _plusModule.CreateAnalogInputArray(levelFbArrayIndex, numberOfLoads);

            _plusModule.CreateDigitalOutputArray(raiseArrayIndex, numberOfLoads);
            _plusModule.CreateDigitalOutputArray(lowerArrayIndex, numberOfLoads);
            _plusModule.CreateAnalogOutputArray(levelArrayIndex, numberOfLoads);
        }

        public void AddLight(ushort signalIndex, ushort loadId, String name)
        {
            try
            {
                DimLight dimLight = new DimLight(loadId, new DimLoad(_plusModule.GetAnalogInput(levelFbArrayIndex, signalIndex),
                                                                    _plusModule.GetAnalogOutput(levelArrayIndex, signalIndex),
                                                                    _plusModule.GetDigitalOutput(raiseArrayIndex, signalIndex),
                                                                    _plusModule.GetDigitalOutput(lowerArrayIndex, signalIndex)));
                
                dimLight.SetName(name);
                Residence.DimLights.Add(loadId, dimLight);
            }
            catch (Exception ex)
            {
            }
        }
    }
}