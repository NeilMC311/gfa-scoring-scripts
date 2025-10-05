program AusNats2025_v18;
// ***************************************************************************************
// ****               S e e Y o u    S c o r i n g    S c r i p t                     ****
// ****                                                                               ****
// ****                 Australian Nationals Rules 2025 v18                           ****
// ****                                                                               ****
// ****  Last Updated                                                                 ****
// ****  Tim Shirley, 11 Oct 2016 v7                                                  ****
// ****  Neil Campbell, 04 August 2018 v8                                             ****
// ****  Neil Campbell, 06 December 2018 v9                                           ****
// ****  Ian Steventon, 22 January 2019 v11                                           ****
// ****  Neil Campbell, 28 January  2019 v12                                          ****
// ****  Neil Campbell, 20 October 2020 v13                                           ****
// ****  Neil Campbell, 13 February 2023 V16                                          ****
// ****  Neil Campbell, 19 March 2023 V17                                             ****
// ****  Neil Campbell, 05 October 2025 V18                                           ****
// ****                                                                               ****
// **** I N S T R U C T I O N S                                                       ****
// **** 1. Confirm Local Rules for variations of                                      ****
// ****    Dd - minimum task distance under which a day is devalued (m)               ****  
// ****    Md - minimum marking distance (m)                                          ****
// ****    Td - minimum task time                                                     ****
// ****                                                                               ****
// **** 2. Uncomment the appropriate class constant before importing into SeeYou      ****
// ****    updating Dd and Md if varied by local rules.  Defaults are listed below    ****
// ****                                                                               ****
// **** 3. Confirm if start intervals is in use.  if so                               ****
// ****    setup the appropriate parameters in the Contest Day Tag - see below        ****
// ****                                                                               ****
// ***************************************************************************************
// ****  Parameters passed via Contest Day Tag => Parm1=Value1;Parm2=Value2           ****
// ****    S T A R T   I N T E R V A L S                                              ****
// ****    =============================                                              ****
// ****    Day Tag Parameters:                                                        ****
// ****      INTERVAL => interval length in seconds                                   ****
// ****      NUMINTERVALS => number of intervals                                      ****
// ****      BUFFER => Pre-interval buffer                                            ****
// ****                                                                               ****
// ****    * Uses standard rules copied from SeeYou example scripts.                  ****
// ****    * Pilot start time alloated to start of interval in which they start.      ****
// ****    * Pilots starting within the Buffer period prior to any interval except    ****
// ****      the first interval will be assigned their actual start time.             ****
// ****    * Pilots starting after the last interval finish will be assigned a        ****
// ****      start time as if they started in the final interval.                     ****
// ****    * User Warning used to record the actual and assigned start times.         ****
// ****                                                                               ****
// ****                                                                               ****
// ****    P I L O T   E V E N T   M A R K E R  S T A R T                             ****
// ****    ===============================================                            ****
// ****    Day Tag Parameters:                                                        ****
// ****      PEVWAIT => The pilot must wait a set time after pushing the PEV          ****
// ****                 before their Start Window commences.                          ****
// ****      PEVWINDOW => The duration of the Start Window.  The pilot may start at   ****
// ****                   any time during the Start Window and the start time will    ****
// ****                   be the actual time of the start.                            ****
// ****      PEVRESTART (Optional) => The pilot must wait a set time after creating   ****
// ****                 a PEV before they can create another PEV start window.        ****
// ****                 If PEVRESTART is not specified it defaults to PEVWAIT         ****
// ****                                                                               ****
// ****    * Scoring script will provide scorer details of any PEV violations as a    ****
// ****      User Warning highlighted by "User Wrning" in the Warning column of the   ****
// ****      day window.  The details are found in the bottom of the screen.          ****
// ****      The scorer has the responsibility to calculate and allocate penalties.   ****
// ****      This approach was taken to enable flexibility for scorer and CD to give  ****
// ****      warnings (as per notes for PEV Start Trial).  It is also consistent with ****
// ****      the approach for other penalities.                                       ****
// ****                                                                               ****
// ****    * Approach is to validate the SeeYou selected start against the valid      ****
// ****      Pilot Events in the trace file.  Alternate start crossings are not       ****
// ****      considered to select the best combination of start time vs PEV penalty.  ****
// ****                                                                               ****
// ****    * A subsequent PEV is only valid after the expiry of the restart time.     ****
// ****      A valid subsequent PEV will restart a new wait time but does not         ****
// ****      invalidate any previous windows.                                         ****
// ****                                                                               ****
// ****    * Adding Pilot Tag of "PEVINFO" will generate a list of Pilot Events and   ****
// ****      starting windows in the user warning for the particular pilot.  This is  ****
// ****      appended to any invalid PEV Start messages.  Note that this will         ****
// ****      generate a user warning even if the start is valid.                      ****
// ****                                                                               ****
// ****    * Pilot Tag of "PEVDEBUG" will generate a series of messsages windows to   ****
// ****      help with any debugging - this will be removed later.                    ****
// ****                                                                               ****
// ****    P R E S T A R T  A L T I T U D E  &  G R O U N D   S P E E D   L I M I T S ****
// ****    ========================================================================== ****
// ****    Australian Rule 28.9 - Pre-start groundspeed and altitude limits           ****
// ****    "A pre-start groundspeed and altitude limit may be imposed and shall be    ****
// ****    specified at the briefing. After the start gate is opened and before       ****
// ****    making a valid start, the pilot must ensure at least one fix below the     ****
// ****    specified pre-start altitudelimit and speed limit. Failure to do so will   ****
// ****    be penalized."                                                             ****
// ****                                                                               ****
// ****    Script updated to validate this to save significant time for the scorer    ****
// ****    as he / she will no longer need to check each file manually.               ****
// ****                                                                               ****
// ****    Special thanks to the Naviter Crew who mad this possible with a new        ****
// ****    competetion tab to expose fixes to the script... LEGENDS!                  ****
// ****                                                                               ****
// ****    Day Tag Parameters:                                                        ****
// ****      PRESTARTALT => Altitude limit in metres.                                 ****
// ****      PRESTARTGS => Groundspeed limit in km/h                                  ****
// ****                                                                               ****
// ****    Competition Parameters:                                                    ****
// ****       "Expose fixes in Scripts" option must be ticked in the competition tab  ****
// ****                                                                               ****
// ****    * Scoring script will check for at least 1 point after the start gate      ****
// ****      opens and the start time selected by SeeYou evaluation.  If no such      ****
// ****      point exists, the lowest altitude under the speed limit and the lowest   ****
// ****      speed under the ground speed limit will be present in a user warning.    ****
// ****      The scorer can then determine the appropriate penalty to apply.          ****
// ****                                                                               ****
// ****    * Pilot Tag of "PREDEBUG" will generate a series of messsages windows to   ****
// ****      help with any debugging - this will be removed later.                    ****
// ****                                                                               ****
// ****    C O M P E T I T I O N   F L O O R                                          ****
// ****    ========================================================================== ****
// ****    Australian Rule 32.9 Competition Floor                                     ****
// ****    Day Tag Parameters:                                                        ****
// ****      FLOOR => Altitude in metres.                                             ****
// ****                                                                               ****
// ****    Competition Parameters:                                                    ****
// ****       "Expose fixes in Scripts" option must be ticked in the competition tab  ****
// ****                                                                               ****
// ****    Will provide user warning for any flight that decends below the floor      ****
// ****    altitude between start and finish times.  Will only flag that there is     ****
// ****    at least 1 point below the floor.  Will require manual inspection to       ****
// ****    validate scenario(s).                                                      ****
// ****                                                                               ****
// ****    D I S T A N C E  H A N D I C A P P E D  T A S K                            ****
// ****    ========================================================================== ****
// ****    Australian Rules 46.9 & 51                                                 ****
// ****    EXCEPT: 46.4 For DHT all finishers will be scored using a handicap         ****
// ****            of 1000.                                                           ****
// ****                                                                               ****
// ****    Day Tag Parameter will active DHT scoring:                                 ****
// ****      HCAP=DHT                                                                 ****
// ****                                                                               ****
// ****    Competition Day Parameters:                                                ****
// ****       "Use Task from IGC file" option must be ticked in the Task tab in the   ****
// ****       Contest Day Properties Screen                                           ****
// ****                                                                               ****
// ****    Intended to be used in conjunction the DHTASK.com tasking solution and     ****
// ****    requires the tasks in the submitted igc files to contain the correct task  ****
// ****    for the pilot                                                              ****
// ****                                                                               ****
// ***************************************************************************************
// ****                                                                               ****
// ****   Version Details                                                             ****  
// ****                                                                               ****
// ****   V18 - Support for National Rules 2025 Revision 5 July 2025                  ****
// ****           - Implementation of Distance Handicapping                           ****
// ****           - Removal of Start Bonus                                            ****
// ****           - UseDayDevaluation = FALSE removes day devaluation and day factor  ****
// ****                                                                               ****
// ****   V17 - Fixed bugs with comp floor implementation                             ****
// ****                                                                               ****
// ****   V16 - Competition Floor                                                     ****
// ****                                                                               ****
// ****   V15 - Pilot Event Markers - align to 2022/23 rules reverting the special    ****
// ****         Benalla rules in version 14p2                                         ****
// ****                                                                               ****
// ****   V14 - Validation of rule 28.9 - Pre-start groundspeed and altitude limits   ****
// ****                                                                               ****
// ****   V13 - Pilot Event Marker logic for start, clean up user warnings now that   ****
// ****         they are actually supported :-)                                       ****
// ****                                                                               ****
// ****   V12 - Bug fix for frustrating unintended type conversion/cast               ****
// ****                                                                               ****
// ****   V11 - Cosmetic readability/commenting changes as part of familiarisation    ****
// ****       - Display bonus window info in the info tag too                         ****
// ****       - Clearer comments for start bonus input                                ****
// ****                                                                               ****
// ****   V10 - Fix error in start bonus point calculation with bonus window          ****
// ****       - Display bonus window info in the info tag too                         ****
// ****       - Clearer comments for start bonus input                                ****
// ****                                                                               ****
// ****   V9 - Updated logic for start time bonus to include a full bonus point       ****
// ****        window after the start time before the bonus points begin to decay.    ****
// ****                                                                               ****
// ****   V8 - Included additional comments and parameters to "simplify"              ****
// ****      - Incorporated logic from SeeYou standard script to support start        ****
// ****        interval logic.   Will need to be changed if intervals are passed to   ****
// ****        scoring script from task dialog in SeeYou                              ****
// ****      - Incorporate logic to support start time bonus as per Alan Barnes'      ****
// ****        request.  Intended to be trialed during 2018/2019.                     ****
// ****                                                                               ****
// ***************************************************************************************
// ****                                                                               ****
// ****   Refer to end of script for SeeYou variables reference                       ****
// ****                                                                               ****
// ***************************************************************************************
// ****    TO DO                                                                      ****
// ****    1.  Clarify rule 46.4                                                      ****
// ****    2.  Replace competition floor logic with streamlined logic from the        ****
// ****        Narromine WGC23 scripts                                                ****
// ****                                                                               ****
// ****                                                                               ****
// ****                                                                               ****
// ***************************************************************************************

