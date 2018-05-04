using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;
using ssl_Utility;

namespace ssl_Residence
{

    public class SwitchLightsModule
    {
        private PlusModule _plusModule;
        
        private const ushort fbArrayIndex = 0;
        private const ushort onArrayIndex = 0;
        private const ushort offArrayIndex = 1;
        
        public SwitchLightsModule()
        {
        }

        public void SetPlusModule(ushort moduleId)
        {
            _plusModule = PlusContainer.GetModule(moduleId);
            _plusModule.SetDigitalInputArrayCount(1);
            _plusModule.SetDigitalOutputArrayCount(2);
        }

        public void SetNumberOfLights(ushort numberOfLights)
        {
            _plusModule.CreateDigitalInputArray(fbArrayIndex, numberOfLights);

            _plusModule.CreateDigitalOutputArray(onArrayIndex, numberOfLights);
            _plusModule.CreateDigitalOutputArray(offArrayIndex, numberOfLights);
        }

        public void AddLight(ushort signalIndex, ushort lightId, String name)
        {
            try
            {
                SwitchLight switchLight = new SwitchLight(lightId, _plusModule.GetDigitalInput(fbArrayIndex, signalIndex), _plusModule.GetDigitalOutput(onArrayIndex, signalIndex), _plusModule.GetDigitalOutput(offArrayIndex, signalIndex));
                switchLight.SetName(name);
                Residence.SwitchLights.Add(lightId, switchLight);
            }
            catch (Exception ex)
            {
            }
        }

        public void ToggleLight(ushort lightId)
        {
            try
            {
                Residence.SwitchLights[lightId].Toggle();
            }
            catch (Exception ex)
            {
            }
        }



    }
}