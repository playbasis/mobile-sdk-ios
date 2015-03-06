## Changes
### 5 March 2015
- [Fix] Removed folder path appearing before header file name in #import. This will make it painlessly work when adding Playbasis library to user's project.
- [Enhancement] Defined Playbasis's error code, and its domain (com.playbasis.iossdk) and use it when needed across the project. Returned via NSError.
- [Fix] Set PBRequestUnit's state properly during the process from start til finish.
- [Fix] Added NSNull checking against date_start and date_expire of PBGoods.
- [New] Changed to only load config in protected resource whenever calling auth...() without directly specify api-key and api-secret.
- [Fix] Removed out un-needed parameters in UI related method of Playbasis class.
- [New] Exposed parseLevelJsonResponse property for all response classes. Users can manually interat with json-response with this property (if needed).
- [Enhancement] Use shared dateFormatter in PBResponses class while parsing json-format response via PBUtils singleton class.
- [Fix] Prefixed _ in front of variable names of classes across the project.
- [New] Support only for ARC-enabled project.
- [Fix] Refactor code in PBResponses class.
- [New] Added macros for outputing debugging message.

### 6 March 2015
- [New] Add device info as custom HTTP header fields for every request. Cache it once, and use for all requests during run-time. 