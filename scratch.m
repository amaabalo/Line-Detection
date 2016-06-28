for sigma = linspace(0.5,5,10)
    plot(fspecial('gaussian',[1 ceil(5*sigma)],sigma))
    pause
end