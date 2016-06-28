function [M,T,RGB] = mat(I)
    % magnitudes and tangents of grayscale, double, range [0,1] image I
    % M in [0,1], double
    % T in 0:359, integer
    %     angles are measured counterclockwise from 'x' axis
    %     where 'x' is row and 'y' is column
    % RGB: representation of M and T (see lines 44-49 for interpretation)
    
    stretch = 0;
    scale = 1;
    npeaks = 1;

    n = 16;
    N = 360;

    [nr,nc] = size(I);

    J = zeros(nr,nc,n);

    orientations = 0:N/n:N-N/n;
    for i = 1:n
        orientation = orientations(i);
        mi = imorlet(stretch,scale,orientation,npeaks);
        J(:,:,i) = conv2(I,mi,'same');
    end

    M = zeros(nr,nc);
    T = zeros(nr,nc);
    k = fspecial('gaussian',[round(7*N/n)+1 1],N/n);
    for row = 1:nr
        for col = 1:nc
            x = zeros(1,N);
            for i = 1:n
                x(round(orientations(i))+1) = J(row,col,i);
            end
            y = conv(x,k,'same');
            % y2 = abs(fft(y));
            [m,im] = max(y);
            M(row,col) = m; % y2(2);
            T(row,col) = im-1;
        end
    end
    M = M/max(max(M));
    
    if nargout > 2
        H = T/360;
        S = ones(nr,nc);
        V = M;

        HSV = cat(3,cat(3,H,S),V);
        RGB = hsv2rgb(HSV);
    end
end