using System;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{    
    public static class DebugHelper
    {
        public static ActionStringDelegate PrintTraceDelegate { get; set; }

        private static Stopwatch stopWatch = new Stopwatch();

        public const bool DebugTraceMode = true;

        public static void PrintDebugTrace(string _message)
        {
            if (PrintTraceDelegate != null && DebugTraceMode) PrintTraceDelegate("S# (debug): " + _message);
        }
        
        public static void PrintTrace(string _message)
        {
            if (PrintTraceDelegate != null) PrintTraceDelegate("S#: " + _message);
        }

        public static void PrintDate()
        {
            PrintTrace("Data: " + CrestronEnvironment.GetLocalTime().ToString());
        }

        public static void PrintThicks()
        {
            PrintTrace("Thicks: " + CrestronEnvironment.TickCount);
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
            PrintTrace("Uplynelo " + stopWatch.ElapsedMilliseconds + " milisekund");
            stopWatch.Reset();
        }

    }
}
