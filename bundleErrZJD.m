%     Steffen Urban
%     Copyright (C) 2014  Steffen Urban
% 
%     This program is free software; you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation; either version 2 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along
%     with this program; if not, write to the Free Software Foundation, Inc.,
%     51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

% 04.03.2014 by Steffen Urban

function errW = bundleErrZJD(x, calib_data,robust)

global weights     % only used if robust is enabled

a=x(1);
b=x(2);
c=x(3);
d=x(4);
e=x(5);
offset = calib_data.taylor_order+6;

ssc=x(6:offset);

% num_points = size(M,1);

Mc=[];
Xpp=[];
Ypp=[];
lauf = 0;
for i=calib_data.ima_proc
    R = rodrigues([x(offset+1+lauf),x(offset+2+lauf),x(offset+3+lauf)]);
    T = [x(offset+4+lauf),x(offset+5+lauf),x(offset+6+lauf)]';
    M = [calib_data.photosInfo(i).patternPoints(:,2),calib_data.photosInfo(i).patternPoints(:,1),zeros(size(calib_data.photosInfo(i).patternPoints(:,2)))];%%add
%     Xt=calib_data.photosInfo(kk).patternPoints(:,1);%pattern
%     Yt=calib_data.photosInfo(kk).patternPoints(:,2);%pattern
    num_points = size(M,1);
    Mc=[Mc, R*M' + T*ones(1,num_points)];
%     Xpt=calib_data.photosInfo(kk).photoPoints(:,1)-xc;%image
%     Ypt=calib_data.photosInfo(kk).photoPoints(:,2)-yc;%image
    Xpp=[Xpp;calib_data.photosInfo(i).photoPoints(:,2)];
    Ypp=[Ypp;calib_data.photosInfo(i).photoPoints(:,1)];
    lauf = lauf+6;
end

[xp1,yp1] = omni3d2pixel(calib_data.ocam_model.ss.*ssc', Mc, calib_data.ocam_model.width, calib_data.ocam_model.height);
xp = xp1*c + yp1*d + calib_data.ocam_model.xc*a;     
yp = xp1*e + yp1   + calib_data.ocam_model.yc*b;          

errx = Xpp-xp';
erry = Ypp-yp';

if (~robust)
    errW = [double(errx) 
            double(erry)]; 
else
    errn = [errx 
            erry];   
    w = huberWeight(errn);
    weights = w;
    errW = sqrt(w).*errn;
end

end

function weight = huberWeight(v)
    k = 1;
    a = abs(v) <= k;
    b = abs(v) > k;
    weight(find(a)) = v(a)./v(a);
    weight(find(b)) = k./abs(v(b)); 
    weight = weight';
end


