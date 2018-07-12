%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Copyright (C) 2006 DAVIDE SCARAMUZZA
%
%   Author: Davide Scaramuzza - email: davsca@tiscali.it
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program; if not, write to the Free Software
%   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
%   USA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [RRfin,ss]=calibrateZJD_test(calib_data)
% Yp=Yp_abs-yc;
% Xp=Xp_abs-xc;
% xc, yc, taylor_order_default, ima_proc
    xc=calib_data.ocam_model.xc;
    yc=calib_data.ocam_model.yc;
    
for kk = calib_data.ima_proc
    Xt=calib_data.photosInfo(kk).patternPoints(:,2);%pattern
    Yt=calib_data.photosInfo(kk).patternPoints(:,1);%pattern
    Xpt=calib_data.photosInfo(kk).photoPoints(:,2)-xc;%image
    Ypt=calib_data.photosInfo(kk).photoPoints(:,1)-yc;%image
    
    %Building the matrix
    A=[-Xt.*Ypt, -Yt.*Ypt, Xt.*Xpt, Yt.*Xpt, -Ypt, Xpt];
    %    [V,D]=eig(A'*A);
    [U,S,V] = svd(A);
    
    % So the coeff is used to flipped them. 
    for coeff = [1, -1]
        r11 = V(1, end) * coeff;
        r21 = V(3, end) * coeff;
        r12 = V(2, end) * coeff;
        r22 = V(4, end) * coeff;
        t1 = V(5, end) * coeff;
        t2 = V(6, end) * coeff;

        r31s = sqrt(roots([1, r11^2 + r21^2 - r12^2 - r22^2, -(r11*r12 + r21*r22)^2]));
        r31s = r31s(imag(r31s) == 0);
        r31s = [r31s; -r31s];
        count2=0;
        for r31 = r31s' 
            r32 = -(r11*r12 + r21*r22) / r31;
            count2=count2+1;
            r1 = [r11; r21; r31];
            r2 = [r12; r22; r32];

            scale = 1 ./ norm(r1);
            r1 = r1 .* scale;
            r2 = r2 .* scale;
            t = [t1; t2;0] .* scale; 
            %t = [t1; t2] .* scale; 

            RR1(:,:,count2)=[r1 r2 t];

        end
         %    figure(1); imagesc(aa(:,:,:,counter)); set(h,'name',filename);
        nm=plot_RR(RR1, Xt, Yt, Xpt, Ypt, 0);
        %nm=input('Which of the following is the correct matrix? type < 1 or 2>: ');

        RRdef=RR1(:,:,nm);
        RRfin(:,:,kk)=RRdef;

    end

       
end
    
   
    


%Run program finding mirror and translation parameters
[RRfin,ss]=omni_find_parameters_fun(calib_data, RRfin);

function [RRfin,ss]=omni_find_parameters_fun(calib_data, RRfin)
%Xt, Yt, Xp_abs, Yp_abs, xc, yc, RRfin, taylor_order, ima_proc
% Yp=Yp_abs-yc;
% Xp=Xp_abs-xc;

%obrand_start
min_order = 4;
range = 1000;
xc=calib_data.ocam_model.xc;
yc=calib_data.ocam_model.yc;
taylor_order=calib_data.taylor_order;
if taylor_order <= min_order  %%215
    PP=[];
    QQ=[];
    mono=[];
    count=0;
    for i = calib_data.ima_proc,
        count=count+1;
        
        RRdef=RRfin(:,:,i);
        
        R11=RRdef(1,1);
        R21=RRdef(2,1);
        R31=RRdef(3,1);
        R12=RRdef(1,2);
        R22=RRdef(2,2);
        R32=RRdef(3,2);
        T1=RRdef(1,3);
        T2=RRdef(2,3);
        
        Xt=calib_data.photosInfo(i).patternPoints(:,2);%pattern
        Yt=calib_data.photosInfo(i).patternPoints(:,1);%pattern
        Xpt=calib_data.photosInfo(i).photoPoints(:,2)-xc;%image
        Ypt=calib_data.photosInfo(i).photoPoints(:,1)-yc;%image
%       Xpt=Xp(:,:,i);
%       Ypt=Yp(:,:,i);
        
        MA= R21.*Xt + R22.*Yt + T2;
        MB= Ypt.*( R31.*Xt + R32.*Yt );
        MC= R11.*Xt + R12.*Yt + T1;
        MD= Xpt.*( R31.*Xt + R32.*Yt );
        
        rho=[];
        for j=2:taylor_order
            rho(:,:,j)= (sqrt(Xpt.^2 + Ypt.^2)).^j;
        end
        
        PP1=[MA;MC];
        for j=2:taylor_order
            PP1=[ PP1, [MA.*rho(:,:,j);MC.*rho(:,:,j)] ];
        end
        
        
        
        PP=[PP   zeros(size(PP,1),1);
            PP1, zeros(size(PP1,1),count-1) [-Ypt;-Xpt]];
        QQ=[QQ;
            MB; MD];
    end
    
    if(license('checkout','Optimization_Toolbox') ~= 1)
        s=pinv(PP)*QQ;
        ss=s(1:taylor_order);
        count=0;
        for j=calib_data.ima_proc,
            count=count+1;
            RRfin(3,3,j) = s( length(ss) + count );
        end
        ss=[ss(1);0;ss(2:end)];
        
    else  
        diff_order = 2;
        mono_rho = [];
        tempmax=0;
        for kkk = calib_data.ima_proc
            temptemp=max(calib_data.photosInfo(kkk).photoPoints(:,2));
            if tempmax<temptemp
                tempmax=temptemp;
            end
        end
        for j = 1:taylor_order
            mono_rho(:,j) = [1:tempmax].^j;;
            %mono_rho(:,j) = [1: max(squeeze(max(Xpt-xc)))].^j;;
        end
        for diff_k = 1:min(diff_order,taylor_order) % max = taylor_order
            mono1 = [];
            for j = 1:diff_k
                mono1 = [mono1, zeros(size(mono_rho,1),1)];
            end
            mono1 = [mono1, factorial(diff_k)*ones(size(mono_rho,1),1)];
            for j = diff_k+1:taylor_order
                mono1 = [mono1 , factorial(j)/factorial(j-diff_k)*mono_rho(:,j-diff_k)];
            end
            
            mono=[mono; mono1(:,1),mono1(:,3:end)];
        end
        
        if isempty(mono)
            mono = [];
            mono_const = [];
        else
            mono = -[mono, zeros(size(mono,1),size(PP,2)-size(mono,2))];
            mono_const = zeros(size(mono,1),1);
        end
        options=optimset('Display','off');
        warning('off','all');
        [s_o,ob_resnorm,ob_residual,ob_exitflag,ob_output,ob_lambda] = lsqlin(double(PP),double(QQ),mono,mono_const,[],[],[],[],[],options);
        warning('on','all');
        ss_o = s_o(1:taylor_order);
        count=0;
        for j=calib_data.ima_proc,
            count=count+1;
            RRfin(3,3,j) = s_o( length(ss_o) + count );
        end
        ss=[ss_o(1);0;ss_o(2:end)];
    end
    
else
    %obrand calculate higher order polynomials iteratively
    x0 = zeros(1,length(ima_proc)+2);
    lb = -Inf*ones(size(x0));
    ub = Inf*ones(size(x0));
    max_order = taylor_order;
    
    for taylor_order = min_order:max_order
        PP=[];
        QQ=[];
        count=0;
        
        for i = ima_proc,
            count=count+1;
            
            RRdef=RRfin(:,:,i);
            
            R11=RRdef(1,1);
            R21=RRdef(2,1);
            R31=RRdef(3,1);
            R12=RRdef(1,2);
            R22=RRdef(2,2);
            R32=RRdef(3,2);
            T1=RRdef(1,3);
            T2=RRdef(2,3);
            Xt=calib_data.photosInfo(kk).patternPoints(:,2);%pattern
            Yt=calib_data.photosInfo(kk).patternPoints(:,1);%pattern
            Ypt=calib_data.photosInfo(kk).photoPoints(:,2)-xc;%image
            Xpt=calib_data.photosInfo(kk).photoPoints(:,1)-yc;%image
%             Xpt=Xp(:,:,i);
%             Ypt=Yp(:,:,i);
            
            MA= R21.*Xt + R22.*Yt + T2;
            MB= Ypt.*( R31.*Xt + R32.*Yt );
            MC= R11.*Xt + R12.*Yt + T1;
            MD= Xpt.*( R31.*Xt + R32.*Yt );
            
            rho=[];
            for j=2:taylor_order
                rho(:,:,j)= (sqrt(Xpt.^2 + Ypt.^2)).^j;
            end
            
            PP1=[MA;MC];
            for j=2:taylor_order
                PP1=[ PP1, [MA.*rho(:,:,j);MC.*rho(:,:,j)] ];
            end
            PP=[PP   zeros(size(PP,1),1);
                PP1, zeros(size(PP1,1),count-1) [-Ypt;-Xpt]];
            QQ=[QQ;
                MB; MD];
        end
        
        if(license('checkout','Optimization_Toolbox') ~= 1)
            s=pinv(PP)*QQ;
            ss=s(1:taylor_order);
        else
            options=optimset('Display','off');
            warning('off','all');
            [s,ob_resnorm,ob_residual,ob_exitflag,ob_output,ob_lambda] = lsqlin(PP,QQ,[],[],[],[],lb,ub,x0,options);
            warning('on','all');
            ss = s(1:taylor_order);
        end
        x0 = [s(1:taylor_order);0;s(taylor_order+1:end)];
        lb = [s(1:taylor_order) - abs(range * s(1:taylor_order));-Inf; -Inf*ones(size(s(taylor_order+1:end)))];
        ub = [s(1:taylor_order) + abs(range * s(1:taylor_order));Inf; Inf*ones(size(s(taylor_order+1:end)))];
        eq_bounds = find(lb == ub);
        lb(eq_bounds) = lb(eq_bounds) - eps(lb(eq_bounds));
        ub(eq_bounds) = ub(eq_bounds) + eps(ub(eq_bounds));
        
    end
    count=0;
    for j=ima_proc,
        count=count+1;
        RRfin(3,3,j) = s( length(ss) + count );
    end
    ss=[ss(1);0;ss(2:end)];
end
%obrand_end

function index=plot_RR(RR, Xt, Yt, Xpt, Ypt, figure_number)

if figure_number>0
    figure(figure_number);
end
for i=1:size(RR,3)
    RRdef=RR(:,:,i);
    R11=RRdef(1,1);
    R21=RRdef(2,1);
    R31=RRdef(3,1);
    R12=RRdef(1,2);
    R22=RRdef(2,2);
    R32=RRdef(3,2);
    T1=RRdef(1,3);
    T2=RRdef(2,3);
    
    MA= R21.*Xt + R22.*Yt + T2;
    MB= Ypt.*( R31.*Xt + R32.*Yt );
    MC= R11.*Xt + R12.*Yt + T1;
    MD= Xpt.*( R31.*Xt + R32.*Yt );
    rho= sqrt(Xpt.^2 + Ypt.^2);
    rho2= (Xpt.^2 + Ypt.^2);
    
    PP1=[MA, MA.*rho, MA.*rho2;
        MC, MC.*rho, MC.*rho2];
    
    PP=[PP1, [-Ypt;-Xpt]];
    
    QQ=[MB; MD];
    
    s=pinv(PP)*QQ;
    ss=s(1:3);
    if figure_number>0
        subplot(1,size(RR,3),i); plot(0:620,polyval([ss(3) ss(2) ss(1)],[0:620])); grid; axis equal;
    end
    if ss(end)>=0
        index=i;
    end
end


