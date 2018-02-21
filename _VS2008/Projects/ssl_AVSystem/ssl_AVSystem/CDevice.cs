using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace ssl_AVSystem
{
    #region Definicje delegatów
    public delegate void DSourceSelect(ushort _zoneId, ushort _sourceId);
    public delegate void DVolumeSet(ushort _zoneId, ushort _volume);
    public delegate void DMuteSet(ushort _zoneId, ushort _mute);
    #endregion

    public static class CDevice
    {
        #region Stałe dotyczące zakresu głośności
        public const ushort MIN_VOLUME = 5;
        public const ushort MAX_VOLUME = 100;
        public const ushort VOLUME_SHIFT = 5;
        #endregion

        #region Pola delegatów
        public static DSourceSelect AudioSourceSelect {get; set;}
        public static DSourceSelect VideoSourceSelect { get; set; }
        public static DVolumeSet VolumeSet { get; set; }
        public static DMuteSet MuteSet { get; set; }
        #endregion

        #region Update
        public static void UpdateZoneSelectedAudioId(ushort _zoneId, ushort _audioId)
        {
            if (CElementManager.IsInitialized == 0) return;
            CElementManager.ZoneArray[_zoneId].CurrentSourceId = CElementManager.GetSourceIdByAudioId(_audioId);
        }

        public static void UpdateZoneVolume(ushort _zoneId, ushort _volume)
        {
            if (CElementManager.IsInitialized == 0) return;
            CElementManager.ZoneArray[_zoneId].CurrentVolume = _volume;
        }

        public static void UpdateZoneMute(ushort _zoneId, ushort _mute)
        {
            if (CElementManager.IsInitialized == 0) return;
            CElementManager.ZoneArray[_zoneId].IsMuted = _mute;
        }
        #endregion

        #region Set
        private static void SetZoneAudio(ushort _zoneId, ushort _audioId)
        {
            if (AudioSourceSelect == null) return;
            else AudioSourceSelect(_zoneId, _audioId);
        }

        private static void SetZoneVideo(ushort _zoneId, ushort _videoId)
        {
            if (VideoSourceSelect == null) return;
            else VideoSourceSelect(_zoneId, _videoId);
        }

        public static void SetZoneSource(ushort _zoneId, ushort _sourceId)
        {
            if (CElementManager.IsInitialized == 0 || _sourceId > CSource.COUNT || CElementManager.SourceArray[_sourceId].IsEnabled == 0) return;
            SetZoneAudio(_zoneId, CElementManager.SourceArray[_sourceId].AudioId);
            SetZoneVideo(_zoneId, CElementManager.SourceArray[_sourceId].VideoId);
        }

        public static void SetZoneVolume(ushort _zoneId, ushort _volume)
        {
            if (VolumeSet == null) return;
            else if (_volume < MIN_VOLUME) VolumeSet(_zoneId, MIN_VOLUME);
            else if (_volume > MAX_VOLUME) VolumeSet(_zoneId, MAX_VOLUME);
            else VolumeSet(_zoneId, _volume);
        }

        public static void SetZoneMute(ushort _zoneId, ushort _mute)
        {
            if (MuteSet == null) return;
            else MuteSet(_zoneId, _mute);
        }
        #endregion
    }
}