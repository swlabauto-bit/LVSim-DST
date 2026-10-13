clear all;
close all;

% New Trackmate with clump tracking

% edges2 = 0:1e5:3e6;

% edges1 = 0:5e3:1e5;

for a = 1:1:6
   
    index = (a-1)*9;
    
    for b = 1:1:9
    
    clear data00 data000 data10 data data_t
    
    directory_name = '\'; % Data file folder location

    subfolder = num2str(a,'%01d'); %

    str = [directory_name, subfolder]; %

    path = join(str);

    data00=readtable([path '\' num2str(b,'%01d') '_All Spots statistics.csv']);
    
    data000(:,1)= data00(:,8); % FrameID
    data000(:,2)= data00(:,5); % x
    data000(:,3)= data00(:,6); % y
    data000(:,4)= data00(:,27);% Area(pixel^2)
    data10=table2array(data000);
    data10(1:3,:)=[];
    data10=str2double(data10);


    f1=1;
    f2=size(data10,1);
    data=data10(f1:f2,:);
    n=1;

    for i=data(f1,1):1:data(f2,1)

        clear vector1 ind1 vector11;
        clear vector2 ind2 vector22;
        clear vector;

        V1 = find(data(:,1)==i,1,'first');
        V2 = find(data(:,1)==i,1,'last');

        TTP = V2-V1+1;

        if isempty(V1)==0
            
            small = [];
            medium = [];
            large = [];
            count1 = 0;
            count2 = 0;
            count3 = 0;
            vector1 = data(V1:V2,4);
            
            for m = 1:1:TTP
                currentArea = vector1(m);
                
                if currentArea <= 38.4846
                    count1 = count1 + 1;
                    small(count1) = currentArea;
                    
                elseif currentArea <= 153.9384
                    count2 = count2 + 1;
                    medium(count2) = currentArea;
                    
                else
                    count3 = count3 + 1;
                    large(count3) = currentArea;
                    
                end
            end
            
            countSmall = numel(small);
            countMedium = numel(medium);
            countLarge = numel(large);
            
            meanSmall = sum(small)/countSmall;
            
            if countMedium > 0
                meanMedium = sum(medium)/countMedium;
            else
                meanMedium = 0;
            end

            if countLarge > 0
                meanLarge = sum(large)/countLarge;
            else
                meanLarge = 0;
            end
            
            if (countMedium > 0) || (countLarge > 0)
                meanMediumLarge = (sum(medium) + sum(large)) / (countMedium + countLarge);
            else
                meanMediumLarge = 0;
            end
            
            dataSmall(n,1) = meanSmall;
            dataMedium(n,1) = meanMedium;
            dataLarge(n,1) = meanLarge;
            dataMediumLarge(n,1) = meanMediumLarge;
            
            n = n + 1;
        end

    end
    
    c1 = size(dataSmall,1);
    histTotalSmall(1:c1,index+b) = dataSmall(:,1);
    c2 = size(dataMedium,1);
    histTotalMedium(1:c2,index+b) = dataMedium(:,1);
    c3 = size(dataLarge,1);
    histTotalLarge(1:c3,index+b) = dataLarge(:,1);
    c4 = size(dataMediumLarge,1);
    histTotalMediumLarge(1:c4,index+b) = dataMediumLarge(:,1);
    
    [a,b]
    

    end
    
end
