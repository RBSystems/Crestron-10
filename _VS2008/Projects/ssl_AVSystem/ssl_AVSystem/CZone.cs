using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_AVSystem
{
    public delegate void ZoneSharpEventHandler(CZone sender, StateChangeEventArgs e);

    public class CZone : CDestination
    {
        public static ushort COUNT = 32;

        #region Eventy
        public static event ZoneSharpEventHandler ZoneSharpStateChanged;
        public static event EventHandler ZonePlusStateChanged;
        public static event EventHandler ZoneInfoChanged;
        #endregion

        #region Pola prywatne
        ushort currentSourceId = 0;
        ushort currentVolume = 0;
        ushort isMuted = 0;
        ushort isPoweredOn = 0;

        ushort lastSourceId = 0;
        ushort lastVolume = 50;
        #endregion

        #region Właściwości
        public ushort AssignedGroupId { get; set; }

        public ushort CurrentSourceId
        {
            get { return currentSourceId; }
            set
            {
                if (currentSourceId == value) return;

                CDebugHelper.SendTraceMessage("CurrentSourceId Set Change");

                if (value == 0)
                {
                    isPoweredOn = 0;
                    lastSourceId = currentSourceId;
                    lastVolume = currentVolume;
                }
                else
                {
                    if (isPoweredOn == 0) SetDefaultVolume();
                    isPoweredOn = 1;
                    lastSourceId = value;
                }
                
                currentSourceId = value;
                OnZoneStateChanged(new StateChangeEventArgs(StateChangeType.Source));
            }
        }

        public CSource CurrentSource
        {
            get
            {
                if (CElementManager.SourceArray == null) return new CSource(0);
                else return CElementManager.SourceArray[currentSourceId];
            }
        }

        public ushort CurrentVolume
        {
            get { return currentVolume; }
            set
            {
                if (currentVolume == value) return;

                currentVolume = value;
                OnZoneStateChanged(new StateChangeEventArgs(StateChangeType.Volume));
            }
        }

        public ushort IsMuted
        {
            get { return isMuted; }
            set
            {
                if (isMuted == value) return;

                isMuted = value;
                OnZoneStateChanged(new StateChangeEventArgs(StateChangeType.Mute));
            }
        }                

        public ushort IsPoweredOn
        {
            get { return isPoweredOn; }
        }

        public CSource LastSource
        {
            get
            {
                if (CElementManager.SourceArray == null) return new CSource(0);
                else return CElementManager.SourceArray[lastSourceId];
            }            
        }

        public ushort LastVolume
        {
            get { return lastVolume; }
        }
        #endregion

        #region Konstruktory i inicjalizacja domyślnych nazw
        public CZone()
        {
            AssignedGroupId = 0;
        }

        public CZone(ushort _id, ushort _defaultSourceId)
            : base(_id, _defaultSourceId)
        {
            AssignedGroupId = 0;
        }

        protected override void InitializeDefaultNames()
        {
            if (Id == 0)
            {
                NameShort = "BRAK";
                NameLong = "BRAK";
            }
            else
            {
                NameShort = "AZ-" + Id;
                NameLong = "Strefa AV - " + Id;
            }
        }

        public void Initialize(CZone _zone)
        {
            base.Initialize(_zone);
            AssignedGroupId = _zone.AssignedGroupId;
        }
        #endregion

        #region Metody typu OnSomething - zgłaszające eventy
        private void OnZoneStateChanged(StateChangeEventArgs e)
        {
            if (CZone.ZonePlusStateChanged != null) ZonePlusStateChanged(this, EventArgs.Empty);
            if (CZone.ZoneSharpStateChanged != null) ZoneSharpStateChanged(this, e);
        }

        //  Czy dodać do tej funkcji zachowania pożądana w przypadku zmiany informacji o strefie
        public override void OnInfoChanged()
        {
            if (CZone.ZoneInfoChanged != null) ZoneInfoChanged(this, EventArgs.Empty);
        }
        #endregion

        #region Metody zwracające teksty z informacjami o aktualnym stanie
        public override string GetCurrentSourceTextShort()
        {
            if (CElementManager.IsInitialized == 0 || IsEnabled == 0) return SOURCE_NONE_TEXT;
            else return CurrentSource.NameShort;
        }

        public override string GetCurrentSourceTextLong()
        {
            if (CElementManager.IsInitialized == 0 || IsEnabled == 0) return SOURCE_NONE_TEXT;
            else return CurrentSource.NameLong;
        }

        public override string GetCurrentVolumeText()
        {
            if (IsEnabled == 0) return VOLUME_UNKNOWN_TEXT;

            return "" + CurrentVolume + " %";
        }
        #endregion

        #region Metody sterujące
        public override void SetSource(ushort _sourceId)
        {
            if (IsEnabled == 0) return;

            CDebugHelper.SendTraceMessage("Zone SetSource(" + _sourceId + ")");
            
            CDevice.SetZoneSource(Id, _sourceId);
        }

        public override void SetDefaultSource()
        {
            if (IsEnabled == 0) return;
            
            if (IsSourceStartupDefault == 0 && lastSourceId != 0) SetSource(lastSourceId);
            else SetSource(DefaultSourceId);
        }

        public override void PowerOn()
        {
            if (IsEnabled == 0) return;
            
            if (isPoweredOn == 1) return;
            else SetDefaultSource();
        }

        public override void PowerOff()
        {
            if (IsEnabled == 0) return;
            
            if (isPoweredOn == 0) return;
            SetSource(0);
        }

        public override void TogglePower()
        {
            if (IsEnabled == 0) return;
            
            if (isPoweredOn == 0) PowerOn();
            else PowerOff();
        }

        public override void SetVolume(ushort _volume)
        {
            if (IsEnabled == 0) return;
            
            CDevice.SetZoneVolume(Id, _volume);
        }

        public override void SetDefaultVolume()
        {
            if (IsEnabled == 0) return;
            
            if (IsVolumeStartupDefault == 0) SetVolume(lastVolume);
            else SetVolume(DefaultVolume);
        }

        public override void IncreaseVolume()
        {
            if (IsEnabled == 0) return;
            
            SetVolume((ushort)(currentVolume + CDevice.VOLUME_SHIFT));
        }

        //  TODO:   Sprawdzić co w przypadku kiedy currentVolume < CDevice.VOLUME_SHIFT - przekroczenie zakresu?
        public override void DecreaseVolume()
        {
            if (IsEnabled == 0) return;
            
            SetVolume((ushort)(currentVolume - CDevice.VOLUME_SHIFT));
        }

        public override void SetMute(ushort _mute)
        {
            if (IsEnabled == 0) return;
            
            CDevice.SetZoneMute(Id, _mute);
        }

        public override void ToggleMute()
        {
            if (IsEnabled == 0) return;
            
            if (IsMuted == 0) SetMute(1);
            else SetMute(0);
        }
        #endregion

    }
}