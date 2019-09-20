BEGIN {
printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n", "Stops ID","Route ID","Transport ID","Time","km/h","Start Point", "Start Date", "Start Time", "End Point", "End Date", "End Time"
}
function dt2secs(dt) { return mktime(gensub(/[.:]/," ","g",dt)) }
function secs2hms(s) { return sprintf("%02d:%02d:%02d",s/(60*60),(s/60)%60,s%60) }
function secs2dhms(s) { return sprintf("%02d %02d:%02d:%02d",s/(60*60*24),s/(60*60)%24,(s/60)%60,s%60) }
{
	#from the city stop id
	stopIds[38] = 38;
	stopIds[15] = 15;
	stopIds[318] = 318;
#	stopIds[1897] = 1897;
	stopIds[316] = 316;
#	stopIds[1899] = 1899;
	stopIds[315] = 315;
#	stopIds[1900] = 1900;
	stopIds[313] = 313;
	stopIds[311] = 311;
#	stopIds[1894] = 1894;
	stopIds[306] = 306;
#	stopIds[1902] = 1902;
	stopIds[305] = 305;
	stopIds[302] = 302;
	stopIds[318] = 318;
	stopIds[299] = 299;
#	stopIds[1889] = 1889;
	stopIds[1286] = 1286;
	#to the city stop id
	stopIds[1301] = 1301;
#	stopIds[1888] = 1888;
#	stopIds[1887] = 1887;
#	stopIds[1890] = 1890;
	stopIds[1203] = 1203;
	stopIds[1058] = 1058;
#	stopIds[1903] = 1903;
	stopIds[303] = 303;
	stopIds[304] = 304;
#	stopIds[1901] = 1901;
	stopIds[307] = 307;
#	stopIds[1748] = 1748;
#	stopIds[1893] = 1893;
	stopIds[310] = 310;
	stopIds[312] = 312;
	stopIds[314] = 314;
#	stopIds[1898] = 1898;
	stopIds[673] = 673;
	stopIds[317] = 317;
	stopIds[865] = 865;
	stopIds[16] = 16;
	stopIds[867] = 867;
	if($13 in stopIds && ($12 == 625 || $12 == 624)){
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
			split(strftime("%Y.%m.%d %H:%M:%S", dt2secs(startDate[id]" "startTime[id])+3.6*startDistance[id]/40+1),endDtm);
			endDate[id] = endDtm[1];
			endTime[id] = endDtm[2];
			endDistance[id] = 0;
		}
		seconds = dt2secs(endDate[id]" "endTime[id]) - dt2secs(startDate[id]" "startTime[id]);
		speed = 3.6*(startDistance[id]-endDistance[id])/(seconds);
		timeSpend = secs2hms(seconds);
		allTramsTimes += seconds;
		printf "%s,%s,%2.1f,%4.1f,%s,%s,%3.1f,%s,%s\n", id, timeSpend, speed, startDistance[id], startDate[id], startTime[id], endDistance[id], endDate[id], endTime[id]
	}
}
