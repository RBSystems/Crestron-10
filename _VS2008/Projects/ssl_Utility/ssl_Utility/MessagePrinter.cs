using System;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public delegate void DPrintTraceMessage(SimplSharpString _message);

    public static class MessagePrinter
    {
        public static DPrintTraceMessage PrintTraceMessage { get; set; }

        private static Stopwatch stopWatch = new Stopwatch();

        public static void PrintAsTrace(string _message)
        {
            if (PrintTraceMessage != null) PrintTraceMessage("S#: " + _message);
        }

        public static void PrintDate()
        {
            PrintAsTrace("Data: " + CrestronEnvironment.GetLocalTime().ToString());
        }

        public static void PrintThicks()
        {
            PrintAsTrace("Thicks: " + CrestronEnvironment.TickCount);
        }

        public static void LogError()
        {
            ErrorLog.Error("Custom Error");
        }

        public static void LogWarning()
        {
            ErrorLog.Warn("CustomWarning");
        }

        public static void LogNotice()
        {
            ErrorLog.Notice("CustomNotice");
        }

        public static void StartStopWatch()
        {
            stopWatch.Start();
        }

        public static void StopStopWatch()
        {
            stopWatch.Stop();
            PrintAsTrace("Uplynelo " + stopWatch.ElapsedMilliseconds + " milisekund");
            stopWatch.Reset();
        }

    }
}
