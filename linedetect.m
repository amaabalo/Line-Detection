function linedetect(Image)

    % magnitudes and tangents

    I0 = double(rgb2gray(imread(Image.name)))/255;
    
    

    % [Gmag,Gdir,RGB] = mat2(I0);
    % imshow(Gmag)
    % imwrite(Gmag,'C2Grad3.png');
    % return

    % p = [123; 59];
    % q = [41; 76];

    % p = [141; 43];
    % q = [50; 140];
    p = Image.p;
    q = Image.q;
    % I = repmat(I0,[1 1 3]);
    % I(p(1),p(2),1) = 1;
    % I(p(1),p(2),2:3) = 0;
    % I(q(1),q(2),1) = 1;
    % I(q(1),q(2),2:3) = 0;
    % imshow(I)
    % return

      figure(1),imshow(I0)
      hold on
      plot([p(2),q(2)],[p(1),q(1)],'Color','r','LineWidth',2)
    
    d = norm(q-p);
    v = (q-p)/d;

    % figure(1)
    % figure(2)

    I = repmat(I0,[1 1 3]);     %RGB? 

    for i = 0:2:1.2*d
        r0 = p+i*v;
        r = round(r0);
        I(r(1),r(2),1) = 1;
        I(r(1),r(2),2:3) = 0;
        m = [];
        for j = -15:15
            s0 = r0+j*[-v(2); v(1)];
            s = round(s0);
            I(s(1),s(2),1) = 1;
            I(s(1),s(2),2:3) = 0;
            % m = [m mean(mean(I0(s(1)-1:s(1)+1,s(2)-1:s(2)+1)))];
            m = [m I0(s(1),s(2))];
        end
    %     figure(1)
    %     imshow(I)
        
        %plot(m);
        %hold on
        %pause
        if i == 0
            for sigma = 0.25:3
                m = conv(m,fspecial('gaussian',[1 4*sigma],sigma),'same');
                %plot(m);
                %hold on
                %pause
                mIn = m(11:21);
                mConv = conv2(m,mIn,'same');
                [pks,lcs] = findpeaks(mConv);
    %             figure(2)
    %             plot(m,'r'), hold on
    %             plot(mConv,'g')
    %             for j = 1:length(pks)
    %                 plot(lcs(j),pks(j),'ko')
    %             end
    %             hold off
    %             legend('original', 'convolved')
    %             title(sprintf('defining sigma = %f',sigma))
    %             pause
                if length(pks) == 1
                    sigma0 = sigma;
                    break
                end
            end
        else
            m = conv(m,fspecial('gaussian',[1 4*sigma0],sigma0),'same');
            mConv = conv2(m,mIn,'same');
    %         figure(2)
    %         plot(m,'r'), hold on
    %         plot(mConv,'g'), hold off
    %         legend('original', 'convolved')
    %         title('moving on')
            [pks,lcs] = findpeaks(mConv);
            if length(pks) > 1
                break
            end
    %         pause
        end
    end
    figure(2)
    imshow(I)