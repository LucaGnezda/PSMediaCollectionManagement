```Friendly Coverage Report
Generated on: 29 January 2022 12:41:39 UTC

Codebase                                     Coverage                Cov/Tot  Exc  Cov %   E Cov %
-------------------------------------------- ---------------------- --------- ---- ------- -------
PS.MediaCollectionManagement/CollectionManagement/Public                                          
  Compare-ContentModels                      [●●●●●●●●●●●●●●●●●●●●]    9/9         100.00% 100.00%
  Copy-ContentModel                          [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
  Merge-ContentModel                         [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
  New-ContentModel                           [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
  Test-FilesystemHashes                      [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
  Types                                                                                           
    <script>                                 [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/BusinessObjects                           
  ActorBO.Class                                                                                   
    ActorBO                                  [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    ActsOnType                               [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ActsOnFilenameElement                    [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ReplaceSubjectLinkedToContent            [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
    ReplaceActorLinkedWithContent            [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    AddActorRelationshipsWithContent         [●●●●●●●●●●●●●●●●●●●●]   13/13        100.00% 100.00%
    RemoveActorRelationshipsWithContentAn... [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%

  AlbumBO.Class                                                                                   
    AlbumBO                                  [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    ActsOnType                               [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ActsOnFilenameElement                    [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ReplaceSubjectLinkedToContent            [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    ReplaceAlbumLinkedWithContent            [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    ModifyCrossLinksBetweenAlbumAndStudio    [●●●●●●●●●●●●●●●●●●●●]   10/10        100.00% 100.00%
    AddAlbumRelationshipsWithContent         [●●●●●●●●●●●●●●●●●●●●]   13/13        100.00% 100.00%
    RemoveAlbumRelationshipsWithContentAn... [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%

  ArtistBO.Class                                                                                  
    ArtistBO                                 [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    ActsOnType                               [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ActsOnFilenameElement                    [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ReplaceSubjectLinkedToContent            [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
    ReplaceArtistLinkedWithContent           [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    AddArtistRelationshipsWithContent        [●●●●●●●●●●●●●●●●●●●●]   13/13        100.00% 100.00%
    RemoveArtistRelationshipsWithContentA... [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%

  ContentBO.Class                                                                                 
    <script>                                 [○○○○○○○○○○○○○○○○○○○○]    0/1           0.00%   0.00%
    ContentBO                                [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    CreateContentObject                      [●●●●●●●●●●●●●●●●●●●●]   40/40        100.00% 100.00%
    IsValidSeasonEpisode                     [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
    IsSeasonEpisodePattern                   [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    IsValidTrackNumber                       [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    IsValidYear                              [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    GetSeasonFromString                      [●●●●●●●●●●●●●●●●●●●●]   12/12        100.00% 100.00%
    GetEpisodeFromString                     [●●●●●●●●●●●●●●●●●●●●]   12/12        100.00% 100.00%
    SeasonEpisodeToString                    [●●●●●●●●●●●●●●●●●●●○]   21/22         95.45%  95.45%
    TrackToString                            [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    AddContentToList                         [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    RemoveContentFromList                    [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    UpdateContentBaseName                    [●●●●●●●●●●●●●●●●●●●●]   28/28        100.00% 100.00%
    UpdateFileName                           [●●●●●●●●●●●●●●●●●○○○]    8/9          88.89%  88.89%
    FillPropertiesWhereMissing               [●●●●●●●●●●●●●●●●●○○○]   44/49         89.80%  89.80%
    GenerateHashIfMissing                    [●●●●●●●●●●○○○○○○○○○○]    9/17         52.94%  52.94%
    CopyPropertiesHashAndWarnings            [●●●●●●●●●●●●●●●●●●●●]   10/10        100.00% 100.00%

  ContentModelConfigBO.Class                                                                      
    IsMatch                                  [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    CloneCopy                                [●●●●●●●●●●●●●●●●●●●●]   10/10        100.00% 100.00%

  SeriesBO.Class                                                                                  
    SeriesBO                                 [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    ActsOnType                               [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ActsOnFilenameElement                    [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ReplaceSubjectLinkedToContent            [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    ReplaceSeriesLinkedWithContent           [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    ModifyCrossLinksBetweenSeriesAndStudio   [●●●●●●●●●●●●●●●●●●●●]   10/10        100.00% 100.00%
    AddSeriesRelationshipsWithContent        [●●●●●●●●●●●●●●●●●●●●]   13/13        100.00% 100.00%
    RemoveSeriesRelationshipsWithContentA... [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%

  StudioBO.Class                                                                                  
    StudioBO                                 [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    ActsOnType                               [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ActsOnFilenameElement                    [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ReplaceSubjectLinkedToContent            [●●●●●●●●●●●●●●●●●●●●]    8/8         100.00% 100.00%
    ReplaceStudioLinkedWithContent           [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    ModifyCrossLinksBetweenAlbumAndStudio    [●●●●●●●●●●●●●●●●●●●●]   10/10        100.00% 100.00%
    ModifyCrossLinksBetweenSeriesAndStudio   [●●●●●●●●●●●●●●●●●●●●]   10/10        100.00% 100.00%
    AddStudioRelationshipsWithContent        [●●●●●●●●●●●●●●●●●●●●]   13/13        100.00% 100.00%
    RemoveStudioRelationshipsWithContentA... [●●●●●●●●●●●●●●●●●●●●]    8/8         100.00% 100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/Controllers                               
  CollectionManagementController.Static                                                           
    CollectionManagementController           [○○○○○○○○○○○○○○○○○○○○]    0/1           0.00%   0.00%
    Build                                    [●●●●●●●●●●●●●●●●●●●●]    5/5         100.00% 100.00%
    Rebuild                                  [●●●●●●●●●●●●●●●●●●●●]    5/5         100.00% 100.00%
    Load                                     [●●●●●●●●●●●●●●●●●●●●]    7/7         100.00% 100.00%
    Save                                     [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    AlterActor                               [●●●●●●●●●●●●●●○○○○○○]    5/7          71.43%  71.43%
    AlterAlbum                               [●●●●●●●●●●●●●●○○○○○○]    5/7          71.43%  71.43%
    AlterArtist                              [●●●●●●●●●●●●●●○○○○○○]    5/7          71.43%  71.43%
    AlterSeries                              [●●●●●●●●●●●●●●○○○○○○]    5/7          71.43%  71.43%
    AlterStudio                              [●●●●●●●●●●●●●●○○○○○○]    5/7          71.43%  71.43%
    RemodelFilenameFormat                    [●●●●●●●●●●●●●●○○○○○○]    5/7          71.43%  71.43%
    AlterSeasonEpisodeFormat                 [●●●●●●●●●●●●●●○○○○○○]    5/7          71.43%  71.43%
    AlterTrackFormat                         [●●●●●●●●●●●●●●○○○○○○]    5/7          71.43%  71.43%
    ApplyAllPendingFilenameChanges           [○○○○○○○○○○○○○○○○○○○○]    0/3           0.00%   0.00%
    RemoveContentFromModel                   [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    CopyModel                                [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    MergeModel                               [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    Compare                                  [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    TestFilesystemHashes                     [●●●●●●●●●●●●●●●●●●●●]    5/5         100.00% 100.00%
    ModelSummary                             [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    AnalysePossibleLabellingIssues           [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
    SpellcheckContentTitles                  [●●●●●●●●●●●●●●●●○○○○]    4/5          80.00%  80.00%


PS.MediaCollectionManagement/CollectionManagement/Using/Handlers                                  
  CommandHandler.Class                                                                            
    CopyModel                                [●●●●●●●●●●●●●●●●●●●●]   18/18        100.00% 100.00%
    MergeModels                              [●●●●●●●●●●●●●●●●●●●○]   39/41         95.12%  95.12%
    Compare                                  [●●●●●●●●●●●●●●●●●●○○]  152/165        92.12%  92.12%
    TestFilesystemHashes                     [●●●●●●●●●●●●●●●●○○○○]   38/47         80.85%  80.85%
    ValidateComparisonInputAndRetrieveAsC... [●●●●●●●●●●●●●●○○○○○○]   22/30         73.33%  73.33%
    ProvideConsoleTipsForMergeWarnings       [●●●●●●●●●●●●●●●●●●●●]    7/7         100.00% 100.00%

  ModelAnalysisHandler.Class                                                                      
    SetStringSimilarityProvider              [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    SetSpellcheckProvider                    [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ModelSummary                             [●●●●●●●●●●●●●●●●●●●●]   23/23        100.00% 100.00%
    AnalysePossibleLabellingIssues           [●●●●●●●●●●●●●●○○○○○○]   58/79         73.42%  73.42%
    SpellcheckContentTitles                  [●●●●●●●●●●●●●●●●●●○○]   20/22         90.91%  90.91%
    DisplaySpellcheckSuggestions             [●●●●●●●●●●●●●●●●●●●●]   24/24        100.00% 100.00%

  ModelManipulationHandler.Class                                                                  
    ModelManipulationHandler                 [●●●●●●●●●●○○○○○○○○○○]    1/2          50.00%  50.00%
    RemodelFilenameFormat                    [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    ApplyAllPendingFilenameChanges           [○○○○○○○○○○○○○○○○○○○○]    0/9           0.00%   0.00%
    AlterSeasonEpisodeFormat                 [●●●●●●●●●●●●●●●●●●○○]   15/16         93.75%  93.75%
    AlterTrackFormat                         [●●●●●●●●●●●●●●●●●●○○]   14/15         93.33%  93.33%
    AlterSubject                             [●●●●●●●●●●●●●●●●●●●●]   21/21        100.00% 100.00%
    AddContentToModel                        [●●●●●●●●●●●●●●●●●●○○]   68/73         93.15%  93.15%
    Build                                    [●●●●●●●●●●●●●●●●●●○○]   18/19         94.74%  94.74%
    Rebuild                                  [●●●●●●●●●●●●●●●●●●●○]   58/59         98.31%  98.31%
    Load                                     [●●●●●●●●●●●●●●●●●●●○]   19/20         95.00%  95.00%
    FillPropertiesAndHashWhereMissing        [●●●●●●●●●●●●●●●●●●○○]   17/18         94.44%  94.44%
    RemoveContentFromModel                   [●●●●●●●●●●●●●○○○○○○○]   13/20         65.00%  65.00%
    WillAlterResultInContentCollision        [●●●●●●●●●●●●●●●●●●●●]   10/10        100.00% 100.00%
    IsValidForAlter                          [●●●●●●●●●●●●○○○○○○○○]   14/22         63.64%  63.64%
    IfRequiredProvideConsoleTipsForAlter     [●●●●●●●●●●●●●●●●●●●●]   12/12        100.00% 100.00%
    IfRequiredProvideConsoleTipsForLoadWa... [●●●●●●●●●●●●●●●●●●●●]   11/11        100.00% 100.00%

  ModelPersistenceHandler.Class                                                                   
    LoadConfigFromIndexFile                  [●●●●●●●●●●●●●●●●●●○○]   30/33         90.91%  90.91%
    RetrieveDataFromIndexFile                [●●●●●●●●●●●●●●○○○○○○]   12/17         70.59%  70.59%
    SaveToIndexFile                          [●●●●●●●●●●●●●●●●●●●○]   26/27         96.30%  96.30%
    ReadFromIndexFile                        [●●●●●●●●●●●○○○○○○○○○]    7/12         58.33%  58.33%


PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces                                
  ICommandHandler.Interface                                                                       
    ICommandHandler                          [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    CopyModel                                [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    MergeModels                              [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    Compare                                  [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    TestFilesystemHashes                     [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%

  IContentModel.Interface                                                                         
    IContentModel                            [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    RemodelFilenameFormat                    [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3     0.00% 100.00%
    AlterActor                               [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3     0.00% 100.00%
    AlterAlbum                               [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3     0.00% 100.00%
    AlterArtist                              [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3     0.00% 100.00%
    AlterSeries                              [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3     0.00% 100.00%
    AlterStudio                              [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3     0.00% 100.00%
    AlterSeasonEpisodeFormat                 [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3     0.00% 100.00%
    AlterTrackFormat                         [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/3    +3     0.00% 100.00%
    AnalyseActorsForPossibleLabellingIssues  [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%
    AnalyseAlbumsForPossibleLabellingIssues  [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%
    AnalyseArtistsForPossibleLabellingIssues [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%
    AnalyseSeriesForPossibleLabellingIssues  [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%
    AnalyseStudiosForPossibleLabellingIssues [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%
    SpellcheckContentTitles                  [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%

  IContentSubjectBO.Interface                                                                     
    IContentSubjectBO                        [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    ActsOnType                               [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    ActsOnFilenameElement                    [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%

  IFilesystemProvider.Interface                                                                   
    IFilesystemProvider                      [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    GetFiles                                 [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    GetFileIfExists                          [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    FileExists                               [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    GenerateHash                             [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%
    CheckFilesystemHash                      [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%
    GetFileMetadataProperty                  [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    GetFileMetadataProperties                [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    UpdateFileName                           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%

  IModelAnalysisHandler.Interface                                                                 
    IModelAnalysisHandler                    [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    AnalysePossibleLabellingIssues           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    SpellcheckContentTitles                  [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%

  IModelManipulationHandler.Interface                                                             
    IModelManipulationHandler                [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    RemodelFilenameFormat                    [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    AlterSeasonEpisodeFormat                 [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    AlterTrackFormat                         [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    AlterSubject                             [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    AddContentToModel                        [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%

  IModelPersistenceHandler.Interface                                                              
    IModelPersistenceHandler                 [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    LoadConfigFromIndexFile                  [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    RetrieveDataFromIndexFile                [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%

  ISpellcheckProvider.Interface                                                                   
    ISpellcheckProvider                      [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    Initialise                               [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    CheckSpelling                            [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    GetSuggestions                           [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%

  IStringSimilarityProvider.Interface                                                             
    IStringSimilarityProvider                [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    GetNormalisedDistanceBetween             [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%
    GetRawDistanceBetween                    [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/ModuleBehaviour                           
  CollectionManagementDefaults.Static                                                             
    CollectionManagementDefaults             [○○○○○○○○○○○○○○○○○○○○]    0/1           0.00%   0.00%
    DEFAULT_AUDIO_EXTENSIONS                 [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_VIDEO_EXTENSIONS                 [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_TAGS                             [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_TAG_OPEN_DELIMITER               [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    DEFAULT_TAG_CLOSE_DELIMITER              [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    DEFAULT_FILENAME_SPLITTER                [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    DEFAULT_LIST_SPLITTER                    [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    DEFAULT_SHORTFILM_FILENAME_FORMAT        [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_FILE_FILENAME_FORMAT             [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_FILM_FILENAME_FORMAT             [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_SERIES_FILENAME_FORMAT           [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_TRACK_FILENAME_FORMAT            [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_ALBUMANDTRACK_FILENAME_FORMAT    [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_AUDIO_EXPORT_FORMAT              [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_VIDEO_EXPORT_FORMAT              [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_FILES_EXPORT_FORMAT              [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_CONFIG_EXPORT_FORMAT             [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    DEFAULT_FILEINDEX_FILEFORMAT             [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    LEGACY_FILEINDEX_FILEFORMAT              [○○○○○○○○○○○○○○○○○○○○]    0/1           0.00%   0.00%
    V2_FILEINDEX_FILEFORMAT                  [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    V3_FILEINDEX_FILEFORMAT                  [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/ObjectModels                              
  Actor.Class                                                                                     
    Actor                                    [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
    Init                                     [●●●●●●●●●●●●●●●●●●●●]   13/13        100.00% 100.00%

  Album.Class                                                                                     
    Album                                    [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    Init                                     [●●●●●●●●●●●●●●●●●●●●]   32/32        100.00% 100.00%

  Artist.Class                                                                                    
    Artist                                   [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
    Init                                     [●●●●●●●●●●●●●●●●●●●●]   13/13        100.00% 100.00%

  Content.Class                                                                                   
    Content                                  [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    Init                                     [●●●●●●●●●●●●●●●●●●●○]   83/84         98.81%  98.81%
    ToString                                 [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    AddWarning                               [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    ClearWarning                             [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    ClearWarnings                            [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%

  ContentComparer.Class                                                                           
    ContentComparer                          [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    Compare                                  [●●●●●●●●●●●●●●●●●●●●]   12/12        100.00% 100.00%

  ContentModel.Class                                                                              
    ContentModel                             [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    Init                                     [●●●●●●●●●●●●●●●●●●●●]  102/102       100.00% 100.00%
    Reset                                    [●●●●●●●●●●●●●●●●●●●●]    7/7         100.00% 100.00%
    Build                                    [●●●●●●●●●●○○○○○○○○○○]    2/4          50.00%  50.00%
    Rebuild                                  [●●●●●○○○○○○○○○○○○○○○]    1/4          25.00%  25.00%
    LoadIndex                                [●●●●●●●●●●●●●●●●●●●●]    5/5         100.00% 100.00%
    SaveIndex                                [●●●●●●●●●●●●●●●●●●●●]    5/5         100.00% 100.00%
    RemodelFilenameFormat                    [●●●●●●○○○○○○○○○○○○○○]    1/3          33.33%  33.33%
    AlterActor                               [●●●●●●○○○○○○○○○○○○○○]    1/3          33.33%  33.33%
    AlterAlbum                               [●●●●●●○○○○○○○○○○○○○○]    1/3          33.33%  33.33%
    AlterArtist                              [●●●●●●○○○○○○○○○○○○○○]    1/3          33.33%  33.33%
    AlterSeries                              [●●●●●●○○○○○○○○○○○○○○]    1/3          33.33%  33.33%
    AlterStudio                              [●●●●●●○○○○○○○○○○○○○○]    1/3          33.33%  33.33%
    AlterSeasonEpisodeFormat                 [●●●●●●○○○○○○○○○○○○○○]    1/3          33.33%  33.33%
    AlterTrackFormat                         [●●●●●●○○○○○○○○○○○○○○]    1/3          33.33%  33.33%
    ApplyAllPendingFilenameChanges           [○○○○○○○○○○○○○○○○○○○○]    0/2           0.00%   0.00%
    Summary                                  [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    AnalyseActorsForPossibleLabellingIssues  [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    AnalyseAlbumsForPossibleLabellingIssues  [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    AnalyseArtistsForPossibleLabellingIssues [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    AnalyseSeriesForPossibleLabellingIssues  [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    AnalyseStudiosForPossibleLabellingIssues [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    SpellcheckContentTitles                  [●●●●●●●●●●○○○○○○○○○○]    1/2          50.00%  50.00%
    RemoveContentFromModel                   [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%

  ContentModelConfig.Class                                                                        
    ContentModelConfig                       [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    Init                                     [●●●●●●●●●●●●●●●●●●●●]   54/54        100.00% 100.00%
    UpdateIndexes                            [●●●●●●●●●●●●●●●●●●●●]   18/18        100.00% 100.00%
    RemodelFilenameFormat                    [●●●●●●●●●●●●●●●●●●●●]   15/15        100.00% 100.00%
    OverrideIncludedExtensions               [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    OverrideTagsToDecorate                   [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    OverrideTagDelimiters                    [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    OverrideFilenameFormat                   [●●●●●●●●●●●●●●●●●●●●]    7/7         100.00% 100.00%
    OverrideFilenameSplitter                 [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
    OverrideListSplitter                     [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
    OverrideExportFormat                     [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
    ConfigureForUnstructuredFiles            [●●●●●●●●●●●●●●●●●●●●]   11/11        100.00% 100.00%
    ConfigureForStructuredFiles              [●●●●●●●●●●●●●●●●●●●●]   11/11        100.00% 100.00%
    ConfigureForFilm                         [●●●●●●●●●●●●●●●●●●●●]   11/11        100.00% 100.00%
    ConfigureForShortFilm                    [●●●●●●●●●●●●●●●●●●●●]   11/11        100.00% 100.00%
    ConfigureForSeries                       [●●●●●●●●●●●●●●●●●●●●]   11/11        100.00% 100.00%
    ConfigureForTrack                        [●●●●●●●●●●●●●●●●●●●●]   11/11        100.00% 100.00%
    ConfigureForAlbumAndTrack                [●●●●●●●●●●●●●●●●●●●●]   11/11        100.00% 100.00%
    DisplayConfig                            [●●●●●●●●●●●●●●●●●●●●]   25/25        100.00% 100.00%
    LockFilenameFormat                       [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%

  ContentSubjectBase.Class                                                                        
    ContentSubjectBase                       [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    ContentSubjectInit                       [●●●●●●●●●●●●●●●●●●●●]   16/16        100.00% 100.00%
    ToString                                 [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    GetRelatedContent                        [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%

  Series.Class                                                                                    
    Series                                   [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    Init                                     [●●●●●●●●●●●●●●●●●●●●]   32/32        100.00% 100.00%

  SpellcheckResult.Class                                                                          
    SpellcheckResult                         [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
    AddSuggestion                            [●●●●●●●●●●●●●●●●●●●●]    5/5         100.00% 100.00%
    AddRelatedContent                        [●●●●●●●●●●●●●●●●○○○○]    4/5          80.00%  80.00%

  Studio.Class                                                                                    
    Studio                                   [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    Init                                     [●●●●●●●●●●●●●●●●●●●●]   50/50        100.00% 100.00%


PS.MediaCollectionManagement/CollectionManagement/Using/Providers                                 
  FilesystemProvider.Class                                                                        
    FilesystemProvider                       [●●●●●●●●●●●●●●●●●●●●]    7/7         100.00% 100.00%
    ChangePath                               [●●●●●●●●●●●●●●●●●●●●]   15/15        100.00% 100.00%
    GetFiles                                 [●●●●●●●●●●●●●●●●●●●●]    7/7         100.00% 100.00%
    GetFileIfExists                          [●●●●●●●●●●●●●●●●●●●●]    7/7         100.00% 100.00%
    FileExists                               [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    GenerateHash                             [●●●●●●●●●●●●●●●●●●●●]    8/8         100.00% 100.00%
    CheckFilesystemHash                      [●●●●●●●●●●●●●●●●●●●●]   13/13        100.00% 100.00%
    GetFileMetadataProperty                  [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    GetFileMetadataProperties                [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    UpdateFileName                           [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    Dispose                                  [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%

  LevenshteinStringSimilarityProvider.Class                                                       
    GetNormalisedDistanceBetween             [●●●●●●●●●●●●●●●●●●●●]    6/6         100.00% 100.00%
    GetRawDistanceBetween                    [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    GetLevenshteinDistanceBetween            [●●●●●●●●●●●●●●●●●●●●]   32/32        100.00% 100.00%

  MSWordCOMSpellcheckProvider.Class                                                               
    Initialise                               [●●●●●●●●●●●○○○○○○○○○]    4/7          57.14%  57.14%
    CheckSpelling                            [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
    GetSuggestions                           [●●●●●●●●●●●●●●●●●●●●]    5/5         100.00% 100.00%
    Dispose                                  [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%


PS.MediaCollectionManagement/ConsoleExtensions/Private                                            
  Set-ConsoleState                           [●●●●●●●●●●●●●●●●●○○○]   20/23         86.96%  86.96%

PS.MediaCollectionManagement/ConsoleExtensions/Public                                             
  Add-ConsoleIndent                          [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%
  Remove-ConsoleIndent                       [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
  Reset-ConsoleIndent                        [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
  Write-ErrorToConsole                       [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
  Write-FormattedTableToConsole              [●●●●●●●●●●●●●●●●●●●●]   37/37        100.00% 100.00%
  Write-InfoToConsole                        [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
  Write-SuccessToConsole                     [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%
  Write-ToConsole                            [●●●●●●●●●●●●●●●●●●●●]    8/8         100.00% 100.00%
  Write-WarnToConsole                        [●●●●●●●●●●●●●●●●●●●●]    4/4         100.00% 100.00%

PS.MediaCollectionManagement/ConsoleExtensions/Using/Helpers                                      
  ANSIEscapedString.Static                                                                        
    PrintedLength                            [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%
    Strip                                    [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    Colourise                                [●●●●●●●●●●●●●●●●●●●●]    7/7         100.00% 100.00%
    FixedWidth                               [●●●●●●●●●●●●●●●●●●●●]   38/38        100.00% 100.00%


PS.MediaCollectionManagement/ConsoleExtensions/Using/ModuleBehaviour                              
  ConsoleExtensionsSettings.Static                                                                
    ConsoleExtensionsSettings                [○○○○○○○○○○○○○○○○○○○○]    0/1           0.00%   0.00%
    MIN_INDENT                               [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    TAB                                      [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%

  ConsoleExtensionsState.Singleton                                                                
    <script>                                 [○○○○○○○○○○○○○○○○○○○○]    0/1           0.00%   0.00%
    ConsoleExtensionsState                   [○○○○○○○○○○○○○○○○○○○○]    0/1           0.00%   0.00%
    MockConsoleReceiver                      [●●●●●●●●●●●●●●●●○○○○]    4/5          80.00%  80.00%
    ResetMockConsole                         [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%


PS.MediaCollectionManagement/FilesystemExtensions/Public                                          
  Get-AvailableFileMetadataKeys              [●●●●●●●●●●●●●●●●●○○○]   19/22         86.36%  86.36%
  Get-FileMetadata                           [●●●●●●●●●●●●●●●●●●●●]   33/33        100.00% 100.00%
  Initialize-PersistentFilesystemShell       [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
  Remove-PersistentFilesystemShell           [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
  Rename-File                                [●●●●●●●●●●●●●●●●●○○○]   15/17         88.24%  88.24%
  Save-File                                  [●●●●●●●●●●●●●●○○○○○○]    5/7          71.43%  71.43%
  Test-PersistentFilesystemShellExistence    [●●●●●●●●●●●●●●●●●●●●]    2/2         100.00% 100.00%

PS.MediaCollectionManagement/FilesystemExtensions/Using/ModuleBehaviour                           
  FilesystemExtensionsSettings.Static                                                             
    FilesystemExtensionsSettings             [○○○○○○○○○○○○○○○○○○○○]    0/1           0.00%   0.00%
    DEFAULT_MAX_METADATA_PROPERTIES          [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%

  FilesystemExtensionsState.Singleton                                                             
    FilesystemExtensionsState                [○○○○○○○○○○○○○○○○○○○○]    0/1           0.00%   0.00%
    InstantiateShell                         [●●●●●●●●●●●●●●●●●●●●]    5/5         100.00% 100.00%
    DisposeCurrentShellIfPresent             [●●●●●●●●●●●●●●●●●●●●]    7/7         100.00% 100.00%


PS.MediaCollectionManagement/FilesystemExtensions/Using/ObjectModels                              
  FileMetadataProperty.Class                                                                      
    FileMetadataProperty                     [●●●●●●●●●●●●●●●●●●●●]    3/3         100.00% 100.00%


PS.MediaCollectionManagement/Shared/Using/Base                                                    
  IsAbstract.Class                                                                                
    IsAbstract                               [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/1    +1     0.00% 100.00%
    AssertAsAbstract                         [▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲]    0/2    +2     0.00% 100.00%

  IsInterface.Class                                                                               
    IsInterface                              [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    AssertAsInterface                        [●●●●●●●●●●●●○○○○○○○○]    9/14         64.29%  64.29%

  IsStatic.Class                                                                                  
    IsStatic                                 [●●●●●●●●●●●●●●●●●●●●]    1/1         100.00% 100.00%
    AssertAsStatic                           [●●●●●●●●●●●●●○○○○○○○]    2/3          66.67%  66.67%


PS.MediaCollectionManagement                                                                      
  PS.MediaCollectionManagement                                                                    
    <script>                                 [●●●●●●●●●●●●●●●●○○○○]    9/11         81.82%  81.82%



Overall coverage:                            [●●●●●●●●●●●●●●●●●○○○] 2390/2658 +71   89.92%  92.59%
  (69 files, 2390 instructions)
```
