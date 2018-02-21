using System;
using System.Text;
using Crestron.SimplSharp;
using ssl_Utility;

namespace ssl_Residence
{
    public static class Residence
    {
        public static event EventHandler ResidenceInitialized;
        
        public static ushort IsInitialized { get; private set; }

        public static HeatingLoop[] HeatingLoopArray;

        public static void CreateHeatingLoopArray()
        {
            HeatingLoopArray = new HeatingLoop[HeatingLoop.COUNT + 1];

            for (ushort id = 0; id <= HeatingLoop.COUNT; id++) HeatingLoopArray[id] = new HeatingLoop(id);
        }

        private static void OnResidenceInitialized()
        {
            if (ResidenceInitialized != null) ResidenceInitialized(new Dummy(), EventArgs.Empty);
        }

        public static void Initialize()
        {
            if (IsInitialized == 1) return;
            
            CreateHeatingLoopArray();
            IsInitialized = 1;
            OnResidenceInitialized();
        }
       
    }
}