const
// ***************************************************************************************
// ****  Uncomment correct class - Update values if varied by Local Rules             ****
// ***************************************************************************************
  CompClass = 'Club', Dd = 200000, Md = 80000;
  //CompClass = '15m Sports', Dd = 225000, Md = 90000;
  //CompClass = 'Std', Dd = 225000, Md = 90000;
  //CompClass = '15m', Dd = 225000, Md = 90000;
  //CompClass = 'Open Sports', Dd = 250000, Md = 100000;
  //CompClass = '18m', Dd = 250000, Md = 100000;
  //CompClass = 'Open', Dd = 250000, Md = 100000;
  //CompClass = '2-seater', Dd = 250000, Md = 100000;

// ***************************************************************************************
// ****  Minimum Task Time - Update value if varied by local rules                    ****
// ***************************************************************************************
  Td = 3;  // in hours 

// ***************************************************************************************
// ****  Day devaluation                                                              ****
// ***************************************************************************************
UseDayDevaluation = TRUE;
//UseDayDevaluation = FALSE;
    
// ***************************************************************************************
// ****  Other Constants                                                              ****
// ***************************************************************************************
  HcapBase = 1000.0;
  Pmax = 1000.0;         //Max available points

// ***************************************************************************************
// ****  Global Variables                                                             ****
// ***************************************************************************************
var
  i, j, N, Nd, Nv : integer;
  Dhmax, Vhmax, Tdmin,
  PmaxDistance, PmaxSpeed,
  Pvmax, Pdmax, Pm,
  Pd, Pv,
  Rd, Rv,
  F, S : double;
  TempString1, TempString2, TempStr3, TTD, GTD, LPA, LCT : string;
  NumIntervals, Interval, IntervalBuffer, StartBonus, BonusTime, BonusWindow : integer;
  GateIntervalPos, NumIntervalsPos, PilotStartInterval, PilotStartTime : integer;
  PevWait, PevWindow, PEVRestart : integer;
  PEVWindowStart, PEVWindowEnd : Integer;
  PreviousPEVWindowStart, PreviousPEVWindowEnd : Integer;
  PreviousPEVMiss , AfterPEVMiss: double;
  PEVFound , PEVDEBUG, PEVINFO, ValidPEVStart, PEVWindowAfterStartFound,PEVCheckNext, StartGreaterThanWindow, ValidPev: boolean;
  LastEventNbr, LastValidPevNbr : integer;
  StartBonusInUse, StartIntervalsInUse, PEVStartInUse : Boolean;
  StartIntervalWarning, StartBonusWarning, PEVStartWarning, PEVStartInfo : string;
  PreStartAltLimit, PreStartGSLimitkmh, PreStartGSLimit, MinGSBelowAltTime, MinAltBelowGSTime, NbrFixes, Launchfix, Finishfix : integer;
  MinGSBelowAlt, MinAltBelowGS : double;
  PreStartLimitsInUse, PreStartLimitOK : boolean;
  FirstPreGS, FirstPreAlt, PREDEBUG, FirstPEV :boolean;
  PreStartWarning : string;
  // event checking
  EventCount : integer;
  // Competition Floor 
  FloorInUse : Boolean;
  FloorAlt, LowPoint, PrevHeight, LastClimbTop : Double;
  FloorWarning, LowPointTime, TimeBelowDeck : string;
  LowPointFix,CurrFix,LastClimbFix,fixcount,fixduration,lastfixtime : integer;
  tbstart,tbend : integer; // Time below deck start and end

  //DHT variables
  HCAP : string; // Retrieved from Day Tag HCAP=xxxx; identify Handicap method
  DHTInUse : Boolean; // True if HCAP=DHT
  Tmin, Rt : double; // Minimum time and ratio of perf to min time
  Nt : integer; //Number of competitors under 150% of the minimum time spent on task of any competitor
    
