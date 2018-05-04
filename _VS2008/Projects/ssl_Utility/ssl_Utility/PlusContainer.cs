using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    
    public static class PlusContainer
    {
        private static Dictionary<ushort, PlusModule> _modules = new Dictionary<ushort, PlusModule>();

        public static ushort ModulesCount { get { return (ushort)_modules.Count; } }

        public static void AddModule(PlusModule module)
        {
            try
            {
                if (module.Id != 0) _modules.Add(module.Id, module);
            }
            catch (Exception ex)
            {
            }
        }

        public static PlusModule GetModule(ushort id)
        {
            return _modules[id];
        }

        public static void Test_01()
        {
            int elapsedTicks = CrestronEnvironment.TickCount;
            
            _modules[1].GetDigitalOutput(0, 1).Pulse();
            CrestronEnvironment.Sleep(2000);
            _modules[1].GetDigitalOutput(0, 3).Pulse(1000);
            CrestronEnvironment.Sleep(1000);
            _modules[1].GetDigitalOutput(0, 5).Pulse(1);

            elapsedTicks = CrestronEnvironment.TickCount - elapsedTicks;
            DebugHelper.PrintDebugTrace("Elapsed ticks: " + elapsedTicks);
        }

      
    }
    
}