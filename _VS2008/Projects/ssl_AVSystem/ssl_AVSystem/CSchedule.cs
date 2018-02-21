using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_AVSystem
{
    public class CSchedule
    {
        #region Stałe
        public const ushort DAYS_OF_WEEK = 7;
        public const ushort MAX_HOUR = 23;
        public const ushort MAX_MINUTE = 55;
        public const ushort HOUR_SHIFT = 1;
        public const ushort MINUTE_SHIFT = 5;
        #endregion

        #region Właściwości
        public ushort IsEnabled { get; private set; }

        public ushort HourStart { get; private set; }

        public ushort MinuteStart { get; private set; }

        public ushort HourStop { get; private set; }

        public ushort MinuteStop { get; private set; }

        public ushort[] IsDayOfWeekEnabled { get; private set; }
        #endregion

        #region Konstruktor
        public CSchedule()
        {
            IsEnabled = 0;
            HourStart = 9;
            MinuteStart = 0;
            HourStop = 17;
            MinuteStop = 0;
            IsDayOfWeekEnabled = new ushort[DAYS_OF_WEEK + 1];
        }

        public void Initialize(CSchedule _schedule)
        {
            IsEnabled = _schedule.IsEnabled;
            HourStart = _schedule.HourStart;
            MinuteStart = _schedule.MinuteStart;
            HourStop = _schedule.HourStop;
            MinuteStop = _schedule.MinuteStop;
            Array.Copy(_schedule.IsDayOfWeekEnabled, IsDayOfWeekEnabled, DAYS_OF_WEEK + 1);
        }
        #endregion

        #region Przełączanie enabled harmonogramu i dni tygodnia
        public void ToggleEnabled()
        {
            if (IsEnabled == 1) IsEnabled = 0;
            else IsEnabled = 1;
        }

        public void ToggleDayOfWeekEnebled(ushort _day)
        {
            if (IsDayOfWeekEnabled[_day] == 1) IsDayOfWeekEnabled[_day] = 0;
            else IsDayOfWeekEnabled[_day] = 1;
        }
        #endregion

        #region Czas Start +/-

        public void IncrementHourStart()
        {
            if (HourStart == MAX_HOUR) HourStart = 0;
            else HourStart += HOUR_SHIFT;
        }

        public void DecrementHourStart()
        {
            if (HourStart == 0) HourStart = MAX_HOUR;
            else HourStart -= HOUR_SHIFT;
        }

        public void IncrementMinuteStart()
        {
            if (MinuteStart == MAX_MINUTE) MinuteStart = 0;
            else MinuteStart += MINUTE_SHIFT;
        }

        public void DecrementMinuteStart()
        {
            if (MinuteStart == 0) MinuteStart = MAX_MINUTE;
            else MinuteStart -= MINUTE_SHIFT;
        }
        #endregion

        #region Czas Stop +/-

        public void IncrementHourStop()
        {
            if (HourStop == MAX_HOUR) HourStop = 0;
            else HourStop += HOUR_SHIFT;
        }

        public void DecrementHourStop()
        {
            if (HourStop == 0) HourStop = MAX_HOUR;
            else HourStop -= HOUR_SHIFT;
        }

        public void IncrementMinuteStop()
        {
            if (MinuteStop == MAX_MINUTE) MinuteStop = 0;
            else MinuteStop += MINUTE_SHIFT;
        }

        public void DecrementMinuteStop()
        {
            if (MinuteStop == 0) MinuteStop = MAX_MINUTE;
            else MinuteStop -= MINUTE_SHIFT;
        }
        #endregion

        public bool AreTimesCorrect()
        {
            if (HourStart < HourStop) return true;
            else if (HourStart == HourStop && MinuteStart < MinuteStop) return true;
            else return false;
        }

        #region Czasy - text

        public string GetHourStartText()
        {
            return (HourStart < 10 ? "0" : "") + HourStart;
        }

        public string GetMinuteStartText()
        {
            return (MinuteStart < 10 ? "0" : "") + MinuteStart;
        }

        public string GetHourStopText()
        {
            return (HourStop < 10 ? "0" : "") + HourStop;
        }

        public string GetMinuteStopText()
        {
            return (MinuteStop < 10 ? "0" : "") + MinuteStop;
        }

        #endregion

        #region Sprawdzanie warunków Start i Stop
        public bool IsTimeToStart(ushort _day, ushort _hour, ushort _minute)
        {
            if (IsEnabled == 1 && IsDayOfWeekEnabled[_day] == 1 && HourStart == _hour && MinuteStart == _minute) return true;
            else return false;
        }

        public bool IsTimeToStop(ushort _day, ushort _hour, ushort _minute)
        {
            if (IsEnabled == 1 && IsDayOfWeekEnabled[_day] == 1 && HourStop == _hour && MinuteStop == _minute) return true;
            else return false;
        }
        #endregion
    }
}