using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_Utility
{
    public class ZoneLightingInterface : PlusModule
    {
        public ActionUshortUshortStringDelegate SendZoneInfoDelegate { get; set; }
        
        public Zone SelectedZone { get; private set; }

        private ushort _maxSwitchCount;
        private ushort _maxDimCount;

        private const ushort SW_FB_DOUT = 0;
        private const ushort DIM_FB_DOUT = 1;

        private const ushort SW_TYPE_AOUT = 0;
        private const ushort DIM_TYPE_AOUT = 1;
        private const ushort DIM_LEVEL_AOUT = 2;

        private const ushort SW_NAME_SOUT = 0;
        private const ushort DIM_NAME_SOUT = 1;
        private const ushort DIM_PERCENT_SOUT = 2;

        public ZoneLightingInterface()
        {
            SetDigitalOutputArrayCount(2); // 0 = switch_FB, 1 = dim_FB
            SetAnalogOutputArrayCount(3); // 0 = switchType#_FB, 1 = dimType#_FB, 2 = dimLevel#_FB
            SetStringOutputArrayCount(3); // 0 = switchName$, 1 = dimName$, 2 = dimPercent$
        }

        public void SetMaxSwitchCount(ushort maxSwitchCount)
        {
            _maxSwitchCount = maxSwitchCount;

            CreateDigitalOutputArray(SW_FB_DOUT, maxSwitchCount); // switch_FB
            
            CreateAnalogOutputArray(SW_TYPE_AOUT, maxSwitchCount); // switchType#_FB
            
            CreateStringOutputArray(SW_NAME_SOUT, maxSwitchCount); // switchName$
        }

        public void SetMaxDimCount(ushort maxDimCount)
        {
            _maxDimCount = maxDimCount;

            CreateDigitalOutputArray(DIM_FB_DOUT, maxDimCount); // dim_FB

            CreateAnalogOutputArray(DIM_TYPE_AOUT, maxDimCount); // dimType#_FB
            CreateAnalogOutputArray(DIM_LEVEL_AOUT, maxDimCount); // dimLevel#_FB

            CreateStringOutputArray(DIM_NAME_SOUT, maxDimCount); // dimName$
            CreateStringOutputArray(DIM_PERCENT_SOUT, maxDimCount); // dimPercent$
        }

        public ushort SetCurrentZone(ushort id)
        {
            if (!SimplSystem.Zones.ContainsKey(id)) return 0;

            if (SelectedZone != null && SelectedZone.Id == id) return 0;

            try
            {
                SelectedZone.SwitchLoadChanged -= SwitchLoadChangedHandler;
                SelectedZone.DimLoadChanged -= DimLoadChangedHandler;
            }
            catch (Exception ex)
            {
            }

            SelectedZone = SimplSystem.Zones[id];

            SelectedZone.SwitchLoadChanged += SwitchLoadChangedHandler;
            SelectedZone.DimLoadChanged += DimLoadChangedHandler;

            SendZoneInfo();
            
            SendSwitchInfo();
            SendDimInfo();

            SendAllSwitchFB();
            SendAllDimFB();

            return id;
        }

        private void SwitchLoadChangedHandler(ushort id)
        {
            SendSingleSwitchFB(++id);
        }

        private void DimLoadChangedHandler(ushort id)
        {
            SendSingleDimFB(++id);
        }

        public void SwitchToggle(ushort id)
        {
            try
            {
                SelectedZone.SwitchLoads[id - 1].Toggle();
            }
            catch (Exception ex)
            {
            }
        }

        public void DimToggle(ushort id)
        {
            try
            {
                SelectedZone.DimLoads[id - 1].Toggle();
            }
            catch (Exception ex)
            {
            }
        }

        public void DimRaise(ushort id)
        {
            try
            {
                SelectedZone.DimLoads[id - 1].Raise();
            }
            catch (Exception ex)
            {
            }
        }

        public void DimLower(ushort id)
        {
            try
            {
                SelectedZone.DimLoads[id - 1].Lower();
            }
            catch (Exception ex)
            {
            }
        }

        public void DimStop(ushort id)
        {
            try
            {
                SelectedZone.DimLoads[id - 1].Stop();
            }
            catch (Exception ex)
            {
            }
        }

        private void SendZoneInfo()
        {
            try
            {
                SendZoneInfoDelegate((ushort)SelectedZone.SwitchLoads.Count, (ushort)SelectedZone.DimLoads.Count, SelectedZone.Name);
            }
            catch (Exception ex)
            {
            }
        }

        private void SendSwitchInfo()
        {
            try
            {
                for (ushort i = 1; i <= _maxSwitchCount; i++)
                {
                    if (i <= SelectedZone.SwitchLoads.Count)
                    {
                        SendAnalogOutputDelegate(SW_TYPE_AOUT, i, (ushort)(SelectedZone.SwitchLoads[i - 1].LoadType));
                        SendStringOutputDelegate(SW_NAME_SOUT, i, SelectedZone.SwitchLoads[i - 1].Name);
                    }
                    else
                    {
                        SendAnalogOutputDelegate(SW_TYPE_AOUT, i, 0);
                        SendStringOutputDelegate(SW_NAME_SOUT, i, "");
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }

        private void SendDimInfo()
        {
            try
            {
                for (ushort i = 1; i <= _maxDimCount; i++)
                {
                    if (i <= SelectedZone.DimLoads.Count)
                    {
                        SendAnalogOutputDelegate(DIM_TYPE_AOUT, i, (ushort)(SelectedZone.DimLoads[i - 1].LoadType));
                        SendStringOutputDelegate(DIM_NAME_SOUT, i, SelectedZone.DimLoads[i - 1].Name);
                    }
                    else
                    {
                        SendAnalogOutputDelegate(DIM_TYPE_AOUT, i, 0);
                        SendStringOutputDelegate(DIM_NAME_SOUT, i, "");
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }

        private void SendSingleSwitchFB(ushort id)
        {
            try
            {
                if (id <= SelectedZone.SwitchLoads.Count) SendDigitalOutputDelegate(SW_FB_DOUT, id, (ushort)(SelectedZone.SwitchLoads[id - 1].IsOn ? 1 : 0));
                else SendDigitalOutputDelegate(SW_FB_DOUT, id, 0);
            }
            catch (Exception ex)
            {
            }
        }

        private void SendAllSwitchFB()
        {
            for (ushort i = 1; i <= _maxSwitchCount; i++)
            {
                SendSingleSwitchFB(i);
            }
        }

        private void SendSingleDimFB(ushort id)
        {
            try
            {
                if (id <= SelectedZone.DimLoads.Count)
                {
                    SendDigitalOutputDelegate(DIM_FB_DOUT, id, (ushort)(SelectedZone.DimLoads[id - 1].IsOn ? 1 : 0));
                    SendAnalogOutputDelegate(DIM_LEVEL_AOUT, id, SelectedZone.DimLoads[id - 1].Level);
                    SendStringOutputDelegate(DIM_PERCENT_SOUT, id, "" + SelectedZone.DimLoads[id - 1].Percent + " %");
                }
                else
                {
                    SendDigitalOutputDelegate(DIM_FB_DOUT, id, 0);
                    SendAnalogOutputDelegate(DIM_LEVEL_AOUT, id, 0);
                    SendStringOutputDelegate(DIM_PERCENT_SOUT, id, "0 %");
                }
            }
            catch (Exception ex)
            {
            }
        }

        private void SendAllDimFB()
        {
            for (ushort i = 1; i <= _maxDimCount; i++)
            {
                SendSingleDimFB(i);
            }
        }

    }
}