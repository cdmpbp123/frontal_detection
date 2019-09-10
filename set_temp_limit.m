function [tmin,tmax,mm] = set_temp_limit(mon)
switch mon
    case 1
        tmin =15;
        tmax =30;
        mm = 'Jan';
    case 2
        tmin =15;
        tmax =30;
        mm = 'Feb';
    case 3
        tmin =15;
        tmax =30;
        mm = 'Mar';
    case 4
        tmin =18;
        tmax =30;
        mm = 'Apr';
    case 5
        tmin =22;
        tmax =30;
        mm = 'May';
    case 6
        tmin =25;
        tmax =30;
        mm = 'Jun';
    case 7
        tmin =26;
        tmax =30;
        mm = 'Jul';
    case 8
        tmin =26;
        tmax =30;
        mm = 'Aug';
    case 9
        tmin =26;
        tmax =30;
        mm = 'Sep';
    case 10
        tmin =24;
        tmax =30;
        mm = 'Oct';
    case 11
        tmin =20;
        tmax =30;
        mm = 'Nov';
    case 12
        tmin =15;
        tmax =30;
        mm = 'Dec';
end
