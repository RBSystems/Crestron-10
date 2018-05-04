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

        private static void OnResidenceInitialized()
        {
            if (ResidenceInitialized != null) ResidenceInitialized(new Dummy(), EventArgs.Empty);
        }

        public static void Initialize()
        {
            if (IsInitialized == 1) return;
            
            IsInitialized = 1;
            OnResidenceInitialized();
        }
       
    }
}
