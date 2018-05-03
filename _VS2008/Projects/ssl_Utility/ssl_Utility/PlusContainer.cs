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

        public static void AddModule(ushort moduleId, PlusModule module)
        {
            try
            {
                if (moduleId != 0) _modules.Add(moduleId, module);
            }
            catch (Exception ex)
            {
            }
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

        public static void Test_02()
        {
            _modules[1].GetDigitalOutput(2, 1).SendValue(true);
            _modules[1].GetDigitalOutput(2, 3).SendValue(true);
            _modules[1].GetDigitalOutput(2, 5).SendValue(true);
            _modules[1].GetDigitalOutput(2, 3).SendValue(false);
        }

        public static void Test_03()
        {
            _modules[1].GetAnalogOutput(0, 1).SendValue(100);
            _modules[1].GetAnalogOutput(0, 3).SendValue(300);
            _modules[1].GetAnalogOutput(0, 5).SendValue(50);
            _modules[1].GetAnalogOutput(0, 3).SendValue(150);
        }

        public static void Test_04()
        {
            _modules[1].GetAnalogOutput(1, 1).SendValue(100);
            _modules[1].GetAnalogOutput(1, 3).SendValue(300);
            _modules[1].GetAnalogOutput(1, 5).SendValue(50);
            _modules[1].GetAnalogOutput(1, 3).SendValue(150);
        }

        public static void Test_05()
        {
            _modules[1].GetStringOutput(0, 1).SendValue("ala");
            _modules[1].GetStringOutput(0, 3).SendValue("ma");
            _modules[1].GetStringOutput(0, 5).SendValue("kota");
            _modules[1].GetStringOutput(0, 3).SendValue("nie ma");
        }

        public static void Test_06()
        {
            _modules[1].GetStringOutput(3, 1).SendValue("ala");
            _modules[1].GetStringOutput(3, 3).SendValue("ma");
            _modules[1].GetStringOutput(3, 5).SendValue("kota");
            _modules[1].GetStringOutput(3, 3).SendValue("nie ma");
        }
    }
}