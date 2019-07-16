
function getSignBit(a)
	if (a > 0) then
		return 1
	else
		return -1
	end
end




local Pos = {}
local T = {}

function GETAXIS_Trace_Calculate(time_s,Pos,T)
    	local 	n --后期根据time_s判断 第n条贝塞尔曲线
      	local 	as,bs,cs
     	local 	 at,bt,ct,dt
     	local 	 trace
     	local 	 A,B,C,Y1,Y2,t1,t2,t3,Temp,sita,t
     	local deta
	    local Sptr = {}
	    local Tptr = {}
		if(time_s <= T[3]) then
			n = 0
		elseif(time_s <= T[6]) then
			n = 1
		elseif(time_s <= T[9]) then
			n = 2
		elseif(time_s <= T[12]) then
			n = 3
		elseif(time_s <= T[15]) then
			n = 4
		elseif(time_s <= T[18]) then
			n = 5
		elseif(time_s <= T[21]) then
			n = 6
		elseif(time_s <= T[24]) then
			n = 7
		elseif(time_s <= T[27]) then
			n = 8
		elseif(time_s <= T[30]) then
			n = 9
		else
			n = 10
		end
		Sptr = Pos
		Tptr = T
		cs = 3*(Sptr[2] - Sptr[1])
		bs = 3*(Sptr[3] - Sptr[2]) - cs
		as = Sptr[4] - Sptr[1] - cs - bs

		ct = 3*(Tptr[2] - Tptr[1])
		bt = 3*(Tptr[3] - Tptr[2]) - ct
		at = Tptr[4] - Tptr[1] - ct - bt
		dt = Tptr[1] - time_s
	 
	    A=bt*bt-3*at*ct
	    B=bt*ct-9*at*dt
	    C=ct*ct-3*bt*dt
		
		deta=B*B-4*A*C
	
		if(A==0 and B==0) then
			 t=-ct/bt
		 elseif(deta>0) then
 	         Y1=A*bt+3*at*( -B+math.sqrt(deta) )/2
 	         Y2=A*bt+3*at*( -B-math.sqrt(deta) )/2
	         t1 = getSignBit(Y1)
	         t2 = getSignBit(Y2)
 	         t=( -bt-( t1* math.abs(Y1) ^ (1.0 / 3.0) +t2* math.abs(Y2)^(1.0/3)))/at/3.0
			 print(type(math.abs))
			 
 		 elseif(deta==0) then
         	t1=-bt/at+B/A
         	t2=-B/A/2.0
         	if(t1>=0 and t1<=1) then
             t=t1
        	 else
             t=t2
 		 	end
		else
			Temp=(2*A*bt-3*at*B)/A/2.0/math.sqrt(A)
			sita = math.acos(Temp)
		    t1=( -bt-2* math.sqrt(A)* math.cos(sita/3) ) / at /3
		    t2=( -bt+math.sqrt(A)*( math.cos(sita/3)+math.sin(sita/3)*math.sqrt(3.0) ) ) / at /3
			t3=( -bt+math.sqrt(A)*( math.cos(sita/3)-math.sin(sita/3)*math.sqrt(3.0) ) ) / at /3
			t=t3
			if(t1 >= 0.0000 and t1 <= 1.00000) then
				t = t1
			end
			if(t2 >= 0.0000 and t2 <= 1.00000) then
					t = t2
			end
			if(t3 >= 0.0000 and t3 <= 1.00000) then
				t = t3
			end		
		end
		print()
        trace =as*t*t*t+bs*t*t+cs*t+Sptr[1];
		if(time_s <= T[1]) then
			trace = Pos[1]
		end
	return trace
end


-- + (NSArray *)recursionGetsubLevelPointsWithSuperPoints:(NSArray *)points progress:(CGFloat)progress{
--     if (points.count == 1) return points;
--
--     NSMutableArray *tempArr = [[NSMutableArray alloc] init];
--     for (int i = 0; i < points.count-1; i++) {
--         NSValue *preValue = [points objectAtIndex:i];
--         CGPoint prePoint = preValue.CGPointValue;
--
--         NSValue *lastValue = [points objectAtIndex:i+1];
--         CGPoint lastPoint = lastValue.CGPointValue;
--         CGFloat diffX = lastPoint.x-prePoint.x;
--         CGFloat diffY = lastPoint.y-prePoint.y;
--
--         CGPoint currentPoint = CGPointMake(prePoint.x+diffX*progress, prePoint.y+diffY*progress);
--         [tempArr addObject:[NSValue valueWithCGPoint:currentPoint]];
--     }
--     return [self recursionGetsubLevelPointsWithSuperPoints:tempArr progress:progress];
-- }

local points = {}
function GetArray(points, progress)
	
	
	a = points[1]
	print("get:",a[1])
	return tempArr
end
-- local c = {{1,2},{2,3}}

-- GetArray(c)

	
	
	
	
	
	
	
	
	
	
	
	
