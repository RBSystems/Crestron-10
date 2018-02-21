using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_AVSystem
{
    public delegate void DTraceMessage(SimplSharpString _message);
    
    public static class CDebugHelper
    {
        public static DTraceMessage TraceMessage { get; set; }

        public static void SendTraceMessage(string _message)
        {
            if (TraceMessage != null) TraceMessage("S#: " + _message);
        }

    }
}