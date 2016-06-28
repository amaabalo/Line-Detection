function [Gmag,Gdir,RGB] = mat2(I)
    % 'mat' with only 2 convolutions (similar to 'mmat')
    
    stretch = 0;
    scale = 1;
    npeaks = 1;
    mi = imorlet(stretch,scale,0,npeaks);
    Gx = conv2(I,mi,'same');
    mi = imorlet(stretch,scale,90,npeaks);
    Gy = conv2(I,mi,'same');
    
    Gmag = sqrt(Gx.*Gx+Gy.*Gy);
    Gmag = Gmag/max(max(Gmag));
    
    Gdir = atan2(Gy,Gx)/pi*180; % -180 to 180
    Gdir(Gdir < 0) = Gdir(Gdir < 0)+360; % 0 to 360

    if nargout > 2
        H = Gdir/360;
        S = ones(size(H));
        V = Gmag;

        HSV = cat(3,cat(3,H,S),V);
        RGB = hsv2rgb(HSV);
    end
end