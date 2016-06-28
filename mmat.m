function [Gmag,Gdir,RGB] = mmat(I)
    % matlab's 'mat'

    [Gmag, Gdir] = imgradient(I);
    
%     stretch = 0;
%     scale = 1;
%     npeaks = 1;
%     mi = imorlet(stretch,scale,90,npeaks);
%     Gx = conv2(I,mi,'same');
%     mi = imorlet(stretch,scale,0,npeaks);
%     Gy = conv2(I,mi,'same');
%     [Gmag, Gdir] = imgradient(Gx, Gy);

    Gmag = Gmag/max(max(Gmag));

    Gdir = Gdir+90;
    Gdir(Gdir < 0) = Gdir(Gdir < 0)+360;

    if nargout > 2
        H = Gdir/360;
        S = ones(size(H));
        V = Gmag;

        HSV = cat(3,cat(3,H,S),V);
        RGB = hsv2rgb(HSV);
    end
end