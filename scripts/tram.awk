BEGIN {
printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n", "Stops ID","Route ID","Transport ID","Time","km/h","Start Point", "Start Date", "Start Time", "End Point", "End Date", "End Time"
}
function dt2secs(dt) { return mktime(gensub(/[.:]/," ","g",dt)) }
function secs2hms(s) { return sprintf("%02d:%02d:%02d",s/(60*60),(s/60)%60,s%60) }
function secs2dhms(s) { return sprintf("%02d %02d:%02d:%02d",s/(60*60*24),s/(60*60)%24,(s/60)%60,s%60) }
{
	if($8==3){
		i = 1;
		do {
			id = $13","$12","$1"_"i;
			if(!(id in startTime)){
				startTime[id] = $4;
				startDate[id] = $3;
				startDistance[id] = $14;
				endDistance[id] = $14;
				endTime[id] = $4;
				endDate[id] = $3;
				break;
			}
			else if (dt2secs($3" "$4) - dt2secs(endDate[id]" "endTime[id]) < 360){
				if(endDistance[id] >= $14){
					endTime[id] = $4;
					endDate[id] = $3;
					endDistance[id] = $14;
				}
				break;
			} else {
				i++;
			} 
		} while(i>0)
	}
}
END{
	allTramsWaitingTime = 0;
	allTramsTimes = 0;
	for (id in startTime){
		if(dt2secs(endDate[id]" "endTime[id]) - dt2secs(startDate[id]" "startTime[id]) == 0){
			split(strftime("%Y.%m.%d %H:%M:%S", dt2secs(startDate[id]" "startTime[id])+3.6*startDistance[id]/20+1),endDtm);
			#print "date: " endDtm[2] " time:" endDtm[1]"\n" 
                        endDate[id] = endDtm[1];
			endTime[id] = endDtm[2];
			endDistance[id] = 0;
		}
		seconds = dt2secs(endDate[id]" "endTime[id]) - dt2secs(startDate[id]" "startTime[id]);
		speed = 3.6*(startDistance[id]-endDistance[id])/(seconds);
		timeSpend = secs2hms(seconds);
		allTramsTimes += seconds;
		printf "%s,%s,%2.1f,%4.1f,%s,%s,%3.1f,%s,%s\n", id, timeSpend, speed, startDistance[id], startDate[id], startTime[id], endDistance[id], endDate[id], endTime[id]
		#if(seconds>240 && speed<10){
		#	allTramsWaitingTime += seconds;
		#}
	}
	#printf "There is total time trams spend in a traffic jam: %11s DD HH:MM:SS or %8s seconds.\n", secs2dhms(allTramsWaitingTime), allTramsWaitingTime
	#printf "There is total time trams spend on a city  roads: %11s DD HH:MM:SS or %8s seconds.\n", secs2dhms(allTramsTimes), allTramsTimes
	#printf "allTramsWaitingTime/allTramsTimes: %2.2f%\n", allTramsWaitingTime/allTramsTimes*100
}
