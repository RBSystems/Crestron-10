using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_AVSystem
{
    #region Deklaracje typów wyliczeniowych
    public enum SourceType { None, Equal, Mixed, MixedWithNone };
    public enum VolumeType { Equal, Mixed };
    public enum MuteType { Off, On, Mixed };
    #endregion

    #region Deklaracje delegat
    public delegate void GroupSharpEventHandler(CGroup sender, StateChangeEventArgs e);
    #endregion

    public class CGroup : CDestination
    {
        public static ushort COUNT = 32;
        
        #region Stałe
        private const string SOURCE_MIXED_TEXT = "Rozne";        
        #endregion

        #region Zdarzenia
        public static event GroupSharpEventHandler GroupSharpStateChanged;
        public static event EventHandler GroupPlusStateChanged;
        public static event EventHandler GroupInfoChanged;
        #endregion

        #region Pola prywatne
        SourceType selectedSourceType = SourceType.None;
        VolumeType currentVolumeType = VolumeType.Mixed;
        MuteType currentMuteType = MuteType.Off;
        ushort currentEqualSourceId = 0;
        ushort currentEqualVolume = 0;
        bool isZoneHandlerBlocked = false;
        #endregion

        #region Właściwości
        public SourceType SelectedSourceType
        {
            get { return selectedSourceType; }
            set
            {
                if (selectedSourceType == value) return;

                selectedSourceType = value;
                OnGroupStateChanged(new StateChangeEventArgs(StateChangeType.Source));
            }
        }

        public VolumeType CurrentVolumeType
        {
            get { return currentVolumeType; }
            set
            {
                if (currentVolumeType == value) return;

                currentVolumeType = value;
                OnGroupStateChanged(new StateChangeEventArgs(StateChangeType.Volume));
            }
        }

        public MuteType CurrentMuteType
        {
            get { return currentMuteType; }
            set
            {
                if (currentMuteType == value) return;

                currentMuteType = value;
                OnGroupStateChanged(new StateChangeEventArgs(StateChangeType.Mute));
            }
        }

        public ushort CurrentEqualSourceId
        {
            get { return currentEqualSourceId; }
            set
            {
                if (currentEqualSourceId == value) return;

                currentEqualSourceId = value;

                if (selectedSourceType == SourceType.Equal) OnGroupStateChanged(new StateChangeEventArgs(StateChangeType.Source));
            }
        }

        private ushort CurrentEqualVolume
        {
            get { return currentEqualVolume; }
            set
            {
                if (currentEqualVolume == value) return;

                currentEqualVolume = value;

                if (currentVolumeType == VolumeType.Equal) OnGroupStateChanged(new StateChangeEventArgs(StateChangeType.Volume));
            }
        }

        private bool IsEmpty
        {
            get
            {
                if (ZoneIdList == null || ZoneIdList.Count == 0) return true;
                else return false;
            }
        }

        public ushort ZoneCount
        {
            get
            {
                if (IsEmpty) return 0;
                else return (ushort)ZoneIdList.Count;
            }
        }

        List<ushort> ZoneIdList { get; set; }

        public CSchedule Schedule { get; private set; }
        #endregion

        #region Konstruktory i inicjalizacja
        public CGroup()
        {
            ZoneIdList = new List<ushort>();
            Schedule = new CSchedule();
            CZone.ZoneSharpStateChanged += ZoneStateChangedHandler;
        }

        public CGroup(ushort _id, ushort _defaultSourceId)
            : base(_id, _defaultSourceId)
        {
            ZoneIdList = new List<ushort>();
            Schedule = new CSchedule();
            CZone.ZoneSharpStateChanged += ZoneStateChangedHandler;
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
                NameShort = "AG-" + Id;
                NameLong = "Grupa AV - " + Id;
            }
        }

        public void Initialize(CGroup _group)
        {
            base.Initialize(_group);
            RefreshZoneIdList();
            Schedule.Initialize(_group.Schedule);
        }
        #endregion

        #region Metody obliczające aktualny stan na podstawie stanu stref należących do grupy
        private void CalculateCurrentSourceType()
        {
            if (IsEmpty)
            {
                SelectedSourceType = SourceType.None;
                return;
            }

            ushort firstSourceId = 0;
            bool isEqual = true;
            bool isFirst = true;
            bool onFlag = false;
            bool offFlag = false;

            foreach (ushort zoneId in ZoneIdList)
            {
                if (CElementManager.ZoneArray[zoneId].IsEnabled == 0) continue;

                if (CElementManager.ZoneArray[zoneId].CurrentSourceId == 0)
                {
                    isEqual = false;
                    
                    if (isFirst)
                    {
                        isFirst = false;                        
                    }

                    if (!offFlag) offFlag = true;
                }
                else
                {
                    if (!onFlag) onFlag = true;
	
				    if (isFirst)
				    {
					    isFirst = false;
					    firstSourceId = CElementManager.ZoneArray[zoneId].CurrentSourceId;
				    }
				    else
				    {
                        if (isEqual && firstSourceId != CElementManager.ZoneArray[zoneId].CurrentSourceId) isEqual = false;
				    }
                }
            }

            if (isEqual)
            {
                CurrentEqualSourceId = firstSourceId;
                SelectedSourceType = SourceType.Equal;
                return;
            }

            if (onFlag)
            {
                if (offFlag) SelectedSourceType = SourceType.MixedWithNone;
                else SelectedSourceType = SourceType.Mixed;
            }
            else SelectedSourceType = SourceType.None;

            CurrentEqualSourceId = 0;
        }

        private void CalculateCurrentVolumeType()
        {
            if (IsEmpty)
            {
                CurrentVolumeType = VolumeType.Mixed;
                return;
            }

            ushort firstVolume = 0;
            bool isEqual = true;
            bool isFirst = true;

            foreach (ushort zoneId in ZoneIdList)
            {
                if (CElementManager.ZoneArray[zoneId].IsEnabled == 0) continue;

                if (isFirst)
			    {
				    isFirst = false;
				    firstVolume = CElementManager.ZoneArray[zoneId].CurrentVolume;
			    }
			    else
			    {
                    if (isEqual && firstVolume != CElementManager.ZoneArray[zoneId].CurrentVolume)
				    {
                        isEqual = false;
					    break;
				    }
			    }
            }

            if (isEqual)
            {
                CurrentEqualVolume = firstVolume;
                CurrentVolumeType = VolumeType.Equal;
            }
            else
            {
                CurrentVolumeType = VolumeType.Mixed;
                CurrentEqualVolume = 0;
            }
        }

        private void CalculateCurrentMuteType()
        {
            if (IsEmpty)
            {
                CurrentMuteType = MuteType.Off;
                return;
            }

            bool onFlag = false;
            bool offFlag = false;

            foreach (ushort zoneId in ZoneIdList)
            {
                if (CElementManager.ZoneArray[zoneId].IsEnabled == 0) continue;

                if (CElementManager.ZoneArray[zoneId].IsMuted == 1) onFlag = true;
                else offFlag = true;
            }

            if (onFlag)
            {
                if (offFlag) CurrentMuteType = MuteType.Mixed;
                else CurrentMuteType = MuteType.On;
            }
            else CurrentMuteType = MuteType.Off;
        }

        private void CalculateAll()
        {
            CalculateCurrentSourceType();
            CalculateCurrentVolumeType();
            CalculateCurrentMuteType();
        }
        #endregion

        #region Obsługa zdarzenia ZoneStateChanged
        public void ZoneStateChangedHandler(CZone zone, StateChangeEventArgs e)
        {

            if (IsEnabled == 0 || IsEmpty || !ZoneIdList.Contains(zone.Id) || isZoneHandlerBlocked) return;

            switch (e.ChangeType)
            {
                case StateChangeType.Source:
                    CalculateCurrentSourceType();
                    break;
                case StateChangeType.Volume:
                    CalculateCurrentVolumeType();
                    break;
                case StateChangeType.Mute:
                    CalculateCurrentMuteType();
                    break;
                default:
                    return;
            }
        }
        #endregion

        #region Metody typu OnSomething - zgłaszające eventy
        private void OnGroupStateChanged(StateChangeEventArgs e)
        {
            if (CGroup.GroupPlusStateChanged != null) GroupPlusStateChanged(this, EventArgs.Empty);
            if (CGroup.GroupSharpStateChanged != null) GroupSharpStateChanged(this, e);
        }

        //  Czy dodać do tej funkcji zachowania pożądana w przypadku zmiany informacji o grupie (CalculateAll ?)
        public override void OnInfoChanged()
        {
            if (CGroup.GroupInfoChanged != null) GroupInfoChanged(this, EventArgs.Empty);
        }
        #endregion

        #region Dodawanie i usuwanie stref
        private void RefreshZoneIdList()
        {
            if (CElementManager.IsInitialized == 0 || Id == 0) return;
            ZoneIdList = new List<ushort>();

            foreach (CZone zone in CElementManager.ZoneArray)
            {
                if (zone.AssignedGroupId == Id) ZoneIdList.Add(zone.Id);
            }
        }

        public void AddZone(ushort _zoneId)
        {
            if (ZoneIdList.Contains(_zoneId)) return;

            ZoneIdList.Add(_zoneId);

            /*  Niepotrzebne - interfejs zapewnia, że dodawać można tylko strefy z grupą 0
            if (CElementManager.ZoneArray[_zoneId].AssignedGroupId != 0)
            {
                CElementManager.GroupArray[CElementManager.ZoneArray[_zoneId].AssignedGroupId].RemoveZone(_zoneId);
            }
            */

            CElementManager.ZoneArray[_zoneId].AssignedGroupId = Id;
            CElementManager.SaveElement(CElementManager.ZoneArray[_zoneId]);
            CalculateAll();
        }

        public void RemoveZone(ushort _zoneId)
        {
            if (!ZoneIdList.Contains(_zoneId)) return;
            ZoneIdList.Remove(_zoneId);
            CElementManager.ZoneArray[_zoneId].AssignedGroupId = 0;
            CElementManager.SaveElement(CElementManager.ZoneArray[_zoneId]);
            CalculateAll();
        }
        #endregion

        #region Metody zwracające teksty z informacjami o aktualnym stanie
        public override string GetCurrentSourceTextShort()
        {
            if (IsEnabled == 0 || IsEmpty || selectedSourceType == SourceType.None) return SOURCE_NONE_TEXT;
            else if (selectedSourceType != SourceType.Equal) return SOURCE_MIXED_TEXT;
            else return CElementManager.SourceArray[CurrentEqualSourceId].NameShort;
        }

        public override string GetCurrentSourceTextLong()
        {
            if (IsEnabled == 0 || IsEmpty || selectedSourceType == SourceType.None) return SOURCE_NONE_TEXT;
            else if (selectedSourceType != SourceType.Equal) return SOURCE_MIXED_TEXT;
            else return CElementManager.SourceArray[CurrentEqualSourceId].NameLong;
        }

        public override string GetCurrentVolumeText()
        {
            if (IsEnabled == 0 || IsEmpty || currentVolumeType == VolumeType.Mixed) return VOLUME_UNKNOWN_TEXT;
            else return "" + CurrentEqualVolume + " %";
        }
        #endregion

        #region Metody sterujące
        public override void SetSource(ushort _sourceId)
        {
            if (IsEnabled == 0 || IsEmpty) return;

            isZoneHandlerBlocked = true;

            foreach (ushort zoneId in ZoneIdList) CElementManager.ZoneArray[zoneId].SetSource(_sourceId);

            CalculateCurrentSourceType();
            isZoneHandlerBlocked = false;
        }

        public override void SetDefaultSource()
        {
            if (IsEnabled == 0 || IsEmpty) return;

            if (IsSourceStartupDefault == 1)
            {
                SetSource(DefaultSourceId);
            }
            else
            {
                isZoneHandlerBlocked = true;
                
                foreach (ushort zoneId in ZoneIdList) CElementManager.ZoneArray[zoneId].SetDefaultSource();

                CalculateCurrentSourceType();
                isZoneHandlerBlocked = false;
            }
        }

        public override void PowerOn()
        {
            if (IsEnabled == 0 || IsEmpty || selectedSourceType == SourceType.Equal || selectedSourceType == SourceType.Mixed) return;

            isZoneHandlerBlocked = true;

            foreach (ushort zoneId in ZoneIdList)
            {
                if (CElementManager.ZoneArray[zoneId].IsPoweredOn == 0)
                {
                    if (IsSourceStartupDefault == 1) CElementManager.ZoneArray[zoneId].SetSource(DefaultSourceId);
                    else CElementManager.ZoneArray[zoneId].SetDefaultSource();
                }
            }

            CalculateCurrentSourceType();
            CalculateCurrentVolumeType();
            isZoneHandlerBlocked = false;
        }

        public override void PowerOff()
        {
            if (IsEnabled == 0 || IsEmpty) return;

            isZoneHandlerBlocked = true;

            foreach (ushort zoneId in ZoneIdList) CElementManager.ZoneArray[zoneId].PowerOff();

            CalculateCurrentSourceType();
            CalculateCurrentVolumeType();
            isZoneHandlerBlocked = false;
        }

        public override void TogglePower()
        {
            if (IsEnabled == 0 || IsEmpty) return;

            if (selectedSourceType == SourceType.None || selectedSourceType == SourceType.MixedWithNone) PowerOn();
            else PowerOff();

        }

        public override void SetVolume(ushort _volume)
        {
            if (IsEnabled == 0 || IsEmpty) return;

            isZoneHandlerBlocked = true;

            foreach (ushort zoneId in ZoneIdList) CElementManager.ZoneArray[zoneId].SetVolume(_volume);

            CalculateCurrentVolumeType();
            isZoneHandlerBlocked = false;
        }

        public override void SetDefaultVolume()
        {
            if (IsEnabled == 0 || IsEmpty) return;

            if (IsVolumeStartupDefault == 1)
            {
                SetVolume(DefaultVolume);
            }
            else
            {
                isZoneHandlerBlocked = true;

                foreach (ushort zoneId in ZoneIdList) CElementManager.ZoneArray[zoneId].SetDefaultVolume();

                CalculateCurrentVolumeType();
                isZoneHandlerBlocked = false;
            }
            
        }

        public override void IncreaseVolume()
        {
            if (IsEnabled == 0 || IsEmpty) return;

            isZoneHandlerBlocked = true;

            foreach (ushort zoneId in ZoneIdList) CElementManager.ZoneArray[zoneId].IncreaseVolume();

            CalculateCurrentVolumeType();
            isZoneHandlerBlocked = false;
        }

        public override void DecreaseVolume()
        {
            if (IsEnabled == 0 || IsEmpty) return;

            isZoneHandlerBlocked = true;

            foreach (ushort zoneId in ZoneIdList) CElementManager.ZoneArray[zoneId].DecreaseVolume();

            CalculateCurrentVolumeType();
            isZoneHandlerBlocked = false;
        }

        public override void SetMute(ushort _mute)
        {
            if (IsEnabled == 0 || IsEmpty) return;

            isZoneHandlerBlocked = true;

            foreach (ushort zoneId in ZoneIdList) CElementManager.ZoneArray[zoneId].SetMute(_mute);

            CalculateCurrentMuteType();
            isZoneHandlerBlocked = false;
        }

        public override void ToggleMute()
        {
            if (IsEnabled == 0 || IsEmpty) return;

            if (currentMuteType == MuteType.On || currentMuteType == MuteType.Mixed) SetMute(0);
            else SetMute(1);
        }
        #endregion

        #region Sprawdzenie harmonogramu
        public void CheckSchedule(ushort _day, ushort _hour, ushort _minute)
        {
            if (IsEnabled == 0 || IsEmpty) return;
            
            if (Schedule.IsTimeToStart(_day, _hour, _minute)) PowerOn();

            if (Schedule.IsTimeToStop(_day, _hour, _minute)) PowerOff();
        }
        #endregion
    }
}