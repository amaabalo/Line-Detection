function mi = imorlet(stretch,scale,orientation,npeaks)
    % imaginary part of morlet wavelet

    % controls width of gaussian window (default: scale)
    sigma = scale;

    % orientation (in radians)
    theta = -(orientation-90)/360*2*pi+pi;

    % controls elongation in direction perpendicular to wave
    gamma = 1/(1+stretch);

    % width and height of kernel
    support = 2.5*sigma/gamma;

    % wavelength (default: 4*sigma)
    lambda = 1/npeaks*4*sigma;

    % phase offset (in radians)
    psi = 0;

    xmin = -support;
    xmax = -xmin;
    ymin = xmin;
    ymax = xmax;

    xdomain = xmin:xmax;
    ydomain = ymin:ymax;

    [x,y] = meshgrid(xdomain,ydomain);

    xprime = cos(theta)*x+sin(theta)*y;
    yprime = -sin(theta)*x+cos(theta)*y;

    expf = exp(-0.5/sigma^2*(xprime.^2+gamma^2*yprime.^2));

    mi = expf.*sin(2*pi/lambda*xprime+psi);

    % mean = 0
    mi = mi-sum(sum(mi))/numel(mi);

    % norm = 1
    mi = mi./sqrt(sum(sum(mi.*mi)));
end