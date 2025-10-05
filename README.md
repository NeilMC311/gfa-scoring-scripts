# gfa-scoring-scripts
Scoring scripts for use with SeeYou configured for GFA National Rules

AusNationals2025_v18.pas: implements most of the Australian Rules - https://doc.glidingaustralia.org/index.php?option=com_docman&view=download&alias=3360-sdp010-australian-nationals-rules&category_slug=competitions&Itemid=101

TotalsScript.pas: contains logic to support laydays and pilot pairs.

SGPNoScore.pas: Used to enable use of soaring spot and flight evaluation during SGP competitions.  Defaults scores to 0 as the primary scoring is completed via crosscountry.aero however, airspace validation and presentation is better using SeeYou.  Scorer needs to manually enter points and penalities into SeeYou based on the SGP scoring system.  Also created to enable soaringspot flight upload via glidingcomp.au which can then be fed into the SGP scoring system from a local directory on scoring computer.

SGPNoScoreGawlerTZ.pas: Created to add an extra info line to explain the 1/2 hour difference as the Adelaide timezone is incorrect in SeeYou....   