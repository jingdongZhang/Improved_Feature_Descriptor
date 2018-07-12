figure(3);
set(3,'Name','Calibration results','NumberTitle','off');
subplot(2,1,1);
ssmy=[-2.224834e+02 ;0.000000e+00 ;1.990932e-03; -4.004428e-06; 1.218167e-08];
ssit=[-2.169126e+02 ;0.000000e+00; 1.585854e-03 ;-3.183199e-07; 3.767708e-09];

x=0:0.02*370:370;
test_value=polyval([ssmy(end:-1:1)],[0:1:double(330)]);
real_value=polyval([ssit(end:-1:1)],[0:1:double(330)]);
real_average_value=(sum(real_value))/length(real_value);
sst=sum((real_value-real_average_value).^2);
ssr=sum((real_value-test_value).^2);
result=1-ssr/sst;
c=length(a);
d=sum((a-b).^2);
rms=sqrt(d/c);
%rms=sqrt((sum(a-b).^2)/length(a));
mmh=plot(x,polyval([ssmy(end:-1:1)],[0:0.02*double(370):double(370)]),'*r',x,polyval([ssit(end:-1:1)],[0:0.02*double(370):double(370)]),'ob');legend({'Proposed','Urban'},'Location','NorthWest'); grid off; %axis equal;
xlabel('Distance ¦Ñ from the image center in pixels');
ylabel('the polynomial f(¦Ñ)');
%title('Forward projection function');
%
% subplot(2,1,2);
% plot(0:floor(calib_data.ocam_model.width/2),180/pi*atan2(0:floor(calib_data.ocam_model.width/2),-polyval([ss(end:-1:1)],[0:floor(calib_data.ocam_model.width/2)]))-90); grid on;
% xlabel('Distance ''rho'' from the image center in pixels');
% ylabel('Degrees');
% title('Angle of optical ray as a function of distance from circle center (pixels)');
