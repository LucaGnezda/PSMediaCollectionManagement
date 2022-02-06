```Friendly Coverage Report
Generated on: 06 February 2022 13:54:24 UTC

Legend:
  ● = Coverage
  ▲ = Known Exemptions
  ○ = Missed Instructions

Codebase                                              Coverage                Cov/Tot  Exc  Coverage % E Coverage %
----------------------------------------------------- ---------------------- --------- ---- ---------- ------------
PS.MediaCollectionManagement/CollectionManagement/Public                                                         
  Compare-ContentModels                               [●●●●●●●●●●●●●●●●●●●●]    9/9           100.00%     100.00%
  Copy-ContentModel                                   [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
  Merge-ContentModel                                  [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
  New-ContentModel                                    [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
  Test-FilesystemHashes                               [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
  Types                                                                                                          
    <script>                                          [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/BusinessObjects                                          
  ActorBO.Class                                                                                                  
    ActorBO                                           [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    ActsOnType                                        [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ActsOnFilenameElement                             [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ReplaceSubjectLinkedToContent                     [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    ReplaceActorLinkedWithContent                     [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    AddActorRelationshipsWithContent                  [●●●●●●●●●●●●●●●●●●●●]   13/13          100.00%     100.00%
    RemoveActorRelationshipsWithContentAndCleanup     [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%

  AlbumBO.Class                                                                                                  
    AlbumBO                                           [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    ActsOnType                                        [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ActsOnFilenameElement                             [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ReplaceSubjectLinkedToContent                     [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    ReplaceAlbumLinkedWithContent                     [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    ModifyCrossLinksBetweenAlbumAndStudio             [●●●●●●●●●●●●●●●●●●●●]   10/10          100.00%     100.00%
    AddAlbumRelationshipsWithContent                  [●●●●●●●●●●●●●●●●●●●●]   13/13          100.00%     100.00%
    RemoveAlbumRelationshipsWithContentAndCleanup     [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%

  ArtistBO.Class                                                                                                 
    ArtistBO                                          [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    ActsOnType                                        [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ActsOnFilenameElement                             [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ReplaceSubjectLinkedToContent                     [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    ReplaceArtistLinkedWithContent                    [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    AddArtistRelationshipsWithContent                 [●●●●●●●●●●●●●●●●●●●●]   13/13          100.00%     100.00%
    RemoveArtistRelationshipsWithContentAndCleanup    [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%

  ContentBO.Class                                                                                                
    <script>                                          [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    ContentBO                                         [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    CreateContentObject                               [●●●●●●●●●●●●●●●●●●●●]   40/40          100.00%     100.00%
    IsValidSeasonEpisode                              [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    IsSeasonEpisodePattern                            [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    IsValidTrackNumber                                [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    IsValidYear                                       [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    GetSeasonFromString                               [●●●●●●●●●●●●●●●●●●●●]   12/12          100.00%     100.00%
    GetEpisodeFromString                              [●●●●●●●●●●●●●●●●●●●●]   12/12          100.00%     100.00%
    SeasonEpisodeToString                             [●●●●●●●●●●●●●●●●●●●▲]   21/22   +1      95.45%     100.00%
    TrackToString                                     [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    AddContentToList                                  [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    RemoveContentFromList                             [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    UpdateContentBaseName                             [●●●●●●●●●●●●●●●●●●●●]   28/28          100.00%     100.00%
    UpdateFileName                                    [●●●●●●●●●●●●●●●●●●●●]    9/9           100.00%     100.00%
    FillPropertiesWhereMissing                        [●●●●●●●●●●●●●●●●●▲▲▲]   44/49   +5      89.80%     100.00%
    GenerateHashIfMissing                             [●●●●●●●●●●▲▲▲▲▲▲▲▲▲▲]    9/17   +8      52.94%     100.00%
    CopyPropertiesHashAndWarnings                     [●●●●●●●●●●●●●●●●●●●●]   10/10          100.00%     100.00%

  ContentModelConfigBO.Class                                                                                     
    IsMatch                                           [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    CloneCopy                                         [●●●●●●●●●●●●●●●●●●●●]   10/10          100.00%     100.00%

  SeriesBO.Class                                                                                                 
    SeriesBO                                          [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    ActsOnType                                        [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ActsOnFilenameElement                             [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ReplaceSubjectLinkedToContent                     [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    ReplaceSeriesLinkedWithContent                    [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    ModifyCrossLinksBetweenSeriesAndStudio            [●●●●●●●●●●●●●●●●●●●●]   10/10          100.00%     100.00%
    AddSeriesRelationshipsWithContent                 [●●●●●●●●●●●●●●●●●●●●]   13/13          100.00%     100.00%
    RemoveSeriesRelationshipsWithContentAndCleanup    [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%

  StudioBO.Class                                                                                                 
    StudioBO                                          [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    ActsOnType                                        [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ActsOnFilenameElement                             [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ReplaceSubjectLinkedToContent                     [●●●●●●●●●●●●●●●●●●●●]    8/8           100.00%     100.00%
    ReplaceStudioLinkedWithContent                    [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    ModifyCrossLinksBetweenAlbumAndStudio             [●●●●●●●●●●●●●●●●●●●●]   10/10          100.00%     100.00%
    ModifyCrossLinksBetweenSeriesAndStudio            [●●●●●●●●●●●●●●●●●●●●]   10/10          100.00%     100.00%
    AddStudioRelationshipsWithContent                 [●●●●●●●●●●●●●●●●●●●●]   13/13          100.00%     100.00%
    RemoveStudioRelationshipsWithContentAndCleanup    [●●●●●●●●●●●●●●●●●●●●]    8/8           100.00%     100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/Controllers                                              
  CollectionManagementController.Static                                                                          
    Build                                             [●●●●●●●●●●●●●●●●●●●●]    5/5           100.00%     100.00%
    Rebuild                                           [●●●●●●●●●●●●●●●●●●●●]    5/5           100.00%     100.00%
    Load                                              [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    Save                                              [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    AlterActor                                        [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    AlterAlbum                                        [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    AlterArtist                                       [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    AlterSeries                                       [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    AlterStudio                                       [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    RemodelFilenameFormat                             [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    AlterSeasonEpisodeFormat                          [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    AlterTrackFormat                                  [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    ApplyAllPendingFilenameChanges                    [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    RemoveContentFromModel                            [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    CopyModel                                         [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    MergeModel                                        [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    Compare                                           [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    TestFilesystemHashes                              [●●●●●●●●●●●●●●●●●●●●]    5/5           100.00%     100.00%
    ModelSummary                                      [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    AnalysePossibleLabellingIssues                    [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    SpellcheckContentTitles                           [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/Handlers                                                 
  CommandHandler.Class                                                                                           
    CopyModel                                         [●●●●●●●●●●●●●●●●●●●●]   18/18          100.00%     100.00%
    MergeModels                                       [●●●●●●●●●●●●●●●●●●●●]   41/41          100.00%     100.00%
    Compare                                           [●●●●●●●●●●●●●●●●●●●●]  165/165         100.00%     100.00%
    TestFilesystemHashes                              [●●●●●●●●●●●●●●●●●●●▲]   45/47   +2      95.74%     100.00%
    ValidateComparisonInputAndRetrieveAsContent       [●●●●●●●●●●●●●●●●▲▲▲▲]   24/30   +6      80.00%     100.00%
    ProvideConsoleTipsForMergeWarnings                [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%

  ModelAnalysisHandler.Class                                                                                     
    SetStringSimilarityProvider                       [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    SetSpellcheckProvider                             [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ModelSummary                                      [●●●●●●●●●●●●●●●●●●●●]   23/23          100.00%     100.00%
    AnalysePossibleLabellingIssues                    [●●●●●●●●●●●●●●●●●●●●]   79/79          100.00%     100.00%
    SpellcheckContentTitles                           [●●●●●●●●●●●●●●●●●●●●]   22/22          100.00%     100.00%
    DisplaySpellcheckSuggestions                      [●●●●●●●●●●●●●●●●●●●●]   24/24          100.00%     100.00%

  ModelManipulationHandler.Class                                                                                 
    ModelManipulationHandler                          [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    RemodelFilenameFormat                             [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    ApplyAllPendingFilenameChanges                    [●●●●●●●●●●●●●●●▲▲▲▲▲]    7/9    +2      77.78%     100.00%
    AlterSeasonEpisodeFormat                          [●●●●●●●●●●●●●●●●●●▲▲]   15/16   +1      93.75%     100.00%
    AlterTrackFormat                                  [●●●●●●●●●●●●●●●●●●▲▲]   14/15   +1      93.33%     100.00%
    AlterSubject                                      [●●●●●●●●●●●●●●●●●●●●]   21/21          100.00%     100.00%
    AddContentToModel                                 [●●●●●●●●●●●●●●●●●●▲▲]   68/73   +5      93.15%     100.00%
    Build                                             [●●●●●●●●●●●●●●●●●●▲▲]   18/19   +1      94.74%     100.00%
    Rebuild                                           [●●●●●●●●●●●●●●●●●●●▲]   58/59   +1      98.31%     100.00%
    Load                                              [●●●●●●●●●●●●●●●●●●●▲]   19/20   +1      95.00%     100.00%
    FillPropertiesAndHashWhereMissing                 [●●●●●●●●●●●●●●●●●●▲▲]   17/18   +1      94.44%     100.00%
    RemoveContentFromModel                            [●●●●●●●●●●●●●●●●●●●●]   20/20          100.00%     100.00%
    WillAlterResultInContentCollision                 [●●●●●●●●●●●●●●●●●●●●]   10/10          100.00%     100.00%
    IsValidForAlter                                   [●●●●●●●●●●●●●●▲▲▲▲▲▲]   16/22   +6      72.73%     100.00%
    IfRequiredProvideConsoleTipsForAlter              [●●●●●●●●●●●●●●●●●●●●]   12/12          100.00%     100.00%
    IfRequiredProvideConsoleTipsForLoadWarnings       [●●●●●●●●●●●●●●●●●●●●]   11/11          100.00%     100.00%

  ModelPersistenceHandler.Class                                                                                  
    LoadConfigFromIndexFile                           [●●●●●●●●●●●●●●●●●●▲▲]   31/33   +2      93.94%     100.00%
    RetrieveDataFromIndexFile                         [●●●●●●●●●●●●●●▲▲▲▲▲▲]   12/17   +5      70.59%     100.00%
    SaveToIndexFile                                   [●●●●●●●●●●●●●●●●●●●●]   27/27          100.00%     100.00%
    ReadFromIndexFile                                 [●●●●●●●●●●●●●●●▲▲▲▲▲]    9/12   +3      75.00%     100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces                                               
  ICommandHandler.Interface                                                                                      
    ICommandHandler                                   [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    CopyModel                                         [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    MergeModels                                       [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    Compare                                           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    TestFilesystemHashes                              [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%

  IContentModel.Interface                                                                                        
    IContentModel                                     [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    RemodelFilenameFormat                             [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3       0.00%     100.00%
    AlterActor                                        [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3       0.00%     100.00%
    AlterAlbum                                        [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3       0.00%     100.00%
    AlterArtist                                       [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3       0.00%     100.00%
    AlterSeries                                       [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3       0.00%     100.00%
    AlterStudio                                       [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3       0.00%     100.00%
    AlterSeasonEpisodeFormat                          [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3       0.00%     100.00%
    AlterTrackFormat                                  [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3       0.00%     100.00%
    AnalyseActorsForPossibleLabellingIssues           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2       0.00%     100.00%
    AnalyseAlbumsForPossibleLabellingIssues           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2       0.00%     100.00%
    AnalyseArtistsForPossibleLabellingIssues          [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2       0.00%     100.00%
    AnalyseSeriesForPossibleLabellingIssues           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2       0.00%     100.00%
    AnalyseStudiosForPossibleLabellingIssues          [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2       0.00%     100.00%
    SpellcheckContentTitles                           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%

  IContentSubjectBO.Interface                                                                                    
    IContentSubjectBO                                 [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    ActsOnType                                        [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    ActsOnFilenameElement                             [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%

  IFilesystemProvider.Interface                                                                                  
    IFilesystemProvider                               [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    GetFiles                                          [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    GetFileIfExists                                   [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    FileExists                                        [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    GenerateHash                                      [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2       0.00%     100.00%
    CheckFilesystemHash                               [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2       0.00%     100.00%
    GetFileMetadataProperty                           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    GetFileMetadataProperties                         [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    UpdateFileName                                    [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2       0.00%     100.00%

  IModelAnalysisHandler.Interface                                                                                
    IModelAnalysisHandler                             [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    AnalysePossibleLabellingIssues                    [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    SpellcheckContentTitles                           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%

  IModelManipulationHandler.Interface                                                                            
    IModelManipulationHandler                         [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    RemodelFilenameFormat                             [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    AlterSeasonEpisodeFormat                          [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    AlterTrackFormat                                  [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    AlterSubject                                      [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    AddContentToModel                                 [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%

  IModelPersistenceHandler.Interface                                                                             
    IModelPersistenceHandler                          [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    LoadConfigFromIndexFile                           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    RetrieveDataFromIndexFile                         [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%

  ISpellcheckProvider.Interface                                                                                  
    ISpellcheckProvider                               [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    Initialise                                        [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    CheckSpelling                                     [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    GetSuggestions                                    [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%

  IStringSimilarityProvider.Interface                                                                            
    IStringSimilarityProvider                         [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    GetNormalisedDistanceBetween                      [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2       0.00%     100.00%
    GetRawDistanceBetween                             [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2       0.00%     100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/ModuleBehaviour                                          
  CollectionManagementDefaults.Static                                                                            
    CollectionManagementDefaults                      [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    DEFAULT_AUDIO_EXTENSIONS                          [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_VIDEO_EXTENSIONS                          [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_TAGS                                      [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_TAG_OPEN_DELIMITER                        [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    DEFAULT_TAG_CLOSE_DELIMITER                       [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    DEFAULT_FILENAME_SPLITTER                         [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    DEFAULT_LIST_SPLITTER                             [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    DEFAULT_SHORTFILM_FILENAME_FORMAT                 [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_FILE_FILENAME_FORMAT                      [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_FILM_FILENAME_FORMAT                      [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_SERIES_FILENAME_FORMAT                    [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_TRACK_FILENAME_FORMAT                     [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_ALBUMANDTRACK_FILENAME_FORMAT             [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_AUDIO_EXPORT_FORMAT                       [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_VIDEO_EXPORT_FORMAT                       [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_FILES_EXPORT_FORMAT                       [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_CONFIG_EXPORT_FORMAT                      [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    DEFAULT_FILEINDEX_FILEFORMAT                      [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    LEGACY_FILEINDEX_FILEFORMAT                       [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    V2_FILEINDEX_FILEFORMAT                           [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    V3_FILEINDEX_FILEFORMAT                           [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/ObjectModels                                             
  Actor.Class                                                                                                    
    Actor                                             [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    Init                                              [●●●●●●●●●●●●●●●●●●●●]   13/13          100.00%     100.00%

  Album.Class                                                                                                    
    Album                                             [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    Init                                              [●●●●●●●●●●●●●●●●●●●●]   32/32          100.00%     100.00%

  Artist.Class                                                                                                   
    Artist                                            [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    Init                                              [●●●●●●●●●●●●●●●●●●●●]   13/13          100.00%     100.00%

  Content.Class                                                                                                  
    Content                                           [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    Init                                              [●●●●●●●●●●●●●●●●●●●▲]   83/84   +1      98.81%     100.00%
    ToString                                          [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    AddWarning                                        [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    ClearWarning                                      [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    ClearWarnings                                     [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%

  ContentComparer.Class                                                                                          
    ContentComparer                                   [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    Compare                                           [●●●●●●●●●●●●●●●●●●●●]   12/12          100.00%     100.00%

  ContentModel.Class                                                                                             
    ContentModel                                      [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    Init                                              [●●●●●●●●●●●●●●●●●●●●]  102/102         100.00%     100.00%
    Reset                                             [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    Build                                             [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    Rebuild                                           [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    LoadIndex                                         [●●●●●●●●●●●●●●●●●●●●]    5/5           100.00%     100.00%
    SaveIndex                                         [●●●●●●●●●●●●●●●●●●●●]    5/5           100.00%     100.00%
    RemodelFilenameFormat                             [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    AlterActor                                        [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    AlterAlbum                                        [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    AlterArtist                                       [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    AlterSeries                                       [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    AlterStudio                                       [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    AlterSeasonEpisodeFormat                          [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    AlterTrackFormat                                  [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    ApplyAllPendingFilenameChanges                    [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    Summary                                           [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    AnalyseActorsForPossibleLabellingIssues           [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    AnalyseAlbumsForPossibleLabellingIssues           [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    AnalyseArtistsForPossibleLabellingIssues          [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    AnalyseSeriesForPossibleLabellingIssues           [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    AnalyseStudiosForPossibleLabellingIssues          [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    SpellcheckContentTitles                           [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    RemoveContentFromModel                            [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%

  ContentModelConfig.Class                                                                                       
    ContentModelConfig                                [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    Init                                              [●●●●●●●●●●●●●●●●●●●●]   54/54          100.00%     100.00%
    UpdateIndexes                                     [●●●●●●●●●●●●●●●●●●●●]   18/18          100.00%     100.00%
    RemodelFilenameFormat                             [●●●●●●●●●●●●●●●●●●●●]   15/15          100.00%     100.00%
    OverrideIncludedExtensions                        [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    OverrideTagsToDecorate                            [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    OverrideTagDelimiters                             [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    OverrideFilenameFormat                            [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    OverrideFilenameSplitter                          [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    OverrideListSplitter                              [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    OverrideExportFormat                              [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    ConfigureForUnstructuredFiles                     [●●●●●●●●●●●●●●●●●●●●]   11/11          100.00%     100.00%
    ConfigureForStructuredFiles                       [●●●●●●●●●●●●●●●●●●●●]   11/11          100.00%     100.00%
    ConfigureForFilm                                  [●●●●●●●●●●●●●●●●●●●●]   11/11          100.00%     100.00%
    ConfigureForShortFilm                             [●●●●●●●●●●●●●●●●●●●●]   11/11          100.00%     100.00%
    ConfigureForSeries                                [●●●●●●●●●●●●●●●●●●●●]   11/11          100.00%     100.00%
    ConfigureForTrack                                 [●●●●●●●●●●●●●●●●●●●●]   11/11          100.00%     100.00%
    ConfigureForAlbumAndTrack                         [●●●●●●●●●●●●●●●●●●●●]   11/11          100.00%     100.00%
    DisplayConfig                                     [●●●●●●●●●●●●●●●●●●●●]   25/25          100.00%     100.00%
    LockFilenameFormat                                [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%

  ContentSubjectBase.Class                                                                                       
    ContentSubjectBase                                [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    ContentSubjectInit                                [●●●●●●●●●●●●●●●●●●●●]   16/16          100.00%     100.00%
    ToString                                          [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    GetRelatedContent                                 [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%

  Series.Class                                                                                                   
    Series                                            [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    Init                                              [●●●●●●●●●●●●●●●●●●●●]   32/32          100.00%     100.00%

  SpellcheckResult.Class                                                                                         
    SpellcheckResult                                  [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
    AddSuggestion                                     [●●●●●●●●●●●●●●●●●●●●]    5/5           100.00%     100.00%
    AddRelatedContent                                 [●●●●●●●●●●●●●●●●●●●●]    5/5           100.00%     100.00%

  Studio.Class                                                                                                   
    Studio                                            [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    Init                                              [●●●●●●●●●●●●●●●●●●●●]   50/50          100.00%     100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/Providers                                                
  FilesystemProvider.Class                                                                                       
    FilesystemProvider                                [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    ChangePath                                        [●●●●●●●●●●●●●●●●●●●●]   15/15          100.00%     100.00%
    GetFiles                                          [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    GetFileIfExists                                   [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    FileExists                                        [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    GenerateHash                                      [●●●●●●●●●●●●●●●●●●●●]    8/8           100.00%     100.00%
    CheckFilesystemHash                               [●●●●●●●●●●●●●●●●●●●●]   13/13          100.00%     100.00%
    GetFileMetadataProperty                           [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    GetFileMetadataProperties                         [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    UpdateFileName                                    [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    Dispose                                           [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%

  LevenshteinStringSimilarityProvider.Class                                                                      
    GetNormalisedDistanceBetween                      [●●●●●●●●●●●●●●●●●●●●]    6/6           100.00%     100.00%
    GetRawDistanceBetween                             [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    GetLevenshteinDistanceBetween                     [●●●●●●●●●●●●●●●●●●●●]   32/32          100.00%     100.00%

  MSWordCOMSpellcheckProvider.Class                                                                              
    Initialise                                        [●●●●●●●●●●●▲▲▲▲▲▲▲▲▲]    4/7    +3      57.14%     100.00%
    CheckSpelling                                     [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
    GetSuggestions                                    [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    Dispose                                           [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%


PS.MediaCollectionManagement/ConsoleExtensions/Private                                                           
  Set-ConsoleState                                    [●●●●●●●●●●●●●●●●●●●●]   23/23          100.00%     100.00%

PS.MediaCollectionManagement/ConsoleExtensions/Public                                                            
  Add-ConsoleIndent                                   [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%
  Remove-ConsoleIndent                                [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
  Reset-ConsoleIndent                                 [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
  Write-ErrorToConsole                                [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
  Write-FormattedTableToConsole                       [●●●●●●●●●●●●●●●●●●●●]   37/37          100.00%     100.00%
  Write-InfoToConsole                                 [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
  Write-SuccessToConsole                              [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%
  Write-ToConsole                                     [●●●●●●●●●●●●●●●●●●●●]    8/8           100.00%     100.00%
  Write-WarnToConsole                                 [●●●●●●●●●●●●●●●●●●●●]    4/4           100.00%     100.00%

PS.MediaCollectionManagement/ConsoleExtensions/Using/Helpers                                                     
  ANSIEscapedString.Static                                                                                       
    PrintedLength                                     [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%
    Strip                                             [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    Colourise                                         [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%
    FixedWidth                                        [●●●●●●●●●●●●●●●●●●●●]   38/38          100.00%     100.00%


PS.MediaCollectionManagement/ConsoleExtensions/Using/ModuleBehaviour                                             
  ConsoleExtensionsSettings.Static                                                                               
    ConsoleExtensionsSettings                         [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    MIN_INDENT                                        [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    TAB                                               [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%

  ConsoleExtensionsState.Singleton                                                                               
    <script>                                          [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    ConsoleExtensionsState                            [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    MockConsoleReceiver                               [●●●●●●●●●●●●●●●●▲▲▲▲]    4/5    +1      80.00%     100.00%
    ResetMockConsole                                  [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%


PS.MediaCollectionManagement/FilesystemExtensions/Public                                                         
  Get-AvailableFileMetadataKeys                       [●●●●●●●●●●●●●●●●●●●●]   22/22          100.00%     100.00%
  Get-FileMetadata                                    [●●●●●●●●●●●●●●●●●●●●]   33/33          100.00%     100.00%
  Initialize-PersistentFilesystemShell                [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
  Remove-PersistentFilesystemShell                    [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
  Rename-File                                         [●●●●●●●●●●●●●●●●●▲▲▲]   15/17   +2      88.24%     100.00%
  Save-File                                           [●●●●●●●●●●●●●●▲▲▲▲▲▲]    5/7    +2      71.43%     100.00%
  Test-PersistentFilesystemShellExistence             [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%

PS.MediaCollectionManagement/FilesystemExtensions/Using/ModuleBehaviour                                          
  FilesystemExtensionsSettings.Static                                                                            
    FilesystemExtensionsSettings                      [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    DEFAULT_MAX_METADATA_PROPERTIES                   [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%

  FilesystemExtensionsState.Singleton                                                                            
    FilesystemExtensionsState                         [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1       0.00%     100.00%
    InstantiateShell                                  [●●●●●●●●●●●●●●●●●●●●]    5/5           100.00%     100.00%
    DisposeCurrentShellIfPresent                      [●●●●●●●●●●●●●●●●●●●●]    7/7           100.00%     100.00%


PS.MediaCollectionManagement/FilesystemExtensions/Using/ObjectModels                                             
  FileMetadataProperty.Class                                                                                     
    FileMetadataProperty                              [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%


PS.MediaCollectionManagement/Shared/Using/Base                                                                   
  IsAbstract.Class                                                                                               
    IsAbstract                                        [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    AssertAsAbstract                                  [●●●●●●●●●●●●●●●●●●●●]    2/2           100.00%     100.00%

  IsInterface.Class                                                                                              
    IsInterface                                       [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    AssertAsInterface                                 [●●●●●●●●●●●●●●▲▲▲▲▲▲]   10/14   +4      71.43%     100.00%

  IsStatic.Class                                                                                                 
    IsStatic                                          [●●●●●●●●●●●●●●●●●●●●]    1/1           100.00%     100.00%
    AssertAsStatic                                    [●●●●●●●●●●●●●●●●●●●●]    3/3           100.00%     100.00%


PS.MediaCollectionManagement                                                                                     
  PS.MediaCollectionManagement                                                                                   
    <script>                                          [●●●●●●●●●●●●●●●●▲▲▲▲]    9/11   +2      81.82%     100.00%



Overall coverage:                                     [●●●●●●●●●●●●●●●●●●▲▲] 2517/2659 +142    94.66%     100.00%
  (69 files, 2517 instructions)
```