// ***************************************************************************************
// ****  MinValue Function to simplify maximum daily points calculation               ****
// ***************************************************************************************
function MinValue( a,b,c : double ) : double;
var
  m : double;
begin
  m := a;
  if (b < m) then m := b;
  if (c < m) then m := c;
  MinValue := m;
end;

// ***************************************************************************************
// ****  Parse daytag for parameters  Parm1=Value1;Parm2=Value2                   ****
// ***************************************************************************************
function ParseDayTag( TagString, Tag : string ) : string;
var
  x : integer;
begin
  //showmessage('start of parse for:' + Tag + ' in:' + TagString);
  Result := '';
  TagString := Uppercase(TagString);
  x := pos(uppercase(Tag),TagString);
  //showmessage('x=' + inttostr(x));
  if (x > 0) then begin
    Result := copy(TagString,x + length(Tag) + 1,99);
    x := pos(';',Result);
    //showmessage('x=' + inttostr(x));
    if (x > 0) then begin
      Result := copy(Result,1,x - 1);
    end;
  end;
  //showmessage('Result:' + Result);
end;

// ***************************************************************************************
// ****  Seconds to time of day                                      ****
// ***************************************************************************************
function SecsToTOD( seconds : integer ) : string;
var
  h, m, s, x : integer;
  hh, mm, ss : string; 
begin
  h := seconds div 3600;
  x := (seconds - h * 3600);
  m := x div 60;
  s := x - m * 60;
  
  if h < 10 then hh := '0' + inttostr(h) else hh := inttostr(h);
  if m < 10 then mm := '0' + inttostr(m) else mm := inttostr(m);
  if s < 10 then ss := '0' + inttostr(s) else ss := inttostr(s);
  
  Result := hh + ':' + mm + ':' + ss;
  //Showmessage('seconds = ' + inttostr(seconds) + 'time = ' + Result);
end;

