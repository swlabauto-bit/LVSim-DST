clear all;
close all;

edges1 = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5 10 10.5 11 11.5 12];
%edges2 = [0 0.1e6 0.2e6 0.3e6 0.4e6 0.5e6 0.6e6 0.7e6 0.8e6 0.9e6 1e6 1.1e6 1.2e6 1.3e6 1.4e6 1.5e6 1.6e6 1.7e6 1.8e6 1.9e6 2e6];

for a = 1:1:6
   
    index = (a-1)*9;
    
    for b = 1:1:9
    
    clear data00 data000 data10 data data_t1 data_t2
    
    directory_name = '\'; %Data file folder e.g. 'G:\AST-TB\Signal\'

    subfolder = num2str(a,'%01d'); %

    str = [directory_name, subfolder]; %

    path = join(str);

    data00=readtable([path '\' num2str(b,'%01d') '_Spots in tracks statistics.csv']);

    data000(:,1)= data00(:,3); % TrackID
    data000(:,2)= data00(:,5); % x
    data000(:,3)= data00(:,6); % y
    data000(:,4)= data00(:,10);% radius
    data000(:,5)= data00(:,27);% total area
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

        V1 = find(data(:,1)==i,1,'first');
        V2 = find(data(:,1)==i,1,'last');
        TTP = V2-V1+1;
        
        if isempty(V1)==0
            vector1 = data(V1:V2,4);
            [~,ind1] = sort(vector1,'descend');
            vector11 = vector1(ind1(1:TTP));
            m1 = mean(vector11);
            data_t1(n,1)=m1;
            n=n+1;
        end

    end
    
    c1 = size(data_t1(:,1),1);
    histTotal1(1:c1,index+b) = data_t1(:,1);
    binCounts1(index+b,1:24) = histcounts(data_t1,edges1);
    [a,b]
    
    end
    
end