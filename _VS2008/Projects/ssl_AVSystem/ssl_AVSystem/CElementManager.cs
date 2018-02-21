using System;
using System.Collections.Generic;
using System.Text;
using Crestron.SimplSharp;      // For Basic SIMPL# Classes

namespace ssl_AVSystem
{     
    public static class CElementManager
    {
        #region Stałe do budowanie scieżek plików

        private const string FILE_DIRECTORY = "\\CF0\\AVDatabase\\";
        private const string SOURCE_PREFIX = "Source_";
        private const string ZONE_PREFIX = "Zone_";
        private const string GROUP_PREFIX = "Group_";
        private const string SCHEDULE_PREFIX = "Schedule_";
        private const string FILE_EXTENSION = ".xml";

        #endregion

        public static ushort IsInitialized { get; private set; }

        public static event EventHandler ElementManagerInitialized;

        #region Tablice elementów
        public static CSource[] SourceArray;
        public static CZone[] ZoneArray;
        public static CGroup[] GroupArray;
        #endregion

        #region Zapis/odczyt elementów do/z pliku

        private static string MakeElementFilepath(string _prefix, ushort _id)
        {
            return FILE_DIRECTORY + _prefix + _id + FILE_EXTENSION;
        }


        public static void SaveElement(CElement _element)
        {
            try
            {
                if (_element is CSource) CXMLSerialization.WriteToXMLFile<CSource>(MakeElementFilepath(SOURCE_PREFIX, _element.Id), (CSource)_element);
                else if (_element is CZone) CXMLSerialization.WriteToXMLFile<CZone>(MakeElementFilepath(ZONE_PREFIX, _element.Id), (CZone)_element);
                else if (_element is CGroup) CXMLSerialization.WriteToXMLFile<CGroup>(MakeElementFilepath(GROUP_PREFIX, _element.Id), (CGroup)_element);

                _element.OnInfoChanged();
            }
            catch (Exception ex)
            {
                CDebugHelper.SendTraceMessage("Wyjatek podczas zapisywania pliku: " + ex.Message);
            }

        }

        public static void LoadSource(ushort _sourceId)
        {
            try
            {
                CSource tempSource = CXMLSerialization.ReadFromXMLFile<CSource>(MakeElementFilepath(SOURCE_PREFIX, _sourceId));

                if (tempSource != null) SourceArray[_sourceId].Initialize(tempSource);
            }
            catch (Exception ex)
            {
                CDebugHelper.SendTraceMessage("Wyjatek podczas ladowania pliku zrodla: " + ex.Message);
            }
        }

        public static void LoadZone(ushort _zoneId)
        {
            try
            {
                CZone tempZone = CXMLSerialization.ReadFromXMLFile<CZone>(MakeElementFilepath(ZONE_PREFIX, _zoneId));

                if (tempZone != null) ZoneArray[_zoneId].Initialize(tempZone);
            }
            catch (Exception ex)
            {
                CDebugHelper.SendTraceMessage("Wyjatek podczas ladowania pliku strefy: " + ex.Message);
            }
        }

        public static void LoadGroup(ushort _groupId)
        {
            try
            {
                CGroup tempGroup = CXMLSerialization.ReadFromXMLFile<CGroup>(MakeElementFilepath(GROUP_PREFIX, _groupId));

                if (tempGroup != null) GroupArray[_groupId].Initialize(tempGroup);
            }
            catch (Exception ex)
            {
                CDebugHelper.SendTraceMessage("Wyjatek podczas ladowania pliku grupy: " + ex.Message);
            }
        }

        #endregion

        #region Tworzenie tablic elementów

        private static void CreateElements()
        {
            CDebugHelper.SendTraceMessage("Creating Elements");
            
            SourceArray = new CSource[CSource.COUNT + 1];
            ZoneArray = new CZone[CZone.COUNT + 1];
            GroupArray = new CGroup[CGroup.COUNT + 1];

            for (ushort id = 0; id <= CSource.COUNT; id++) SourceArray[id] = new CSource(id);

            for (ushort id = 0; id <= CZone.COUNT; id++) ZoneArray[id] = new CZone(id, 1);

            for (ushort id = 0; id <= CGroup.COUNT; id++) GroupArray[id] = new CGroup(id, 1);
        }

        #endregion

        #region Ładowanie słowników elementów danymi z plików

        private static void LoadSources()
        {
            for (ushort id = 1; id <= CSource.COUNT; id++)
            {
                LoadSource(id);
            }
        }

        private static void LoadZones()
        {
            for (ushort id = 1; id <= CZone.COUNT; id++)
            {
                LoadZone(id);
            }
        }

        private static void LoadGroups()
        {
            for (ushort id = 1; id <= CGroup.COUNT; id++)
            {
                LoadGroup(id);
            }
        }

        private static void LoadAllElements()
        {
            LoadSources();
            LoadZones();
            LoadGroups();
        }

        #endregion

        private static void OnElementManagerInitialized()
        {
            if (ElementManagerInitialized != null) ElementManagerInitialized(new CElement(), EventArgs.Empty);
        }

        public static void Initialize()
        {
            CreateElements();
            LoadAllElements();
            IsInitialized = 1;
            OnElementManagerInitialized();
        }

        public static void SaveAllElements()
        {
            for (ushort sourceId = 1; sourceId <= CSource.COUNT; sourceId++)
            {
                SaveElement(SourceArray[sourceId]);
            }

            for (ushort zoneId = 1; zoneId <= CZone.COUNT; zoneId++)
            {
                SaveElement(ZoneArray[zoneId]);
            }

            for (ushort groupId = 1; groupId <= CGroup.COUNT; groupId++)
            {
                SaveElement(GroupArray[groupId]);
            }
        }

        public static ushort GetSourceIdByAudioId(ushort _audioId)
        {
            CDebugHelper.SendTraceMessage("GetSourceIdByAudioId(" + _audioId + ")");
            
            for (ushort sourceId = 0; sourceId <= CSource.COUNT; sourceId++)
            {
                if (SourceArray[sourceId].AudioId == _audioId) return sourceId;
            }

            return 0;
        }

        public static void CheckGroupSchedules(ushort _day, ushort _hour, ushort _minute)
        {
            if (IsInitialized == 1) foreach (CGroup group in GroupArray) group.CheckSchedule(_day, _hour, _minute);
        }

        #region Metody testowe

        public static void Test01()
        {
            
        }

        public static void Test02()
        {
            
        }

        public static void Test03()
        {
            
        }

        public static void Test04()
        {

        }

        #endregion
    }
}