// ***************************************************************************************
// ****  Main Script                                                                  ****
// ***************************************************************************************
begin
  //showmessage('AusNats2019v15 Start');
  
  //Extract variables from daytag  
  Interval       	:= strtoint(ParseDayTag(DayTag,'INTERVAL'),0);
  NumIntervals   	:= strtoint(ParseDayTag(DayTag,'NUMINTERVALS'),0);
  IntervalBuffer 	:= strtoint(ParseDayTag(DayTag,'BUFFER'),0);
  PEVWait        	:= StrToInt(ParseDayTag(DayTag,'PEVWAIT'),0);
  PEVWindow      	:= StrToInt(ParseDayTag(DayTag,'PEVWINDOW'),0);
  PEVRestart      	:= StrToInt(ParseDayTag(DayTag,'PEVRESTART'),0);
  PreStartAltLimit	:= StrToInt(ParseDayTag(DayTag,'PRESTARTALT'),0);
  PreStartGSLimitkmh	:= StrToInt(ParseDayTag(DayTag,'PRESTARTGS'),0);
  PreStartGSLimit := round(PreStartGSLimitkmh * 1000 / 3600);
  FloorAlt := StrToInt(ParseDayTag(DayTag,'FLOOR'),0);
  HCAP := ParseDayTag(DayTag,'HCAP'); // HCAP=DHT;
  
  // Debug output of parameters
  //showmessage('int='+ inttostr(Interval) + ' NbrInt=' + inttostr(NumIntervals) + ' IntervalBuffer=' + inttostr(IntervalBuffer));
  //showmessage('StartBonus=' + inttostr(StartBonus) + ' BonusTime=' + inttostr(BonusTime) + ' BonusWindow=' + inttostr(BonusWindow));
  //showmessage('PEVWait =' + inttostr(PEVWait) + ' Window =' + inttostr(PEVWindow));

  // Check for events
  // for i := 0 to GetArrayLength(Pilots)-1 do begin
	//   showmessage('Pilot Nbr = ' + inttostr(i) + 'nbr markers = ' + inttostr(GetArrayLength(pilots[i].Markers)) );
  //   for j := 0 to GetArrayLength(pilots[i].Markers)-1 do begin
	//     showmessage('Pilot Nbr =>' + inttostr(i) + ' Time =>' + inttostr(pilots[i].Markers[j].Tsec) + ' Msg =>' + pilots[i].Markers[j].Msg );
	//   end;
  // end;
  
  // set DHTInUse flag based on HCAP=DHT in Day Tag
  if (HCAP = 'DHT') then DHTInUse := TRUE else DHTInUse := FALSE;
  
  if (Interval > 0) and (NumIntervals > 0) and (IntervalBuffer > 0) then StartIntervalsInUse := TRUE else StartIntervalsInUse := FALSE;
  if (PEVWait > 0) and (PEVWindow > 0) then begin 
	PEVStartInUse := TRUE;
	if (PEVRestart = 0) then PEVRestart := PevWait;
  end 
  else begin 
	PEVStartInUse := FALSE;
  end;
  if (PreStartAltLimit > 0) and (PreStartGSLimit > 0) then PreStartLimitsInUse := TRUE else PreStartLimitsInUse := FALSE;
  
  if (StartIntervalsInUse) and (PEVStartInUse) then begin
	Info1 := '';
    Info2 := 'ERROR: Start Intervals and Pilot Event Start can not be used at the same time';
    exit;
  end;

  if (FloorAlt > 0) then FloorInUse := TRUE else FloorInUse := False;
 
  // Start time intervals  
  if StartIntervalsInUse then begin                                      
    for i:=0 to GetArrayLength(Pilots)-1 do begin
	  Pilots[i].user_str1 := '';
      // Start interval used by pilot. 0 = first interval = opening of the start line
      PilotStartInterval := Round(Pilots[i].start - Task.NoStartBeforeTime) div Interval;          
      PilotStartTime := Task.NoStartBeforeTime + PilotStartInterval * Interval;

      // Last start interval if pilot started late
      if PilotStartInterval > (NumIntervals-1) then PilotStartInterval := NumIntervals-1;

      if (Pilots[i].start > 0) 
      and ((PilotStartTime + Interval - Pilots[i].start) > IntervalBuffer) then begin
        // Check for buffer zone to next start interval
        // set up warning to display change in times - store in user_str1
        Pilots[i].user_str1 := #10'Actual Start=' + SecsToTOD(round(Pilots[i].start)) + ' Allocated Start=' + SecsToTOD(PilotStartTime);  
        Pilots[i].start := PilotStartTime;
        if (Pilots[i].speed > 0) then begin
          Pilots[i].speed := Pilots[i].dis / (Pilots[i].finish - Pilots[i].start);
        end
      end;  
      // Else not required. if started in buffer zone actual times are used
      //showmessage('Pilot ' + Pilots[i].CompID + ' allocated start time =' + floattostr(Pilots[i].start) + ' Speed=' + floattostr(Pilots[i].speed) + ' interval=' + inttostr(PilotStartInterval)); 
    end;
  end;

  // Calculation of basic daily parameters
  Dhmax := 0;  //Highest Marking distance D0 in the scoring definitions
  Vhmax := 0;  //Maximum handicapped speed
  Tdmin := 99999;
  Tmin := 9999999; 
  N     := 0;
  Nd    := 0;
  Nv    := 0;
  
  for i := 0 to GetArrayLength(Pilots)-1 do begin
    // Use temporary double 1 td1 = handicapped distance
   
    Pilots[i].td1 := Pilots[i].dis / Pilots[i].Hcap*HcapBase;

    // Use temporary double 2 td2 = handicapped speed
    Pilots[i].td2 := Pilots[i].speed / Pilots[i].Hcap*HcapBase;

    // Pilots hors concours are not included in day devaluation calculations
    if not Pilots[i].isHC then begin
      // Pilot is competing (Not HC)
      // Find maximum handicapped distance (Dhmax) and speed (Vhmax)
      if (Pilots[i].td1 > Dhmax) then Dhmax := Pilots[i].td1;
    
      if (Pilots[i].td2 >= Vhmax) then begin
        Vhmax := Pilots[i].td2;
        if (Vhmax > 0) then Tdmin := ((Pilots[i].td1/1000)/(Vhmax*3.6));
      end;

      // For DHT find minimum time (Tmin) for pilots who have completed the task
      if (Pilots[i].finish > 0) and (Pilots[i].start > 0) then begin
          if (Pilots[i].finish - Pilots[i].start < Tmin) then Tmin := Pilots[i].finish - Pilots[i].start;
      end;
      // Count the number of competition launches (N) and number of competitors
      // exceeding handicapped distance (Nd)
      if (Pilots[i].takeoff > 0) then N  := N+1;
      if (Pilots[i].td1 >= Md)   then Nd := Nd+1;
    end;
  end;
 
  if N = 0 then Exit; // No competition launches (yet?)

  // Rule 44.2  Short Day devaluation.  By default 3 hours and 250km,
  // change Dd and Td if local rules specify.
  PmaxDistance := (1250 * Dhmax / Dd) - 250;
  if (Vhmax > 0) then PmaxSpeed := (1200 * Tdmin / Td) - 200 else PmaxSpeed := 1000;
  if (UseDayDevaluation) then Pm := MinValue( PmaxDistance, PmaxSpeed, 1000.0 ) else Pm := 1000;
  
  // Showmessage ('Pmaxdistance=' + FormatFloat('0',PmaxDistance))
  // Showmessage ('PmaxSpeed=' + FormatFloat('0',PmaxSpeed))

  // Day factor (rule 44.6)
  F := 1.25*Nd/N;
  if (F > 1) then F := 1;
  if not(UseDayDevaluation) then F := 1; // Override day devaluation if not in use

  Nv := 0;
  Nt := 0;  //DHT - number of pilots within 1.5 * Tmin

  for i := 0 to GetArrayLength(Pilots)-1 do begin
    if (not Pilots[i].isHC) then begin 
      // Pilot is competing (not HC)
      // Check if any pilot reached the goal.
      if (Pilots[i].finish > 0) then begin
        // Count the number of pilots who exceed 2/3rds of the fastest speed (Nv)
        if Pilots[i].td2 > Vhmax*2/3 then Nv := Nv+1;
        // DHT Count the number of pilots who are withn 3/2 of the lowest time (Nt)
        if Pilots[i].finish - Pilots[i].start < Tmin*3/2 then Nt := Nt+1; //DHT
      end;
    end;
  end;

  for i := 0 to GetArrayLength(Pilots)-1 do begin
    // Definition of Rd
    if (Dhmax > 0) then begin
      Rd := Pilots[i].td1 / Dhmax;
      if (Pilots[i].finish > 0) then Rd := 1;
    end
    else begin
      Rd := 0;
    end;

    // Definition of Rv
    if (Vhmax > 0) then Rv := Pilots[i].td2 / Vhmax else Rv := 0;
    
    // Definition of Rt
    if ((Tmin < 9999999) and ((Pilots[i].finish - Pilots[i].start) > 0)) then Rt := Tmin / (Pilots[i].finish - Pilots[i].start)  else Rt := 0; 
     
    // These formulas are taken from rule 44.3 but also cover rule 44.4
    // since when Nv=0 the formulas are equivalent.

    if (DHTInUse) then begin 
      Pd := Pm * ((1 - (2/3)*(Nt/N)) * Rd);
      Pv := Pm * (2 * (Rt - 2/3) * (Nt/N)); 
    end 
    else begin 
      Pd := Pm * ((1 - (2/3)*(Nv/N)) * Rd);
      Pv := Pm * (2 * (Rv - 2/3) * (Nv/N)); 
    end;

    if (Pv < 0) then Pv := 0;
   
    S := Pv + Pd;
    
    // Apply the day factor (rule 44.6) and penalty (rule 44.5) if day devaluation is not in use F is set to 1 above
    S := S * F - Pilots[i].Penalty;
    
    // Pilot Event Start
	if (pilots[i].PilotTag = 'PEVDEBUG') then PEVDEBUG:=TRUE else PEVDEBUG:=FALSE;
	if (pilots[i].PilotTag = 'PEVINFO') then PEVINFO:=TRUE else PEVINFO:=FALSE;
	
	if (PEVDEBUG) then showmessage('Checking pilot => ' + pilots[i].CompID + ' Start time => ' + formatfloat('0.0',Pilots[i].start));
	PEVStartWarning := '';
	PEVStartInfo := '';
	
    if (PEVStartInUse) and (Pilots[i].start >= 0)  then begin	//only check if we are useng PEVSTarts and the pilot has a valid start
	
	// loop through Pilot events to find PEV Start Windows
	// stop if we find a valid one for the pilots start time.
	// if no start within a PEV window we need the previous window
	// and the next window to determine the minimum miss.

		if (PEVDEBUG) then showmessage(' PEV Logic Start');
		
		ValidPEVStart := FALSE;
		PEVWindowAfterStartFound := FALSE;
		PEVCheckNext := TRUE;
		StartGreaterThanWindow := FALSE;
		LastEventNbr := GetArrayLength(pilots[i].Markers)-1;
		FirstPEV := TRUE;
		
		if (PEVDEBUG) then showmessage('number of PEVs => ' + inttostr(LastEventNbr + 1) + 'LastEventNbr = ' + inttostr(LastEventNbr));
		
		j :=0;	

		// loop through the events to see if we can find a match
		while not(ValidPEVStart) and not(PEVWindowAfterStartFound) and (j <= LastEventNbr) do begin
		    if (PEVDEBUG) then showmessage('Starting Loop j = ' + inttostr(j) + 'LastEventNbr  = ' + inttostr(LastEventNbr));
			
			
			if (j = 0)  then begin
				ValidPev := TRUE;
        LastValidPevNbr := j;
			end else begin
				if pilots[i].Markers[j].Tsec >= pilots[i].Markers[LastValidPevNbr].Tsec + PevRestart then begin 
					ValidPev := TRUE; 
          LastValidPevNbr := j;
				end else begin 
					ValidPev := FALSE;
					if (PEVDEBUG) then showmessage('PEV too soon skipping' +  inttostr(pilots[i].Markers[j].Tsec) + ' less than ' + inttostr(Pilots[i].Markers[j].Tsec + PevRestart) );
          j := j + 1;   // no valid PEV as pushed before restart time so lets check next PEV
					end;
			end;
			
			if (ValidPEV) then begin
        PEVWindowStart := pilots[i].Markers[j].Tsec + PEVWait;
				PEVWindowEnd := PEVWindowStart + PevWindow;	

					// we have ourselves a window so check if the start happened in it
				if (PEVDEBUG) then showmessage('checking window  start =>' + formatfloat('0.0',Pilots[i].start) + ' WS=>' + inttostr(PEVWindowStart) + 'WE=>' + inttostr(PEVWindowEnd));

				if (Pilots[i].start >= PEVWindowStart) and (Pilots[i].start < PEVWindowEND) then begin
					ValidPEVStart := TRUE;  //it does so we are done
					if (PEVDEBUG) then showmessage('We have a valid PEV STart so stop');
				end	else begin
					if (PEVDEBUG) then showmessage('We dont have a valid PEVStart');
					if (Pilots[i].start < PEVWindowStart) then begin
						if (PEVDEBUG) then showmessage('Start < WindowStart');
						PEVWindowAfterStartFound := TRUE;  // we have found a pev window after the start time so no point in continuing exit the while loop
					end else begin
						if (PEVDEBUG) then showmessage('Start not < WindowStart so setting PreviousPev');
						StartGreaterThanWindow := TRUE;  // we have found  PEV window that is before the start so look for a later PEV that might match
            PreviousPEVWindowStart := PEVWindowStart;
		        PreviousPEVWindowEnd := PEVWindowEnd;
  				  j := j + 1;  //it does not so lets check the next one.
					end;
				end;

			end;   // (ValidPev)

			
		end;
		
		if (PEVDEBUG) then showmessage('Now evaluate the windows');
	
		if (ValidPEVStart) then begin
			if (PEVDEBUG) then showmessage('setting warning to null');
			PEVStartWarning := '';
		end
		else begin
			if (StartGreaterThanWindow) OR (PEVWindowAfterStartFound) then begin
			    if (PEVDEBUG) then showmessage('we don;t have a valid start in a window but have found other windows');
				if (StartGreaterThanWindow) then begin
					PreviousPEVMiss := Pilots[i].start - PreviousPEVWindowEnd;
					if (PEVDEBUG) then showmessage('we have a previous window miss by ' + formatfloat('0.0',PreviousPEVMiss));
				end;
				If (PEVWindowAfterStartFound) then begin
					AfterPEVMiss := PEVWindowStart - Pilots[i].start;
					if (PEVDEBUG) then showmessage('After Window miss = ' + formatfloat('0.0',AfterPEVMiss) );
				end;
                
				if (StartGreaterThanWindow) and (PEVWindowAfterStartFound) then begin
					if (PEVDEBUG) then showmessage('We have and after and before window');
					if PreviousPevMiss < AfterPevMiss then begin
					    if (PEVDEBUG) then showmessage('PreviousMiss is smaller');
						PEVStartWarning := #10'INVALID PEV START: Started after closest window - Window End Time:' + SecsToTOD(PreviousPEVWindowEnd) + ' Start Time:' + SecsToTOD(round(Pilots[i].start)) + ' Missed by:' + SecsToTOD(round(PreviousPEVMiss)) + ' (' + formatfloat('0.0',PreviousPEVMiss/60) + ' minutes)' ;
					end else begin
					    if (PEVDEBUG) then showmessage('AfterMiss is smaller');
						PEVStartWarning := #10'INVALID PEV START: Started before closest window - Window Start Time:' + SecsToTOD(PEVWindowStart) + ' Start Time:' + SecsToTOD(round(Pilots[i].start)) + ' Missed by:' + SecsToTOD(round(AfterPEVMiss)) + ' (' + formatfloat('0.0',AfterPEVMiss/60) + ' minutes)' ;
					end;
				end else begin
					if (StartGreaterThanWindow) then begin
					    if (PEVDEBUG) then showmessage('we only have previous');
						PEVStartWarning :=  #10'INVALID PEV START: Started after closest window - Window End Time:' + SecsToTOD(PreviousPEVWindowEnd) + ' Start Time:' + SecsToTOD(round(Pilots[i].start)) + ' Missed by:' + SecsToTOD(round(PreviousPEVMiss)) + ' (' + formatfloat('0.0',PreviousPEVMiss/60) + ' minutes)';
					end	else begin
						if (PEVDEBUG) then showmessage('we only have after');
						PEVStartWarning := #10'INVALID PEV START: Started before closest window - Window Start Time:' + SecsToTOD(PEVWindowStart) + ' Start Time:' + SecsToTOD(round(Pilots[i].start)) + ' Missed by:' + SecsToTOD(round(AfterPEVMiss)) + ' (' + formatfloat('0.0',AfterPEVMiss/60) + ' minutes)';
					end;
				end;
			end
			else begin
			   if (PEVDEBUG) then showmessage('we found no PEVs at all');
				PEVStartWarning := #10'INVALID PEV START: No Pilot Events Found';
			end;
		end;
		if (PEVDEBUG) then showmessage('PEV Info setup');
		if (PEVInfo) or (PEVDEBUG) then begin
			PEVStartWarning := PEVStartWarning + #10' **** PEVSTART INFO: Nbr PEVs=' + inttostr(LastEventNbr + 1) + ', Start Time=' + SecsToTOD(round(Pilots[i].start));
			for j:=0 to LastEventNbr do begin
				PEVStartWarning := PEVStartWarning + #10'PEV' + inttostr(j + 1) + ' ' + SecsToTOD(pilots[i].Markers[j].Tsec) + ' : WS=' + SecsToTOD(pilots[i].Markers[j].Tsec + PevWait) + ' WE=' + SecsToTOD(pilots[i].Markers[j].Tsec + PevWait + PEVWindow) + ' RS=' + SecsToTOD(pilots[i].Markers[j].Tsec + PEVRestart);
			end;
			PEVStartWarning := PEVStartWarning + ' ****';
		end;	
		
	end;  
	if (pilots[i].PilotTag = 'PREDEBUG') then PREDEBUG:=TRUE else PREDEBUG:=FALSE;
    
	// Prestart Altitude and Groundspeed Limit Checking - Rule 28.9
	PreStartWarning := '';
	if (PreStartLimitsInUse) and (Pilots[i].start >= 0) then begin
		PreStartLimitOK := FALSE;
		NbrFixes := GetArrayLength(Pilots[i].Fixes);
		if (PREDEBUG) then showmessage('Pilot = '  + pilots[i].CompID
					 + #10'Number of fixes = ' + inttostr(NbrFixes) 
					 + #10'Task no start before=' + inttostr(Task.NoStartBeforeTime) 
					 + #10'Start Time=' + floattostr(Pilots[i].start));
		

		if NbrFixes > 0 then begin
			j := 0;
			While (Pilots[i].Fixes[j].TSec < Task.NoStartBeforeTime) and (j < NbrFixes - 1) do begin
				j := J + 1;
			end;
			FirstPreGS := TRUE;
			FirstPreAlt := TRUE;
			if (PREDEBUG) then showmessage('found gate open at fix nbr ' + inttostr(j));
			While (Pilots[i].Fixes[j].TSec < Pilots[i].start) and (j < NbrFixes - 1) and not(PreStartLimitOK) do begin
				if (Pilots[i].Fixes[j].AltQnh < PreStartAltLimit ) and (Pilots[i].Fixes[j].Gsp < PreStartGSLimit) then begin
					PreStartLimitOK := TRUE;
					if (PREDEBUG) then showmessage('found point below and slow');
				end else begin
					if (Pilots[i].Fixes[j].AltQnh < PreStartAltLimit ) then begin
						if (FirstPreAlt) then begin
							FirstPreAlt := FALSE;
							MinGSBelowAlt := Pilots[i].Fixes[j].Gsp;
							MinGSBelowAltTime := Pilots[i].Fixes[j].Tsec;
						end else begin
							if (Pilots[i].Fixes[j].Gsp < MinGSBelowAlt) then begin
								MinGSBelowAlt := Pilots[i].Fixes[j].Gsp;
								MinGSBelowAltTime := Pilots[i].Fixes[j].Tsec;
							end;
						end;
					end;
					if (Pilots[i].Fixes[j].Gsp < PreStartGSLimit ) then begin
						if (FirstPreGS) then begin
							FirstPreGS := FALSE;
							MinAltBelowGS := Pilots[i].Fixes[j].AltQnh;
							MinAltBelowGSTime := Pilots[i].Fixes[j].Tsec;
						end else begin
							if (Pilots[i].Fixes[j].AltQnh < MinAltBelowGS) then begin
								MinAltBelowGS := Pilots[i].Fixes[j].AltQnh;
								MinAltBelowGSTime := Pilots[i].Fixes[j].Tsec;
							end;
						end;
					end;
				end;
				j := J + 1;
			end;
			if not(PreStartLimitOK) then begin
				PreStartWarning := #10'Invalid Pre-Start GS / Alt - Minimum Ground Speed Below Alt Limit = ';
				if (FirstPreAlt) then begin
					PreStartWarning := PreStartWarning + 'Not below Altitude Limit';
				end else begin
					PreStartWarning := PreStartWarning + formatfloat('0.00',MinGSBelowAlt / 1000 * 3600) + 'km/h at time ' + SecsToTOD(MinGSBelowAltTime);
				end;
				PreStartWarning := PreStartWarning + ' and Minimum Altitude below Groundspeed Limit = ';
				if (FirstPreGS) then begin
					PreStartWarning := PreStartWarning + 'Not below Groundspeed Limit';
				end else begin
					 PreStartWarning := PreStartWarning + formatfloat('0.00',MinAltBelowGS) + 'm at time '  + SecsToTOD(MinAltBelowGSTime);
				end;
			end;
		end;	
	end;

  // ----------------- Competition Floor implementation -----------------------------------------------
  FloorWarning := '';
  if (FloorInUse) and (Pilots[i].start >= 0) then begin  // and (Pilots[i].finish >= 0) // didnt neccesarily finish 
    //showmessage('floor check for ' + Pilots[i].CompID);
    NbrFixes := GetArrayLength(Pilots[i].Fixes);
    if (NbrFixes > 0) then begin
      //showmessage('> 0 fixes');
      j := 0;
	  TTD := '';
	  //------------------------------ TOW TO COMP DECK -------------------------------------------
	  // Calculate fix for TTD "Tow To Deck" Ignore fixes until comp hard deck reached. 
	  // (after that "game on" ? hard deck pre-start warnings ?)
	  while (Pilots[i].Fixes[j].AltQnh <= FloorAlt) and (j < NbrFixes - 1) do begin
		j := j + 1;
	  end;
	  
      // j should now be the first fix where glider went past comp hard deck on launch
	  if (j > 1) then begin
        // Now find 60 seconds worth of fixes above competition deck on tow out climb
	    fixduration := 0;
	    lastfixtime := Pilots[i].Fixes[j].Tsec;
		j := j + 1; // Start from NEXT fix 
        while (fixduration < 60) and (j < NbrFixes - 1) do begin
	      if (Pilots[i].Fixes[j].AltQnh >= FloorAlt) then begin
		    // Still above hard deck on tow out
		    fixduration := fixduration + (Pilots[i].Fixes[j].Tsec - lastfixtime);
		  end
		  else begin
		    fixduration := 0;
		  end;
		  lastfixtime := Pilots[i].Fixes[j].Tsec;
		  j := j + 1;
        end;
	 
	    Launchfix := j; // a bit of wriggle room
		TTD := SecsToTOD(Pilots[i].Fixes[Launchfix].Tsec)+':('+IntToStr(fixduration)+'s)'; // Climb To Deck 
	  end;	  
	  	  
	  
	  //------------------------------ FINAL GLIDE TO COMP DECK -------------------------------------------
	  // Now step backwards from final fix to find comp floor on final glide
	  j := NbrFixes - 1;
	  GTD := '';
	  while (j < Launchfix) and (Pilots[i].Fixes[j].AltQnh < FloorAlt) and (j > 1) do begin
		j := j - 1;
	  end;	  
	  
	  // The point where we find contest deck on final glide is now j if j > 1
	  if (j > 1) then begin
	    // Now find 60 seconds worth of fixes below competition deck on final glide
	    fixduration := 0;
	    lastfixtime := Pilots[i].Fixes[j].Tsec;
		j := j - 1; // Start from PREVIOUS fix and step backwards
        while (fixduration < 60) and (j > 0) do begin
	      if (Pilots[i].Fixes[j].AltQnh >= FloorAlt) then begin
		    // Still below hard deck on final glide
			// Note that this is the reverse of above as we are going back in time
		    fixduration := fixduration + (lastfixtime - Pilots[i].Fixes[j].Tsec);
		  end
		  else begin
		    fixduration := 0; // reset unti we get a full minute
		  end;
		  lastfixtime := Pilots[i].Fixes[j].Tsec;
		  j := j - 1;
        end;
	 
	    Finishfix := j; // Fix just before comp deck on final glide
		GTD := GTD + SecsToTOD(Pilots[i].Fixes[Finishfix].Tsec)+':('+IntToStr(fixduration)+'s)'; // Final Glide To Deck 
	  end;	  
	  
	  //------------------------------ NOW CHECK FOR LOW POINTS -------------------------------------------
	  // Now check from Launchfix to finishfix if they go below hard deck
	  j := Launchfix;
	  Lowpoint := Pilots[i].Fixes[Launchfix].AltQnh;
    
	  // Times below contest deck
      tbstart := 0; 
	  TimeBelowDeck := 'Time(s):';
	  while (j < Finishfix) and (j < NbrFixes - 1) do begin
	    CurrFix := j;
		if (Pilots[i].Fixes[j].AltQnh < FloorAlt) and (tbstart = 0) then begin
		  tbstart := Pilots[i].Fixes[j].Tsec;
		end;
		
		if (Pilots[i].Fixes[j].AltQnh >= FloorAlt) and (tbstart > 0) then begin
		  tbend := Pilots[i].Fixes[j].Tsec;
		  TimeBelowDeck := TimeBelowDeck +'  ('+SecsToTOD(tbstart)+'-'+SecsToTOD(tbend)+')';
		  tbstart := 0;
		end;
		
		if (Pilots[i].Fixes[j].AltQnh < LowPoint) then begin
		  LowPoint := Pilots[i].Fixes[j].AltQnh;
		  LowPointFix := CurrFix;
		end;
	    j := j + 1;
      end;
      LowPointTime := SecsToTOD(Pilots[i].Fixes[LowPointFix].Tsec);
      LPA := FormatFloat('0.00',LowPoint*3.281)+'ft'; // LPA Low Point Altitude.

      // Diagnostic Data string
      TempStr3 := 'TTD:'+TTD+' GTD:'+GTD+'   LowPoint:'+LPA+' at '+LowPointTime;	  
    	
      // We found a fix between Launch and final glide where the deck was breached.
	  if (LowPoint < FloorAlt) then begin
        FloorWarning := 
		  'Below Floor: (' +LPA+' < '+FloatToStr(FloorAlt*3.281)+'ft) at '+TimeBelowDeck+#10+TempStr3;
       end
	  else begin
	    FloorWarning := TempStr3;
      end;
    end;
  end;  
  
  // ---------------------- Manage User Warnings ----------------------------------------------------
  Pilots[i].warning := '';
  if StartIntervalsInUse then begin
    Pilots[i].warning := Pilots[i].user_str1;
  end;
  
  if (PEVStartInUse) then begin
    Pilots[i].warning := Pilots[i].warning + PEVStartWarning;
  end;
	
  if (PreStartLimitsInUse) then begin
    Pilots[i].warning := Pilots[i].warning + PreStartWarning;
  end;

  if (FloorInUse) then begin
    Pilots[i].warning := Pilots[i].warning + FloorWarning;
  end;

  // Round to nearest whole point (rule 44.1)
  if (Pilots[i].Points > -1) then begin
    Pilots[i].Points := Round(S);
    Pilots[i].PointString := FormatFloat('0',Pilots[i].Points);
   // showmessage('Pilot ' + Pilots[i].CompID + ' Points=' + formatfloat('0.000',Pilots[i].Points) + ' S=' + formatfloat('0.000',S) );
  end;

  end; // For loop

  // Set up results for display
  for i := 0 to GetArrayLength(Pilots)-1 do begin
    // Displayed start and finish times are real start and finish times
   // showmessage('Pilot ' + Pilots[i].CompID + ' Start=' + floattostr(Pilots[i].start) + ' Finish=' + floattostr(Pilots[i].finish) + ' Speed=' + floattostr(Pilots[i].speed) + ' Distance=' + floattostr(Pilots[i].dis));
    Pilots[i].sstart  := Pilots[i].start ;
    Pilots[i].sfinish := Pilots[i].finish;

    // Displayed distance and speed are handicapped distance and speed
    // Pilots[i].sdis    := Pilots[i].td1;
    // Pilots[i].sspeed  := Pilots[i].td2;

    // Displayed distance and speed are raw distance and speed
    Pilots[i].sdis    := Pilots[i].dis;
    Pilots[i].sspeed  := Pilots[i].speed;

  end;

  // Calculate the maximum possible speed and distance scores 
  // fixed in v8 Pmax changed to Pm.
  // (corrected for day factor)

  if (DHTInUse) then begin 
    Pdmax := Pm * (1 - 2/3*(Nt/N)) * F;
    Pvmax := Pm * (2/3 * (Nt/N)) * F;
  end 
  else begin 
    Pdmax := Pm * (1 - 2/3*(Nv/N)) * F;
    Pvmax := Pm * (2/3 * (Nv/N)) * F;
  end;




  Info1 := 'Maximum Points: '+FormatFloat('0',Pvmax+Pdmax)+', Pvmax: '+FormatFloat('0',Pvmax)+', Pdmax: '+FormatFloat('0',Pdmax);
  if (UseDayDevaluation) then begin
    Info2 := 'f='+FormatFloat('0.000',F) +', N='+IntToStr(N)+', Nd='+IntToStr(Nd)+', Nv='+IntToStr(Nv);
  end 
  else begin
    Info2 := 'Day Devaluation Not In Use, N='+IntToStr(N);
  end;  

    
  if StartIntervalsInUse then begin
    Info3 := 'Strt Int: '+IntToStr(Interval div 60)+', Nbr: '+IntToStr(NumIntervals) + ', Buff: ' + IntToStr(IntervalBuffer) +'s '
  end
  else begin
    Info3 := '';
  end;
 
  if PEVStartInUse then begin
    Info3 := Info3 + 'PEVWait='+IntToStr(PevWait div 60)+'mins, PEVWin='+IntToStr(PevWindow div 60) + ' mins, NextPEV=' + IntToStr(PevRestart div 60) + ' mins ';
  end;
  
  if PreStartLimitsInUse then begin
    Info3 := Info3 + 'PreStart Alt:'+IntToStr(PreStartAltLimit)+'m, GS:'+IntToStr(PreStartGSLimitkmh) + 'km/h ';
  end;

end.

//---------------------------------------------------------------------------------------------
//Pilots[i] record element description
//
// sstart starttime   written in results sets in seconds
// sfinish finishtime written in results sets in seconds (negative values - no finish)
// sdis               distance shown in results in meters (negative values will be shown in parenthesis)
// sspeed             speed shown in results in m/s (negative values will be shown in parenthesis)
// points             points shown in results
// pointString:       string; a string representation of points for custom output
// Hcap               handicap factor as declared in pilot setup
// penalty            penalty points defined in Day performance dialog
// start              start time of task (-1 if no start)
// finish             finish time of task (-1 if no finish)
// dis                flown distance
// speed              speed of finished taks (-1 if no finish, takes into account task time)
// tstart             start time of task with time (-1 if no start)
// tfinish            finish time of task with time
// tdis               flown distance in task time
// tspeed             flown distance divided by task time
// takeoff            takeoff time (-1 if no takeoff)
// landing            landing time (-1 if no landing)
// phototime          outlanding time (-1 if no outlanding)
// isHc               set to TRUE if not competing is used
// FinishAlt          altitude of task finish
// DisToGoal          distance between Task landing point and flight landing point
// Tag                string value as defined in Day performace dialog
// Leg,LegT           array of TLeg records; info about each leg, LegT for timeout calculation
// Warning:           String; used to set up a user warning
// CompID:            String; Competition ID
// PilotTag:          String; string value as defined in Pilot edit dialog
// user_str1,user_str2,user_str3: String; user strings, which are stored also in XML file
// td1,td2,td3:       Double; temprary variables

//---------------------------------------------------------------------------------------------
//TLeg = record; holding leg information
//
// start,finish,d,crs Double; time in seconds, distance in meters, crs in radians
// td1,td2,td3 Double; variables may be used as temporary variables

//---------------------------------------------------------------------------------------------
//other variables
// info1..info2 informational strings shown on results
// DayTag string value as defined in Day properties dialog
//
//---------------------------------------------------------------------------------------------
//Task = record; holding basic information about task
// TotalDis: Double; task distance in meters
// TaskTime: Integer; task time in second
// NoStartBeforeTime: Integer; start time in second
// Point: Array of TTaskPoint; description of task
//---------------------------------------------------------------------------------------------
//TTaskPoint = record; holding basic information about taskpoint and leg
// lon,lat: Double; 
// d,crs: Double; distance, course to next point
// td1,td2,td3 Double; variables may be used as temporary variables

