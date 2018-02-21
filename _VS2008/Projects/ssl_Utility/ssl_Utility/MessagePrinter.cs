using System;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public delegate void DPrintTraceMessage(SimplSharpString _message);

    public static class MessagePrinter
    {
        public static DPrintTraceMessage PrintTraceMessage { get; set; }

        public static void PrintAsTrace(string _message)
        {
            if (PrintTraceMessage != null) PrintTraceMessage("S#: " + _message);
        }

    }
}
